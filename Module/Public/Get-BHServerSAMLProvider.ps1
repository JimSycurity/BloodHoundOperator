<#
.SYNOPSIS
    Get BloodHound SAML Provider
.DESCRIPTION
    Get BloodHound SAML Provider
.EXAMPLE
    Get-BHServerSAMLProvider
#>

function Get-BHServerSAMLProvider{
    [Alias('BHSAMLProvider')]
    Param(
        [Parameter(Mandatory=0)][Alias('ID')][int]$ProviderID
        )
    if($ProviderID){BHAPI api/v2/saml/providers/$ProviderID -expand data}
    else{BHAPI api/v2/saml -expand data.saml_providers}
    }
