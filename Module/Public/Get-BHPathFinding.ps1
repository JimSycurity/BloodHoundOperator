<#
.Synopsis
    [BHE] Get BloodHound Path Finding
.DESCRIPTION
    Get BloodHound Attack Path Finding
.EXAMPLE
    BHFinding -TypeList
.EXAMPLE
    BHFinding -ListAvail -DomainID $ID
.EXAMPLE
    BHFinding -Detail -DomainID $ID -Type Kerberoasting
.EXAMPLE
    BHSearch Domain | BHFinding -Trend -Verbose -start (date).adddays(-10)
#>

function Get-BHPathFinding{
    [CmdletBinding(DefaultParameterSetName='Detail')]
    [Alias('BHFinding')]
    Param(
        [Parameter(Mandatory,ParameterSetName='ListAll')][Alias('ListAll')][Switch]$TypeList,
        [Parameter(Mandatory,ParameterSetName='Avail')][Switch]$ListAvail,
        [Parameter(Mandatory=0,ParameterSetName='Detail')][Switch]$Detail,
        [Parameter(Mandatory,ParameterSetName='Spark')][Switch]$Sparkline,
        [Parameter(Mandatory,ParameterSetName='Trend')][Switch]$Trend,
        [Parameter(ParameterSetName='Detail')]
        [Parameter(ParameterSetName='Spark')][Alias('Type')][BHFindingType[]]$FindingType,
        [Parameter(ParameterSetName='Trend',Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName=1,Position=0)]
        [Parameter(ParameterSetName='Spark',Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName=1,Position=0)]
        [Parameter(ParameterSetName='Detail',Mandatory=0,ValueFromPipeline,ValueFromPipelineByPropertyName=1,Position=0)]
        [Parameter(ParameterSetName='Avail',Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName=1,Position=0)][Alias('ID','objectid')][String[]]$DomainID,
        [Parameter(ParameterSetName='Trend')]
        [Parameter(ParameterSetName='Spark')][Datetime]$StartDate,
        [Parameter(ParameterSetName='Trend')]
        [Parameter(ParameterSetName='Spark')][Datetime]$EndDate,
        [Parameter(ParameterSetName='Spark')]
        [Parameter(ParameterSetName='Detail')][Int]$Limit=$($BHSession|? x|select -last 1).limit
        )
    Begin{BHEOnly
        $DomList=[Collections.ArrayList]@()
        if($PSCmdlet.ParameterSetName -eq 'ListAll'){BHAPI api/v2/attack-path-types -expand data}
        }
    Process{Foreach($DomID in $DomainID){
        if($PSCmdlet.ParameterSetName -ne 'trend'){$FindType = if(-Not$FindingType.count){BHAPI api/v2/domains/$DomID/available-types -expand data}else{$FindingType}}
        Switch($PSCmdlet.ParameterSetName){
                Avail {$FindType}
                Detail{[Array]$qFilter=@()
                    if($Limit){$qFilter+="limit=$Limit"}
                    Foreach($fType in $FindType){BHAPI api/v2/domains/$DomID/details -filter "finding=$fType",$qFilter -expand data}
                    }
                Spark{[Array]$qFilter=@()
                    if($StartDate){$qFilter+="from=$($StartDate|ToBHDate)"}
                    if($EndDate){$qFilter+="to=$($EndDate|ToBHDate)"}
                    Foreach($fType in $FindType){
                        $Out = BHAPI api/v2/domains/$DomID/sparkline -filter "finding=$fType",$qFilter -expand data
                        if($Limit){$Out |Select -first $Limit}else{$Out}
                        }
                    }
                Trend{$Null=$DomList.add($DomID)}
                }}}
    End{if($PSCmdlet.ParameterSetName -eq 'trend'){
        [Array]$qFilter=@()
        if($StartDate){$qFilter+="start=$($StartDate|ToBHDate)"}
        if($EndDate){$qFilter+="end=$($EndDate|ToBHDate)"}
        Foreach($Dom in $DomList){$qFilter+="environments=$Dom"}
        BHAPI api/v2/attack-paths/finding-trends -Filter $qfilter -Expand Data.findings
        }
    elseif($PSCmdlet.ParameterSetName -eq 'detail' -AND -Not$DomainID){
        BHAPI 'api/v2/attack-paths/details' -Expand data.findings
        }}
    }
