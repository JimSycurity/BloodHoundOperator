<#
.SYNOPSIS
    Get BloodHound Server Audit Log
.DESCRIPTION
    Get BloodHound Server Audit Log
.EXAMPLE
    BHAudit
#>

Function Get-BHServerAuditLog{ #<------------------------------------------- /!\ Check Filters /!\
    [Alias('BHAudit')]
    Param(
        [Parameter()][string]$Limit='100',
        [Parameter()][DateTime]$Before,
        [Parameter()][DateTIme]$After,
        [Parameter()][String[]]$Filter,
        [Parameter()][string]$Skip
        )
    [Array]$qFltr=@()
    if($After){$qFltr+="after=$($After|ToBHDate)"}
    if($Before){$qFltr+="before=$($Before|ToBHDate)"}
    if($Skip){$qFltr+="Skip=$Skip"}
    if($Limit){$qFltr+="limit=$Limit"}
    if($Filter.count){$qFltr+=$Filter}
    Invoke-BHAPI 'api/v2/audit' -filter $qFltr -Expand data.logs
    }
