<#
.SYNOPSIS
    Get BloodHound Composer Logs
.DESCRIPTION
    Get BloodHound Composer Logs
.EXAMPLE
    BHLog -TraceObject | select time,status,message
#>

Function Get-BHComposerLog{
    [Alias('BHLog')]
    [CmdletBinding(DefaultParameterSetName='obj')]
    Param(
        [Parameter(Mandatory=0)][Alias('Latest')][string]$Limit='all',
        [Parameter(Mandatory=1,ParameterSetName='Trace')][Switch]$Trace,
        [Parameter(Mandatory=1,ParameterSetName='TraceObject')][Switch]$TraceObject,
        [Parameter(Mandatory=0)]$ComposerFolder=$pwd
        )
    Switch($PSCmdlet.ParameterSetName){
        TraceObject{$Ago = [DateTime]::utcnow.ToString('o')
            while($true){
                docker compose logs --since $Ago --no-log-prefix bloodhound | Convertfrom-JSON | sort-object time -descending
                $Ago = [DateTime]::utcnow.ToString('o')
                Start-Sleep -seconds 1
                }}
        Trace   {docker compose logs -f bloodhound}
        Default {docker compose logs -n $Limit --no-log-prefix bloodhound | Convertfrom-JSON}
        }}
