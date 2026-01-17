<#
.Synopsis
    [BHE] Get BloodHound Data Posture
.DESCRIPTION
    Get BloodHound Data Posture
.EXAMPLE
    Get-BHDataPosture
.EXAMPLE
    BHSearch Domain test | BHPosture -Exposure -StartDate (date).adddays(-30)

#>

function Get-BHDataPosture{
    [CmdletBinding(DefaultParameterSetName='General')]
    [Alias('BHPosture')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipelineByPropertyName)][Alias('ID','ObjectID')][String[]]$DomainID,
        [Parameter(Mandatory=1,ParameterSetName='Exposure')][Switch]$Exposure,
        [Parameter(Mandatory=1,ParameterSetName='Finding')][Switch]$Findings,
        [Parameter(Mandatory=1,ParameterSetName='Asset')][Switch]$Assets,
        [Parameter(Mandatory=1,ParameterSetName='Group')][Switch]$GroupCompleteness,
        [Parameter(Mandatory=1,ParameterSetName='Session')][Switch]$SessionCompleteness,
        [Parameter(ParameterSetName='General')][Int]$Limit=1,
        [Parameter(ParameterSetName='Exposure')]
        [Parameter(ParameterSetName='Finding')]
        [Parameter(ParameterSetName='Asset')]
        [Parameter(ParameterSetName='Group')]
        [Parameter(ParameterSetName='Session')]
        [Parameter(ParameterSetName='General')][Alias('From')][Datetime]$StartDate,
        [Parameter(ParameterSetName='Exposure')]
        [Parameter(ParameterSetName='Finding')]
        [Parameter(ParameterSetName='Asset')]
        [Parameter(ParameterSetName='Group')]
        [Parameter(ParameterSetName='Session')]
        [Parameter(ParameterSetName='General')][Alias('To')][Datetime]$EndDate
        )
    Begin{BHEOnly
        $DomList = [Collections.ArrayList]@()
        [Array]$qFilter=@() ## /!\ Date filter /!\
        if($StartDate){$qFilter+=if($PSCmdlet.ParameterSetName -eq 'General'){"from=$($StartDate|ToBHDate)"}else{"start=$($StartDate|ToBHDate)"}}
        if($EndDate){$qFilter+=if($PSCmdlet.ParameterSetName -eq 'General'){"to=$($EndDate|ToBHDate)"}else{"end=$($EndDate|ToBHDate)"}}
        }
    Process{foreach($DomID in $DomainID){
        Switch($PSCmdlet.ParameterSetName){
            General {
                $qFilter+="limit=$Limit"
                $qfilter+="domain_sid=eq:$DomID"
                BHAPI api/v2/posture-stats -filter $qFilter -expand data
                }
            Default{$Null=$DomList.add($DomID)}
            }}}
    End{Foreach($Dom in $DomList){$qFilter+="environments=$Dom"}
        Switch($PSCmdlet.ParameterSetName){
            Exposure{BHAPI api/v2/posture-history/exposure -Filter $qfilter -expand data}
            Finding {BHAPI api/v2/posture-history/findings -Filter $qfilter -expand data}
            Asset   {BHAPI api/v2/posture-history/assets -Filter $qfilter -expand data}
            Group   {BHAPI api/v2/posture-history/group-completeness -Filter $qfilter -expand data}
            Session {BHAPI api/v2/posture-history/session-completeness -Filter $qfilter -expand data}
            }
        }
    }
