<#
.Synopsis
    Get BloodHound Operator
.DESCRIPTION
    Get BloodHound Operator
.EXAMPLE
    BHOperator
#>

Function Get-BHOperator{
    [CmdletBinding(DefaultParameterSetName='All')]
    [Alias('BHOperator')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ByID')][string[]]$ID,
        [Parameter(Mandatory,ParameterSetName='ByName')][String[]]$Name,
        [Parameter(Mandatory,ParameterSetName='Self')][Alias('Self','Whoami')][Switch]$Current,
        [ValidateScript({$_ -in (Get-BHOperatorRole).name})]
        [Parameter(Mandatory,ParameterSetName='ByRole')][String]$Role
        )
    Begin{$Collect=[Collections.ArrayList]@()}
    Process{Foreach($OperatorID in $ID){$Null=$Collect.Add($OperatorID)}}
    End{$Reply = Switch($PSCmdlet.ParameterSetName){
            ByID    {Foreach($OperatorID in $Collect){Invoke-BHAPI api/v2/bloodhound-users/$OperatorID -expand data}}
            Self    {Invoke-BHAPI api/v2/self -expand data}
            Default {Invoke-BHAPI api/v2/bloodhound-users -expand data.users}
            }
        $Reply = Switch($PSCmdlet.ParameterSetName){
            ByName  {$Reply | ? {$_.'Principal_Name' -in $Name}}
            ByRole  {$Reply | ? {$_.Roles.Name -eq $Role}}
            Default {$Reply}
            }
        $Reply
        }
    }
