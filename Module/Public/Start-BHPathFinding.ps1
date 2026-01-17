<#
.Synopsis
    [BHE] Start BloodHound Path Finding
.DESCRIPTION
    Start BloodHound Attack Path Analysis
.EXAMPLE
    Start-BHPathFinding
#>

function Start-BHPathFinding{
    [CmdletBinding()]
    [Alias('BHPathAnalysis')]
    Param()
    BHEOnly
    $Null = BHAPI -Method PUT api/v2/attack-paths
    }
