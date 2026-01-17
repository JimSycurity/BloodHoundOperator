<#
.SYNOPSIS
    Select BloodHound Path Filter
.DESCRIPTION
    Select BloodHound Path Filter
.EXAMPLE
    Select-BHFilter
#>

function Select-BHPathFilter{
    [Alias('BHFilterSelect')]
    Param(
        [Parameter(Mandatory=1,ParameterSetName='All')][Switch]$All,
        [Parameter(Mandatory=1,ParameterSetName='None')][Switch]$None,
        [Parameter(Mandatory=1,ParameterSetName='Platform')][BHPlatform[]]$Platform,
        [Parameter(Mandatory=1,ParameterSetName='EdgeGroup')][Alias('Group')][BHEdgeGroup[]]$EdgeGroup,
        [Parameter(Mandatory=1,ParameterSetName='Edge')][BHEdge[]]$Edge,
        [Parameter(Mandatory=0,ParameterSetName='Platform')]
        [Parameter(Mandatory=0,ParameterSetName='EdgeGroup')]
        [Parameter(Mandatory=0,ParameterSetName='Edge')][Switch]$NoSelect
        )
    $xVal = if($NoSelect){$Null}else{'x'}
    Switch($PSCmdlet.ParameterSetName){
        # All
        All {$Script:BHFilter = Get-BHPathFilter -List | Select Platform,Group,@{n='x';e={'x'}},Edge}
        # None
        None{$Script:BHFilter|? x |%{$_.x=$Null}}
        # Platform
        Platform{foreach($Plt in $Platform){$Script:BHFilter|? Platform -eq $Plt |%{$_.x=$xVal}}}
        # EdgeGroup
        EdgeGroup{foreach($Grp in $EdgeGroup){$Script:BHFilter|? Group -eq $Grp |%{$_.x=$xVal}}}
        # Edge
        Edge{foreach($Edg in $Edge){$Script:BHFilter|? Edge -eq $Edg |%{$_.x=$xVal}}}
        }}
