@{
    RootModule           = 'BloodHoundOperator.psm1'
    ModuleVersion        = '0.0.0'
    GUID                 = 'fc2eb4ab-7006-422a-82fe-2330cf3cf0b0'
    Author               = 'SadProcessor'
    CompanyName          = ''
    Copyright            = ''
    Description          = 'PowerShell client for BloodHound Community Edition and BloodHound Enterprise'
    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    FunctionsToExport    = '*'
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = '*'

    PrivateData          = @{
        PSData = @{
            Tags         = @()
            LicenseUri   = 'https://github.com/SadProcessor/BloodHoundOperator/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/SadProcessor/BloodHoundOperator'
            ReleaseNotes = ''
        }
    }
}
