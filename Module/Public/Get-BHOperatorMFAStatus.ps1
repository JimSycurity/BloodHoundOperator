<#
.Synopsis
    Get BloodHound Operator MFA status
.DESCRIPTION
    Get BloodHound MFA status
.EXAMPLE
    BHOperator -self | Get-BHOperatorMFAStatus
#>

function Get-BHOperatorMFAStatus{
    [Alias('BHOperatorMFA')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][String[]]$ID
        )
    Begin{NoMultiSession}
    Process{Foreach($OperID in $ID){
        [PSCustomObject]@{
            ID     = $OperID
            Name   = Invoke-BHAPI api/v2/bloodhound-users/$OperId -expand data.principal_name 
            MFA    = Invoke-BHAPI api/v2/bloodhound-users/$OperId/mfa-activation -expand data.status
            }}}
    End{}###
    }
