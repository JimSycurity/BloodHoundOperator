<#
.SYNOPSIS
    Remove BloodHound SAML Provider
.DESCRIPTION
    Remove BloodHound SAML Provider
.EXAMPLE
    Remove-BHServerSAMLProvider -id <id> [-Force]
#>

function Remove-BHServerSAMLProvider{
    [Alias('Remove-BHSAMLProvider')]
    Param(
        [Parameter(Mandatory=1)][Alias('ID')][int]$ProviderID,
        [Parameter(Mandatory=0)][Switch]$Force,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    if($Force -OR (Confirm-Action "Remove SAML Provider $ProviderID")){
    $Impacted = BHAPI api/v2/saml/providers/$ProviderID DELETE -Expand data
    if($PassThru){$Impacted}
    }}
