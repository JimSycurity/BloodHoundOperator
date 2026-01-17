<#
.SYNOPSIS
    Set BH Asset Group Selector
.DESCRIPTION
    Set BloodHound Asset Group Selector
.EXAMPLE
    Set-BHSelector 1 44 -name test
#>

function Set-BHAssetGroupSelector{
    [Alias('Set-BHSelector')]
    Param(
        [Parameter(Mandatory=1,Position=0)][String]$GroupID,
        [Parameter(Mandatory=1,Position=1)][String]$SelectorID,
        [Parameter(Mandatory=0)][String]$Name,
        [Parameter(Mandatory=0)][String[]]$Seed,
        [ValidateSet('Cypher','ObjectID')]
        [Parameter(Mandatory=0)][string]$SeedType,
        [Parameter(Mandatory=0)][String]$Description,
        [Parameter(Mandatory=0)][bool]$AutoCertify,
        [Parameter(Mandatory=0)][bool]$Disabled
        )
    if(($SeedType -AND -NOT$Seed) -OR ($Seed -AND -NOT$SeedType)){
        Write-Warning "[BH] Please Specify Seed and SeedType"
        RETURN
        }
    if($SeedType){$sType=Switch($SeedType){Cypher{2}objectid{1}}}
    if($Seed){$Seeds=$Seed|%{@{type=$sType;value=$_}}}
    $Hash=@{}
    if($Name){$Hash['name']=$Name}
    if($Seed){$Hash['seeds']=$Seeds}
    if($Description){$Hash['description']=$Description}
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'AutoCertify'){$Hash['auto-certify']=$AutoCertify}
    if($PSCmdlet.MyInvocation.BoundParameters.keys -contains 'Disabled'){$Hash['disabled']=$Disabled}
    #$($Hash|Convertto-Json -Depth 21)
    BHAPI /asset-group-tags/$GroupID/selectors/$SelectorID PATCH $($Hash|Convertto-Json -Depth 21) -expand data
    }
