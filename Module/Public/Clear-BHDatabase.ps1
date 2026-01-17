function Clear-BHDatabase{
    Param(
        [ValidateSet('AD','AZ','OG')]
        [Parameter()][String[]]$GraphData,
        [ValidateSet('HighValue','AssetGroup')]
        [Parameter()][String[]]$CustomSelector,
        [Parameter()][Switch]$IngestHistory,
        [Parameter()][Switch]$DataHistory,
        [Parameter()][Switch]$Force,
        [Parameter()][Switch]$Really
        )
    NoMultiSession
    $ClearItem = @{}
    if($GraphData){
        $GD = [Array]@()
        If('AD' -in $GraphData){$GD+=1}
        If('AZ' -in $GraphData){$GD+=2}
        If('OG' -in $GraphData){$GD+=0}
        $ClearItem['deleteSourceKinds']=$GD
        $ClearItem['deleteCollectedGraphData']=$False
        }
    if($CustomSelector){
        $CS = [Array]@()
        if('HighValue' -in $CustomSelector){$CS+=1}
        if('AssetGroup' -in $CustomSelector){$CS+=2}
        $ClearItem['deleteAssetGroupSelectors']=$CS
        }
    if($IngestHistory){$ClearItem['deleteFileIngestHistory']=$true}
    if($DataHistory){$ClearItem['deleteDataQualityHistory']=$true}
    if($ClearItem -AND $($Force -OR $(Confirm-Action "Can't undo later... Are you sure"))){
        if($Really -OR $(Confirm-Action "This is irreversible... Are you really sure")){
            ## Comment line below to remove BHE safety - Don't blame me if you wipe your instance ##
            if($(BHSession|? x).edition -eq 'BHE'){RETURN 'Computer Says No... Â¯\_(ãƒ„)_/Â¯'}
            #DEBUG
            #$($ClearItem|Convertto-Json)
            # Clear DB
            BHAPI api/v2/clear-database POST $($ClearItem|Convertto-Json)
            }
        }
    }
