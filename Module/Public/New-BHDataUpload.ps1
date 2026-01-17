<#
.Synopsis
    New BloodHound Data Upload
.DESCRIPTION
    New BloodHound Data upload
.EXAMPLE
    BHDataUploadJSON $JSON
#>

function New-BHDataUpload{
    [Alias('BHDataUploadJSON')]
    param(
        [Parameter(Mandatory=1,ValueFromPipeline)][Alias('JSON')][String[]]$UploadJSON
        )
    Begin{ # Begin upload > ID
        $Upl = Invoke-BHAPI "api/v2/file-upload/start" -Method POST -expand data
        }
    Process{# Add files to Upload ID
        Foreach($JSON in $UploadJSON){
            $Null = Invoke-BHAPI "api/v2/file-upload/$($Upl.ID)" -Method POST -body $JSON
            }}
    End{# submit Upload ID
        $Null = Invoke-BHAPI "api/v2/file-upload/$($Upl.ID)/end" -Method POST
        }}
