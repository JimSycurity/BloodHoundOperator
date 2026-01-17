<#
.SYNOPSIS
    Remove BloodHound API Session
.DESCRIPTION
    Remove BloodHound API Session
.EXAMPLE
    Remove-BHSession
#>

function Remove-BHSession{
    Param(
        [Parameter(Mandatory)][int[]]$ID,
        [Parameter()][Switch]$Force
        )
    Foreach($SessID in $ID){
        if($Force -OR $(Confirm-Action "Remove BHSession ID $SessID")){$BHSession.Remove(($BHSession | ? id -eq $SessID))}}
    }
