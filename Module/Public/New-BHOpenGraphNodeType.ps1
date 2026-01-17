<#
.SYNOPSIS
    New OpenGraph Node type
.DESCRIPTION
    New BloodHound OpenGraph Node type Configuration
.EXAMPLE
        
#>

function New-BHOpenGraphNodeType{
    [Alias('New-BHOGType')]
    Param(
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Type')][Alias('Label','PrimaryKind')][String]$NodeType,
        [Parameter(Mandatory=0,Position=1,ParameterSetName='Type')][String]$Icon='question',
        [Parameter(Mandatory=0,Position=2,ParameterSetName='Type')][String]$Color='#FFF',
        #[Parameter(Mandatory=0)][String]$IconType='font-awesome',
        [Parameter(Mandatory=1,ValueFromPipeline=1,ParameterSetName='Object')][PSCUstomObject[]]$InputObject
        )
    Begin{
        NoMultiSession
        if($Color){if($Color -notmatch "^\#"){$Color="#$Color"}}
        if($NodeType){[PSCustomObject]@{NodeType=$NodeType;Icon=$Icon;Color=$Color}|New-BHOpenGraphNodeType;Break}
        $Collect=@()
        $IconType='font-awesome'
        }
    Process{foreach($Obj in $InputObject){$Collect+=$Obj}}
    End{$Ctype = $Collect|%{@{"$($_.NodeType)"=@{icon=@{type=$IconType;name=$_.Icon;color=$_.Color}}}}
        BHAPI /custom-nodes POST (@{custom_types=$Ctype}|Convertto-Json -Depth 23) -expand data
        }
    }
