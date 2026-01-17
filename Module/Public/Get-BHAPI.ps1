<#
.Synopsis
    Get BloodHound API Info
.DESCRIPTION
    Return BloodHound API Info as objects
.EXAMPLE
    Get-BHAPI
.EXAMPLE
    Get-BHAPI | select-object method,route,summary | sort-object route
#>

Function Get-BHAPI{
    [Alias('BHAPIInfo')]
    Param()
    foreach ($APIObj in (invoke-BHAPI "api/v2/swagger/doc.json").paths){
        foreach($Route in ($APIObj | GM | ? MemberType -eq NoteProperty).name){
            foreach($Meth in (($APIObj.$Route | gm | ? Membertype -eq Noteproperty).name | ?{$_ -ne 'parameters'})){
                $RouteData   = $APIObj.$Route.$Meth
                [PSCustomObject]@{
                    Route       = $Route
                    Method      = $Meth
                    Deprecated  = $RouteData.Deprecated
                    Tag         = $RouteData.tags
                    Data        = $RouteData
                    Summary     = $RouteData.Summary
                    Description = $RouteData.description
                    Parameters  = $RouteData.parameters
                    Consumes    = $RouteData.consumes
                    ParamInfo   = $APIObj.$Route.Parameters
                    }}}}}
