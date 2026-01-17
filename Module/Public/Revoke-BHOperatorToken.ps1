<#
.Synopsis
    Revoke BloodHound Operator Token
.DESCRIPTION
    Revoke BloodHound Operator Token
.EXAMPLE
    Revoke-BHToken
#>

Function Revoke-BHOperatorToken{
    [Alias('Revoke-BHToken')]
    Param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('id')][String[]]$TokenID,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{foreach($Token in $TokenID){
        if($Force -OR (Confirm-Action "Revoke Token $Token")){Invoke-BHAPI -Method DELETE "api/v2/tokens/$token"}
        }}
    End{}
    }
