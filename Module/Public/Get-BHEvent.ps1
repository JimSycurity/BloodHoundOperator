<#
.Synopsis
    [BHE] Get BloodHound Client Event
.DESCRIPTION
    Description
.EXAMPLE
    Get-BHEvent
#>

function Get-BHEvent{
    Param(
        [Parameter(Mandatory=1,ParameterSetName='ID')][String[]]$EventID,
        [Parameter(Mandatory=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='All')][Alias('ID')][String[]]$ClientID
        )
    Begin{BHEOnly
        if($EventID){Foreach($EvtID in $EventID){BHAPI events/$EvtID -expand data}}

        }
    Process{if($ClientID){Foreach($CliID in $ClientID){BHAPI api/v2/events -filter "client_id=eq:$CliID" -expand Data}}}
    End{if(-Not$ClientID -AND -NOT $EventID){BHAPI api/v2/events -expand Data}}
    }
