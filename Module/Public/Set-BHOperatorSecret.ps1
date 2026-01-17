<#
.Synopsis
    Set BloodHound Operator Secret
.DESCRIPTION
    Set BloodHound Operator Secret
.EXAMPLE
    Set-BHSecret
#>

Function Set-BHOperatorSecret{
    [Alias('Set-BHSecret')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String]$OperatorID,
        [Parameter(Mandatory=0)][Alias('Password')][String]$Secret='BloodHoundPassword123!',
        [Parameter(Mandatory=0)][Switch]$RequireReset,
        [Parameter(Mandatory=0)][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($ID in $OperatorID){
        $Operator = Get-BHOperator -ID $ID -Verbose:$False
        if($Force -OR (Confirm-Action "Set password for operator $($Operator.principal_name)")){
            # Body
            $Body=@{
                needs_password_reset = if($Secret -eq 'BloodHoundPassword123!'){$true}else{$PSCmdlet.MyInvocation.BoundParameters['RequireReset'].IsPresent}
                secret               = $Secret
                }
            $Body = $Body | ConvertTo-Json
            # Call
            Invoke-BHAPI "api/v2/bloodhound-users/$ID/secret" -Method PUT -Body $Body
            if($PassThru){Get-BHOperator -ID $ID -Verbose:$False}
            }}}
    End{}###
    }
