<#
.Synopsis
    [BHE] Approve BloodHound Path Finding
.DESCRIPTION
    Approve BloodHound Path Finding
.EXAMPLE
    Approve-BHPathFinding -ID $id [-Force]
#>

function Approve-BHPathFinding{
    [Alias('Approve-BHFinding')]
    Param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('PathID')][Int[]]$ID,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][Alias('finding')][BHFindingType]$FindingType,
        [Parameter(Mandatory)][Bool]$Accepted,
        [Parameter()][DateTime]$Until=$([DateTime]::utcnow.AddDays(30)),
        [Parameter()][Switch]$Force,
        [Parameter()][Switch]$PassThru
        )
    Begin{NoMultiSession;BHEOnly}
    Process{foreach($PathId in $ID){
    if($Force -OR $(Confirm-Action "Confirm Acceptance:$Accepted for Finding ID $PathID")){
        $Accept = @{
            risk_type    = "$FindingType"
            accepted     = $Accepted
            accept_until = if($Until -AND $Accepted){$Until|ToBHDate}
            } | Convertto-Json
        $Out = BHAPI api/v2/attack-paths/$PathID/acceptance PUT $Accept -expand data
        if($PassThru){$Out}
        }}}
    End{}
    }
