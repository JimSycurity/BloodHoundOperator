<#
.SYNOPSIS
    Get BloodHound Relay Target
.DESCRIPTION
    Get BloodHound Relay Target
.EXAMPLE
    Get-BHPathRelayTarget -SourceID $x -EdgeType $r -TargetID $y
#>

function Get-BHPathRelayTarget{
    [Alias('BHRelayTarget')]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$SourceID,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$TargetID,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('Edge')][String]$EdgeType
        )
    Begin{$idx=0;$stp=0}
    Process{
        if($Sourceid -notmatch "^\d+$"){$Sourceid = try{((BHCypher "MATCH (x{objectid:'$SourceID'}) RETURN x" -NoConvert -verbose:$False).data.nodes|gm|? Membertype -eq Noteproperty).name}Catch{}}
        if($Targetid -notmatch "^\d+$"){$Targetid = try{((BHCypher "MATCH (x{objectid:'$TargetID'}) RETURN x" -NoConvert -verbose:$False).data.nodes|gm|? Membertype -eq Noteproperty).name}catch{}}
        if(-Not$SourceID -OR -Not$TargetID){Break}
        $qfilter = @(
            "source_node=$SourceID",
            "target_node=$TargetID",
            "edge_type=$EdgeType"
            )
        #$RelayEdges = 'CoerceAndRelayNTLMToSMB','CoerceAndRelayNTLMToLDAP','CoerceAndRelayNTLMToLDAPS','CoerceAndRelayNTLMToADCS'
        $CallURL=if($EdgeType -IN $RelayEdges){'api/v2/graphs/relay-targets'}else{'api/v2/graphs/relay-targets'}
        $CompData = BHAPI $CallURL -Filter $qFilter -dot data
        for($i=0;$i -lt $CompData.edges.count;$i++){
            $CurrentEdge = $CompData.edges[$i]
            $SrcNode     = $CompData.Nodes.$($CurrentEdge.source)
            $TgtNode     = $CompData.Nodes.$($CurrentEdge.target)
            $CurrentEdge | Add-Member -MemberType NoteProperty -Name source_node -Value $SrcNode -Force
            $CurrentEdge | Add-Member -MemberType NoteProperty -Name target_node -Value $TgtNode -Force
            [PSCustomObject]@{
                ID         = $idx
                Step       = $stp
                SourceType = $CurrentEdge.source_node.kind
                Source     = $CurrentEdge.source_node.label
                Edge       = $CurrentEdge.Kind
                TargetType = $CurrentEdge.target_node.kind
                Target     = $CurrentEdge.target_node.label
                IsTierZeroSource = $CurrentEdge.source_node.isTierZero
                IsTierZeroTarget = $CurrentEdge.target_node.isTierZero
                TierZeroViolation = $CurrentEdge.target_node.IsTierZero -AND -Not$CurrentEdge.source_node.IsTierZero
                SourceId  = $CurrentEdge.source_node.objectid
                TargetId  = $CurrentEdge.target_node.objectid
                EdgeProps = $CurrentEdge.Properties
                }
            if($CurrentEdge.Target -eq $CompData.edges[$i+1].source){$stp+=1}else{$idx+=1;$Stp=0}
            }
        }
    End{}
    }
