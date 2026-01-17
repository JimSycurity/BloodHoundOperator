<#
.SYNOPSIS
Invoke BloodHound Composer
.DESCRIPTION
Invoke BloodHound docker-compose commands
.EXAMPLE
Invoke-BHComposer Up
#>

function Invoke-BHComposer{
    [Alias('BHComposer')]
    Param(
        [ValidateSet('Status','Up','Start','Pause','Resume','Stop','Down','Update','KillNeo','KillAll')]
        [Parameter(Mandatory=0,Position=0,ParameterSetName='Action')][String]$Action='Status',
        [Parameter(Mandatory=1,ParameterSetName='Command')][String]$Command,
        [Parameter(Mandatory=0)][String]$ComposerFolder=$pwd,
        [Parameter(Mandatory=0,ParameterSetName='Action')][Switch]$Force
        )
    # Action
    if($PSCmdlet.ParameterSetName -eq 'Action'){
        $Project = split-path $ComposerFolder -leaf
        Switch($Action){
            Status {docker compose $Composer ps --format json | Convertfrom-JSON}
            Up     {docker compose $Composer up}
            Start  {docker compose $Composer start}
            Pause  {docker compose $Composer pause}
            Resume {docker compose $Composer unpause}
            Stop   {docker compose $Composer stop}
            Down   {if($Force -OR $(Confirm-Action "Remove $Project [Keep volumes]")){
                docker compose $Composer down
                }}
            Update {if($Force -OR $(Confirm-Action "Update $Project to latest build - Keep volumes")){
                docker compose $Composer down
                docker compose $Composer pull
                docker compose $Composer up
                }}
            KillNeo{if($Force -OR $(Confirm-Action "Remove $Project - Neo4j data only")){
                $Project= $Project.ToLower()
                docker volume rm ${Project}_neo4j-data
                }}
            KillAll{if($Force -OR $(Confirm-Action "Remove $Project - Remove volumes")){
                docker compose $Composer down -v
                }}}}
    # Command ##
    else{docker compose $Composer $Command}
    }
