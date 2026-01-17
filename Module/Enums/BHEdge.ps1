enum BHEdge{
    ## AD
    # ADStructure
    #ClaimSpecialIdentity
    ContainsIdentity
    #DCFor
    GPOAppliesTo
    HasSIDHistory
    MemberOf
    PropagatesACEsTo
    SameForestTrust
    # ADLateralMovement
    AdminTo
    AllowedToAct
    AllowedToDelegate
    CanPSRemote
    CanRDP
    ExecuteDCOM
    SQLAdmin
    # ADCredentialAccess
    CoerceToTGT
    DCSync
    DumpSMSAPassword
    HasSession
    ReadGMSAPassword
    ReadLAPSPassword
    SyncLAPSPassword
    HasTrustKeys
    # ADObjectBasic
    AddMember
    AddSelf
    AllExtendedRights
    ForceChangePassword
    GenericAll
    Owns
    OwnsLimitedRights
    GenericWrite
    WriteDacl
    WriteOwner
    WriteOwnerLimitedRights
    # ADObjectAdvanced
    AddAllowedToAct
    AddKeyCredentialLink
    CanApplyGPO
    WriteAccountRestrictions
    WriteSPN
    WriteGPLink
    # ADCertService
    GoldenCert
    ADCSESC1
    ADCSESC3
    ADCSESC4
    ADCSESC6a
    ADCSESC6b
    ADCSESC9a
    ADCSESC9b
    ADCSESC10a
    ADCSESC10b
    ADCSESC13
    # ADCrossForest
    SpoofSIDHistory
    AbuseTGTDelegation
    # X-Platform
    SyncedToEntraUser
    # NTLMRelay
    CoerceAndRelayNTLMToSMB
    CoerceAndRelayNTLMToADCS
    CoerceAndRelayNTLMToLDAP
    CoerceAndRelayNTLMToLDAPS
    ## AZ
    # AZStructure
    AZAppAdmin
    AZCloudAppAdmin
    AZContains
    AZGlobalAdmin
    AZHasRole
    AZManagedIdentity
    AZMemberOf
    AZNodeResourceGroup
    AZPrivilegedAuthAdmin
    AZPrivilegedRoleAdmin
    AZRunsAs
    AZRoleEligible
    AZRoleApprover
    # AZADObjectBasic
    AZAddMembers
    AZAddOwner
    AZAddSecret
    AZExecuteCommand
    AZGrant
    AZGrantSelf
    AZOwns
    AZResetPassword
    # AZGraphRole
    AZMGAddMember
    AZMGAddOwner
    AZMGAddSecret
    AZMGGrantAppRoles
    AZMGGrantRole
    # AZCredentialAccess
    AZGetCertficates
    AZGetKeys
    AZGetSecrets
    # AZRMObjectBasic
    AZAvereContributor
    AZKeyVaultContributor
    AZOwner
    AZContributor
    AZUserAccessAdministrator
    AZVMAdminLogin
    AZVMContributor
    # AZRMObjectAdvanced
    AZAKSContributor
    AZAutomationContributor
    AZLogicAppContributor
    AZWebsiteContributor
    # X-Platform
    SyncedToADUser
    }
