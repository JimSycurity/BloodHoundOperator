<#
.SYNOPSIS
    Set BloodHound API Session
.DESCRIPTION
    Set BloodHound API Session
.EXAMPLE
    Set-BHSession
#>

Function Set-BHSession{
    Param(
        [Parameter()][int]$Limit,
        [ValidateRange(0,3600)][Parameter()][int]$Timeout,
        [Parameter()][Switch]$CypherClip,
        [Parameter()][Switch]$NoClip
        )
    if($Limit){$BHSession|? x |%{$_.Limit=$Limit}}
    if($PSCmdlet.MyInvocation.BoundParameters.ContainsKey("Timeout")){
        #if($Timeout -eq 0){$Timeout=30}
        $BHSession|? x|%{$_.Timeout=$Timeout}
        }
    if($NoClip){($BHSession|? x).CypherClip=$False}
    elseif($CypherClip){($BHSession|? x)|%{$_.CypherClip=$True}}
    }
