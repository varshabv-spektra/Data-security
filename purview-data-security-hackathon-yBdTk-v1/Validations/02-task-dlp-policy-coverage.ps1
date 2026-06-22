using namespace System.Net

# Note: $sub (subscription id) and $DID (deployment id) are injected by the platform.
$rg = "rg-purviewhack-$DID"
$count = 0
$found = $false

do {
    $count = $count + 1
    try {
        Set-AzContext -Subscription $sub -ErrorAction Stop

        $vm = Get-AzVM -ResourceGroupName $rg -Status -ErrorAction Stop | Select-Object -First 1
        if (-not $vm) {
            throw "No lab VM was found in resource group '$rg'."
        }

        $commandId = "RunPowerShellScript"
        $scriptLines = @(
            "$ErrorActionPreference = 'Stop'",
            "$result = [ordered]@{ found = $false; policyName = ''; workloads = @(); notifications = $false; alerts = $false; endpointMode = ''; ruleCount = 0; details = '' }",
            "Import-Module ExchangeOnlineManagement -ErrorAction Stop",
            "$credPath = 'C:\\LabFiles\\tenantadmin.cred'",
            "if (-not (Test-Path $credPath)) { $credPath = 'C:\\LabFiles\\PurviewAdmin.cred' }",
            "if (-not (Test-Path $credPath)) { throw 'Tenant admin credential file was not found in C:\\LabFiles.' }",
            "$cred = Import-Clixml -Path $credPath",
            "Connect-IPPSSession -Credential $cred -ErrorAction Stop | Out-Null",
            "$policies = Get-DlpCompliancePolicy -ErrorAction Stop | Where-Object { $_.Mode -ne 'TestWithoutNotifications' }",
            "foreach ($policy in $policies) {",
            "    $ruleItems = @(Get-DlpComplianceRule -Policy $policy.Identity -ErrorAction SilentlyContinue)",
            "    $locations = @()",
            "    if ($policy.ExchangeLocation -and $policy.ExchangeLocation.ToString() -ne 'None') { $locations += 'Exchange' }",
            "    if ($policy.SharePointLocation -and $policy.SharePointLocation.ToString() -ne 'None') { $locations += 'SharePoint' }",
            "    if ($policy.OneDriveLocation -and $policy.OneDriveLocation.ToString() -ne 'None') { $locations += 'OneDrive' }",
            "    if ($policy.TeamsLocation -and $policy.TeamsLocation.ToString() -ne 'None') { $locations += 'Teams' }",
            "    $hasCoverage = ($locations -contains 'Exchange') -and ($locations -contains 'SharePoint') -and ($locations -contains 'OneDrive') -and ($locations -contains 'Teams')",
            "    if (-not $hasCoverage) { continue }",
            "    $hasNotifications = $false",
            "    $hasAlerts = $false",
            "    foreach ($rule in $ruleItems) {",
            "        if ($rule.PSObject.Properties.Name -contains 'NotifyUser') { if ($rule.NotifyUser -and $rule.NotifyUser.ToString() -ne 'None') { $hasNotifications = $true } }",
            "        if ($rule.PSObject.Properties.Name -contains 'NotifyAllowOverride') { if ($rule.NotifyAllowOverride) { $hasNotifications = $true } }",
            "        if ($rule.PSObject.Properties.Name -contains 'GenerateAlert') { if ($rule.GenerateAlert) { $hasAlerts = $true } }",
            "        if ($rule.PSObject.Properties.Name -contains 'IncidentReportContent') { if ($rule.IncidentReportContent) { $hasAlerts = $true } }",
            "    }",
            "    $endpointMode = ''",
            "    if ($policy.PSObject.Properties.Name -contains 'EndpointDlpLocation') { $endpointMode = $policy.EndpointDlpLocation.ToString() }",
            "    if ($hasNotifications -and $hasAlerts) {",
            "        $result.found = $true",
            "        $result.policyName = $policy.Name",
            "        $result.workloads = $locations",
            "        $result.notifications = $hasNotifications",
            "        $result.alerts = $hasAlerts",
            "        $result.endpointMode = $endpointMode",
            "        $result.ruleCount = $ruleItems.Count",
            "        $result.details = ('Policy ' + $policy.Name + ' covers ' + ($locations -join ', ') + '; notifications=' + $hasNotifications + '; alerts=' + $hasAlerts + '; endpoint=' + $endpointMode + '; rules=' + $ruleItems.Count)",
            "        break",
            "    }",
            "}",
            "Disconnect-ExchangeOnline -Confirm:$false -ErrorAction SilentlyContinue",
            "$result | ConvertTo-Json -Depth 5"
        )

        $runResult = Invoke-AzVMRunCommand -ResourceGroupName $rg -VMName $vm.Name -CommandId $commandId -ScriptString $scriptLines -ErrorAction Stop
        $rawOutput = ($runResult.Value | Select-Object -ExpandProperty Message) -join "`n"
        $jsonText = [regex]::Match($rawOutput, '\{[\s\S]*\}').Value

        if ([string]::IsNullOrWhiteSpace($jsonText)) {
            throw "The VM run command did not return structured DLP validation output. Raw output: $rawOutput"
        }

        $validation = $jsonText | ConvertFrom-Json -ErrorAction Stop

        if ($validation.found) {
            $found = $true
            $endpointText = if ([string]::IsNullOrWhiteSpace($validation.endpointMode)) { "not configured" } else { $validation.endpointMode }
            $message = @{
                Status  = "Succeeded"
                Message = "DLP policy '$($validation.policyName)' was found through the lab VM in RG '$rg' with coverage for $($validation.workloads -join ', '), user notification or policy tip settings enabled, alerting or incident reporting enabled, and endpoint DLP mode '$endpointText'."
            } | ConvertTo-Json
        } else {
            $message = @{
                Status  = "Failed"
                Message = "No active Microsoft Purview DLP policy was found through the lab VM in RG '$rg' that covers Exchange, SharePoint, OneDrive, and Teams together with notification/policy tip settings and alerting or incident-report evidence."
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
        Message = "DLP policy coverage validation not found in RG '$rg' after 3 attempts."
    } | ConvertTo-Json
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = $message
    })
}
