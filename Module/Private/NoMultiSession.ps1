<#
.Synopsis
    NoMultiSession
.DESCRIPTION
    Break if multi-session (use BHScript)
    [Internal] Used at begining of cmdlets
.EXAMPLE
    NoMultiSession
#>

function NoMultiSession{
    if((BHSession|? x).count -gt 1){Write-Warning "NoMultiSession - Please select single session or run BHScript...";Break}
    }
