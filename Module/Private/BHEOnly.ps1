<#
.Synopsis
    BHOnly
.DESCRIPTION
    Break if not BHE session
    [Internal] Used at begining of cmdlets
.EXAMPLE
    BHEOnly
#>

function BHEOnly{
    if((BHSession|? x).edition -match 'BHCE'){Write-Warning "BHEOnly - Requires session to BloodHound Enterprise...";Break}
    }
