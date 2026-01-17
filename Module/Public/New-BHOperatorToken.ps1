<#
.Synopsis
    New BloodHound Operator Token
.DESCRIPTION
    New BloodHound Operator Token
.EXAMPLE
    New-BHToken -ID $OperatorID -TokenName $TokenName
#>

Function New-BHOperatorToken{
    [Alias('New-BHToken')]
    Param(
        # OperatorID
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineBYPropertyName)][Alias('ID')][String]$OperatorID,
        # TokenName
        [Parameter(Mandatory=0)][String]$TokenName,
        # AsPlainText
        [Parameter()][Switch]$AsPlainText,
        # Confirm
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession}
    Process{Foreach($ID in $OperatorID){
        # token name
        if(-Not$TokenName){$TokenName = "Token_$ID"}
        $Operator = Get-BHOperator -ID $ID -Verbose:$False
        if($Force -OR (Confirm-Action "Generate token for operator $($Operator.principal_name)")){
            # Body
            $Params = @{
                token_name = $TokenName
                user_id    = $ID
                } | ConvertTo-Json
            # Call
            $ApiToken = Invoke-BHAPI 'api/v2/tokens' -Method POST -Body $Params -Expand data
            # Secure String
            if(-Not$AsPlainText){$ApiToken.key=$Apitoken.Key|ConvertTo-SecureString -AsPlainText -Force}
            # Output
            $ApiToken
            }}}
    End{}###
    }
