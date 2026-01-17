<#
.Synopsis
    [BHE] Remove-BloodHound Client
.DESCRIPTION
    Description
.EXAMPLE
    Example
#>

function Remove-BHClient{
    Param(
        [Parameter(Mandatory,ValuefromPipeline,ValuefromPipelineByPropertyName)][Alias('ClientID')][String]$ID,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession;BHEOnly}
    Process{Foreach($CliID in $ID){
        if($Force -OR $(Confirm-Action "Delete BHClient ID $ID")){
            $Null = BHAPI api/v2/clients/$ID DELETE
            }}}
    End{}###
    }
