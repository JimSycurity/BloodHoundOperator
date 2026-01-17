<#
.Synopsis
    Search BloodHound Node
.DESCRIPTION
    Search BloodHound Node
.EXAMPLE
    BHSearch user bob
#>

function Search-BHNode{
    [Alias('BHSearch')]
    Param(
        [Parameter(Mandatory=0,Position=0)][Alias('Type')][BHEntityType[]]$Label,
        [Parameter(Mandatory=0,Position=1)][String[]]$Keyword='-',
        [Parameter(Mandatory=0)][Int]$Limit=$($BHSession|? x|select -last 1).limit,
        [Parameter(Mandatory=0)][Switch]$Exact,
        [Parameter(Mandatory=0)][int[]]$SessionID=($BHSession|? x).id
        )
    foreach($SessID in $SessionID){Foreach($Key in $Keyword){
        $Key=$Key.replace(' ','+')
        $RL = if($exact){
            $Label = 'exact'
            "api/v2/graph-search?query=$Key"
            }
        else{"api/v2/search?q=$key"}
        if($Limit){$RL+="&limit=$Limit"}
        if($Label){Foreach($Lbl in $Label){Invoke-BHAPI "$RL&type=$lbl" -dot data -SessionID $SessID}}
        else{Invoke-BHAPI $RL -dot data -SessionID $SessID}
        }}
    }
