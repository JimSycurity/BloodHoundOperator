<#
.SYNOPSIS
    Invoke BloodHound API Session Script
.DESCRIPTION
    Invoke BloodHound API Session Script
.EXAMPLE
    BHScript {BHOperator -self | select principal_name} -SessionID 1,2
#>

function Invoke-BHSessionScript{
    [Alias('BHScript')]
    Param(
        [Parameter()][ScriptBlock]$Script,
        [Parameter()][int[]]$SessionID=$((BHSession|? x).id)
        )
    Begin{$Selected = (BHSession|? x).id}
    Process{
        Try{Foreach($SessID in $SessionID){
            Select-BHSession -id $SessID
            $res = Invoke-Command $Script -NoNewScope
            If($Selected.count -gt 1){$res|Add-Member -MemberType NoteProperty -Name SessionID -Value $SessID}
            $res
            }}
        catch{}
        Finally{Select-BHSession $Selected}
        }
    End{Select-BHSession $Selected}
    }
