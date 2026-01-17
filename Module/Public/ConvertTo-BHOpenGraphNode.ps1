<#
.SYNOPSIS
    Convert to OpenGraph Node
.DESCRIPTION
    Convert Random Objects to BloodHound OpenGraph Node Format 
.EXAMPLE
    $ObjectList | ToBHOpenGraphNode -Label Person -ExtraLabel CustomNode -NameFrom displayName -ExcludeProps id,displayName
.EXAMPLE
    $ObjectList | ToBHOpenGraphNode *
    If objects already have label,(extralabel),id,name property (ex: Import-Csv)
    Any other props will be used as node property unless -excludeProps is used.
#>

Function ConvertTo-BHOpenGraphNode{
    [Alias('ToBHOGNode')]
    Param(
        [Parameter(Mandatory=1,Position=1,ValueFromPipeline=1)][PSCustomObject[]]$InputObject,
        [Parameter(Mandatory=1,Position=0)][Alias('Label','PrimaryKind')][string]$NodeType,
        [Parameter(Mandatory=0,Position=2)][Alias('ExtraLabel')][string[]]$ExtraType,
        [Parameter(Mandatory=0)][Alias('IDFrom')][string]$ObjectIDfrom,
        [Parameter(Mandatory=0)][string]$NameFrom='Name',
        [Parameter(Mandatory=0)][Alias('Prop')][string[]]$SelectProps='*',
        [Parameter(Mandatory=0)][Alias('xProp')][string[]]$ExcludeProps,
        [Parameter(Mandatory=0,ParameterSetName='RandomID')][Switch]$RandomID
        )
    Begin{}
    Process{Foreach($Obj in $InputObject){
        # NodeType
        if($NodeType -eq '*'){
            $NType=if($Obj.Label){$Obj.Label}
            if($Obj.ExtraLabel){$ExtraType=$Obj.ExtraLabel}
            }
        else{$Ntype=$NodeType}
        # Kinds
        [Collections.ArrayList]$kinds=@($NType)
        if($ExtraType.count){foreach($xType in $extraType){$null=$Kinds.add("$xType")}}
        # Name/ID
        $oName = if($Obj.$NameFrom){"$($Obj.$NameFrom)".toUpper()}Else{Write-Warning "[BH] No Name Property Found. Please specify property to use";RETURN}
        $oID = if($RandomID){"$([GUID]::NewGuid())".toupper()}else{
            if($Obj.$ObjectIDFrom){"$($Obj.$ObjectIDFrom)".toUpper()}
            elseif($Obj.objectid -ne $null){$Obj.objectid.toupper()}
            elseif($Obj.id -ne $null){$Obj.id.toupper()}
            Else{Write-Warning "[BH] No ID Property Found. Please specify property to use";RETURN}
            }
        # Props
        $Props = $Obj | Select-Object $SelectProps -exclude $ExcludeProps
        # Objectid/name
        $Props | Add-Member -MemberType NoteProperty -Name 'objectid' -Value $oID -Force -ea 0
        $Props | Add-Member -MemberType NoteProperty -Name 'name' -Value $oName -Force -ea 0
        # OpenGraph out
        [PSCustomObject]@{
            id         = $oID
            kinds      = $Kinds
            properties = $Props | select objectid,name,* -ea 0
            }
        }}
    End{}
    }
