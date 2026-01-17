<#
.Synopsis
    Set BloodHound Operator
.DESCRIPTION
    Set BloodHound Operator
.EXAMPLE
    BHOperator -id 2 | Set-BHOperator -firstname alice
#>

Function Set-BHOperator{
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String]$OperatorID,
        [Parameter(Mandatory=0)][Alias('Principal_Name')][String]$Name,
        [Parameter(Mandatory=0)][String]$FirstName,
        [Parameter(Mandatory=0)][String]$LastName,
        [Parameter(Mandatory=0)][String]$Email,
        [Parameter(Mandatory=0)][Int[]]$Role,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    Begin{NoMultiSession}
    Process{Foreach($ID in $OperatorID){
        $Operator = Get-BHOperator -ID $OperatorID -Verbose:$False
        # Body
        $Body=@{
            principal     = if($Name){$Name}else{$Operator.principal_name}
            first_name    = if($FirstName){$FirstName}else{$Operator.first_name}
            last_name     = if($LastName){$LastName}else{$Operator.last_name}
            Email         = if($Email){$Email}else{$Operator.email_address}
            #roles         = if($Role.count){[Array]@($Role)}else{[Array]@($($Operator.roles.id))}
            roles         = @($Role)
            is_disabled   = $Operator.is_disabled
            }
        $Body = $Body | ConvertTo-Json
        # Call
        Invoke-BHAPI "api/v2/bloodhound-users/$ID" -Method PATCH -Body $Body
        if($PassThru){Get-BHOperator -ID $ID -Verbose:$False}
        }}
    End{}
    }
