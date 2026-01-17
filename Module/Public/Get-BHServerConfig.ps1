<#
.SYNOPSIS
    Get BloodHound Server Config
.DESCRIPTION
    Get BloodHound Server Config
.EXAMPLE
    BHConfig
#>

Function Get-BHServerConfig{
    [CmdletBinding()]
    [Alias('BHConfig')]
    Param()
    Invoke-BHAPI 'api/v2/config' -expand data
    }
