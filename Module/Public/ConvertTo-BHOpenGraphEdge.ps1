<#
.SYNOPSIS
    Convert to OpenGraph Edge
.DESCRIPTION
    Convert Random Objects to BloodHound OpenGraph Edge Format.
    (Use -AllowOrphans when Importing edges without already existing nodes in BHE)
.EXAMPLE
    $RelList | ToBHOpenGraphEdge -Edge CanAbuse -Start <sourceidproperty> -End <targetidproperty>
.EXAMPLE
    $RelList | ToBHOpenGraphEdge  -Edge CanAbuse -TargetByName  -SourceByName -Start <sourcenameproperty> -End <targetnameproperty>
    Will match on name instead of objectid when importing
.EXAMPLE
    $RelList | ToBHOpenGraphEdge -Edge *
    If $RelList objects have source,edge,target property (ex: Import-Csv)
    Any other props will be used as node property unless -excludeProps is used. 
    #>

Function ConvertTo-BHOpenGraphEdge{
    [Alias('ToBHOGEdge')]
    Param(
        [Parameter(Mandatory=1,Position=0)][Alias('kind')][string]$EdgeType,
        [Parameter(Mandatory=0,Position=1)][Alias('Source')][String]$Start='source',
        [Parameter(Mandatory=0,Position=2)][Alias('Target')][String]$End='target',
        [Parameter(Mandatory=0,Position=3)][Alias('Prop')][String[]]$SelectProps='*',
        [Parameter(Mandatory=0)][Alias('xProp')][String[]]$ExcludeProps,
        [Parameter(Mandatory=0)][switch]$SourceByName,
        [Parameter(Mandatory=0)][string]$SourceKind,
        [Parameter(Mandatory=0)][switch]$TargetByName,
        [Parameter(Mandatory=0)][string]$TargetKind,
        [Parameter(Mandatory=0)][Switch]$AllowOrphans,
        [Parameter(Mandatory=1,ValueFromPipeline=1)][PSCustomObject[]]$InputObject
        )
    Begin{}
    Process{Foreach($Obj in $InputObject){
        $srcNode = [PSCustomObject]@{
            value = $(Try{"$($Obj.$Start)".toupper()}Catch{Write-Warning "[BH] Missing Edge Source Value";break})
            match_by = if($SourceByName){'name'}else{'id'}
            }
        if($SourceKind){$srcNode|Add-Member -MemberType NoteProperty -Name 'kind' -Value $SourceKind -force} 
        if($AllowOrphans){$srcNode|Add-Member -MemberType NoteProperty -Name 'allow_orphan' -Value $true} 
        $tgtNode = [PSCustomObject]@{
            value = $(Try{"$($Obj.$End)".toupper()}Catch{Write-Warning "[BH] Missing Edge Target Value";break})
            match_by = if($TargetByName){'name'}else{'id'}
            }
        if($TargetKind){$tgtNode|Add-Member -MemberType NoteProperty -Name 'kind' -Value $TargetKind -force}
        if($AllowOrphans){$tgtNode|Add-Member -MemberType NoteProperty -Name 'allow_orphan' -Value $true}
        $EType = if($EdgeType -eq '*'){if($Obj.edge){$Obj.edge}elseif($Obj.Kind){$Obj.Kind}else{$Obj.Type}}else{$EdgeType}
        $EType = $EType.Substring(0,1).toUpper() + $EType.Substring(1)
        [PSCustomObject]@{
            kind = $EType
            start = $srcNode
            end = $tgtNode
            properties = $Obj | Select-Object $SelectProps -ExcludeProperty $ExcludeProps
            }
        }}
    End{}
    }
