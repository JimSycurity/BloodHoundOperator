<#
.SYNOPSIS
    Remove OpenGraph Node type
.DESCRIPTION
    Remove BloodHound OpenGraph Node Type Configuration 
.EXAMPLE
    Remove-BHOpenGraphType <$NodeType> [-Force]
#>

function Remove-BHOpenGraphNodeType{
    [Alias('Remove-BHOGType')]
    Param(
        [Parameter(Mandatory=1,Position=0,ValueFromPipelineByPropertyName=1)][Alias('Label','PrimaryKind')][String[]]$NodeType,
        [Parameter(Mandatory=0)][Switch]$force
        )
    Begin{NoMultiSession}
    Process{Foreach($NType in $NodeType){
        if($Force -OR (Confirm-action "[BH] Delete Custom Node type $Ntype?")){
            BHAPI /custom-nodes/$NType DELETE
            }}}
    End{}###
    }
