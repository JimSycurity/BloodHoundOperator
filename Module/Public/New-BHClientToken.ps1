<#
.Synopsis
    [BHE] New BloodHound Client Token
.DESCRIPTION
    New BHE Client Token
.EXAMPLE
    New-BHClientToken -id $ClientID [-Force]
#>

function New-BHClientToken{
    Param(
        [Parameter(Mandatory,ValuefromPipelineByPropertyName)][Alias('ClientID')][String[]]$ID,
        [Parameter()][Switch]$AsPlainText,
        [Parameter()][Switch]$Force
        )
    Begin{NoMultiSession;BHEOnly}
    Process{foreach($CliID in $ID){
        if($Force -OR $(Confirm-Action "Generate $(if($AsPlainText){'Plaintext '})Token for Client $CliID")){
        $Output = BHAPI clients/$ID/token PUT -expand data
        if($Output -AND -Not$AsPlainText){$Output.key=$Output.key|ConvertTo-SecureString -AsPlainText -Force
            $Output|Add-Member -MemberType NoteProperty -Name client_id -Value $CliID
            }
        $Output
        }}}
    End{}
    }
