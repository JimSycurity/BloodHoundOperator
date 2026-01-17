<#
.SYNOPSIS
    Get BH Asset Group
.DESCRIPTION
    Get BloodHound Asset Groups
.EXAMPLE
    BHAssetGroup
#>

function Get-BHAssetGroup{
    [Alias('BHZone','Get-BHZone')]
    [CmdletBinding(DefaultParameterSetName='Group')]
    Param(
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Search')]
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Count')]
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Member')]
        [Parameter(Mandatory=0,Position=0,ParameterSetName='Group')][Int]$GroupID,
        #[Parameter(Mandatory=1,ParameterSetName='Search')]
        [Parameter(Mandatory=1,ParameterSetName='Count')]
        [Parameter(Mandatory=1,ParameterSetName='Member')][Switch]$Member,
        [Parameter(Mandatory=1,ParameterSetName='Count')][Switch]$Count,
        [Parameter(Mandatory=1,Position=1,ParameterSetName='Search')][String]$AssetID,
        [Parameter(Mandatory=0,ParameterSetName='Search')][Switch]$Selector
        )
    if(-Not$GroupID){BHAPI /asset-group-tags -Expand data.tags}
    else{if($Count){BHAPI /asset-group-tags/$GroupID/members/counts -Expand data.counts}
        elseif($AssetID){
            $Exp=if($Selector){'data.member.selectors'}else{'data.member'}
            BHAPI /asset-group-tags/$GroupID/members/$AssetID -Expand $exp}
        elseif($Member){BHAPI /asset-group-tags/$GroupID/members -Expand data.members}
        else{BHAPI /asset-group-tags/$GroupID -Expand data.tag}
        }
    }
