<#
.Synopsis
    Import BloodHound Data Collector
.DESCRIPTION
    Import BloodHound Data Collector
    /!\ AV
.EXAMPLE
    Import-BHDataCollector -SharpHound
#>

function Import-BHDataCollector{
    [Alias('Import-BHCollector')]
    Param(
        [Parameter(Mandatory=1,ParameterSetName='SharpHound')][Switch]$SharpHound,
        [Parameter(Mandatory=1,ParameterSetName='AzureHound')][Switch]$AzureHound,
        [Parameter(Mandatory=0)][string]$Version,
        [Parameter(Mandatory=0)][Switch]$Unzip
        )
    if(-Not$Version){$Version=(Get-BHDataCollector $PSCmdlet.ParameterSetName).latest}
    $Download = Switch($PSCmdlet.ParameterSetName){
        AzureHound{
            "https://github.com/BloodHoundAD/AzureHound/releases/download/$Version/azurehound-windows-amd64.zip"
            }
        SharpHound{
            "https://github.com/BloodHoundAD/SharpHound/releases/download/$Version/SharpHound-$Version.zip"
            }
        }
    Start-BitsTransfer -source $Download
    if($Unzip){Expand-Archive $(Split-Path $Download -leaf)}
    }
