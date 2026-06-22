using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-purviewhack-$DID"
$count = 0
$found = $false

# Validation intent:
# Confirm the lab VM exists in the supporting Azure resource group and contains
# investigation evidence artifacts saved by the learner for Challenge 3.
# This uses Run Command to inspect the guest filesystem for Insider Risk / case evidence.
# Expected evidence can be screenshots, notes, exports, or case summaries placed in common
# evidence folders during the challenge.

 do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $vm = Get-AzVM -ResourceGroupName $rg -Status -ErrorAction Stop |
            Where-Object { $_.Name -match '^(vm-|labvm|purview).*' } |
            Select-Object -First 1

        if (-not $vm) {
            throw "No lab VM was found in resource group '$rg'."
        }

        $script = @'
$paths = @(
    'C:\LabFiles\Evidence',
    'C:\LabFiles\InsiderRisk',
    'C:\Evidence',
    'C:\Users\Student\Documents\Evidence',
    'C:\Users\labuser\Documents\Evidence',
    'C:\Users\azureuser\Documents\Evidence'
)

$keywords = @(
    'insider',
    'risk',
    'investigation',
    'case',
    'evidence',
    'alert',
    'timeline',
    'purview'
)

$matches = @()
foreach ($path in $paths) {
    if (Test-Path -LiteralPath $path) {
        $items = Get-ChildItem -LiteralPath $path -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $name = $_.Name.ToLowerInvariant()
                ($keywords | Where-Object { $name -like "*$_*" }).Count -gt 0
            } |
            Sort-Object LastWriteTime -Descending

        foreach ($item in $items) {
            $matches += [PSCustomObject]@{
                Path = $item.FullName
                LastWriteTime = $item.LastWriteTime
                Length = $item.Length
            }
        }
    }
}

$matches = $matches | Sort-Object LastWriteTime -Descending
if ($matches.Count -gt 0) {
    $top = $matches | Select-Object -First 5
    $summary = ($top | ForEach-Object { "$($_.Path) [$($_.LastWriteTime.ToString('s'))]" }) -join '; '
    Write-Output "FOUND::$($matches.Count)::$summary"
}
else {
    Write-Output 'NOTFOUND::0::No matching Insider Risk investigation evidence files were located in expected evidence folders.'
}
'@

        $runResult = Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $vm.Name -CommandId 'RunPowerShellScript' -ScriptString $script -ErrorAction Stop

        $outputLines = @()
        if ($runResult.Value) {
            $outputLines = $runResult.Value | ForEach-Object { $_.Message }
        }
        $outputText = ($outputLines -join "`n")

        if ($outputText -match 'FOUND::(\d+)::(.+)') {
            $found = $true
            $fileCount = $matches[1]
            $details = $matches[2]
            $message = @{
                Status  = "Succeeded"
                Message = "Insider Risk investigation evidence was found on VM '$($vm.Name)' in RG '$rg'. Matching artifacts: $fileCount. Examples: $details"
            } | ConvertTo-Json
        } else {
            $message = @{
                Status  = "Failed"
                Message = "No Insider Risk / investigation evidence artifacts were found on VM '$($vm.Name)' in RG '$rg'. Save case notes, screenshots, exports, or evidence files in a lab evidence folder and try again."
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
        Message = "Insider Risk investigation artifacts not found in RG '$rg' after 3 attempts."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
