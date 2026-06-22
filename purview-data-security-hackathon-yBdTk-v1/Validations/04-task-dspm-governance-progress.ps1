using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-purview-hackathon-$DID"
$count = 0
$found = $false

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $storageAccounts = Get-AzStorageAccount -ResourceGroupName $rg -ErrorAction Stop
        $candidateAccounts = $storageAccounts | Where-Object {
            ($_.StorageAccountName -like "*purview*") -or
            ($_.StorageAccountName -like "*govern*") -or
            ($_.StorageAccountName -like "*data*") -or
            ($_.Tags -and $_.Tags.ContainsKey('Scenario')) -or
            ($_.Tags -and $_.Tags.ContainsKey('Purpose'))
        }

        if (-not $candidateAccounts) {
            $candidateAccounts = $storageAccounts
        }

        $evidence = @()

        foreach ($account in $candidateAccounts) {
            $ctx = $account.Context
            $containers = Get-AzStorageContainer -Context $ctx -ErrorAction SilentlyContinue

            if ($containers) {
                foreach ($container in $containers) {
                    $blobCount = 0
                    try {
                        $blobs = Get-AzStorageBlob -Container $container.Name -Context $ctx -ErrorAction SilentlyContinue
                        if ($blobs) {
                            $blobCount = ($blobs | Measure-Object).Count
                        }
                    }
                    catch {
                        $blobCount = 0
                    }

                    if ($blobCount -gt 0) {
                        $evidence += [PSCustomObject]@{
                            StorageAccount = $account.StorageAccountName
                            Container      = $container.Name
                            BlobCount      = $blobCount
                        }
                    }
                }
            }
        }

        if ($evidence.Count -gt 0) {
            $topEvidence = $evidence | Sort-Object BlobCount -Descending | Select-Object -First 3
            $detail = ($topEvidence | ForEach-Object {
                "$($_.StorageAccount)/$($_.Container) contains $($_.BlobCount) blob(s)"
            }) -join '; '

            $found = $true
            $message = @{
                Status  = "Succeeded"
                Message = "Governance progress evidence found in RG '$rg'. Discovered asset outcomes are present: $detail."
            } | ConvertTo-Json
        }
        else {
            $message = @{
                Status  = "Failed"
                Message = "No discovered-asset or remediation evidence was found in any storage container in RG '$rg'. Verify the learner created or populated governance-supporting assets for the DSPM/governance challenge."
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
        Message = "DSPM governance evidence not found in RG '$rg' after 3 attempts."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
