<#
.Synopsis
    Convert from BloodHound Date
.DESCRIPTION
    Converrt from BloodHound date format
.EXAMPLE
    $BHDate | FromBHDate
#>

function ConvertFrom-BHDate{
    [Alias('FromBHDate')]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)][String[]]$Date
        )
    Process{Foreach($dString in $Date){
        if($False){}
        if($dString -match "^(\d{13})$"){[DateTime]::New(1970,1,1,0,0,0,0,0,'utc').AddMilliseconds($dString)}
        else{($dString -as [DateTime]).toUniversalTime()}
        }}}
