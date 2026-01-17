<#
.SYNOPSIS
    Set BloodHound Server Config
.DESCRIPTION
    Set BloodHound Server Config
.EXAMPLE
    Set-BHConfig -key prune.ttl -value @{base_ttl="P8D";has_session_edge_ttl="P5D"}
.EXAMPLE
    Set-BHConfig -key analysis.reconciliation -value @{enabled=$true}
#>

Function Set-BHServerConfig{
    [Alias('Set-BHConfig')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('key')][string[]]$ConfigKey,
        [Parameter(Mandatory)][HashTable]$Value
        )
    Begin{}
    Process{Foreach($key in $ConfigKey){
        $Body = @{key=$key;value=$Value}|ConvertTo-Json
        Invoke-BHAPI "api/v2/config" -Method PUT -Body $Body
        }}
    End{}
    }
