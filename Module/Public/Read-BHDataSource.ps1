<#
.Synopsis
    Read BloodHound Data Source
.DESCRIPTION
    Read BloodHound Data Source
.EXAMPLE
    Read-BHDataSource $Zip -Split 5000
#>

function Read-BHDataSource{
    [Alias('BHRead')]
    Param(
        [Parameter(Mandatory=1,ValueFromPipeline=1)][String[]]$Source,
        [Parameter()][Int]$Split,
        [Parameter()][Switch]$Unpack
        )
    Begin{}
    Process{foreach($Obj in $Source){
            $Src='Raw Json Input'
            $Json=if(Test-Path $Obj){$Src = Split-Path $Obj -leaf
                if($Obj -match "\.json$"){Get-Content $Obj -Raw}
                if($Obj -match "\.zip$"){Read-ZipContent $Obj}
                }
            else{$Obj}
            foreach($JsonData in ($JSON)){
                $JsonData = $JsonData | ConvertFrom-Json | ConvertTo-Json -depth 21 -Compress
                # AD
                if($JsonData -match ',"meta":{"methods":'){
                    $meta = '{"methods":' + ($JsonData -split ',"meta":{"methods":')[1].trimend('}') + '}' | Convertfrom-JSON
                    $meta | Add-Member -MemberType NoteProperty -Name 'Source' -Value $Src
                    $data = ($JsonData -split ',"meta":{"methods":')[0].replace('{"data":[','[')
                    $meta | Add-Member -MemberType NoteProperty -Name 'Data' -Value $JsonData
                    # Split
                    if($Split -AND $($Meta | Select-object -expand Count) -gt $Split){
                        foreach($SplitData in (($Meta.Data | Convertfrom-Json).data | Split-Collection $Split)){
                            [PSCustomObject]@{
                                methods = $Meta.methods
                                type    = $Meta.Type
                                count   = $SplitData.count
                                Version = $Meta.Version
                                Source  = $Meta.Source
                                Data    = '{"data":' + $($SplitData | Convertto-JSON -depth 11 -Compress)+',"meta":'+$([PSCustomObject]@{methods=$Meta.Methods;type=$Meta.type;count=$SplitData.count;version=$Meta.version } | Convertto-json -compress)+'}'
                                }
                            }
                        }
                    Else{$Meta}
                    }
                # AZ
                if($JsonData -match '"meta":{"type":"azure"'){
                    $Meta = ($Jsondata -split '"meta":{"type":"azure"')[1].trim().trimend('}')
                    $Meta = ('{"type":"azure"' + $meta + '}') | Convertfrom-json
                    $meta | Add-Member -MemberType NoteProperty -Name 'Source' -Value $Src
                    $meta | Add-Member -MemberType NoteProperty -Name 'Data' -Value $Jsondata
                    # Split
                    if($Split -AND $($Meta | Select-object -expand Count) -gt $Split){
                        foreach($SplitData in (($Meta.Data | Convertfrom-Json).data | Split-Collection $Split)){
                            [PSCustomObject]@{
                                type    = $Meta.Type
                                count   = $SplitData.count
                                Version = $Meta.Version
                                Source  = $Meta.Source
                                Data    = '{"data":' + $($SplitData | Convertto-JSON -depth 11 -Compress)+',"meta":'+$([PSCustomObject]@{type=$Meta.type;count=$SplitData.count;version=$Meta.version}|Convertto-json -compress)+'}'
                                }
                            }
                        }
                    Else{$Meta}
                    }
                }
            }
        }
    End{}
    }
