<#
.SYNOPSIS
    Get BH Asset Group Selector
.DESCRIPTION
    Get BloodHound Asset Group Selector
.EXAMPLE
    BHSelector 1 21
#>

function Get-BHAssetGroupSelector{
    [CmdletBinding(DefaultParameterSetName='Selector')]
    [Alias('BHSelector','Get-BHSelector')]
    Param(
        [Parameter(Mandatory=1,Position=0)][Alias('id')][Int]$GroupID,
        [Parameter(Mandatory=1,Position=1,ParameterSetName='Count')]
        [Parameter(Mandatory=1,Position=1,ParameterSetName='Member')]
        [Parameter(Mandatory=1,Position=1,ParameterSetName='SelectorID')][Int]$SelectorID,
        [Parameter(Mandatory=1,ParameterSetName='Count')]
        [Parameter(Mandatory=1,ParameterSetName='Member')][Switch]$Member,
        [Parameter(Mandatory=1,ParameterSetName='Count')][Switch]$Count,
        [Parameter(Mandatory=0,ParameterSetName='SelectorID')][Switch]$Seeds
        )
    if(-Not$SelectorID){BHAPI /asset-group-tags/$GroupID/selectors -Expand data.selectors}
    else{if($Count){
            BHAPI /asset-group-tags/$GroupID/selectors/$selectorID/members -Expand data.members | Group-Object primary_kind -NoElement | Select @{n='primary_kind';e={$_.Name}},count
            }
        elseif($Member){BHAPI /asset-group-tags/$GroupID/selectors/$selectorID/members -Expand data.members}
        else{$Exp = if($Seeds){'data.selector.seeds'}else{'data.selector'}
            BHAPI /asset-group-tags/$GroupID/selectors/$selectorID -Expand $exp
            }
        }
    }
