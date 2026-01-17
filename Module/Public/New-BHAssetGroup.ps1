<#
.SYNOPSIS
    New BH Asset Group
.DESCRIPTION
    Create BloodHound Asset Group
.EXAMPLE
    New-BHAssetGroup -Name MyAssetGroup -type Label
#>

function New-BHAssetGroup{
    [Alias('New-BHZone')]
    Param(
        [Parameter(Mandatory=1)][String]$Name,
        [ValidateSet('Tier','Label')]
        [Parameter(Mandatory=0)][String]$Type='Label',
        [Parameter(Mandatory=0)][String]$Description='Privilege Zone',
        [Parameter(Mandatory=0)][int]$Position,
        [Parameter(Mandatory=0)][Switch]$RequireCertiFy
        )
    NoMultiSession;BHEOnly
    if(($Type -eq 'Label') -AND ('Position' -IN $PSCmdlet.MyInvocation.BoundParameters.Keys)){
        Write-Warning "[BH] Asset group position only applies to Tiers. Remove -Position or set -Type Tier";RETURN
        }
    $AssGrp = @{
        name            = $Name
        type            = Switch($Type){Tier{0}Label{1}}
        description     = $Description
        require_certify = if($RequireCertify){$true}else{$false}
        }
    if('Position' -IN $PSCmdlet.MyInvocation.BoundParameters.Keys){
        $AssGrp['position'] = $Position
        }
    $AssGrp = $AssGrp | ConvertTo-Json -Depth 21
    BHAPI api/v2/asset-group-tags POST $AssGrp -Expand $Null
    }
