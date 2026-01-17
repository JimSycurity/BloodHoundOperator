<#
.SYNOPSIS
    Get BloodHound Query
.DESCRIPTION
    Get BloodHound Saved Query 
.EXAMPLE
    BHQuery
.EXAMPLE
    BHQuery -ID 123
.EXAMPLE
    BHQuery -name MyQuery
.EXAMPLE
    BHQuery -description <keyword>
.EXAMPLE
    BHQuery -scope <shared|public>
#>

function Get-BHPathQueryOnlineLibrary{
    [CmdletBinding(DefaultParameterSetName='ByID')]
    [Alias('BHQLib','Get-BHQueryLibrary')]
    Param()
    irm https://raw.githubusercontent.com/SpecterOps/BloodHoundQueryLibrary/refs/heads/main/Queries.json | sort name -unique
    }
