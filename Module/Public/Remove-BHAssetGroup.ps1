<#
.SYNOPSIS
    Remove BH Asset Group
.DESCRIPTION
    Remove BloodHound Asset Group
.EXAMPLE
    Remove-BHAssetGroup -id 3 -force
#>

function Remove-BHAssetGroup{
    [Alias('Remove-BHZone')]
    Param(
        [Parameter(Mandatory=1,Position=0)][int]$GroupID,
        [Parameter()][int]$Force
        )
    NoMultiSession;BHEOnly
    if($Force -OR $(Confirm-Action "[BH] Delete Asset Group $GroupID?")){
        BHAPI api/v2/asset-group-tags/$GroupID DELETE
        }
    }
