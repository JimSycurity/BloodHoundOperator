<#
.SYNOPSIS
    Select BloodHound API Session
.DESCRIPTION
    Select BloodHound API Session
.EXAMPLE
    Select-BHSession 1
#>

function Select-BHSession{
    [CmdletBinding(DefaultParameterSetName='ID')]
    [Alias('BHSelect')]
    Param(
        [Parameter(Mandatory,ParameterSetName='ID',Position=0)][Alias('SessionID')][int[]]$ID,
        [Parameter(Mandatory,ParameterSetName='None')][Switch]$None
        )
    if($None){$BHSession |? x|%{$_.x = $Null}}
    Else{
        # Unselect
        $BHSession|? x|%{$_.x = $Null}
        # Select
        $BHSession|? id -in @($ID)|%{$_.x='x'}
        }
    }
