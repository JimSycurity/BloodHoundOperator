<#
.Synopsis
    Confirm Action [internal]
.DESCRIPTION
    As for action confirmation
.EXAMPLE
    Confirm-Action
#>

function Confirm-Action{
    Param(
        [Parameter(Mandatory=0)]$Action='Are You sure' 
        )
    If($(Read-Host -Prompt "$Action ? (Y/N)") -eq 'Y'){$True}else{$False}
    }
