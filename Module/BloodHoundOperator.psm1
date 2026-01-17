$enumPath = Join-Path $PSScriptRoot 'Enums'
$privatePath = Join-Path $PSScriptRoot 'Private'
$publicPath = Join-Path $PSScriptRoot 'Public'

$enumFiles = Get-ChildItem -Path $enumPath -Filter '*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object Name
$privateFiles = Get-ChildItem -Path $privatePath -Filter '*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object Name
$publicFiles = Get-ChildItem -Path $publicPath -Filter '*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object Name

foreach ($file in @($enumFiles + $privateFiles + $publicFiles)) {
    . $file.FullName
}

$publicFunctions = $publicFiles.BaseName
if ($publicFunctions) {
    $publicAliases = Get-Alias -Definition $publicFunctions -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
} else {
    $publicAliases = @()
}

Export-ModuleMember -Function $publicFunctions -Alias $publicAliases
