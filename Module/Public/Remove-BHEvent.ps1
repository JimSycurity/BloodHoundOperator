<#
.Synopsis
    [BHE] Remove BloodHound Client Event
.DESCRIPTION
    Description
.EXAMPLE
    Remove-BHEvent $EventID
#>

function Remove-BHEvent{
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][String]$ID,
        [Switch]$Force
        )
    Begin{NoMultiSession;BHEOnly}
    Process{if($Force -OR $(Confirm-Action "Delete BloodHound Event ID $ID")){$Null=BHAPI api/v2/events/$ID DELETE}}
    End{}
    }
