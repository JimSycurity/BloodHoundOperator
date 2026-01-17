<#
.Synopsis
    Get BloodHound Data Collector
.DESCRIPTION
    Get BloodHound Data Collector Info
.EXAMPLE
    Get-BHDataCollector
#>

function Get-BHDataCollector{
    [Alias('BHCollector')]
    Param(
        [ValidateSet('SharpHound','AzureHound')][Parameter()][String[]]$Collector=('SharpHound','AzureHound')
        )
    foreach($Hound in $Collector){foreach($SessID in ($BHSession|? x).id){
        $Coll  = Invoke-BHAPI api/v2/collectors/$($Hound.tolower()) -Sessionid $SessID -expand data
        $Check = Invoke-BHAPI api/v2/collectors/$($Hound.tolower())/$($Coll.latest)/checksum -Sessionid $SessID
        [PSCustomObject]@{
            Collector = $Hound.tolower()
            Latest    = $Coll.latest
            File      = $Check.trim().split(' ')[-1].trim()
            Checksum  = $Check.trim().split(' ')[0].trim()
            Versions  = $Coll.versions
            }
        }}
    }
