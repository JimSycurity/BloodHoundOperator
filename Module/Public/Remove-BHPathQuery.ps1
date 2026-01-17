<#
.SYNOPSIS
    Remove BloodHound Saved Query
.DESCRIPTION
    Remove BloodHound saved query
.EXAMPLE
    Remove-BHPathQuery -id <QueryID> -Force
#>

Function Remove-BHPathQuery{
    [Alias('Remove-BHQuery')]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][String]$ID,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{foreach($Qid in $ID){if($Force -OR (Confirm-Action "Delete saved query ID $Qid")){
        Invoke-BHAPI api/v2/saved-queries/$Qid -Method DELETE | out-Null
        Start-Sleep -Milliseconds 10
        }}}
    End{}
    }
