<#
.Synopsis
    Get BloodHound Operator Permission
.DESCRIPTION
    Get BloodHound Operator Permission
.EXAMPLE
    BHPermission
#>

Function Get-BHOperatorPermission{
    [Alias('BHPermission')]
    Param(
        [Parameter()][Alias('self')][Switch]$Current
        )
    # Current
    if($Current){(Invoke-BHAPI api/v2/self -expand data).Roles.Permissions.name}
    # All
    else{Invoke-BHAPI api/v2/permissions -expand data.permissions}
    }
