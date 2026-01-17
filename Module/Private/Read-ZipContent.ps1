<#
.Synopsis
    Read Zip Content [internal]
.DESCRIPTION
    Read Zip Content
.EXAMPLE
    ZipRead $Zip
#>

function Read-ZipContent{
    [Alias('ZipRead')]
    Param(
        [Parameter(Mandatory=1)][String]$Zip
        )
    # Add type
    Add-Type -assembly "system.io.compression.filesystem" -ea 0
    # Get item
    $Item = Get-Item $Zip
    # Validate .zip
    if($Item.extension -ne '.zip'){Write-Warning "Invalid file extension";RETURN}
    # OpenRead
    try{$ZipRead = [io.compression.zipfile]::OpenRead($Item.FullName)}catch{RETURN}
    foreach($ZipEntry in $ZipRead.entries){
        $Stream  = $ZipEntry.open()
        $Reader  = New-Object IO.StreamReader($Stream)
        $Content = $Reader.ReadToEnd()
        $Content
        $reader.Close()
        $stream.Close()
        }
    # Dispose Zip
    $ZipRead.Dispose()
    }
