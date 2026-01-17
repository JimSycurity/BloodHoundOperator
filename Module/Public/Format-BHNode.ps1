<#
.Synopsis
    Format BloodHound Node
.DESCRIPTION
    Format BloodHound Node Object
.EXAMPLE
    BHFormat
#>

function Format-BHNode{
    [Alias('BHFormat')]
    Param(
        [Parameter(Mandatory=1)][PSCustomObject]$Object,
        [Parameter(Mandatory=0)][Alias('NoCount')][Switch]$PropOnly
        )
    if(-Not$Object.props){Write-Warning "Invalid input Object";RETURN}
    $Formated = $Object.props
    if(-Not$PropOnly){
        foreach($Itm in (($object|GM|? membertype -eq Noteproperty).name -ne 'props')){
            $Formated | Add-Member -MemberType NoteProperty -Name $Itm -value $Object.$itm 
            }}
    $Formated
    }
