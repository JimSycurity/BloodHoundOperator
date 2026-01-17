<#
.Synopsis
    Set BloodHound Asset Group
.DESCRIPTION
    Set BloodHound Asset Group
.EXAMPLE
    Set-BHNodeGroup -ID $GroupID -Name $NewName
#>

function Set-BHNodeGroup{
        Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Int]$ID,
        [Parameter(Mandatory=1)][String]$Name
        )
    Begin{}
    Process{foreach($GrpID in $ID){
        $Body = @{name=$Name} | Convertto-Json
        Invoke-BHAPI api/v2/asset-groups/$GrpID -Method PUT -Body $Body
        }}
    End{}
    }
