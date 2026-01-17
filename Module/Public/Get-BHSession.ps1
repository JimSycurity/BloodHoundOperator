<#
.SYNOPSIS
    Get BloodHound API Session
.DESCRIPTION
    Get BloodHound API Session
.EXAMPLE
    Get-BHSession
.EXAMPLE
    Get-BHSession -Selected
#>

function Get-BHSession{
    [Alias('BHSession')]
    Param(
        [Parameter(Mandatory=0)][Alias('Current')][Switch]$Selected
        )
    if($Selected){$BHSession | ? x | Select * -ExcludeProperty Token,TokenID}
    else{$BHSession | Select * -ExcludeProperty Token,TokenID}
    }
