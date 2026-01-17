[CmdletBinding()]
param(
    [string]$ModuleName = 'BloodHoundOperator'
)

$projectRoot  = Resolve-Path (Join-Path $PSScriptRoot '..')
$manifestPath = Join-Path $projectRoot 'Module\BloodHoundOperator.psd1'

if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "Manifest not found: $manifestPath"
}

if (-not (Get-Module -ListAvailable -Name PSPublishModule)) {
    throw 'PSPublishModule is not installed. Run: Install-Module -Name PSPublishModule -Scope CurrentUser'
}

Import-Module PSPublishModule -Force

$manifest = Import-PowerShellDataFile -Path $manifestPath
$psData   = $manifest.PrivateData.PSData

$manifestParams = @{
    ModuleVersion = $manifest.ModuleVersion
    Guid          = $manifest.GUID
    Author        = $manifest.Author
}

if ($manifest.CompatiblePSEditions) { $manifestParams.CompatiblePSEditions = $manifest.CompatiblePSEditions }
if ($manifest.CompanyName)          { $manifestParams.CompanyName          = $manifest.CompanyName }
if ($manifest.Copyright)            { $manifestParams.Copyright            = $manifest.Copyright }
if ($manifest.Description)          { $manifestParams.Description          = $manifest.Description }
if ($manifest.PowerShellVersion)    { $manifestParams.PowerShellVersion    = $manifest.PowerShellVersion }
if ($manifest.FunctionsToExport)    { $manifestParams.FunctionsToExport    = $manifest.FunctionsToExport }
if ($manifest.CmdletsToExport)      { $manifestParams.CmdletsToExport      = $manifest.CmdletsToExport }
if ($manifest.AliasesToExport)      { $manifestParams.AliasesToExport      = $manifest.AliasesToExport }

if ($psData) {
    if ($psData.Tags)       { $manifestParams.Tags       = $psData.Tags }
    if ($psData.ProjectUri) { $manifestParams.ProjectUri = $psData.ProjectUri }
    if ($psData.LicenseUri) { $manifestParams.LicenseUri = $psData.LicenseUri }
    if ($psData.IconUri)    { $manifestParams.IconUri    = $psData.IconUri }
}

$settings = {
    New-ConfigurationManifest @manifestParams
    New-ConfigurationImportModule -ImportSelf
    New-ConfigurationBuild -Enable:$true -MergeModuleOnBuild
}.GetNewClosure()

Build-Module -ModuleName $ModuleName -Path $projectRoot $settings
