<#
.Synopsis
    [BHE] New BloodHound RRule
.DESCRIPTION
    New BloodHound RRule
.EXAMPLE
    BHRRule
#>

function New-BHRRule{
    [Alias('BHRRule')]
    Param(
        [Parameter()][DateTime]$StartDate=[DateTime]::UTCNow,
        [ValidateSet('MINUTELY','HOURLY','DAILY','WEEKLY','MONTHLY')]
        [Parameter()][String]$Frequency='DAILY',
        [Parameter()][Int]$Interval=1,
        [Parameter()][Int]$Count
        )
    BHEOnly
    $Strt = $startDate.toUniversalTime().tostring('o').replace('.','').replace(':','').replace('-','').trimend('Z')[0..14]-join''
    $RR = "DTSTART:${Strt}Z`nRRULE:FREQ=$Frequency;INTERVAL=$Interval"
    if($Count){$RR+=";COUNT=$Count"}
    RETURN $RR
    }
