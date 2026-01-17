<#
.SYNOPSIS
    Get BloodHound Node
.DESCRIPTION
    Get BloodHound Node
.EXAMPLE
    BHNode User -id <id>
.EXAMPLE
    BHNode -Search User alice
.EXAMPLE
    bhnode -search user yoda -list controllers
.EXAMPLE
    bhnode -search user yoda -list controllers -AsPath [-Cypher] # EXPERIMENTAL - DO NOT TRUST OUTPUT
#>

function Get-BHNode{
    [Alias('BHNode')]
        Param(
        [Parameter(Mandatory=1,Position=0,ParameterSetName='Search')]
        [Parameter(Mandatory=0,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='ByID')][Alias('Type')][BHEntityType]$Label,
        [Parameter(Mandatory=1,Position=1,ValueFromPipeline,ValueFromPipelineByPropertyName,ParameterSetName='ByID')][Alias('ID','object_id')][String[]]$ObjectID,
        [Parameter(Mandatory=1,ParameterSetName='Search')][Switch]$Search,
        [Parameter(Mandatory=0,Position=1,ParameterSetName='Search')][String[]]$Keyword='-',
        [Parameter(Mandatory=0)][Alias('NoCount')][Switch]$PropOnly,
        [Parameter(Mandatory=0)][String]$Expand='data',
        [Parameter(Mandatory=0)][Switch]$AsPath,
        [Parameter(Mandatory=0)][Int]$Limit=$($BHSession|? x|select -last 1).limit,
        [Parameter(Mandatory=0)][Switch]$Cypher,
        [Parameter(Mandatory=0)][int[]]$SessionID=($BHSession|? x).id
        )
    DynamicParam{
        $Dico = New-Object Management.Automation.RuntimeDefinedParameterDictionary
        # Prep DynNamelist
        $DynList = Switch -regex ($Label){
            # AD
            ^Base$          {'Controllables'}
            ^Container$     {'Controllers'}
            ^Computer$      {'AdminRights','AdminUsers','ConstrainedDelegationRights','ConstrainedUsers','Controllables','Controllers','DCOMRights','DCOMUsers','GroupMemberships','PSRemoteRights','PSRemoteUsers','RDPRights','Sessions','SQLAdmins'}
            ^Domain$        {'Computers','Controllers','DCSyncers','ForeignAdmins','ForeignGPOControllers','ForeignGroups','ForeignUsers','GPOs','Groups','IndoundTrusts','LinkedGPOs','OUs','OutboundTrusts','Users'<#,'TierZero'#>}
            ^GPO$           {'Computers','Containers','Controllers','OUs','TierZero','Users'}
            ^Group$         {'AdminRights','Controllables','Controllers','DCMRights','Members','Memberships','PSRemoteRights','RDPRights','Sessions'}
            ^OU$            {'Computers','GPOs','Groups','Users'}
            ^User$          {'AdminRights','ConstrainedDelegationRights','Controllables','Controllers','DCOMRights','Memberships','PSRemoteRights','RDPRights','Sessions','SQLAdminRights'}
            # ADCS
            ^AIACA$        {'Controllers'}
            ^CertTemplate$ {'Controllers'}
            ^EnterpriseCA$ {'Controllers'}
            ^NTAuthStore$  {'Controllers'}
            ^RootCA$       {'Controllers'}
            # AZ <-------------------------------------- ToDo: List Items
            ^AZBase$ {'InboundControl'}
            ^AZTenant$ {
                'Users',
                'Groups',
                'ManagementGroups',
                'Subscriptions',
                'ResourceGroups',
                'VMs',
                'ManagedClusters',
                'VMScaleSets',
                'ContainerRegistries',
                'WebApps',
                'AutomationAccounts',
                'KeyVaults',
                'FunctionApps',
                'LogicApps',
                'AppRegistrations',
                'ServicePrincipals',
                'Devices',
                'InboundControl'
                }
            ^AZManagementGroup$ {
                'Users',
                'Groups',
                'ManagementGroups',
                'Subscriptions',
                'ResourceGroups',
                'VMs',
                'ManagedClusters',
                'VMScaleSets',
                'ContainerRegistries',
                'WebApps',
                'AutomationAccounts',
                'KeyVaults',
                'FunctionApps',
                'LogicApps',
                'AppRegistrations',
                'ServicePrincipals',
                'Devices',
                'InboundControl'
                }
            ^AZSubscription$ {
                'Users',
                'Groups',
                'ResourceGroups',
                'VMs',
                'ManagedClusters',
                'VMScaleSets',
                'ContainerRegistries',
                'WebApps',
                'AutomationAccounts',
                'KeyVaults',
                'FunctionApps',
                'LogicApps',
                'AppRegistrations',
                'ServicePrincipals',
                'Devices',
                'InboundControl'
                }
            ^AZResourceGroup$ {
                'Users',
                'Groups',
                'ResourceGroups',
                'VMs',
                'ManagedClusters',
                'VMScaleSets',
                'ContainerRegistries',
                'WebApps',
                'AutomationAccounts',
                'KeyVaults',
                'FunctionApps',
                'LogicApps',
                'AppRegistrations',
                'ServicePrincipals',
                'Devices',
                'InboundControl'}
            ^AZVM$                  {'LocalAdmins','InboundControl'}
            ^AZAutomationAccount$   {'InboundControl'}
            ^AZLogicApp$            {'InboundControl'}
            ^AZFunctionApp$         {'InboundControl'}
            ^AZWebApp$              {'InboundControl'}
            ^AZKeyVault$            {'InboundControl','KeyReaders','CertificateReaders','SecretReaders',,'AllReaders'}
            ^AZManagedCluster$      {'InboundControl'}
            ^AZVMScaleSet$          {'InboundControl'}
            ^AZContainerRegistry$   {'InboundControl'}
            # AZ AAD
            ^AZRole$                {'ActiveAssignments'<#,'PimAssignments'#>}
            ^AZUser$                {'MemberOf','Roles','ExecutionPrivileges','OutboundControl','InboundControl'}
            ^AZGroup$               {'Members','MemberOf','Roles','InboundControl','OutboundControl'}
            ^AZServicePrincipal$    {'Roles','InboundControl','OutboundControl','InboundAppRole','OutboundAppRole'}
            ^AZApp$                 {'InboundControl'}
            ^AZDevice$              {'LocalAdmin','InboundControl'}
            #Default{}
            }
        # Prep DynP
        $DynP = DynP -Name 'List' -Type 'String' -Mandat 0 -VSet $DynList
        # DynP to Dico
        $Dico.Add("List",$DynP)
        # Return Dico
        Return $Dico
        }
    Begin{Foreach($SessID in $SessionID){if($Search){foreach($Key in $Keyword){Search-BHNode $Label $Key -SessionID $SessID -limit $Limit |%{
            if($DynP.Value){$_|Get-BHNode $Label -List $DynP.Value -Expand $Expand -AsPath:$ASPath -Cypher:$Cypher -limit $Null -PropOnly:$PropOnly -SessionID $SessID}
            else{$_|Get-BHNode $Label -Expand $Expand -AsPath:$ASPath -Cypher:$Cypher -limit $Null -PropOnly:$PropOnly -SessionID $SessID}
            }}}}}
    Process{Foreach($SessID in $SessionID){Foreach($ObjID in $ObjectID){
        $URL = Switch -regex ($Label){
            # AD
            ^Base$      {"api/v2/base/$ObjID"}
            ^Container$ {"api/v2/containers/$ObjID"}
            ^Computer$  {"api/v2/computers/$ObjID"}
            ^Domain$    {"api/v2/domains/$ObjID"}
            ^GPO$       {"api/v2/gpos/$ObjID"}
            ^Group$     {"api/v2/groups/$ObjID"}
            ^OU$        {"api/v2/ous/$ObjID"}
            ^User$      {"api/v2/users/$ObjID"}
            # ADCS
            ^AIACA$        {"api/v2/aiacas/$ObjID"}
            ^CertTemplate$ {"api/v2/certtemplates/$ObjID"}
            ^EnterpriseCA$ {"api/v2/enterprisecas/$ObjID"}
            ^NTAuthStore$  {"api/v2/ntauthstores/$ObjID"}
            ^RootCA$       {"api/v2/rootcas/$ObjID"}
            # AZ
            ^AZ {$lbl = Switch($label){
                    AZBase                  {'az-base'}
                    AZApp                   {'applications'}
                    AZAutomationAccount     {'automation-accounts'}
                    AZContainerRegistry     {'container-registries'}
                    AZFunctionApp           {'function-apps'}
                    AZKeyVault              {'key-vaults'}
                    AZLogicApp              {'logic-apps'}
                    AZManagementGroup       {'management-groups'}
                    AZManagedCluster        {'managed-clusters'}
                    AZResourceGroup         {'resource-groups'}
                    AZServicePrincipal      {'service-principals'}
                    AZVMScaleSet            {'vm-scale-sets'}
                    AZWebApp                {'web-apps'}
                    Default{"$("$label".tolower()-replace"^az")s"}
                    }
                "api/v2/azure/${lbl}?object_id=$($ObjID-replace"/",'%2F')"
                }
            Default{"api/v2/base/$ObjID"}
            }
        $URL += Switch($DynP.value){
            # AD+
            AdminRights                  {'/admin-rights'}
            AdminUsers                   {'/admin-users'}
            Computers                    {'/computers'}
            ConstrainedDelegationRights  {'/constrained-delegation-rights'}
            ConstrainedUsers             {'/constrained-users'}
            Controllables                {'/controllables'}
            Controllers                  {'/controllers'}
            DCOMRights                   {'/dcom-rights'}
            DCOMUsers                    {'/dcom-users'}
            DCSyncers                    {'/dc-syncers'}
            ForeignAdmins                {'/foreign-admins'}
            ForeignGPOControllers        {'/foreign-gpo-contollers'}
            ForeignGroups                {'/foreign-groups'}
            ForeignUsers                 {'/foreign-users'}
            GPOs                         {'/gpos'}
            GroupMemberships             {'/group-memberships'}
            Groups                       {$(if($Label -match '^AZ'){'&related_entity_type=descendent-groups'}else{'/groups'})}
            IndoundTrusts                {'/indbound-trusts'}
            LinkedGPOs                   {'/linked-gpos'}
            Members                      {$(if($Label -match '^AZ'){'&related_entity_type=group-members'}else{'/members'})}
            Memberships                  {'/memberships'}
            OUs                          {'/ous'}
            OutboundTrusts               {'/outboud-trusts'}
            PSRemoteRights               {'/ps-remote-rights'}
            PSRemoteUsers                {'/ps-remote-users'}
            RDPRights                    {'/rdp-rights'}
            RDPUsers                     {'/rdp-users'}
            Sessions                     {'/sessions'}
            SQLAdminRights               {'/sql-admin-rights'}
            SQLAdmins                    {'/sql-admins'}
            TierZero                     {'/tier-zero'}
            Users                        {$(if($Label -match '^AZ'){'&related_entity_type=descendent-users'}else{'/users'})}
            ## AZ
            # Descendents
            AppRegistrations             {'&related_entity_type=descendent-applications'}
            ServicePrincipals            {'&related_entity_type=descendent-service-principals'}
            Devices                      {'&related_entity_type=descendent-devices'}
            ManagementGroups             {'&related_entity_type=descendent-management-groups'}
            Subscriptions                {'&related_entity_type=descendent-subscriptions'}
            ResourceGroups               {'&related_entity_type=descendent-resource-groups'}
            AutomationAccounts           {'&related_entity_type=descendent-automation-accounts'}
            VMs                          {'&related_entity_type=descendent-virtual-machines'}
            ManagedClusters              {'&related_entity_type=descendent-managed-clusters'}
            VMScaleSets                  {'&related_entity_type=descendent-vm-scale-sets'}
            ContainerRegistries          {'&related_entity_type=descendent-container-registries'}
            FunctionApps                 {'&related_entity_type=descendent-function-apps'}
            LogicApps                    {'&related_entity_type=descendent-logic-apps'}
            WebApps                      {'&related_entity_type=descendent-web-apps'}
            KeyVaults                    {'&related_entity_type=descendent-key-vaults'}
            # Other
            InboundControl               {'&related_entity_type=inbound-control'}
            OutboundControl              {'&related_entity_type=outbound-control'}
            ActiveAssignments            {'&related_entity_type=active-assignments'}
            Roles                        {'&related_entity_type=roles'}
            MemberOf                     {'&related_entity_type=group-membership'}
            ExecutionPrivileges          {'&related_entity_type=outbound-execution-privileges'}
            InboundAppRole               {'&related_entity_type=inbound-abusable-app-role-asignments'} # /!\ Not Tested
            OutboundAppRole              {'&related_entity_type=outbound-abusable-app-role-asignments'} # /!\ Not Tested
            LocalAdmins                  {'&related_entity_type=inbound-execution-privileges'} # /!\ Not Tested
            #PimAssignments               {}<------------- /!\ Check
            KeyReaders                   {'&related_entity_type=key-readers'}
            SecretReaders                {'&related_entity_type=secret-readers'}
            CertificateReaders           {'&related_entity_type=certificate-readers'}
            AllReaders                   {'&related_entity_type=all-readers'}
            #Default                      {}
            }
        if($Limit){$URL+=if($URL -match 'azure'){"&limit=$Limit"}else{"?limit=$Limit"}}
        if($PropOnly){$URL+="&counts=false"}
        if($DynP.Value -AND ($AsPath -OR $Cypher)){
            # EdgeList
            # AD
            $ADAttackEdge = (Get-BHPathfilter -ListAll | ? Platform -eq AD).edge
            # AZ
            $AZAttackEdge = (Get-BHPathfilter -ListAll | ? Platform -eq AZ).edge
            $AZExecEdge = 'AZVMAdminLogin',
                'AZVMContributor',
                'AZAvereContributor',
                'AZWebsiteContributor',
                'AZContributor',
                'AZExecuteCommand'
            $AZAppAbuseEdge = 'AZApplicationReadWriteAll',
                'AZAppRoleAssignmentReadWriteAll',
                'AZDirectoryReadWriteAll',
                'AZGroupReadWriteAll',
                'AZGroupMemberReadWriteAll',
                'AZRoleManagementReadWriteDirectory',
                'AZServicePrincipalEndpointReadWriteAll'
            $AZControlEdge=	'AZAvereContributor',
                'AZContributor',
                'AZOwner',
                'AZVMContributor',
                'AZAutomationContributor',
                'AZKeyVaultContributor',
                'AZAddMembers',
                'AZAddSecret',
                'AZExecuteCommand',
                'AZGlobalAdmin',
                'AZGrant',
                'AZGrantSelf',
                'AZPrivilegedRoleAdmin',
                'AZResetPassword',
                'AZUserAccessAdministrator',
                'AZOwns',
                'AZCloudAppAdmin',
                'AZAppAdmin',
                'AZAddOwner',
                'AZManagedIdentity',
                'AZAKSContributor',
                'AZWebsiteContributor',
                'AZLogicAppContributor',
                'AZAZMGAddMember',
                'AZAZMGAddOwner',
                'AZMGAddSecret',
                'AZMGGrantAppRoles',
                'AZMGGrantRole'
            # Query /!\ EXPERIMENTAL FEATURE /!\
            $Query = Switch($DynP.Value){
                AdminRights                  {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|AdminTo*1..]->(x:Computer)"}
                AdminUsers                   {"MATCH p=shortestPath((x:User)-[:MemberOf|AdminTo*1..]->(:$Label{objectid:'$objID'}))"} # Shortest??
                Computers                    {"MATCH p=(:$Label{objectid:'$objID'})-[:Contains*1..]->(x:Computer)"}
                ConstrainedDelegationRights  {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|AllowedToDelegate*1..]->(x:Computer)"}
                ConstrainedUsers             {"MATCH p=(x:Base)-[:MemberOf|AllowedToDelegate*1..]->(:$Label{objectid:'$objID'})"}
                Controllables                {"MATCH p=(:$Label{objectid:'$objID'})-[:$($ADAttackEdge-join'|')*1..]->(x:Base)"}
                Controllers                  {"MATCH p=(x:Base)-[:$($ADAttackEdge-join'|')*1..]->(:$Label{objectid:'$objID'})"}
                DCOMRights                   {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|ExecuteDCOM*1..]->(x:Computer)"}
                DCOMUsers                    {"MATCH p=(x:Base)-[:MemberOf|ExecuteDCOM*1..]->(:$Label{objectid:'$objID'})"}
                DCSyncers                    {"MATCH p=(x:Base)-[:DCSync|SyncLAPSPassword]->(:$Label{objectid:'$ObjID'})"}
                ForeignAdmins                {"MATCH p=shortestPath((x:User)-[:MemberOf|AdminTo*1..]->(y:$Label{objectid:'$objID'})) WHERE x.domain<>y.domain"}
                ForeignGPOControllers        {<#ToDo#>}
                ForeignGroups                {<#ToDo#>}
                ForeignUsers                 {<#ToDo#>}
                GPOs                         {"MATCH p=(:$Label{objectid:'$ObjID'})<-[:GPLink|Contains*1..]-(x:GPO)"}
                GroupMemberships             {"MATCH p=(:$Label{objectid:'$ObjID'})-[:MemberOf*1..]->(x:Group)"}
                Groups                       {if($URL -match 'azure'){"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZGroup)"}
                                                else{"MATCH p=(:$Label{objectid:'$ObjID'})-[:Contains]->(x:Group)"}
                                                }
                IndoundTrusts                {"MATCH p=(:$Label{objectid:'$ObjID'})-[:TrustedBy*1..]->(x:Domain)"}
                LinkedGPOs                   {"MATCH p=(x:GPO)-[:GPLink|Contains*1..]->(:$Label{objectid:'$ObjID'})"}
                Members                      {if($URL -match 'azure'){"MATCH p=(:AZBase)-[:AZMemberOf*1..]->(:$Label{objectid:'$ObjID'})"}
                                                else{"MATCH p=(:Base)-[:MemberOf*1..]->(:$Label{objectid:'$ObjID'})"}
                                                }
                Memberships                  {"MATCH p=(:$Label{objectid:'$ObjID'})-[:MemberOf*1..]->(x:Group)"}
                OUs                          {"MATCH p=(:$Label{objectid:'$ObjID'})-[:Contains*1..]->(x:OU)"}
                OutboundTrusts               {"MATCH p=(x:Domain)-[:TrustedBy*1..]->(:$Label{objectid:'$ObjID'})"}
                PSRemoteRights               {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|CanPSRemote*1..]->(x:Computer)"}
                PSRemoteUsers                {"MATCH p=shortestPath((x:User)-[:MemberOf|CanPSRemote*1..]->(:$Label{objectid:'$objID'}))"}
                RDPRights                    {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|CanRDP*1..]->(x:Computer)"}
                RDPUsers                     {"MATCH p=shortestPath((x:User)-[:MemberOf|CanRDP*1..]->(:$Label{objectid:'$objID'}))"}
                Sessions                     {Switch($Label){
                                                Computer{"MATCH p=(:$Label{objectid:'$ObjID'})-[:HasSession]->(x:User)"}
                                                Default{"MATCH p=(:$Label{objectid:'$ObjID'})-[:MemberOf|HasSession*1..]->(x:User)"} # TEST /!\
                                                }}
                SQLAdminRights               {"MATCH p=(:$Label{objectid:'$objID'})-[:MemberOf|SQLAdmin*1..]->(x:Computer)"}
                SQLAdmins                    {"MATCH p=shortestPath((x:User)-[:MemberOf|SQLDamin*1..]->(:$Label{objectid:'$objID'}))"}
                TierZero                     {"MATCH p=(:$Label{objectid:'$ObjID'})-[:Contains]->(x:Base)`r`nWHERE x.system_tags CONTAINS 'admin_tier_0'"}
                Users                        {if($URL -match 'azure'){"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZUser)"}
                                                else{"MATCH p=(:$Label{objectid:'$ObjID'})-[:Contains*1..]->(x:User)"}
                                                }
                ## AZ - Descendents
                AppRegistrations             {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZApp)"}
                ServicePrincipals            {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZServicePrincipal)"}
                Devices                      {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZDevice)"}
                ManagementGroups             {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZManagementGroup)"}
                Subscriptions                {if($Label -eq 'AZTenant'){"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains]->(x:AZSubscription)"}
                                                else{"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZSubscription)"}}
                ResourceGroups               {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZResourceGroup)"}
                AutomationAccounts           {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZAutomationAccount)"}
                VMs                          {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZVM)"}
                ManagedClusters              {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZManagedCluster)"}
                VMScaleSets                  {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZVMScaleSet)"}
                ContainerRegistries          {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZContainerRegistry)"}
                FunctionApps                 {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZFunctionApp)"}
                LogicApps                    {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZLogicApp)"}
                WebApps                      {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZWebApp)"}
                KeyVaults                    {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZContains*1..]->(x:AZKeyVault)"}
                # AZ - Other
                InboundControl               {"MATCH p=(x:AZBase)-[:AZMemberOf|$($AZControlEdge-join'|')*1..]->(:$Label{objectid:'$objID'})"}
                OutboundControl              {"MATCH p=(:$Label{objectid:'$objID'})-[:AZMemberOf|$($AZControlEdge-join'|')*1..]->(x:AZBase)"}
                ActiveAssignments            {"MATCH (x:AZBase)-[:AZHasRole]->(:$Label{objectid:'$ObjID'})"}# AZMemberOf??
                Roles                        {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZMemberOf|AZHasRole*1..]->(x:AZRole)"}
                MemberOf                     {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZMemberOf*1..]->(x:AZGroup)"}
                ExecutionPrivileges          {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZMemberOf|$($AZExecEdge-join'|')*1..]->(x:AZBase) WHERE NOT x:AZGroup"}
                InboundAppRole               {"MATCH p=(:$Label{objectid:'$ObjID'})-[:AZMemberOf|$($AZAppAbuseEdge-join'|')*1..]->(x:AZBase)"}
                OutboundAppRole              {"MATCH p=(x:AZBase)-[:$($AZAppAbuseEdge-join'|')*1..]->(:$Label{objectid:'$ObjID'})"}
                LocalAdmins                  {"MATCH (x:AZBase)-[:AZMemberOf|$($AZExecEdge-join'|')*1..]->(:$Label{objectid:'$ObjID'})"}
                #PimAssignments              {}
                KeyReaders                   {"MATCH p=(x:AZBase)-[:AZMemberOf|AZOwner|AZContributor|AZGetKeys*1..]->(:$Label{objectid:'$ObjID'})"}
                SecretReaders                {"MATCH p=(x:AZBase)-[:AZMemberOf|AZGetSecrets*1..]->(:$Label{objectid:'$ObjID'})"}
                CertificateReaders           {"MATCH p=(x:AZBase)-[:AZMemberOf|AZGetCertificates*1..]->(:$Label{objectid:'$ObjID'})"}
                AllReaders                   {"MATCH p=(x:AZBase)-[:AZMemberOf|AZGetKeys|AZGetSecrets|AZGetCertificates*1..]->(:$Label{objectid:'$ObjID'})"}
                #Default                     {}
                }
            #$Query = (Get-BHPath -SourceId $SrcID -TargetID $TgtID -Edge $Fltr -limit $($null) -orderby "LENGTH(p)"-Cypher).trim()
            #$Obj = if($Cypher){if(($BHSession|? x|Select -last 1).CypherClip){$Query| Set-Clipboard};RETURN $Query}else{
            #    #Get-BHPath $Query #-SessionID $SessID
            #    $Query
            #    }
            $Query+=if($AsPath){"`r`nRETURN p"}else{"`r`nRETURN x"}
            if($Limit){$Query = "$Query`r`nLIMIT $Limit"}
            $Obj = BHPath -Query $Query -Cypher:$Cypher
            }
        else{$Obj=if($Cypher){"MATCH (x:$Label{objectid:'$ObjID'}) RETURN x"}else{Invoke-BHAPI $URL -expand $Expand -SessionID $SessID}
            }
        if($Obj){if($DynP.IsSet){if($Obj.props -AND $Obj.kind -AND $PropOnly){$Obj.props}else{$Obj}}else{if($Cypher){$Obj}else{Format-BHNode $Obj -PropOnly:$PropOnly}}}
        }}}
    End{}
    }
