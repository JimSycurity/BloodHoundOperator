<#
.SYNOPSIS
    New BH Asset Group Selector
.DESCRIPTION
    New BloodHound Asset Group Selector
.EXAMPLE
    New-BHSelector 1 test "MATCH (x:User) RETURN x LIMIT 1"
#>

function New-BHAssetGroupSelector{
    [Alias('New-BHSelector')]
    Param(
        [Parameter(Mandatory=1,Position=0)][String]$GroupID,
        [Parameter(Mandatory=1,Position=1)][String]$Name,
        [Parameter(Mandatory=1,Position=2)][String[]]$Seed,
        [ValidateSet('Cypher','ObjectID')]
        [Parameter(Mandatory=0)][string]$SeedType='Cypher',
        [Parameter(Mandatory=0)][String]$Description,
        [Parameter(Mandatory=0)][bool]$AutoCertify=$true,
        [Parameter(Mandatory=0)][bool]$Disabled=$false
        )
    $sType = Switch($SeedType){Cypher{2}objectid{1}}
    $Seeds = $Seed|%{@{type=$sType;value=$_}}
    $Hash  = @{
        name  = $Name
        seeds = @($Seeds)
        auto_certify = $AutoCertify
        disabled = $Disabled
        }
    if($Description){$Hash['description']=$Description}
    BHAPI /asset-group-tags/$GroupID/selectors POST $($Hash|Convertto-Json -Depth 21) -expand data
    }
