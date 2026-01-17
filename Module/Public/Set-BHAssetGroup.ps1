<#
.SYNOPSIS
    Set BH Asset Group
.DESCRIPTION
    Set BloodHound Asset Group
.EXAMPLE
    Set-BHAssetGroup -Name MyAssetGroup -type Label
#>

function Set-BHAssetGroup{
    [Alias('Set-BHZone')]
    Param(
        [Parameter(Mandatory=0,Position=0)][String]$GroupID,
        [Parameter(Mandatory=0)][String]$Name,
        [ValidateSet('Tier','Label')]
        [Parameter(Mandatory=0)][String]$Type,
        [Parameter(Mandatory=0)][String]$Description,
        [Parameter(Mandatory=0)][int]$Position,
        [Parameter(Mandatory=0)][Bool]$RequireCertify
        )
    NoMultiSession;BHEOnly
    if(($Type -eq 'Label') -AND ('Position' -IN $PSCmdlet.MyInvocation.BoundParameters.Keys)){
        Write-Warning "[BH] Asset group position only applies to Tiers. Remove -Position or set -Type Tier";RETURN
        }
    $AssGrp = @{}
    if($name){$AssGrp['name'] = $Name}
    if($type){$AssGrp['type'] = Switch($Type){Tier{0}Label{1}}}
    if($description){$AssGrp['description'] = $Description}
    if('RequireCertify' -IN $PSCmdlet.MyInvocation.BoundParameters.Keys){
        $AssGrp['require_certify'] = $RequireCertify
        }
    if('Position' -IN $PSCmdlet.MyInvocation.BoundParameters.Keys){
        $AssGrp['position'] = $Position
        }
    if(-Not$AssGrp.keys.count){Write-Warning "[BH] No Parameters passed. Please specify parameter for update";RETURN}
    $AssGrp = $AssGrp | ConvertTo-Json -Depth 21
    BHAPI api/v2/asset-group-tags/$GroupID PATCH $AssGrp -Expand $Null
    }
