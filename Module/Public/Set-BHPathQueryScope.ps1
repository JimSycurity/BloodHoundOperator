<#
.SYNOPSIS
    Set BloodHound Query Scope
.DESCRIPTION
    Set BloodHound saved query sharing scope
.EXAMPLE
    Set-BHQueryScope -ID 123 -Public
.EXAMPLE
    Set-BHQueryScope -ID 123 -Private
.EXAMPLE
    Set-BHQueryScope -ID 123 -Share <UserID[]>
.EXAMPLE
    Set-BHQueryScope -ID 123 -Share <UserID[]> -Remove
#>

function Set-BHPathQueryScope{
    [Alias('Set-BHQueryScope')]
    Param(
        [Parameter(Mandatory=1,Position=0)][int]$ID,
        [Parameter(Mandatory=1,ParameterSetName='Public')][Switch]$Public,
        [Parameter(Mandatory=1,ParameterSetName='Private')][Switch]$Private,
        [Parameter(Mandatory=1,ParameterSetName='Share')][String[]]$Share,
        [Parameter(Mandatory=0,ParameterSetName='Share')][Switch]$Remove
        )
    NoMultiSession
    $Perm=Switch($PSCmdlet.ParameterSetName){
        Private{@{public=$false}}
        Public {@{public=$true}}
        Share  {@{user_ids=@($Share);public=$false}}
        }
    $Verb=if($Remove){'DELETE'}Else{'PUT'}
    BHAPI saved-queries/$ID/permissions $Verb -Body ($Perm|Convertto-Json)
    }
