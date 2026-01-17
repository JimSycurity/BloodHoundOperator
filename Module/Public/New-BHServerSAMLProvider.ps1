<#
.SYNOPSIS
    New BloodHound SAML Provider
.DESCRIPTION
    New BloodHound SAML Provider
.EXAMPLE
    New-BHServerSAMLProvider
#>

function New-BHServerSAMLProvider{
    [Alias('New-BHSAMLProvider')]
    Param(
        [Parameter(Mandatory=1)][String]$Name,
        [Parameter(Mandatory=1)][String]$Metadata
        )
    Write-Warning "/!\ ------------> ToDo <--------------- /!\"
    # multipart/form >> stckvrflw questions 36268925 powershell-invoke-restmethod-multipart-form-data
    #BHAPI api/v2/saml/providers POST -expand data -Body $Metadata
    }
