<#
.SYNOPSIS
    Test BH Asset Group Selector
.DESCRIPTION
    Test BloodHound Asset Group Selector
.EXAMPLE
    Test-BHSelector "MATCH (x:User) RETURN x LIMIT 5"
#>

function Test-BHAssetGroupSelector{
    [Alias('Test-BHSelector')]
    Param(
        [Parameter(Mandatory=1,Position=0)][Alias('Value')][String]$Seed,
        [ValidateSet('Cypher','ObjectID')]
        [Parameter(Mandatory=0,Position=1)][Alias('Type')][String]$SeedType='Cypher',
        [Parameter(Mandatory=0)][Switch]$Count
        )
    $SType=Switch($seedType){Cypher{2}ObjectID{1}}
    $Hash=@{seeds=@(@{type=$sType;value=$Seed})}
    BHAPI /asset-group-tags/preview-selectors POST ($Hash|Convertto-Json -Depth 21) -expand data.members
    }
