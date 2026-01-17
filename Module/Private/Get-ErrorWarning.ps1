<#
.Synopsis
    Get Error as Warning [internal]
.DESCRIPTION
    Get last error message as warning
.EXAMPLE
    Get-ErrorWarning
#>

function Get-ErrorWarning{
    $errr = $Error[0]
    $errr = try{$errr.ErrorDetails.message | convertfrom-Json -ea 0}Catch{$Errr.Exception.message}
    if($errr.http_status){if($errr.http_status -ne '404'){Write-Warning "$($errr.http_status) - $($errr.errors.message)"}}
    else{Write-Warning $(if($Errr){$Errr}else{'Unknown error... Â¯\_(ãƒ„)_/Â¯'})}
    }
