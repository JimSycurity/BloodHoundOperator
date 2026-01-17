<#
.Synopsis
    [BHE] Set BloodHound Client Event
.DESCRIPTION
    Description
.EXAMPLE
    Set-BHEvent
#>

function Set-BHEvent{
    Param(
        [Parameter(Mandatory=1,ValueFromPipelineByPropertyName)][String[]]$ID,
        [Parameter(Mandatory=0)][String]$Rule,
        [Parameter(Mandatory=0)][bool]$SessionCollection,
        [Parameter(Mandatory=0)][bool]$LocalGroupCollection,
        [Parameter(Mandatory=0)][bool]$ADStructureCollection,
        [Parameter(Mandatory=0)][bool]$CertServiceCollection,
        [Parameter(Mandatory=0)][bool]$CARegistryCollection,
        [Parameter(Mandatory=0)][bool]$DCRegistryCollection,
        [Parameter(Mandatory=0)][bool]$AllDomain,
        [Parameter(Mandatory=0)][String[]]$OU,
        [Parameter(Mandatory=0)][String[]]$Domain,
        [Parameter()][Switch]$PassThru
        )
    Begin{NoMultiSession;BHEOnly
        $Invocation = $PSCmdlet.MyInvocation.BoundParameters
        }
    Process{foreach($EvtId in $ID){# <------------------------------- Confirm Action?
        $EvtObj = BHEvent -Eventid $EvtID
        if($EvtObj){$EvtSet = @{
            rrule                    = if($Rule){$Rule}else{$EvtObj.rrule}
            session_collection       = if($Invocation.ContainsKey("SessionCollection")){$SessionCollection}else{$EvtObj.session_collection}
            local_group_collection   = if($Invocation.ContainsKey("LocalGroupCollection")){$LocalGroupCollection}else{$EvtObj.local_group_collection}
            ad_structure_collection  = if($Invocation.ContainsKey("ADStructureCollection")){$ADStructureCollection}else{$EvtObj.ad_structure_collection}
            cert_services_collection = if($Invocation.ContainsKey("CertServiceCollection")){$CertServiceCollection}else{$EvtObj.cert_services_collection}
            ca_registry_collection   = if($Invocation.ContainsKey("CARegistryCollection")){$CARegistryCollection}else{$EvtObj.ca_registry_collection}
            dc_registry_collection   = if($Invocation.ContainsKey("DCRegistryCollection")){$DCRegistryCollection}else{$EvtObj.dc_registry_collection}
            all_trusted_domains      = if($Invocation.ContainsKey("AllDomain")){$AllDomain}else{$EvtObj.all_trusted_domains}
            ous                      = if($OU){$OU}else{$EvtObj.ous}
            domains                  = if($Domain){$Domain}else{$EvtObj.domains} 
            } | ConvertTo-Json
        $Output = BHAPI events/$ID PUT $EvtSet -expand data
        if($PassThru){$Output}
        }}}
    End{}
    }
