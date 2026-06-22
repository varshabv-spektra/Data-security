using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "purview-ds-$DID"
$count = 0
$found = $false

function Test-NameMatch {
    param(
        [string]$Text,
        [string[]]$Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Text -match $pattern) {
            return $true
        }
    }

    return $false
}

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop | Out-Null

        $vm = Get-AzVM -ResourceGroupName $rg -Status -ErrorAction Stop | Select-Object -First 1
        $storageAccount = Get-AzStorageAccount -ResourceGroupName $rg -ErrorAction Stop | Select-Object -First 1

        if ($null -eq $vm) {
            throw "No lab VM was found in resource group '$rg'."
        }

        if ($null -eq $storageAccount) {
            throw "No storage account was found in resource group '$rg'."
        }

        $ctx = New-AzStorageContext -StorageAccountName $storageAccount.StorageAccountName -UseConnectedAccount -ErrorAction Stop

        $candidateContainers = @('evidence', 'artifacts', 'reports', 'output', 'hackathon')
        $containersChecked = @()
        $allBlobs = @()

        foreach ($containerName in $candidateContainers) {
            try {
                $containerBlobs = Get-AzStorageBlob -Container $containerName -Context $ctx -ErrorAction Stop
                $containersChecked += $containerName
                if ($containerBlobs) {
                    $allBlobs += $containerBlobs
                }
            }
            catch {
                # Container may not exist in every implementation; continue checking other expected names.
            }
        }

        $reportPatterns = @(
            'incident',
            'remediation',
            'final-report',
            'investigation-summary',
            'case-summary',
            'evidence'
        )

        $copilotPatterns = @(
            'copilot',
            'security-copilot',
            'purview-plugin',
            'plugin-enabled',
            'prompt-output'
        )

        $reportBlobs = @($allBlobs | Where-Object { Test-NameMatch -Text $_.Name.ToLowerInvariant() -Patterns $reportPatterns })
        $copilotBlobs = @($allBlobs | Where-Object { Test-NameMatch -Text $_.Name.ToLowerInvariant() -Patterns $copilotPatterns })

        if ($reportBlobs.Count -ge 1) {
            $found = $true

            $reportNames = ($reportBlobs | Select-Object -ExpandProperty Name -Unique | Sort-Object) -join ', '
            $copilotCount = $copilotBlobs.Count
            $containerSummary = if ($containersChecked.Count -gt 0) { ($containersChecked | Sort-Object) -join ', ' } else { 'none' }
            $copilotSummary = if ($copilotCount -gt 0) {
                "Security Copilot evidence detected in $copilotCount blob(s)."
            }
            else {
                "No Security Copilot-specific blob was detected; manual review may confirm Challenge 7 evidence where availability is tenant-dependent."
            }

            $message = @{
                Status  = "Succeeded"
                Message = "Final investigation/remediation deliverable evidence was found in RG '$rg' using VM '$($vm.Name)' and storage account '$($storageAccount.StorageAccountName)'. Checked containers: $containerSummary. Matching deliverable blobs: $reportNames. $copilotSummary"
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "No final investigation or remediation deliverable artifacts were found in the expected storage evidence locations in RG '$rg'. Checked VM '$($vm.Name)', storage account '$($storageAccount.StorageAccountName)', and candidate containers: $(([string]::Join(', ', $candidateContainers)))."
            } | ConvertTo-Json
        }
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $message
        })
    }
    catch {
        $message = @{
            Status  = "Failed"
            Message = "Error during check. Attempt $count of 3. Error: $($_.Exception.Message)"
        } | ConvertTo-Json
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = $message
        })
        Start-Sleep -Seconds 10
    }
} while ($count -lt 3 -and -not $found)

# Post-loop: if every attempt failed, emit a final failure JSON so CloudLabs
# always sees a structured result.
if (-not $found) {
    $message = @{
        Status  = "Failed"
        Message = "Final investigation/remediation deliverable evidence was not found in RG '$rg' after 3 attempts."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
