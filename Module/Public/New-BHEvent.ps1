<#
.Synopsis
    [BHE] New BloodHound Client Event
.DESCRIPTION
    Description
.EXAMPLE
    New-BHEvent
#>

function New-BHEvent{
    Param(
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][Alias('ID')][String[]]$ClientID,
        [Parameter(Mandatory=0)][String]$Rule=$(BHRRule),
        [Parameter(Mandatory=0)][Switch]$SessionCollection,
        [Parameter(Mandatory=0)][Switch]$LocalGroupCollection,
        [Parameter(Mandatory=0)][Switch]$ADStructureCollection,
        [Parameter(Mandatory=0)][Switch]$CertServiceCollection,
        [Parameter(Mandatory=0)][Switch]$CARegistryCollection,
        [Parameter(Mandatory=0)][Switch]$DCRegistryCollection,
        [Parameter(Mandatory=0)][Switch]$AllDomain,
        [Parameter(Mandatory=0)][String[]]$OU,
        [Parameter(Mandatory=0)][String[]]$Domain
        )
    Begin{NoMultiSession;BHEOnly}
    Process{
        $EventObj = @{rrule = $Rule}   
        if($SessionCollection){$EventObj['session_collection']=[bool]$SessionCollection}
        if($LocalGroupCollection){$EventObj['local_group_collection']=[bool]$LocalGroupCollection}
        if($ADStructureCollection){$EventObj['ad_structure_collection']=[bool]$ADStructureCollection}
        if($CertServiceCollection){$EventObj['cert_services_collection']=[bool]$CertServiceCollection}
        if($CARegistryCollection){$EventObj['ca_registry_collection']=[bool]$CARegistryCollection}
        if($DCRegistryCollection){$EventObj['dc_registry_collection']=[bool]$DCRegistryCollection}
        if($AllDomain){$EventObj['all_trusted_domains']=[bool]$AllDomain}
        if($OU.count){$EventObj['ous']=@($OU)}
        if($Domain.count){$EventObj['domains']=@($Domain)}
        Foreach($CliID in $ClientID){
            $EventObj['client_id']=$CliID 
            BHAPI events POST ($EventObj|Convertto-Json) -expand data
            }
        }
    End{if(-Not$ClientID){$EventObj}}
    }
