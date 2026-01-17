<#
.SYNOPSIS
    Add BHNode To BHNodeGroup
.DESCRIPTION
    Add BHNode To BHNodeGroup
.EXAMPLE
    BHSearch User alice | Add-BHNodeToNodeGroup -NodeGroupID 1
#>

function Add-BHNodeToNodeGroup{
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('NodeID')][String[]]$ObjectID,
        [Parameter(Mandatory)][Alias('GroupID')][Int]$NodeGroupID,
        [Parameter()][Switch]$Analyze,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($NodeID in $ObjectID){if($Force -OR $(Confirm-Action "Add Object $NodeID to Asset Group $NodegroupID")){
        $AddSelect = @{
            selector_name = $NodeID
            sid = $NodeID
            action = 'add'
            }
        BHAPI api/v2/asset-groups/$NodeGroupID/selectors PUT "[$(@($AddSelect)|ConvertTo-Json -Depth 21)]" -expand data.added_selectors
        }}}
    End{if($Analyze){Start-BHDataAnalysis -verbose:$False}}
    }
