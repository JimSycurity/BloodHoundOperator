<#
.SYNOPSIS
    Invoke BloodHound Query
.DESCRIPTION
    Invoke BloodHound query
.EXAMPLE
    Invoke-BHQuery "MATCH (x:User) RETURN x LIMIT 1"
.EXAMPLE
    Invoke-BHQuery "api/version"
.EXAMPLE
    BHQuery -ID 123 | BHInvoke
.EXAMPLE
    "MATCH (x{objectid:'${oid}'}) RETURN x" | BHInvoke -Param @{oid='S-1-5-21-928081958-2569533466-1777930793-1800'}
#>

Function Invoke-BHPathQuery{
    [Alias('BHInvoke','Invoke-BHQuery')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][String]$Query,
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Description,
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Name,
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][Alias('GUID')][String]$ID,
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][ALias('Platforms')][String[]]$Platform,
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Category,
        [Parameter(Mandatory=0)][Hashtable]$Param,
        [Parameter(Mandatory=0)][Switch]$Minimal,
        [Parameter(Mandatory=0)][String]$Expand,
        [Parameter(Mandatory=0)][String[]]$Select,
        [Parameter(Mandatory=0)][Switch]$Cypher
        )
    Begin{}
    Process{Foreach($CQ in $Query){
        if($Param){Foreach($Key in $Param.keys){$CQ=$CQ.replace("`${$Key}",$Param.$Key)}}
        $QStart = [Datetime]::utcnow
        $QRes   = if($CQ -match "\/?api\/"){BHAPI $CQ -expand Data}else{
            BHCypher $CQ -Minimal:$Minimal -Cypher:$Cypher
            if($Cypher){RETURN $QRes}
            }
        $QStop  = [Datetime]::utcnow
        if($Expand){foreach($Field in ($Expand.split('.')-ne'Result')){
            $QRes=$QRes.$field
            }}
        if($Select){$QRes = $QRes | Select-Object $Select}
        $Obj = [PSCustomObject]@{}
        if($ID){$Obj|Add-Member -MemberType NoteProperty -Name ID -Value $ID}
        if($Platform){$Obj|Add-Member -MemberType NoteProperty -Name Platform -Value $Platform}
        if($Category){$Obj|Add-Member -MemberType NoteProperty -Name Category -Value $Category}
        if($Name){$Obj|Add-Member -MemberType NoteProperty -Name Name -Value $Name}
        if($Description){$Obj|Add-Member -MemberType NoteProperty -Name Description -Value $Description}
        $Obj|Add-Member -MemberType NoteProperty -Name Query -Value $CQ.trim()
        $Obj|Add-Member -MemberType NoteProperty -Name Result -Value $QRes
        $Obj|Add-Member -MemberType NoteProperty -Name Count -Value $(if($Qres.SourceType -AND $QRes.Step){$Qres[-1].id+1}else{$QRes.Count})
        $Obj|Add-Member -MemberType NoteProperty -Name Timestamp -Value $QStart
        $Obj|Add-Member -MemberType NoteProperty -Name Duration -Value $($QStop-$QStart)
        if("result" -in ($Expand.split('.'))){$Obj|Select -Expand Result}else{$Obj}
        }}
    End{}
    }
