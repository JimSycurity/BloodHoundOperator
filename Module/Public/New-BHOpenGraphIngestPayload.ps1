<#
.SYNOPSIS
    New OpenGraph Ingest Payload
.DESCRIPTION
    Create BloodHound OpenGraph Ingest Payload with OpenGraph Nodes and/or Edges
    Use ConvertTo-BHOpenGraphNode to format node list
    Use ConvertTo-BHOpenGraphEdge to format Edge list
.EXAMPLE
    BHOpenGraphPayload -NodeList $BHOpenGraphNodeList -EdgeList $BHOpenGraphEdgeList
.EXAMPLE
    # Bulk Import from csv files #
    
    $Graph = @{
        Nodelist = Import-Csv BHOpenGraphCSV\Person.csv | ToBHOpenGraphNode *
        EdgeList = Import-Csv BHOpenGraphCSV\EdgeByID.csv | ToBHOpenGraphEdge *
        }
    
    BHOpenGraphPayload @Graph | BHDataUploadJSON
    
    # Node CSV: id,label,[extralabel],name
    # + any other (treated as node properties)
    # Edge CSV: source,edge,target
    # + any other (treated as edge properties)
    # Edge source and target values should be node IDs
    # (use -SourceFromName and/or -TargetFromName to use name values instead)
#>

Function New-BHOpenGraphIngestPayload{
    [CmdletBinding(DefaultParameterSetName='Arrows')]
    [Alias('BHOGPayload','New-BHOGPayload')]
    Param(
        [Parameter(ParameterSetName='List')][PSCustomObject[]]$NodeList,
        [Parameter(ParameterSetName='List')][PSCustomObject[]]$EdgeList,
        [Parameter()][Switch]$NoJSON,
        [Parameter()][Switch]$Compress,
        [Parameter()][string]$CollectorName='CustomCollector',
        [Parameter()][string]$CollectorVersion='beta',
        [Parameter()][String[]]$CollectionMethod='Custom',
        [Parameter()][Switch]$NoMeta,
        [Parameter(Mandatory=1,ParameterSetName='Arrows',ValueFromPipeline)][String]$FromArrows
        )
    Begin{}
    Process{if($PSCmdlet.ParameterSetName -eq 'List'){
        $Graph = [PSCustomObject]@{}
        #if(-not $fromArrows -AND (-Not$NodeList -AND -not$EdgeList)){Write-Warning "Please specify OpenGraph nodes and/or edges for payload";RETURN}
        if($NodeList){$Graph|Add-Member -MemberType NoteProperty -Name nodes -Value @($NodeList)}
        if($EdgeList){$Graph|Add-Member -MemberType NoteProperty -Name edges -Value @($EdgeList)}
        $Meta = [PSCustomObject]@{
            ingest_version='v1'
            collector=@{
                name    = $CollectorName
                version = $CollectorVersion
                properties = @{collection_methods=@($CollectionMethod)}
                }
            }
        $Out=[PSCUstomObject]@{graph=$Graph<#;metadata=$Meta#>}
        if(-Not$NoMeta){$Out|Add-Member -MemberType NoteProperty -Name metadata -Value $Meta}
        if($NoJSON){$Out}else{$out|Convertto-Json -Depth 23 -Compress:$Compress}
        }}
    End{if($PSCmdlet.ParameterSetName -eq 'Arrows'){
        $arrows = $FromArrows | ConvertFrom-Json -Depth 23
        $arrows = $arrows | Select-Object -ExcludeProperty Style
        #$NodeL = $arrows.nodes | select id,@{n='label';e={$_.labels[0]}},@{n='name';e={if($_.caption){$_.Caption}else{$_.id}}},properties
        $NodeL = foreach($Nd in $arrows.nodes){
            #$Nd | select id,@{n='label';e={$_.labels|select -first 1}},@{n='name';e={if($_.caption){$_.Caption}else{$_.id}}},properties
            $Nd | select id,@{n='Label';e={$_.labels|select -first 1}},@{n='ExtraLabel';e={$_.labels|select -Skip 1}},@{n='name';e={if($_.caption){$_.Caption}else{$_.id}}},properties
            }
        $NodeL = Foreach($nd in $NodeL){
            Foreach($np in ($nd.properties|GM -ea 0|? Membertype -eq Noteproperty).name){$nd|Add-Member -MemberType NoteProperty -Name $np -Value $nd.properties.$np -force}
            $nd
            }
        $NodeL = $NodeL | ToBHOGNode * -ExcludeProps id,label,extraLabel,properties
        $EdgeL = $arrows.relationships | select @{n='source';e={$_.fromId}},@{n='Edge';e={if($_.type){$_.type}else{'IsConnectedTo'}}},@{n='Target';e={$_.toId}}
        $EdgeL = Foreach($ed in $EdgeL){
            Foreach($ep in $($ed.properties|%{$_|GM -ea 0|? Membertype -eq Noteproperty}).name){$ed|Add-Member -MemberType NoteProperty -Name $ep -Value $ed.properties.$ep -force}
            $ed
            }
        $EdgeL = $EdgeL | ToBHOGEdge * -exclude source,edge,target,properties # Props /!\
        $Meta = @{
            CollectorName    = $CollectorName
            CollectorVersion = $CollectorVersion
            CollectionMethod = $CollectionMethod
            }
        New-BHOpenGraphIngestPayload -NodeList $NodeL -EdgeList $edgeL -NoJSON:$NoJson -Compress:$Compress @Meta
        }}
    }
