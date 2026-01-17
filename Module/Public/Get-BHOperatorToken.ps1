<#
.Synopsis
    Get BloodHound Operator Token
.DESCRIPTION
    Get BloodHound Operator Token
.EXAMPLE
    BHToken
#>

Function Get-BHOperatorToken{
    [Alias('BHToken')]
    Param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('principal_name')][String[]]$Operator
        )
    Begin{
        $Tokens = Invoke-BHAPI api/v2/tokens -expand data.tokens
        $Operators = [Collections.ArrayList]@()
        }
    Process{Foreach($Name in $Operator){
            $Null=$Operators.add($Name)
            }}
    End{if($Name){
            $OperatorIDs = (Get-BHOperator -Name $Operators).id
            $Tokens|? {$_.'user_id' -in $($OperatorIDs)}
            }
        else{$Tokens}
        }}
