<#
.Synopsis
    Read-SecureString [internal]
.DESCRIPTION
    Read secure string content
.EXAMPLE
    $SecureString | Read-SecureString
#>

function Read-SecureString{
    Param(
        [Parameter(Mandatory,ValuefromPipeline)][Security.SecureString[]]$SecureString
        )
    Begin{}
    Process{Foreach($SecStr in @($SecureString)){
        # Windows_&_7 OR Windows_&_5
        if($PSVersionTable.Platform -eq 'Win32NT' -OR $PSVersionTable.PSEdition -eq 'Desktop'){
            [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecStr)).tostring()
            }
        # Unix_&_7
        else{$SecStr | Convertfrom-SecureString -AsPlainText}
        }}
    End{}
    }
