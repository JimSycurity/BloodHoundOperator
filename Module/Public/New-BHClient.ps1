<#
.Synopsis
    [BHE] New BloodHound Client
.DESCRIPTION
    New BHE Client
.EXAMPLE
    $Client = @{
        Prop = value
        }
    New-BHClient @Client
#>

function New-BHClient{
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline)][String[]]$Name,
        [ValidateSet('SharpHound','AzureHound')]
        [Parameter(Mandatory=1)][Alias('Type')][String]$ClientType,
        [Parameter(Mandatory=0)][Alias('DC')][String]$DomainController
        #[Parameter(Mandatory=0)][PSObject[]]$EventList
        )
    Begin{NoMultiSession;BHEOnly}
    Process{Foreach($CLiName in $Name){
        $ClientObj = @{
            name = $CliName
            type = $ClientType.tolower()
            events = @()
            } 
        if($DomainController){$ClientObj['domain_controller'] = $DomainController}    
        $ClientObj = $ClientObj | ConvertTo-Json
        $Output = BHAPI api/v2/clients POST $ClientObj -expand data
        if($Output){
            $Output.token.key = $Output.token.key | ConvertTo-SecureString -AsPlainText -force
            $Output
            }
        }}
    End{}
    }
