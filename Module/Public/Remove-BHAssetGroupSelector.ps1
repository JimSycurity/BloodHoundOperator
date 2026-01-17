<#
.SYNOPSIS
    Remove BH Asset Group Selector
.DESCRIPTION
    Remove BloodHound Asset Group Selector
.EXAMPLE
    Remove-BHSelector 1 44 -force
#>

function Remove-BHAssetGroupSelector{
    Param(
        [Parameter(Mandatory=1)][int]$GroupID,
        [Parameter(Mandatory=1)][int]$SelectorID,
        [Parameter(Mandatory=0)][Switch]$Force
        )
    if($Force -OR $(Confirm-Action "[BH] Delete Selector $SelectorID from Asset Group $GroupID")){
    BHAPI /asset-group-tags/$GroupID/selectors/$SelectorID DELETE
    }}
