<#
.Synopsis
    [BHE] Approve BloodHound EULA
.DESCRIPTION 
    Approve BloodHound Eneterprise End User License Agreement
.EXAMPLE
    Approve-BHOperatorEULA
#>

function Approve-BHOperatorEULA{
    [CmdletBinding()]
    Param()
    NoMultiSession;BHEOnly
    BHAPI api/v2/accept-eula
    }
