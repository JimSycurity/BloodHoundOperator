function Get-BHPathFindingInfo{
    [Alias('BHFindingInfo')]
    Param(
        [Parameter(ValueFromPipeline=1)][BHFindingType[]]$FindingType,
        [Parameter()][Switch]$Full,
        [Parameter()][Alias('md')][Switch]$OutMarkDown
        )
    Begin{BHEOnly}
    Process{foreach($Ftype in "$FindingType"){
        $FDoc = [PSCustomObject]@{
            Finding = $FType
            Title   = BHAPI "api/v2/assets/findings/$Ftype/title.md"
            Type   = BHAPI "api/v2/assets/findings/$Ftype/type.md"
            Description = BHAPI "api/v2/assets/findings/$Ftype/short_description.md"
            Remediation = BHAPI "api/v2/assets/findings/$Ftype/short_remediation.md"
            References   = BHAPI "api/v2/assets/findings/$Ftype/references.md"
            }
        if($Full){
            $fDesc = BHAPI "api/v2/assets/findings/$Ftype/long_description.md"
            $fRem  = BHAPI "api/v2/assets/findings/$Ftype/long_remediation.md"
            $FDoc | Add-Member -MemberType NoteProperty -Name Description_Full -Value $FDesc
            $FDoc | Add-Member -MemberType NoteProperty -Name Remediation_Full -Value $FRem
            }
        if($OutMarkDown){"# $($FDoc.Title.trim())
**$($FDoc.Type.trim()) - $FType**

## Description
$(if($Full){$FDoc.Description_Full.split("`r`n").replace("##",'###')}else{$FDoc.Description})

## Remediation
$(if($Full){$FDoc.Remediation_Full.split("`r`n").replace("##",'###')}else{$FDoc.Remediation})

## References
$($FDoc.References)
`r`n</br>`r`n
---"}
        else{$FDoc}
        }}
    End{}
    }
