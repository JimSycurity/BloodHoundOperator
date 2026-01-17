<#
.Synopsis
    Invoke BloodHound API call
.DESCRIPTION
    Invoke-RestMethod to Bloodhound API against BHSession
.EXAMPLE
    Invoke-BHAPI /api/version | Select-Object -ExpandProperty data | Select-Object -ExpandProperty server_version
.EXAMPLE
    bhapi api/version -expand data.server_version
.EXAMPLE
    BHAPI bloodhound-users POST $Json
#>

function Invoke-BHAPI{
    [Alias('BHAPI')]
    param(
        # URI
        [Parameter(Mandatory=1)][String]$URI,
        # Method
        [ValidateSet('GET','POST','PATCH','PUT','DELETE')]
        [Parameter(Mandatory=0)][String]$Method='GET',
        # Body
        [Parameter(Mandatory=0)][String]$Body,
        # FIlters
        [Parameter(Mandatory=0)][String[]]$Filter,
        # Session
        [Parameter(Mandatory=0)][int[]]$SessionID=($BHSession | ? x).id,
        # Timeout
        [Parameter(Mandatory=0)][Alias('Prefer')][int]$Timeout,
        # Expand
        [Parameter(Mandatory=0)][Alias('Dot')][String]$Expand
        )
    begin{
        if(-Not$SessionID){Write-Warning "No BHSession found: Use New-BHSession [Help New-BHSession]";Break}
        if($URI -match "^/"){$URI=$URI.trimstart('/')}
        if($URI -notmatch "^api/"){$URI='api/v2/'+$URI}
        if($filter){$qFilter = '?'+$($Filter.replace(' ','+')-join'&')
            $qfilter=[uri]::EscapeUriString($qFilter)
            $qFilter=$qfilter.trimend('&')
            $URI=$URI+$qfilter
            }
        }
    process{foreach($SessID in $SessionID){
            # Session
            $Session   = $BHSession | ? ID -eq $SessID
            $Proto     = $Session.Protocol
            $Server    = $Session.Server
            $Port      = $Session.Port
            if(-Not$TimeOut){$Timeout=($BHSession | ? id -eq $SessID).timeout}
            ## TokenID/TokenKey
            if($Session.tokenID -ne 'JWT'){
                $TokenID   = $Session.TokenID
                $TokenKey  = $Session.Token | Read-SecureString
                # Signature
                $Timestamp = [Datetime]::utcnow.tostring('o')
                $KeyByte   = [Text.Encoding]::UTF8.GetBytes($TokenKey)
                $OpByte    = [Text.Encoding]::UTF8.GetBytes("$Method/$URI")
                $DateByte  = [Text.Encoding]::UTF8.GetBytes(-join $Timestamp[0..12])
                $BodyByte  = [Text.Encoding]::UTF8.GetBytes("$Body")
                $HMAC      = [Security.Cryptography.HMACSHA256]::new($KeyByte).ComputeHash($OpByte)
                $HMAC      = [Security.Cryptography.HMACSHA256]::new($HMAC).ComputeHash($DateByte)
                $HMAC      = [Security.Cryptography.HMACSHA256]::new($HMAC).ComputeHash($BodyByte)
                $Sign      = [Convert]::ToBase64String($HMAC)
                # Headers
                $Headers = @{
                    Authorization = "BHESignature $TokenID"
                    Signature     = $Sign
                    RequestDate   = $Timestamp
                    }}
            ## JWT
            else{$Headers = @{
                Authorization = "Bearer $($Session.Token)"
                }}
            if($Timeout -ne $Null){$Headers.add('Prefer',"wait=$Timeout")}
            ## DEBUG
            #RETURN $Headers
            # Verbose
            Write-verbose "[BH] $Method $URI"
            if($Body){Write-Verbose "$Body"}
            # Params
            if($Port){$Server="${server}:${Port}"}
            $Params = @{
                Uri         = "${Proto}://${Server}/${URI}"
                ContentType = if($Method -eq 'POST' -AND $uri -match "saml/providers$"){'multipart/form-data'}else{'application/json'}
                Method      = $Method
                Headers     = $Headers
                UserAgent   = 'PowerShell BloodHound Operator'
                #TimeoutSec  = 300
                }
            # Body
            if($Body){$Params.Add('Body',"$Body")}
            # Call
            try{$Reply = Invoke-RestMethod @Params -verbose:$false -UseBasicParsing}catch{Get-ErrorWarning;Break}
            # Output
            if($Expand){foreach($Dot in $Expand.split('.')){try{$Reply=$Reply.$Dot}Catch{}}}
            if(($BHSession|? x).count -gt 1 -AND $reply.gettype().name -ne 'string'){$Reply|%{
                $_|Add-Member -MemberType NoteProperty -Name SessionID -Value $SessID -PassThru | select SessionID,* -ea 0
                }}
            else{$Reply}
            }}
    end{}###
    }
