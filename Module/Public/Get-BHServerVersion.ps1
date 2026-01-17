<#
.SYNOPSIS
    Get BloodHound Server version
.DESCRIPTION
    Get BloodHound Server version
.EXAMPLE
    BHVersion
#>

function Get-BHServerVersion{
    [CmdletBinding()]
    [Alias('BHVersion')]
    Param([Parameter()][Int[]]$SessionID=$((BHSession|? x).id))
    foreach($SessID in $SessionID){
        $Reply = Invoke-BHAPI "api/version" -Expand data -SessionID $SessID | select -exclude API
        $ShHversion = Invoke-BHAPI "api/v2/collectors/sharphound" -Expand data.latest -SessionID $SessID
        $AzHversion = Invoke-BHAPI "api/v2/collectors/azurehound" -Expand data.latest -SessionID $SessID
        $Reply | Add-Member -MemberType NoteProperty -Name SharpHound -Value $ShHversion
        $Reply | Add-Member -MemberType NoteProperty -Name AzureHound -Value $AzHversion
        $Reply
        }}
