<#
.Synopsis
    [BHE] Set BloodHound Client
.DESCRIPTION
    Description
.EXAMPLE
    Example
#>

function Set-BHClient{
    Param(
        [Parameter(Mandatory=1)][String]$ID,
        [Parameter(Mandatory=0)][String]$Name,
        [Parameter(Mandatory=0)][Alias('DC')][String]$DomainController
        )
    NoMultiSession;BHEOnly
    $ClientObj = BHAPI clients/$ID -expand data -wa stop
    $ClientSet = @{
        name = if($Name){$Name}else{$ClientObj.Name}
        domain_controller = if($DomainController){$DomainController}else{$ClientObj.domain_controller}
        }
    BHAPI clients/$ID PUT $ClientSet
    }
