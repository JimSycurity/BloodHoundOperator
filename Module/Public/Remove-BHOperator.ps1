<#
.Synopsis
    Remove BloodHound Operator
.DESCRIPTION
    Remove BloodHound Operator
.EXAMPLE
    Remove-BHOperator
#>

Function Remove-BHOperator{
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][String[]]$OperatorID,
        [Parameter(Mandatory=0)][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($ID in $OperatorID){
        $Operator = (Get-BHOperator -ID $ID -Verbose:$False).principal_name
        if($Force -OR (Confirm-Action "Delete Operator $Operator")){Invoke-BHAPI "api/v2/bloodhound-users/$ID" -Method DELETE}
        }}
    End{}
    }
