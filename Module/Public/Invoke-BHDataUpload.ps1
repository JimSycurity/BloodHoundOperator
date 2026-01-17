<#
.Synopsis
    Invoke BloodHound Data Upload
.DESCRIPTION
    Invoke BloodHound Data upload
.EXAMPLE
    BHDataUpload $Zip
#>

function Invoke-BHDataUpload{
    [Alias('BHDataUpload')]
    param(
        [Parameter(Mandatory=1,ValueFromPipeline,ValueFromPipelineByPropertyName)][Alias('Json')][String[]]$Data,
        [Parameter(Mandatory=0)][int]$Split
        )
    Begin{# Start upload sequence (>> ID)
        $Upl = Invoke-BHAPI "api/v2/file-upload/start" -Method POST -expand data -verbose:$false
        Write-Verbose "Creating Upload ID $($Upl.id)"
        }
    Process{# Add files
        Foreach($Json in ($Data | Read-BHDataSource -Split $Split)){
            Write-Verbose "Adding $($Json.Count) $($Json.type.trimend('s'))$(if($Json.Count -gt 1){'s'}) from $($Json.Source) to Upload ID $($Upl.id)"
            $Null = Invoke-BHAPI "api/v2/file-upload/$($Upl.ID)" -Method POST -body $JSON.data -verbose:$false -wa Stop
            }
        }
    End{# End upload sequence
        Write-Verbose "Starting Upload ID $($Upl.id)"
        $Null = Invoke-BHAPI "api/v2/file-upload/$($Upl.ID)/end" -Method POST -verbose:$false
        }
    }
