<#
.Synopsis
    Disable BloodHound Operator
.DESCRIPTION
    Disable BloodHound Operator
.EXAMPLE
    BHOperator -id 2 | Disable-BHOperator
#>

function Disable-BHOperator{
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String[]]$OperatorID,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    Begin{NoMultiSession}
    Process{Foreach($OperID in $OperatorID){
        $Operator = Get-BHOperator -ID $OperID -Verbose:$False
        # Body
        $Body=@{
            principal     = $Operator.principal_name
            first_name    = $Operator.first_name
            last_name     = $Operator.last_name
            email_address = $Operator.email_address
            roles         = [Array]@(,$($Operator.roles.id))
            is_disabled   = $True
            }
        $Body = $Body | ConvertTo-Json
        # Call
        Invoke-BHAPI "api/v2/bloodhound-users/$OperID" -Method PATCH -Body $Body
        if($PassThru){Get-BHOperator -ID $OperID -Verbose:$False}
        }}
    End{}
    }
