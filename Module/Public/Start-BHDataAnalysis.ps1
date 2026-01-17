<#
.SYNOPSIS
    Start BloodHound Data Analysis
.DESCRIPTION
    Start BloodHound Data Analysis
.EXAMPLE
    Start-BHDataAnalysis
#>

function Start-BHDataAnalysis{
    [CmdletBinding()]
    [Alias('BHDataAnalysis')]
    Param()
    BHAPI api/v2/analysis PUT
    }
