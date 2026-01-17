<#
.Synopsis
    Get BloodHound Data Upload
.DESCRIPTION
    Get BloodHound Data upload
.EXAMPLE
    Get-BHDataUpload
.EXAMPLE
    Get-BHDataUpload -limit 10
#>

Function Get-BHDataUpload{
    [Alias('BHUpload')]
    Param(
        [Parameter(Mandatory=0)][String]$ID,
        [Parameter(Mandatory=0)][String]$Expand='data',
        [Parameter(Mandatory=0)][int]$Limit=1
        )
    $URI = if($ID){"api/v2/file-upload/$ID/completed-tasks"}else{'api/v2/file-upload'}
    if($Limit -AND -not$ID){$URI += "?limit=$Limit"}
    Invoke-BHAPI $URI -expand $Expand
    }
