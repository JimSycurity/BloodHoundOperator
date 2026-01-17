<#
.Synopsis
    Get BloodHound Operator Role
.DESCRIPTION
    Get BloodHound Operator Role
.EXAMPLE
    BHRole
#>

Function Get-BHOperatorRole{
    [Alias('BHRole')]
    Param(
        [Parameter()][Alias('self','Whoami')][Switch]$Current
        )
    # Current
    if($Current){(Invoke-BHAPI api/v2/self -expand data).roles.name}
    # All
    else{Invoke-BHAPI api/v2/roles -expand data.roles}
    }
