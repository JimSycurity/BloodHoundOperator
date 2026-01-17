<#
.SYNOPSIS
New BloodHound Composer
.DESCRIPTION
Download BloodHound docker-compose files
.EXAMPLE
New-BHComposer $FolderLocation
#>

function New-BHComposer{
    Param(
        [Parameter(Mandatory=0)][String]$ComposerFolder=$pwd,
        [Parameter(Mandatory=0)][Switch]$IncludeEnv,
        [Parameter(Mandatory=0)][Switch]$IncludeConfig
        )
    if(-Not(Test-Path $ComposerFolder)){$Null = mkdir $ComposerFolder}
    # Docker Compose
    irm https://ghst.ly/getbhce | out-file "$ComposerFolder/docker-compose.yml"
    # Docker env
    if($IncludeEnv){
        irm https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/.env.example | out-file "$ComposerFolder/.env.example"
        }
    # BH Config
    if($IncludeConfig){
        irm https://raw.githubusercontent.com/SpecterOps/BloodHound/main/examples/docker-compose/bloodhound.config.json | out-file "$ComposerFolder/bloodhound.config.json"
        }}
