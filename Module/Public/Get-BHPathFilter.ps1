<#
.SYNOPSIS
    Get BloodHound Path Filter
.DESCRIPTION
    Get BloodHound Path Filter
.EXAMPLE
    BHFilter
#>

function Get-BHPathFilter{
    [CmdletBinding(DefaultParameterSetName='Selected')]
    [Alias('BHFilter')]
    Param(
        [Parameter(Mandatory=1,ParameterSetName='List')][Switch]$ListAll,
        [Parameter(Mandatory=0,ParameterSetName='Selected')][Switch]$String,
        [Parameter(Mandatory=0,ParameterSetName='Selected')][Switch]$Cypher
        )
    $EdgeList = @(
        ## AD
        # Structure
        #[PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='ClaimSpecialIdentity'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='ContainsIdentity'}
        #[PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='DCFor'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='GPOAppliesTo'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='HasSIDHistory'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='MemberOf'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='PropagatesACEsTo'}
        [PSCustomObject]@{Platform='AD'; Group='ADStructure'; Edge='SameForestTrust'}
        # Lateral Movement
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='AdminTo'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='AllowedToAct'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='AllowedToDelegate'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='CanPSRemote'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='CanRDP'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='ExecuteDCOM'}
        [PSCustomObject]@{Platform='AD'; Group='ADLateralMovement'; Edge='SQLAdmin'}
        # Credential Access
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='CoerceToTGT'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='DCSync'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='DumpSMSAPassword'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='HasSession'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='ReadGMSAPassword'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='ReadLAPSPassword'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='SyncLAPSPassword'}
        [PSCustomObject]@{Platform='AD'; Group='ADCredentialAccess'; Edge='HasTrustKeys'}
        # Obj Manipulation Basic
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='AddMember'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='AddSelf'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='AllExtendedRights'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='ForceChangePassword'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='GenericAll'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='Owns'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='OwnsLimitedRights'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='GenericWrite'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='WriteDacl'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='WriteOwner'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectBasic'; Edge='WriteOwnerLimitedRights'}
        # Obj Manipulation Advance
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='AddAllowedToAct'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='AddKeyCredentialLink'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='CanApplyGPO'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='WriteAccountRestrictions'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='WriteSPN'}
        [PSCustomObject]@{Platform='AD'; Group='ADObjectAdvanced'; Edge='WriteGPLink'}
        # AD Cert Service
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='GoldenCert'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC1'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC3'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC4'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC6a'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC6b'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC9a'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC9b'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC10a'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC10b'}
        [PSCustomObject]@{Platform='AD'; Group='ADCertService'; Edge='ADCSESC13'}
        # Cross Forest Trust Abuse
        [PSCustomObject]@{Platform='AD'; Group='ADCrossForest'; Edge='SpoofSIDHistory'}
        [PSCustomObject]@{Platform='AD'; Group='ADCrossForest'; Edge='AbuseTGTDelegation'}
        # X-Platform
        [PSCustomObject]@{Platform='AD'; Group='CrossPlatform'; Edge='SyncedToEntraUser'}
        # NTLM Relay
        [PSCustomObject]@{Platform='AD'; Group='ADNTLMRelay'; Edge='CoerceAndRelayNTLMToSMB'}
        [PSCustomObject]@{Platform='AD'; Group='ADNTLMRelay'; Edge='CoerceAndRelayNTLMToADCS'}
        [PSCustomObject]@{Platform='AD'; Group='ADNTLMRelay'; Edge='CoerceAndRelayNTLMToLDAP'}
        [PSCustomObject]@{Platform='AD'; Group='ADNTLMRelay'; Edge='CoerceAndRelayNTLMToLDAPS'}
        ## AZ
        # Structure
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZAppAdmin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZCloudAppAdmin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZContains'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZGlobalAdmin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZHasRole'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZManagedIdentity'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZMemberOf'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZNodeResourceGroup'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZPrivilegedAuthAdmin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZPrivilegedRoleAdmin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZRunsAs'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZRoleEligible'}
        [PSCustomObject]@{Platform='AZ'; Group='AZStructure'; Edge='AZRoleApprover'}
        # AAD Obj Manipulation
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZAddMembers'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZAddOwner'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZAddSecret'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZExecuteCommand'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZGrant'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZGrantSelf'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZOwns'}
        [PSCustomObject]@{Platform='AZ'; Group='AZADObjectBasic'; Edge='AZResetPassword'}
        # MSGraph Role Abuse
        [PSCustomObject]@{Platform='AZ'; Group='AZGraphRole'; Edge='AZMGAddMember'}
        [PSCustomObject]@{Platform='AZ'; Group='AZGraphRole'; Edge='AZMGAddOwner'}
        [PSCustomObject]@{Platform='AZ'; Group='AZGraphRole'; Edge='AZMGAddSecret'}
        [PSCustomObject]@{Platform='AZ'; Group='AZGraphRole'; Edge='AZMGGrantAppRoles'}
        [PSCustomObject]@{Platform='AZ'; Group='AZGraphRole'; Edge='AZMGGrantRole'}
        # Credential Access
        [PSCustomObject]@{Platform='AZ'; Group='AZCredentialAccess'; Edge='AZGetCertificates'}
        [PSCustomObject]@{Platform='AZ'; Group='AZCredentialAccess'; Edge='AZGetKeys'}
        [PSCustomObject]@{Platform='AZ'; Group='AZCredentialAccess'; Edge='AZGetSecrets'}
        # AzRM Object Manipulation Basic
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZAvereContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZKeyVaultContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZOwner'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZUserAccessAdministrator'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZVMAdminLogin'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectBasic'; Edge='AZVMContributor'}
        # AzRM Object Manipulation Adavnced
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectAdvanced'; Edge='AZAKSContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectAdvanced'; Edge='AZAutomationContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectAdvanced'; Edge='AZLogicAppContributor'}
        [PSCustomObject]@{Platform='AZ'; Group='AZRMObjectAdvanced'; Edge='AZWebsiteContributor'}
        # X-Platform
        [PSCustomObject]@{Platform='AZ'; Group='CrossPlatform'; Edge='SyncedToADUser'}
        )
    # List All
    if($ListAll){if($BHFilter){$BHFilter}else{$EdgeList}}
    # Selected
    else{$SelectedEdge = $BHFilter | ? x
        if($Cypher){
            $Str=':'+(($SelectedEdge.Edge|Sort-Object)-join'|')
            if(($BHSession|? x).CypherClip){try{$Str|Set-Clipboard}Catch{}}
            $str
            }
        #elseif($String){($SelectedEdge.Edge|Sort-Object)-join','}
        elseif($String){"'"+(($SelectedEdge.Edge|Sort-Object)-join"','")+"'"}
        else{$SelectedEdge}
        }}
