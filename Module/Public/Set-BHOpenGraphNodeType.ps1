<#
.SYNOPSIS
    Set Custom Node type
.DESCRIPTION
    Set BloodHound OpenGraph Node Type Configuration 
.EXAMPLE
    Set-BHOpenGraphType Unknown -IconName question -color '#FFF'
#>

function Set-BHOpenGraphNodeType{
    [Alias('Set-BHOGType')]
    Param(
        [Parameter(Mandatory=1,Position=0)][Alias('Label','PrimaryKind')][String]$NodeType,
        [Parameter(Mandatory=0,Position=1)][String]$Icon,
        [Parameter(Mandatory=0,Position=2)][String]$Color,
        #[Parameter(Mandatory=0)][String]$IconType='font-awesome'
        [Parameter(Mandatory=0)][Switch]$Json
        )
    NoMultiSession
    $IconConf = @{type='font-awesome'}
    if($Icon ){$IconConf['name'] = $Icon}
    if($Color){
        if($Color -notmatch "^\#"){$Color="#$Color"}
        $IconConf['color']= $Color
        }
    $Config = @{config=@{icon=$IconConf}} | Convertto-Json -Depth 23
    if($Json){$Config}
    else{BHAPI /custom-nodes/$NodeType PUT $Config -expand data}
    }
