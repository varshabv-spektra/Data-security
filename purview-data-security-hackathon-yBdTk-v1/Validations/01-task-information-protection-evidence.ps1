using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "purview-datasec-$DID"
$count = 0
$found = $false

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $vm = Get-AzVM -ResourceGroupName $rg -Status -ErrorAction Stop | Select-Object -First 1
        $storageAccounts = Get-AzStorageAccount -ResourceGroupName $rg -ErrorAction SilentlyContinue

        $evidencePath = $null
        $matchedFile = $null

        if ($storageAccounts) {
            foreach ($storage in $storageAccounts) {
                try {
                    $ctx = $storage.Context
                    $containers = Get-AzStorageContainer -Context $ctx -ErrorAction SilentlyContinue

                    foreach ($container in $containers) {
                        $blobs = Get-AzStorageBlob -Container $container.Name -Context $ctx -ErrorAction SilentlyContinue |
                            Where-Object {
                                $_.Name -match '(?i)(challenge[-_ ]?1|information[-_ ]?protection|sensitivity[-_ ]?label|label[-_ ]?policy|auto[-_ ]?label|classification|purview).*\.(txt|md|json|csv|html|png|jpg|jpeg)$'
                            }

                        if ($blobs) {
                            $matchedFile = $blobs | Sort-Object LastModified -Descending | Select-Object -First 1
                            $evidencePath = "$($storage.StorageAccountName)/$($container.Name)/$($matchedFile.Name)"
                            break
                        }
                    }
                }
                catch {
                    continue
                }

                if ($evidencePath) {
                    break
                }
            }
        }

        if ($vm -and $evidencePath) {
            $found = $true
            $message = @{
                Status  = "Succeeded"
                Message = "Found foundational Information Protection evidence for Challenge 1 in RG '$rg'. Lab VM '$($vm.Name)' is present and evidence file '$evidencePath' was located (last modified: $($matchedFile.LastModified))."
            } | ConvertTo-Json
        } elseif ($vm) {
            $message = @{
                Status  = "Failed"
                Message = "Lab VM '$($vm.Name)' was found in RG '$rg', but no storage-based evidence file matching Information Protection outcomes such as sensitivity label, label policy, classification, or auto-labeling evidence was located."
            } | ConvertTo-Json
        } else {
            $message = @{
                Status  = "Failed"
                Message = "No lab VM or qualifying Information Protection evidence was found in RG '$rg'."
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
        Message = "Information Protection evidence not found in RG '$rg' after 3 attempts."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
