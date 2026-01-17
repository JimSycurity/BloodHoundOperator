<#
.SYNOPSIS
    Get OpenGraph Node Type
.DESCRIPTION
    Get BloodHound OpenGraph Node Type
.EXAMPLE
    BHOpenGraphType [<$NodeType>] [-Config]
#>

function Get-BHOpenGraphNodeType{
    [Alias('BHOGType','Get-BHOGType')]
    Param(
        [Parameter(Mandatory=0)][Alias('Label','PrimaryKind')][String[]]$NodeType,
        [Parameter(Mandatory=0)][Switch]$Config
        )
    NoMultiSession
    $Exp = if($Config){"data.config.icon"}else{'data'}
    if($NodeType){foreach($NType in $NodeType){BHAPI /custom-nodes/$NType -Expand $exp}}
    else{BHAPI /custom-nodes -Expand $exp}
    }
