<#
.SYNOPSIS
    Get BloodHound Query
.DESCRIPTION
    Get BloodHound Saved Query 
.EXAMPLE
    BHQuery
.EXAMPLE
    BHQuery -ID 123
.EXAMPLE
    BHQuery -name MyQuery
.EXAMPLE
    BHQuery -description <keyword>
.EXAMPLE
    BHQuery -scope <shared|public>
#>

function Get-BHPathQuery{
    [CmdletBinding(DefaultParameterSetName='ByID')]
    [Alias('BHQuery','Get-BHQuery')]
    Param(
        [Parameter(Mandatory=0,Position=0,ParameterSetName='ByID')][String[]]$ID,
        [Parameter(Mandatory=1,ParameterSetName='ByName')][String[]]$Name,
        [ValidateSet('public','shared')]
        [Parameter(Mandatory=1,ParameterSetName='ByScope')][String]$Scope,
        [Parameter(Mandatory=1,ParameterSetName='ByDescription')][String[]]$Description,
        #[Parameter(Mandatory=1,ParameterSetName='FromRepo')][Alias('FromMartin')][Switch]$OnlineLibrary,
        [Parameter(Mandatory=0)][String]$Expand='data',
        [Parameter(Mandatory=0)][SWitch]$Cypher
        )
    NoMultiSession
    $Out = Switch($PSCmdlet.ParameterSetName){
        ByID{$Q=BHAPI api/v2/saved-queries -expand $Expand
            if($ID){$Q|Where id -In $ID}else{$Q}
            }
        ByName{BHAPI api/v2/saved-queries -Filter "name=~eq:$Name" -expand $Expand}
        ByDescription{BHAPI api/v2/saved-queries -Filter "description=~eq:$Description" -expand $expand}
        ByScope{BHAPI api/v2/saved-queries -Filter "scope=$Scope" -expand $expand}
        }
    if($Cypher -AND -Not$OnlineLibray){if(($BHSession|? x|Select -last 1).CypherClip){$Out.Query.trim()|Set-Clipboard};RETURN $Out.Query.trim()}
    else{$Out}
    }
