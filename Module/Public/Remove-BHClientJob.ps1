<#
.Synopsis
    [BHE] Remove BloodHound Client Job
.DESCRIPTION
    Description
.EXAMPLE
    Remove-BHClientJob -Id $JobId
#>

function Remove-BHClientJob{
    [Alias('Remove-BHJob')]
    Param(
        [Parameter(Mandatory,ValuefromPipeline,ValueFromPipelineByPropertyName)][String]$ID,
        [Switch]$Force
        )
    Begin{NoMultiSession;BHEOnly}
    Process{if($Force -OR $(Confirm-Action "Delete BHE Job ID $ID")){
        BHAPI api/v2/jobs/$ID/cancel PUT
        }}
    End{}
    }
