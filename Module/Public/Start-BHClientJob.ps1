<#
.Synopsis
    [BHE] Start BloodHound Client Job
.DESCRIPTION
    Start BHE Client Job (immediate task)
.EXAMPLE
    Start-BHClientJob
#>

function Start-BHClientJob{
    [Alias('Start-BHJob')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String[]]$ClientID,
        [Parameter(Mandatory=0)][Switch]$SessionCollection,
        [Parameter(Mandatory=0)][Switch]$LocalGroupCollection,
        [Parameter(Mandatory=0)][Switch]$ADStructureCollection,
        [Parameter(Mandatory=0)][Switch]$CertServiceCollection,
        [Parameter(Mandatory=0)][Switch]$CARegistryCollection,
        [Parameter(Mandatory=0)][Switch]$DCRegistryCollection,
        [Parameter(Mandatory=0)][Switch]$AllDomain,
        [Parameter(Mandatory=0)][String[]]$OU,
        [Parameter(Mandatory=0)][String[]]$Domain,
        [Parameter(Mandatory=0)][Switch]$Force
        )
    Begin{BHEOnly
        $EvtObj = @{
            session_collection       = [bool]$SessionCollection
            local_group_collection   = [bool]$LocalGroupCollection
            ad_structure_collection  = [bool]$ADStructureCollection
            cert_services_collection = [bool]$CertServiceCollection
            ca_registry_collection   = [bool]$CARegistryCollection
            dc_registry_collection   = [bool]$DCRegistryCollection
            all_trusted_domains      = [bool]$AllDomain
            ous                      = @($OU)
            domains                  = @($Domain)
            } | ConvertTo-Json
        }
    Process{Foreach($CliID in $ClientID){
        if($Force -OR $(Confirm-Action "Run collection Client ID $CliID")){BHAPI -Method POST api/v2/clients/$CliID/jobs -Body $EvtObj -expand data}
        }}
    End{}
    }
