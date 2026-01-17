<#
.SYNOPSIS
    Get BloodHound SAML Endpoints
.DESCRIPTION
    Get BloodHound SAML Endpoints
.EXAMPLE
    Get-BHServerSAMLEndpoint
#>

function Get-BHServerSAMLEndpoint{
    [Alias('BHSAMLEndpoint')]
    Param()
    BHAPI api/v2/saml/sso -Expand data.endpoints
    }
