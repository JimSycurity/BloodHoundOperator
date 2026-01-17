<#
.Synopsis
   Split-Collection [internal]
.DESCRIPTION
   Split Collection
.EXAMPLE
   0..7 | Split-Collection 3 | ConvertTo-Json -Compress
#>

Function Split-Collection{
    Param(
        [Parameter(Position=0)][int]$Count=0,
        [Parameter(Position=1,valuefromPipeline)][PSObject]$Object
        )
    Begin{$Collect=[Collections.ArrayList]@()}
    Process{foreach($Obj in $Object){$Null=$Collect.add($Obj)}}
    End{if($Count-le 0 -OR $Count -gt $Collect.count){$Count=$Collect.count}
        for($i=0;$i-lt$Collect.count;$i+=$Count){,($Collect[$i..($i+($Count-1))])}
        }}
