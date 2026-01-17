<#
.SYNOPSIS
    Set BloodHound Query
.DESCRIPTION
    Set BloodHound saved query 
.EXAMPLE
    Set-BHPathQuery -ID 123 -Name MySavedQuery
#>

function Set-BHPathQuery{
    [Alias('Set-BHQuery')]
    Param(
        [Parameter(Mandatory=1)][int]$ID,
        [Parameter(Mandatory=0)][String]$Name,
        [Parameter(Mandatory=0)][String]$Query,
        [Parameter(Mandatory=0)][String]$Description
        )
    NoMultiSession
    $QObj = Get-BHPathQuery -id $ID | Select Name,Description,Query
    if($QObj){
        if($Name){$QObj.Name=$Name}
        if($Query){$QObj.Query=$Query}
        if($Description){$QObj.Description=$Description}
        BHAPI saved-queries/$ID PUT ($QObj|Convertto-Json) -Expand data
        }
    }
