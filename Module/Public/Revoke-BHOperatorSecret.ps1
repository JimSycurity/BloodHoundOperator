<#
.Synopsis
    Revoke BloodHound Operator Secret
.DESCRIPTION
    Revoke BloodHound Operator Secret
.EXAMPLE
    Revoke-BHSecret
#>

Function Revoke-BHOperatorSecret{
    [Alias('Revoke-BHSecret')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String]$OperatorID,
        [Parameter(Mandatory=0)][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($ID in $OperatorID){
        $Operator = Get-BHOperator -ID $ID -Verbose:$False
        if($Force -OR (Confirm-Action "Expire secret for operator $($Operator.principal_name)")){
            # Call
            Invoke-BHAPI "api/v2/bloodhound-users/$ID/secret" -Method DELETE
            }}}
    End{}###
    }
