<#
.Synopsis
    New BloodHound Operator
.DESCRIPTION
    New BloodHound Operator
.EXAMPLE
    New-BHOperator -name bob
#>

Function New-BHOperator{
    Param(
        [Parameter(Mandatory=1)][Alias('Principal_Name')][String]$Name,
        [Parameter(Mandatory=0)][String]$FirstName,
        [Parameter(Mandatory=0)][String]$LastName,
        [Parameter(Mandatory=0)][String]$Email,
        [Parameter(Mandatory=0)][Int[]]$Role,
        #[Parameter(Mandatory=0)][String]$Secret,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    NoMultiSession
    # Body
    $Body = @{
        principal      = $Name
        first_name     = $FirstName
        last_name      = $LastName
        email_address  = $Email
        roles          = $Role
        secret         = $null
        } | ConvertTo-Json
    # Call
    $Operator = Invoke-BHAPI 'api/v2/bloodhound-users' -Method POST -Body $Body
    # Secret
    #if($Secret){$Operator|Set-BHOperatorSecret -Secret $Secret}
    # Ouptut
    if($PassThru){$Operator}
    }
