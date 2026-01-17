<#
.Synopsis
    Get BloodHound Data
.DESCRIPTION
    Get BloodHound Data Stats
.EXAMPLE
    BHData -ListDomain
.EXAMPLE
    BHData -Platform AD
.EXAMPLE
    BHData -id $DomainID
.EXAMPLE
    BHData
#>

function Get-BHData{
    [CmdletBinding(DefaultParameterSetName='Stats')]
    [Alias('BHData')]
    Param(
        [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='Stats')][Alias('objectid')][String[]]$ID,
        [Parameter(Mandatory=1,ParameterSetName='ListDomain')][Switch]$ListDomain,
        [Parameter(Mandatory=0,ParameterSetName='ListDomain')][Switch]$Collected,
        [ValidateSet('AD','AZ')]
        [Parameter(Mandatory=1,ParameterSetName='Platform')][String]$Platform,
        [Parameter(Mandatory=1,ParameterSetName='Pipe')][Switch]$PipeStatus,
        [Parameter(Mandatory=0)][int]$Limit=1,
        [Parameter(Mandatory=0)][String[]]$Filter,
        [Parameter(Mandatory=0)][String]$Expand='data'
        )
    Begin{# Prep Filter
        [Array]$qfilter=@()
        if($Limit){$qFilter+="limit=$limit"}
        if($Collected){$qFilter+="collected=eq:True"}
        if($Filter){$qFilter+=$filter}
        # Call
        if($PSCmdlet.ParameterSetName -eq 'Platform'){Switch($Platform){
            AD{Invoke-BHAPI "api/v2/platform/ad/data-quality-stats" -Filter $qFilter -expand $Expand}
            AZ{Invoke-BHAPI "api/v2/platform/azure/data-quality-stats" -Filter $qFilter -expand $Expand}
            }}
        if($PSCmdlet.ParameterSetName -eq 'Pipe'){Invoke-BHAPI api/v2/datapipe/status -Filter $qFilter -expand data}
        }
    Process{
        if($PSCmdlet.ParameterSetName -eq 'Stats'){
            if($ID){Foreach($ObjID in $ID){
                    if($ObjID -match '^S-1-5-21'){Invoke-BHAPI "api/v2/ad-domains/$ObjID/data-quality-stats" -Filter $qFilter  -expand $Expand} 
                    else{Invoke-BHAPI "api/v2/azure-tenants/$ObjID/data-quality-stats" -Filter $qFilter -expand $Expand}
                    }}
            else{Invoke-BHAPI 'api/v2/completeness' -Filter $qFilter -expand $Expand}
            }}
    End{if($PSCmdlet.ParameterSetName -eq 'ListDomain'){Invoke-BHAPI api/v2/available-domains -Filter $qFilter -expand $Expand}}
    }
