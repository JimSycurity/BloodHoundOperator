<#
.Synopsis
    [BHE] Get BloodHound Entity Meta
.DESCRIPTION
    Get BHE Entity Meta
.EXAMPLE
    BHMeta <objectID>
#>

function Get-BHNodeMeta{
    [Alias('BHMeta')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName,Position=0)][Alias('objectid')][String[]]$ID
        )
    Begin{BHEOnly}
    Process{foreach($ObjID in $ID){
        BHAPI meta/$ObjID -expand data
        }}
    End{}
    }
