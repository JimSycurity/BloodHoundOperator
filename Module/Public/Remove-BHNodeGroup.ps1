<#
.Synopsis
    Remove BloodHound Asset Group
.DESCRIPTION
    Remove BloodHound Asset Group
.EXAMPLE
    Remove-BHNodeGroup 2
#>

function Remove-BHNodeGroup{
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Int[]]$ID,
        [Parameter()][Switch]$Force
        )
    Begin{}
    Process{Foreach($GrpID in $ID){
        $GrpName = (Get-BHNodeGroup $GrpID).name
        if($force -OR (Confirm-Action "Delete Asset-Group $GrpName")){
            Invoke-BHAPI api/v2/asset-groups/$GrpID -Method DELETE
            }}}
    End{}###
    }
