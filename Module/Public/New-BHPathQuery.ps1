<#
.SYNOPSIS
    New BloodHound Query
.DESCRIPTION
    New BloodHound saved query 
.EXAMPLE
    New-BHPathQuery -Name MySavedQuery -Query "MATCH (x:User) RETURN x LIMIT 1" -Desc "My Saved Query"
#>

function New-BHPathQuery{
    [Alias('New-BHQuery')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipelineByPropertyName)][String]$Name,
        #[Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Platform='Other',
        #[Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Category='Custom',
        [Parameter(Mandatory=0,ValueFromPipelineByPropertyName)][String]$Description='Custom Query',
        [Parameter(Mandatory=1,ValueFromPipelineByPropertyName)][String]$Query,
        [Parameter(Mandatory=0)][Switch]$Public,
        [Parameter(Mandatory=0)][Switch]$PassThru
        )
    Begin{NoMultiSession}
    Process{Foreach($Nm in $Name){
        # Body
        $Body = @{
            name  = $Name
            description = $Description
            query = $Query.trim()
            }
        #if($Platform){$Body['Platform']=$Platform}
        #if($Category){$Body['Category']=$Category}
        if($Description){$Body['Description']=$Description}
        $SQ = Invoke-BHAPI api/v2/saved-queries -Method POST -Body ($Body| ConvertTo-Json) -expand data
        if($SQ.id -AND $Public){Set-BHQueryScope -ID $SQ.id -Public}
        if($PassThru){$SQ}
        Start-Sleep -Milliseconds 10
        }}
    End{}
    }
