<#
.Synopsis
    New BloodHound Asset Group
.DESCRIPTION
    New BloodHound Asset Group
.EXAMPLE
    New-BHNodeGroup TestGroup
#>

function New-BHNodeGroup{
    Param(
        [Parameter(Position=0,Mandatory=1)][String]$Name,
        [Parameter(Position=1,Mandatory=0)][String]$Tag,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    if(-Not$tag){$Tag=$Name.tolower().replace(' ','_')}
    $Body = @{name=$Name;tag=$Tag} | Convertto-Json
    $reply=Invoke-BHAPI api/v2/asset-groups -method POST -Body $Body -expand data
    if($PassThru){$Reply}
    }
