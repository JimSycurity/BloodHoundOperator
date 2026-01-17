<#
.Synopsis
    [BHE] Get BloodHound Client
.DESCRIPTION
    Get BloodHound Client
.EXAMPLE
    Get-BHClient -ID $ClientID
.EXAMPLE
    Get-BHClient -ID $ClientID -CompletedJobs
#>

function Get-BHClient{
    [CmdletBinding(DefaultParameterSetName='All')]
    [Alias('BHClient')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ID')][Alias('ClientID')][String[]]$ID,
        [Parameter(ParameterSetName='ID')][Switch]$CompletedJobs
        )
    Begin{BHEOnly
        if(-Not$ID){BHAPI "api/v2/clients?hydrate_domains=false&hydrate_ous=false" -expand Data}else{NoMultiSession}
        }
    Process{Foreach($CliID in $ID){
        if($CompletedJobs){BHAPI api/v2/clients/$CliID/completed-jobs -expand data}
        else{BHAPI api/v2/clients/$CliID -expand Data}
        }}
    End{}
    }
