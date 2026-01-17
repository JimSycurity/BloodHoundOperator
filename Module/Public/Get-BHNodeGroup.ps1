<#
.Synopsis
    Get BloodHound Asset Group
.DESCRIPTION
    Get BloodHound Asset Group
.EXAMPLE
    BHNodeGroup
#>

function Get-BHNodeGroup{
    [CmdletBinding(DefaultParameterSetName='List')]
    [Alias('BHNodeGroup')]
    Param(
        [Parameter(Mandatory=1,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='Custom')]
        [Parameter(Mandatory=1,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='Collection')]
        [Parameter(Mandatory=1,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='Member')]
        [Parameter(Mandatory=0,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='List')][String[]]$ID,
        [Parameter(Mandatory=1,ParameterSetName='Member')][Switch]$Member,
        [Parameter(Mandatory=0,ParameterSetName='Member')][Alias('TenantID','DomainID')][String]$EnvironmentID,
        [Parameter(Mandatory=0,ParameterSetName='Member')][Switch]$Count,
        #[Parameter(Mandatory=1,ParameterSetName='Collection')][Switch]$Collection, <------------- Broken?
        [Parameter(Mandatory=1,ParameterSetName='Custom')][Switch]$CustomCount,
        [Parameter(ParameterSetName='List')][Switch]$Selector
        )
    Begin{}
    Process{Foreach($ObjID in $ID){
        Switch($PSCmdlet.ParameterSetName){
            List{if($Selector){Invoke-BHAPI api/v2/asset-group-tags/$ObjID/selectors}
                else{Invoke-BHAPI api/v2/asset-groups/$ObjID -expand data}
                }
            Member{$qFilter = if($EnvironmentID){"environment_id=eq:$EnvironmentID"}else{$Null}
                if($Count){Invoke-BHAPI api/v2/asset-groups/$ObjID/members/counts -filter $qFilter -expand data}
                else{Invoke-BHAPI api/v2/asset-groups/$ObjID/members -filter $qFilter -expand data.members}
                }
            Collection{Invoke-BHAPI api/v2/asset-groups/$ObjID/collections -filter "limit=1" -expand data}
            Custom    {Invoke-BHAPI api/v2/asset-groups/$ObjID/custom-selectors -expand data}
            }}}
    End{if(-Not$ObjID){
        if($Selector){Invoke-BHAPI api/v2/asset-groups -expand data.asset_groups.selectors}
        else{Invoke-BHAPI api/v2/asset-groups -expand data.asset_groups}
        }}
    }
