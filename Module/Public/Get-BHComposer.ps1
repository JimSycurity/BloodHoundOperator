<#
.SYNOPSIS
    Get BloodHound Composer
.DESCRIPTION
    View Composer status
    View BloodHound docker-compose files content
.EXAMPLE
    Get-BHComposer
#>

Function Get-BHComposer{
    [CmdletBinding(DefaultParameterSetName='status')]
    Param(
        [Parameter(Mandatory=1,ParameterSetName='Composer')][Switch]$Composer,
        [Parameter(Mandatory=1,ParameterSetName='Env')][Switch]$Env,
        [Parameter(Mandatory=1,ParameterSetName='Config')][Switch]$Config,
        [Parameter(Mandatory=0)]$ComposerFolder=$pwd
        )
    Switch($PSCmdlet.ParameterSetName){
        status   {docker compose ps --format json | Convertfrom-JSON}
        Composer {get-content $ComposerFolder/docker-compose.yml}
        env      {get-content $ComposerFolder/.env}
        Config   {get-content $ComposerFolder/bloodhound.config}
        }}
