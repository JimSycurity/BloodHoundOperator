<#
.SYNOPSIS
    Get BloodHound Path
.DESCRIPTION
    Get BloodHound Path
.EXAMPLE
    BHPath
#>

function Get-BHPath{
    [CmdletBinding(DefaultParameterSetName='Query')]
    [Alias('Invoke-BHCypher','BHCypher')]
    Param(
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Query',ValueFromPipeline)][Alias('q')][String]$Query,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][Alias('Any')][Switch]$All,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][Switch]$Shortest,
        [Parameter(Mandatory=0,ParameterSetName='Manual')][alias('x')][String]$Source,
        [Parameter(Mandatory=0,ParameterSetName='Manual')][alias('y')][String]$Target,
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('xID')][String[]]$SourceID,
        [Parameter(Mandatory=1,ParameterSetName='ByID')][AllowNull()][alias('yID')][String[]]$TargetID,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('r','e')][String[]]$Edge=':{}',
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('n')][String]$Hop='1..',
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('xWhere','x?')][String]$SourceWhere,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('yWhere','y?')][String]$TargetWhere,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][alias('pWhere','p?')][String]$PathWhere,
        [ValidateSet('p','x','y')]
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][String]$Return='p',
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][String]$OrderBy,
        [Parameter(Mandatory=0,ParameterSetName='Manual')]
        [Parameter(Mandatory=0,ParameterSetName='ByID')][Int]$Limit=$($BHSession|? x|select -last 1).limit,
        [Parameter(Mandatory=0)][Switch]$Cypher,
        [Parameter(Mandatory=0)][Switch]$NoConvert,
        [Parameter(Mandatory=0)][Switch]$Minimal,
        [Parameter(Mandatory=0)][Alias('dot')][String]$Expand
        )
    Process{
    # Source / Target
    if($Source -AND $Source -notmatch "^\{"){if($Source -notmatch "^\:"){$Source=":$Source"}}
    if($Target -AND $Target -notmatch "^\{"){if($Target -notmatch "^\:"){$Target=":$Target"}}
    if($SourceID){$SourceWHere = "x.objectid IN ['$($SourceID-join"','")']"}
    if($TargetID){$TargetWHere = "y.objectid IN ['$($TargetID-join"','")']"}
    # Path Type
    $pType = if($All -AND $Shortest){'allShortestPaths'}
         elseif($Shortest -AND -Not$All){'shortestPath'}
         elseif($All -AND -Not$Shortest){}
         else{'shortestPath'}
    # Hop
    $Hop = if($All -AND -Not$Shortest){if($Hop){$Hop}}else{
        if($Hop){if($Hop -notmatch "\.\."){"1..$Hop"}else{$Hop}}else{$Null}
        }
    # EdgeFilter
    $EFilter = if($Edge -eq ':{}'){$((Get-BHPathFilter -Cypher).trim(':'))}else{$Edge-Join'|'}
    if($Edge.count -AND $Efilter -notmatch "^\:"){$EFilter=":$Efilter"}
    if($Source -eq $target -OR -Not$Source -OR -Not$Target){$PathWhere=(("($PathWhere)","x<>y")-ne'()')-join' AND '}
    # Query
    $CypherQ = if($Query){$Query}else{
"$(if($Source -OR $SourceWhere){"MATCH (x$Source)$(if($SourceWhere){" WHERE $SourceWhere"})"})$(
if($Target -OR $TargetWhere){"`r`nMATCH (y$Target)$(if($TargetWhere){" WHERE $TargetWhere"})"})
$(If($Optional){'OPTIONAL '})MATCH p=$pType((x)-[r$EFilter$(if($Hop){"*$Hop"})]->(y))$(if($PathWhere){"`r`nWHERE $PathWhere"})
RETURN $Return$(if($OrderBy){"`r`nORDER BY $OrderBy"})$(if($Limit){"`r`nLIMIT $Limit"})"
        }
    $CypherQ = $CypherQ.replace("-[:{}","-[$(Get-BHPathFilter -Cypher)").replace("-[:*","-[*")
    $CypherQ = $CypherQ.replace("-[r:{",'-[r{').replace("-[r:*",'-[r*').replace("-[r:]",'-[r]')
    ## Cypher
    if($Cypher){if(($BHSession|? x|Select -last 1).CypherClip){$CypherQ.trim()|Set-Clipboard};RETURN $CypherQ.trim()}
    # API Call
    Write-Verbose "[BH] POST api/v2/graphs/cypher
$($CypherQ.trim())"
    $Body = @{query=$CypherQ;include_properties=$(-Not$Minimal)}|ConvertTo-Json
    $QData = Invoke-BHAPI 'api/v2/graphs/cypher' -Method POST -Body $Body -expand $(if($NoConvert){$Expand}else{'data'}) -verbose:$False
    #$QData = BHPath -Query $CypherQ.trim() -Verbose:$false
    #if(-Not$shortest -AND -Not$All){$QData.edges=$QData.Edges|Sort-Object {"$($_.sourceS)-$($_.Target)"} -unique}
    ## NoConvert
    if($NoConvert){$QData | Select-Object -expand $Expand; RETURN}
    # Convert
    if($QData.edges.count){
        $PathID=0;$StepID=0
        For($Index=0;$Index -lt $QData.edges.count;$Index++){
            $Rel = $QData.Edges[$Index]
            $Src = $QData.nodes.$($Rel.Source)
            $tgt = $QData.nodes.$($Rel.target)
            # Edge Obj
            [PSCustomObject]@{
                ID                = $PathID
                Step              = $StepID
                SourceType        = $Src.Kind
                Source            = $Src.label
                Edge              = $Rel.label
                TargetType        = $tgt.Kind
                Target            = $tgt.label
                IsTierZeroSource  = $Src.IsTierZero
                IsTierZeroTarget  = $Tgt.IsTierZero
                TierZeroViolation = $Tgt.IsTierZero -AND -Not$Src.IsTierZero #-AND $Rel.Label -notin ('Contains','LocalToComputer','GetChanges')
                SourceID          = $Src.objectID
                TargetID          = $Tgt.objectID
                #LastSeen          = $Rel.lastseen
                EdgeProps         = $Rel.Properties
                }
            # Next IDs
            if($Rel.Target -eq $QData.Edges[$Index+1].source){$StepID+=1}
            else{$PathID+=1;$StepID=0}
            }}
    # Return x|y
    elseif($QData.nodes -AND ($QData.nodes|GM|? MemberType -eq noteproperty).name){
        $Out = ($QData.nodes|GM|? MemberType -eq noteproperty).name| %{$QData.nodes."$_"}
        if($Expand){foreach($Dot in $Expand.split('.')){$Out=try{$Out.$Dot}Catch{$Out}}}
        RETURN $Out
        }
    }}
