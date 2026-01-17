<#
.Synopsis
    [BHE] Get BloodHound Client Job
.DESCRIPTION
    Get BloodHound Client Finished Job
    Job Status:
    Invalid          =-1
    Ready            = 0
	Running          = 1
	Complete         = 2
	Canceled         = 3
	TimedOut         = 4
	Failed           = 5
	Ingesting        = 6
	Analyzing        = 7
	PartialyComplete = 8
.EXAMPLE
    Get-BHClientJob [-status <status>] [-ClientID <client_id>]
.EXAMPLE
    BHJob -IncludeUnfinished [-Only]
.EXAMPLE
    BHJob -JobId 1234 [-log]
#>

function Get-BHClientJob{
    [CmdletBinding(DefaultParameterSetName='Finished')]
    [Alias('BHJob')]
    Param(
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName,ParameterSetName='Unfinished')]
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName,ParameterSetName='Finished')][Alias('id')][string[]]$ClientID="*",
        [Parameter(Mandatory=0,ParameterSetName='Unfinished')]
        [Parameter(Mandatory=0,ParameterSetName='Finished')][int]$Status,
        [Parameter(Mandatory=0,ParameterSetName='Finished')][Int]$Limit=$($BHSession|? x|select -last 1).limit,
        [Parameter(Mandatory=1,ParameterSetName='Unfinished')][Alias('Unfinished')][Switch]$IncludeUnfinished,
        [Parameter(Mandatory=0,ParameterSetName='Unfinished')][Switch]$Only,
        [Parameter(Mandatory=1,ParameterSetName='ID')][String]$JobID,
        [Parameter(Mandatory=0,ParameterSetName='ID')][Switch]$Logs
        )
    Begin{BHEOnly}
    process{Switch($PSCmdlet.ParameterSetName){
        Unfinished{
            foreach($CliID in $ClientID){
                [Array]$qFilter=@('hydrate_ous=false','hydrate_domains=false')    
                #if($Limit){$qFilter+="limit=$Limit"}
                if($Status){$qFilter+="status=eq:$Status"}
                if($CliID -AND $CliID -ne '*'){$qFilter+="client_id=eq:$CliID"}
                $Jobz=BHAPI jobs -Filter $qFilter -expand data |%{$_|Add-member -MemberType NoteProperty -Name status -Value ($_.status -as [BHJobStatus]) -force -PassThru}
                if($Only){$Jobz|? status -in ('Ready','Running','Canceled','TimedOut','Failed') |Sort-Object execution_time -Descending}else{$Jobz|Sort-Object execution_time -Descending}
                }
            }
        Finished{
            foreach($CliID in $ClientID){
                [Array]$qFilter=@('hydrate_ous=false','hydrate_domains=false')
                if($Limit){$qFilter+="limit=$Limit"}
                if($Status){$qFilter+="status=eq:$Status"}
                if($CliID -AND $CliID -ne '*'){$qFilter+="client_id=eq:$CliID"}
                BHAPI jobs/finished -Filter $qFilter -expand data |%{$_|Add-member -MemberType NoteProperty -Name status -Value ($_.status -as [BHJobStatus]) -force -PassThru}
                }
            }
        ID{if($Logs){BHAPI jobs/$JobID/log}else{BHAPI jobs/$JobID -expand data}}
        }}
    End{}
    }
