Param(
    [Parameter(Mandatory = $false)] [string] $AzureUserName,
    [Parameter(Mandatory = $false)] [string] $AzurePassword,
    [Parameter(Mandatory = $false)] [string] $AzureTenantID,
    [Parameter(Mandatory = $false)] [string] $AzureSubscriptionID,
    [Parameter(Mandatory = $false)] [string] $ODLID,
    [Parameter(Mandatory = $false)] [string] $InstallCloudLabsShadow,
    [Parameter(Mandatory = $false)] [string] $DeploymentID,
    [Parameter(Mandatory = $false)] [string] $vmAdminUsername,
    [Parameter(Mandatory = $false)] [string] $vmAdminPassword,
    [Parameter(Mandatory = $false)] [string] $trainerUserName,
    [Parameter(Mandatory = $false)] [string] $trainerUserPassword
)

$transcriptPath = 'C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt'
New-Item -ItemType Directory -Path (Split-Path $transcriptPath) -Force | Out-Null
Start-Transcript -Path $transcriptPath -Append

$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Write-Log {
    param([string] $Message)
    Write-Host ("[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message)
}

function Ensure-Directory {
    param([string] $Path)
    if (-not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Invoke-ExternalCommand {
    param(
        [Parameter(Mandatory = $true)] [string] $FilePath,
        [Parameter(Mandatory = $false)] [string] $Arguments = '',
        [Parameter(Mandatory = $false)] [string] $WorkingDirectory = $env:TEMP,
        [Parameter(Mandatory = $false)] [switch] $IgnoreExitCode
    )

    Write-Log "Running: $FilePath $Arguments"
    $process = Start-Process -FilePath $FilePath -ArgumentList $Arguments -WorkingDirectory $WorkingDirectory -Wait -PassThru -WindowStyle Hidden
    if (-not $IgnoreExitCode -and $process.ExitCode -ne 0) {
        throw "Command failed with exit code $($process.ExitCode): $FilePath $Arguments"
    }
    return $process.ExitCode
}

function Install-Chocolatey {
    if (Get-Command choco.exe -ErrorAction SilentlyContinue) {
        Write-Log 'Chocolatey already installed.'
        return
    }

    Write-Log 'Installing Chocolatey.'
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $env:Path += ';C:\ProgramData\chocolatey\bin'
}

function Install-AzureCLI {
    if (Get-Command az.cmd -ErrorAction SilentlyContinue) {
        Write-Log 'Azure CLI already installed.'
        return
    }

    Write-Log 'Installing Azure CLI from Microsoft MSI.'
    $msiPath = Join-Path $env:TEMP 'AzureCLI.msi'
    Invoke-WebRequest -Uri 'https://aka.ms/installazurecliwindowsx64' -OutFile $msiPath
    Invoke-ExternalCommand -FilePath 'msiexec.exe' -Arguments "/I `"$msiPath`" /quiet"
    Remove-Item -Path $msiPath -Force -ErrorAction SilentlyContinue
    $env:Path += ';C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin'
}

function Install-Tools {
    Install-Chocolatey

    $packages = @(
        'microsoft-edge',
        'googlechrome',
        '7zip',
        'notepadplusplus',
        'git',
        'vscode',
        'python',
        'jq',
        'sysinternals',
        'microsoftazurestorageexplorer'
    )

    foreach ($package in $packages) {
        Write-Log "Installing package: $package"
        choco install $package -y --no-progress | Out-Host
    }

    Install-AzureCLI

    try {
        Invoke-ExternalCommand -FilePath 'code.cmd' -Arguments '--install-extension ms-vscode.powershell --force' -IgnoreExitCode
    }
    catch {
        Write-Log "VS Code extension installation skipped: $($_.Exception.Message)"
    }
}

function CreateCredFile {
    Write-Log 'Creating CloudLabs credential files.'
    Ensure-Directory -Path 'C:\LabFiles'

    $baseUrl = 'https://experienceazure.blob.core.windows.net/templates/cloudlabs-common'
    $txtPath = 'C:\LabFiles\AzureCreds.txt'
    $ps1Path = 'C:\LabFiles\AzureCreds.ps1'

    Invoke-WebRequest -Uri "$baseUrl/AzureCreds.txt" -OutFile $txtPath
    Invoke-WebRequest -Uri "$baseUrl/AzureCreds.ps1" -OutFile $ps1Path

    $replacements = @{
        'AzureUserName'       = $AzureUserName
        'AzurePassword'       = $AzurePassword
        'AzureTenantID'       = $AzureTenantID
        'AzureSubscriptionID' = $AzureSubscriptionID
        'ODLID'               = $ODLID
        'DeploymentID'        = $DeploymentID
    }

    foreach ($file in @($txtPath, $ps1Path)) {
        $content = Get-Content -Path $file -Raw
        foreach ($key in $replacements.Keys) {
            $content = $content -replace [Regex]::Escape("@@$key@@"), [string]$replacements[$key]
            $content = $content -replace [Regex]::Escape("{{$key}}"), [string]$replacements[$key]
        }
        Set-Content -Path $file -Value $content -Encoding UTF8
    }

    Copy-Item -Path $txtPath -Destination 'C:\Users\Public\Desktop\AzureCreds.txt' -Force
    Copy-Item -Path $ps1Path -Destination 'C:\Users\Public\Desktop\AzureCreds.ps1' -Force
}

function Install-CloudLabsShadowIfRequested {
    if ($InstallCloudLabsShadow -match '^(?i:true|1|yes)$') {
        Write-Log 'InstallCloudLabsShadow requested. Downloading helper bootstrap.'
        $shadowScript = 'C:\LabFiles\InstallCloudLabsShadow.ps1'
        Invoke-WebRequest -Uri 'https://experienceazure.blob.core.windows.net/templates/cloudlabs-common/InstallCloudLabsShadow.ps1' -OutFile $shadowScript
        & $shadowScript
    }
    else {
        Write-Log 'InstallCloudLabsShadow not requested.'
    }
}

function Initialize-LabFolders {
    $folders = @(
        'C:\LabFiles',
        'C:\LabFiles\Bookmarks',
        'C:\LabFiles\Scripts',
        'C:\LabFiles\SampleFiles',
        'C:\LabFiles\GovernanceData',
        'C:\LabFiles\Evidence',
        'C:\LabFiles\Evidence\Challenge-01',
        'C:\LabFiles\Evidence\Challenge-02',
        'C:\LabFiles\Evidence\Challenge-03',
        'C:\LabFiles\Evidence\Challenge-04',
        'C:\LabFiles\Evidence\Challenge-05',
        'C:\LabFiles\Evidence\Challenge-06',
        'C:\LabFiles\Evidence\Challenge-07',
        'C:\LabFiles\Exports',
        'C:\LabFiles\Reports',
        'C:\LabFiles\Screenshots'
    )

    foreach ($folder in $folders) {
        Ensure-Directory -Path $folder
    }
}

function Write-ScenarioFiles {
    $incidentBrief = @'
Purview Data Security Hackathon Incident Brief
============================================

Organization: Titan Journey
Scenario: Recent data exposure involving overshared sensitive files, risky user behavior, and inconsistent Purview protections.

Your mission
- Assess current Purview and Microsoft 365 readiness.
- Implement Information Protection and DLP improvements.
- Investigate Insider Risk activity and evidence.
- Review DSPM for AI / exposure insights and remediate at least one issue.
- Produce a final incident and remediation narrative.

Important notes
- Some tenant features, alerts, cases, and licensing-dependent experiences are pre-staged by the CloudLabs team.
- Azure resources in this deployment provide the learner workstation, helper content, exported evidence paths, and optional bootstrap data sources.
- Perform tenant-bound tasks in the Microsoft Purview and Microsoft 365 portals, not through this VM unless instructed.
'@

    $readme = @'
Purview Lab VM Quick Start
==========================

Use this VM as your primary workstation for the hackathon.

Primary folders
- C:\LabFiles\Evidence         Save screenshots, exports, and notes by challenge.
- C:\LabFiles\SampleFiles      Sensitive sample files for Information Protection and DLP testing.
- C:\LabFiles\GovernanceData   Optional source data for discovery / governance tasks.
- C:\LabFiles\Scripts          Helper scripts to open portals and prepare evidence.
- C:\LabFiles\Reports          Templates for final incident reporting.

Recommended workflow
1. Sign in to Microsoft Edge with the provided learner account if prompted.
2. Open the desktop shortcuts or use the bookmarks HTML file in C:\LabFiles\Bookmarks.
3. Work through the challenge instructions in the lab guide.
4. Save every screenshot/export into the matching challenge evidence folder.
5. Use the final report template in C:\LabFiles\Reports.
'@

    $reportTemplate = @'
Incident Investigation and Remediation Report Template
=====================================================

1. Executive summary
2. What data was exposed or at risk
3. How the exposure occurred
4. Information Protection actions implemented
5. DLP actions implemented
6. Insider Risk findings and case details
7. DSPM / oversharing findings and remediation
8. Evidence inventory
9. Remaining gaps and recommended next steps
10. Final hardened-state summary
'@

    Set-Content -Path 'C:\LabFiles\IncidentBrief.txt' -Value $incidentBrief -Encoding UTF8
    Set-Content -Path 'C:\LabFiles\README.txt' -Value $readme -Encoding UTF8
    Set-Content -Path 'C:\LabFiles\Reports\Incident-Remediation-Report-Template.txt' -Value $reportTemplate -Encoding UTF8

    Copy-Item 'C:\LabFiles\IncidentBrief.txt' 'C:\Users\Public\Desktop\Incident Brief.txt' -Force
    Copy-Item 'C:\LabFiles\README.txt' 'C:\Users\Public\Desktop\Lab VM Quick Start.txt' -Force
}

function Write-SampleFiles {
    $samples = @{
        'Finance-FY26-Projections.csv' = @'
Employee,Region,Quarter,RevenueForecast,Margin,StrategicFlag
Adele Vance,NA,Q1,2450000,0.41,Acquisition target
Diego Silva,EMEA,Q2,1880000,0.37,Board confidential
Mei Chen,APAC,Q3,2215000,0.39,Pre-earnings draft
'@
        'Customer-PII-Roster.txt' = @'
Customer onboarding roster
-------------------------
Name: Jordan Miles | DOB: 1988-04-17 | SSN: 555-01-1001 | Account: 77891234
Name: Priya Anand | DOB: 1991-11-03 | SSN: 555-01-1002 | Account: 77891235
Name: Mateo Ruiz | DOB: 1986-02-26 | SSN: 555-01-1003 | Account: 77891236
'@
        'Mergers-Discussion-Notes.txt' = @'
Confidential sub-label candidate document.
Contains strategic plans, merger timelines, and executives under legal hold review.
Do not share externally.
'@
        'HR-Investigation-Notes.txt' = @'
Sensitive internal document used for insider risk investigation exercises.
Includes behavioral indicators and exfiltration concerns for the simulated user timeline.
'@
        'AI-Exposure-Summary.txt' = @'
Use this file to discuss oversharing and AI exposure scenarios.
Documents broad-access SharePoint locations and sensitive content likely to be surfaced through AI-assisted experiences.
'@
    }

    foreach ($fileName in $samples.Keys) {
        Set-Content -Path (Join-Path 'C:\LabFiles\SampleFiles' $fileName) -Value $samples[$fileName] -Encoding UTF8
    }

    $governanceFiles = @(
        @{ Name = 'catalog-source-01.csv'; Content = "SourceSystem,DataOwner,Classification`nERP,Finance,Confidential`nCRM,Sales,General" },
        @{ Name = 'catalog-source-02.csv'; Content = "Repository,ContainsSensitiveData,RetentionRequired`nContracts,true,true`nMarketing,false,false" }
    )

    foreach ($item in $governanceFiles) {
        Set-Content -Path (Join-Path 'C:\LabFiles\GovernanceData' $item.Name) -Value $item.Content -Encoding UTF8
    }
}

function Write-HelperScripts {
    $openPortals = @'
Start-Process 'https://compliance.microsoft.com/'
Start-Process 'https://purview.microsoft.com/'
Start-Process 'https://securitycopilot.microsoft.com/'
Start-Process 'https://security.microsoft.com/'
Start-Process 'https://admin.microsoft.com/'
'@

    $captureChecklist = @'
Purview Evidence Checklist
==========================

Challenge 1
- Sensitivity labels created or reviewed
- Label policy published
- Auto-label condition screenshot

Challenge 2
- DLP policy overview
- Policy settings for Exchange / SharePoint / OneDrive / Teams
- Alert or activity evidence

Challenge 3
- Insider Risk alert or case view
- User timeline screenshot
- Investigation notes

Challenge 4
- DSPM / posture recommendation screenshot
- AI-related exposure or oversharing evidence
- Remediation action proof

Challenge 5/6/7
- Compliance support evidence
- Final narrative / Copilot outputs if used
'@

    $envTemplate = @"
AZURE_USER_NAME=$AzureUserName
AZURE_TENANT_ID=$AzureTenantID
AZURE_SUBSCRIPTION_ID=$AzureSubscriptionID
ODL_ID=$ODLID
DEPLOYMENT_ID=$DeploymentID
RESOURCE_GROUP=
STORAGE_ACCOUNT=
STORAGE_CONTAINER=governancedata
STORAGE_CONNECTION_STRING=
PURVIEW_PORTAL=https://purview.microsoft.com/
COMPLIANCE_PORTAL=https://compliance.microsoft.com/
SECURITY_PORTAL=https://security.microsoft.com/
SECURITY_COPILOT_PORTAL=https://securitycopilot.microsoft.com/
"@

    Set-Content -Path 'C:\LabFiles\Scripts\Open-Purview-Portals.ps1' -Value $openPortals -Encoding UTF8
    Set-Content -Path 'C:\LabFiles\Scripts\Evidence-Checklist.txt' -Value $captureChecklist -Encoding UTF8
    Set-Content -Path 'C:\LabFiles\.env' -Value $envTemplate -Encoding UTF8
}

function Write-Bookmarks {
    $bookmarks = @'
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Purview Data Security Hackathon</H1>
<DL><p>
    <DT><H3>Core Portals</H3>
    <DL><p>
        <DT><A HREF="https://purview.microsoft.com/">Microsoft Purview portal</A>
        <DT><A HREF="https://compliance.microsoft.com/">Microsoft Purview compliance portal</A>
        <DT><A HREF="https://security.microsoft.com/">Microsoft Defender portal</A>
        <DT><A HREF="https://admin.microsoft.com/">Microsoft 365 admin center</A>
        <DT><A HREF="https://securitycopilot.microsoft.com/">Security Copilot</A>
        <DT><A HREF="https://entra.microsoft.com/">Microsoft Entra admin center</A>
        <DT><A HREF="https://portal.azure.com/">Azure portal</A>
    </DL><p>
    <DT><H3>Reference</H3>
    <DL><p>
        <DT><A HREF="https://learn.microsoft.com/purview/">Microsoft Purview documentation</A>
        <DT><A HREF="https://learn.microsoft.com/microsoft-365/compliance/">Microsoft 365 compliance documentation</A>
    </DL><p>
</DL><p>
'@

    Set-Content -Path 'C:\LabFiles\Bookmarks\Purview-Hackathon-Bookmarks.html' -Value $bookmarks -Encoding UTF8
    Copy-Item 'C:\LabFiles\Bookmarks\Purview-Hackathon-Bookmarks.html' 'C:\Users\Public\Desktop\Purview Bookmarks.html' -Force
}

function New-Shortcut {
    param(
        [string] $ShortcutPath,
        [string] $TargetPath,
        [string] $Arguments = '',
        [string] $IconLocation = ''
    )

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($ShortcutPath)
    $shortcut.TargetPath = $TargetPath
    if ($Arguments) { $shortcut.Arguments = $Arguments }
    if ($IconLocation) { $shortcut.IconLocation = $IconLocation }
    $shortcut.Save()
}

function Write-DesktopShortcuts {
    $desktop = 'C:\Users\Public\Desktop'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Microsoft Purview Portal.lnk') -TargetPath 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Arguments 'https://purview.microsoft.com/'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Purview Compliance Portal.lnk') -TargetPath 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Arguments 'https://compliance.microsoft.com/'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Microsoft Defender Portal.lnk') -TargetPath 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Arguments 'https://security.microsoft.com/'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Security Copilot.lnk') -TargetPath 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' -Arguments 'https://securitycopilot.microsoft.com/'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Open Purview Portals.lnk') -TargetPath 'powershell.exe' -Arguments '-ExecutionPolicy Bypass -File C:\LabFiles\Scripts\Open-Purview-Portals.ps1'
    New-Shortcut -ShortcutPath (Join-Path $desktop 'Evidence Folder.lnk') -TargetPath 'C:\LabFiles\Evidence'
}

function Connect-AzureNonInteractive {
    Write-Log 'Authenticating to Azure CLI with CloudLabs user credentials.'
    $azCmd = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd'
    if (-not (Test-Path $azCmd)) {
        $azCmd = 'az.cmd'
    }

    & $azCmd cloud set --name AzureCloud | Out-Null
    & $azCmd login --username $AzureUserName --password $AzurePassword --tenant $AzureTenantID | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Azure CLI login failed.'
    }

    & $azCmd account set --subscription $AzureSubscriptionID | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw 'Unable to select Azure subscription.'
    }
}

function Resolve-ResourceGroup {
    $azCmd = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd'
    $resourceGroup = (& $azCmd group list --query "[0].name" -o tsv).Trim()
    if (-not $resourceGroup) {
        Write-Log 'No resource group discovered from current subscription context.'
        return $null
    }
    Write-Log "Discovered resource group: $resourceGroup"
    return $resourceGroup
}

function Populate-EnvFromAzure {
    param([string] $ResourceGroupName)

    $azCmd = 'C:\Program Files\Microsoft SDKs\Azure\CLI2\wbin\az.cmd'
    if (-not $ResourceGroupName) {
        Write-Log 'Skipping Azure resource discovery because no resource group was found.'
        return
    }

    $storageAccount = (& $azCmd storage account list -g $ResourceGroupName --query "[0].name" -o tsv).Trim()
    $connectionString = ''

    if ($storageAccount) {
        Write-Log "Discovered storage account: $storageAccount"
        & $azCmd storage container create --name governancedata --account-name $storageAccount --auth-mode login | Out-Null
        $connectionString = (& $azCmd storage account show-connection-string -g $ResourceGroupName -n $storageAccount --query connectionString -o tsv).Trim()

        $envLines = Get-Content -Path 'C:\LabFiles\.env'
        $envLines = $envLines | ForEach-Object {
            $_ -replace '^RESOURCE_GROUP=.*', "RESOURCE_GROUP=$ResourceGroupName" `
               -replace '^STORAGE_ACCOUNT=.*', "STORAGE_ACCOUNT=$storageAccount" `
               -replace '^STORAGE_CONNECTION_STRING=.*', "STORAGE_CONNECTION_STRING=$connectionString"
        }
        Set-Content -Path 'C:\LabFiles\.env' -Value $envLines -Encoding UTF8

        Write-Log 'Uploading governance data samples to blob storage.'
        & $azCmd storage blob upload-batch --auth-mode login --account-name $storageAccount --destination governancedata --source 'C:\LabFiles\GovernanceData' | Out-Null
    }
    else {
        Write-Log 'No storage account found in the resource group.'
    }
}

try {
    Write-Log 'Starting Purview Data Security Hackathon VM bootstrap.'
    Initialize-LabFolders
    CreateCredFile
    Install-CloudLabsShadowIfRequested
    Install-Tools
    Write-ScenarioFiles
    Write-SampleFiles
    Write-HelperScripts
    Write-Bookmarks
    Write-DesktopShortcuts
    Connect-AzureNonInteractive
    $resourceGroupName = Resolve-ResourceGroup
    Populate-EnvFromAzure -ResourceGroupName $resourceGroupName
    Write-Log 'Bootstrap completed successfully.'
}
catch {
    Write-Error $_.Exception.Message
    throw
}
finally {
    Stop-Transcript
}
