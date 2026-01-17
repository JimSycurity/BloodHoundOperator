<#
.SYNOPSIS
    Set BloodHound Server Feature
.DESCRIPTION
    Set BloodHound Server Feature
.EXAMPLE
    Set-BHFeature -id 1 -Enabled
#>

Function Set-BHServerFeature{
    [Alias('Set-BHFeature')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('ID')][int[]]$FeatureID,
        [Parameter(Mandatory,ParameterSetName='Enable')][Switch]$Enabled,
        [Parameter(Mandatory,ParameterSetName='Disable')][Switch]$Disabled
        )
    Begin{}
    Process{Foreach($ID in $FeatureID){
        $IsEnabled = (Get-BHServerFeature | ? ID -eq $ID).enabled
        if(($PSCmdlet.ParameterSetName -eq 'Enable' -AND -Not$IsEnabled) -OR ($PSCmdlet.ParameterSetName -eq 'Disable' -AND $IsEnabled)){
            Invoke-BHAPI "api/v2/features/$ID/toggle" -Method PUT
            }
        }}
    End{}
    }
