<#
.SYNOPSIS
    Get BloodHound Server Feature
.DESCRIPTION
    Get BloodHound Server Feature
.EXAMPLE
    BHFeature
#>

Function Get-BHServerFeature{
    [CmdletBinding()]
    [Alias('BHFeature')]
    Param()
    Invoke-BHAPI 'api/v2/features' -expand data
    }
