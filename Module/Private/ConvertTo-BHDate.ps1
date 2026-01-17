<#
.Synopsis
    Convert to BloodHound Date
.DESCRIPTION
    Converrt to BloodHound date format
.EXAMPLE
    Get-Date | ToBHDate
#>

function ConvertTo-BHDate{
    [Alias('ToBHDate')]
    Param(
        [Parameter(Mandatory=0,ValueFromPipeline)][DateTime[]]$Date=[DateTime]::utcnow,
        [Parameter()][Switch]$Epoch
        )
    Process{Foreach($dTime in $Date){
        if($Epoch){[Math]::Round(($dtime.toUniversalTime()-[DateTime]::New(1970,1,1,0,0,0,0,0,'utc')).totalmilliseconds,0)}
        else{#[Xml.XmlConvert]::ToString($dTime,[Xml.XmlDateTimeSerializationMode]::Utc)
            $dTime.ToUniversalTime().ToString('o') -replace("0*Z$"),('Z')-replace("\.Z$"),('Z')
            }}}}
