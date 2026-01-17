<#
.SYNOPSIS
    New BloodHound API Session
.DESCRIPTION
    New BloodHound API Session
.EXAMPLE
    $TokenKey = Get-Clipboard | Convertto-SecureString -AsPlainText -Force
    
    Convert plaintext token key from clipboard to secure string variable
.EXAMPLE
    New-BHSession -TokenID $TokenID -Token $TokenKey
    
    Create a BHCE session (localhost:8080). 
    - $TokenKey must be secure string.
.EXAMPLE
    New-BHSession -Server $Instance -TokenID $TokenID -Token $TokenKey
    
    Create a BHE session. 
    - $TokenKey must be secure string.
.EXAMPLE
    New-BHSession -JWT $JWT [-Server $Instance]
    
    Create Session with JWT
#>

function New-BHSession{
    [CmdletBinding(DefaultParameterSetName='JWT')]
    Param(
        # TokenID
        [Parameter(Mandatory=1,ParameterSetName='Token')][String]$TokenID,
        # Token
        [Parameter(Mandatory=1,ParameterSetName='Token')][Security.SecureString]$Token,
        # JWT
        [Parameter(Mandatory=1,Position=0,ParameterSetName='JWT')][String]$JWT,
        # Server
        [Parameter(Mandatory=0)][String]$Server='127.0.0.1',
        # Port
        [Parameter(Mandatory=0)][String]$Port,
        # Proto
        [Parameter(Mandatory=0)][String]$Protocol,
        # CypherClip
        [Parameter(Mandatory=0)][Switch]$CypherClip,
        # Edition
        [VAlidateSet('BHE','BHCE')]
        [Parameter(Mandatory=0)][Alias('Flavor')][Switch]$Edition
        )
    # ASCII
    $ASCII= @("
    _____________________________________________
    _______|_____________________________________
    ______||_________________BloodHoundOperator__
    ______||-________...___________________BETA__
    _______||-__--||||||||-._____________________
    ________!||||||||||||||||||--________________
    _________|||||||||||||||||||||-______________
    _________!||||||||||||||||||||||.____________
    ________.||||||!!||||||||||||||||-___________
    _______|||!||||___||||||||||||||||.__________
    ______|||_.||!___.|||'_!||_'||||||!._________
    _____||___!||____|||____||___|||||.__________
    ______||___||_____||_____||!__!|||'__________
    ___________ ||!____||!_______________________
    _____________________________________________
   
    BloodHound Dog Whisperer - @SadProcessor 2024
")  
    # Server, Port & Proto
    if($Server -match "127.0.0.1|localhost" -AND -Not$Port){$Port='8080'}
    if($Server -match "127.0.0.1|localhost" -AND -Not$Protocol){$Protocol='http'}
    if($Server -ne 'localhost' -AND -Not$Protocol){$Protocol='https'}
    if($Server -match "^https://"){$Server=$Server-replace"^https\:\/\/",'';$Protocol='https'}
    if($Server -match "^http://"){$Server=$Server-replace"^http\:\/\/",'';$Protocol='http'}
    if($Server -notmatch "^http://|^https://" -AND $Server -notmatch "\." -AND $Server -notmatch "127.0.0.1|localhost"){
        $Server+='.bloodhoundenterprise.io'
        }
    # BHFilter
    if(-Not$BHFilter){$Script:BHFilter = Get-BHPathFilter -ListAll | Select Platform,Group,@{n='x';e={'x'} },Edge}
    # BHSession
    if(-Not$BHSession){Write-Host $ASCII -ForegroundColor Blue; $Script:BHSession=[Collections.ArrayList]@()}
    # Unselect all
    $BHSession|? x|%{$_.x=''}
    # Session ID
    $SessionID = ($BHSession.id | sort-object | Select-Object -Last 1)+1 
    # New Session
    $NewSession = [PSCustomObject]@{
        x          = 'x'
        ID         = $SessionID
        Protocol   = $Protocol
        Server     = $Server
        Port       = $Port
        Operator   = 'tbd'
        Role       = 'tbd'
        Edition    = 'tbd'
        Version    = 'tbd'
        Timeout    = 0
        Limit      = 1000
        CypherClip = [Bool]$PSCmdlet.MyInvocation.BoundParameters.CypherClip.IsPresent
        TokenID    = if($JWT){'JWT'}else{$TokenID}
        Token      = if($JWT){$JWT}else{$Token}
        }
    # Add New Session
    $Null = $BHSession.add($NewSession)
    # Version
    $vers = BHAPI 'api/version' -Expand 'data.server_version' -SessionID $SessionID -verbose:$False
    if(-Not$Vers){
    #($Script:BHSession | ? x).Version = Try{BHAPI 'api/version' -Expand 'data.server_version' -SessionID $SessionID -verbose:$False}Catch{
        #$BHSession.Remove($NewSession)
        Write-Warning "Invalid Session Token - No Session Selected"
        RETURN 
        }
    else{($Script:BHSession | ? x).Version = $Vers}
    # Operator
    ($Script:BHSession | ? x).Operator = (BHAPI "api/v2/self" -Expand 'data.principal_name' -SessionID $SessionID -verbose:$False)
    # Role
    ($Script:BHSession | ? x).Role = (BHAPI "api/v2/self" -Expand 'data.roles' -SessionID $SessionID -verbose:$False).name
    # Edition 
    $BHEdition = if($Edition){$Edition}else{if($NewSession.server -match "\.bloodhoundenterprise\.io$"){'BHE'}else{'BHCE'}}
    ($Script:BHSession | ? x).Edition = $BHEdition 
    }
