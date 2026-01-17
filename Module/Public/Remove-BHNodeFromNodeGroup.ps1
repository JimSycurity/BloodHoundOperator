<#
.SYNOPSIS
    Remove BHNode From BHNodeGroup
.DESCRIPTION
    Remove BHNode From BHNodeGroup
.EXAMPLE
    BHSearch User alice | Remove-BHNodeFromNodeGroup -NodeGroupID 1
#>

function Remove-BHNodeFromNodeGroup{
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('NodeID','selector')][String[]]$ObjectID,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('GroupID','asset_group_id')][Int[]]$NodeGroupID,
        [Parameter()][Switch]$Analyse,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($NodeID in $ObjectID){if($Force -OR $(Confirm-Action "Remove Object $NodeID from Asset Group $NodegroupID")){
        # Get Selector
        $SelectSelect = Get-BHNodeGroup -ID $NodegroupID -Selector | ? selector -eq $NodeID
        # Remove Selector
        if($SelectSelect){$RemoveSelect=@{
            action = 'remove'
            selector_name = $SelectSelect.name
            sid = $SelectSelect.Selector
            } | ConvertTo-Json -Depth 11
        BHAPI api/v2/asset-groups/$NodeGroupID/selectors PUT "[$RemoveSelect]" -expand data.removed_selectors
        }}}}
    End{if($Analyze){Start-BHDataAnalysis -verbose:$false}}
    }
