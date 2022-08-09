/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class RecordAccess {
	public SA_Audit__Test_Object__c dummycontact { get; set; }
	public Id currentId { get; set; }
	public List<Sobject> shrObjList { get; set;}
	public transient List<Group> groupList { get; set;}
	public String access { get; set; }
	public String access1 { get; set; }
	public String sObjName { get; set; }
	public String sObjLabel { get; set; }
	public Boolean noSharing {get; set; }
	public Sobject sObj { get; set; }
	public Boolean owdRW { get; set; }
	public Boolean noError { get; set; }
	public User user { get; set; }
	public User selectedUserRecord { get; set; }
	public Sobject userTerritory { get; set; }
	public Boolean noTerritory2 { get; set; }
	public Boolean noTerritory { get; set; }
	public String enabledTerritory { get; set; }
	public Boolean enableTerritory { get; set; }
	public Boolean enableEnterpriseTerritory { get; set; }
	public transient Map<Id, String> objTer2IdMap { get; set; }
	public transient Map<Id, Sobject> userTerrMap { get; set; }
	public transient List<Sobject> territoryList { get; set; }
	public transient List<Territory2Wrapper> territory2WrapperList { get; set; }
	public transient List<TerritoryWrapper> territoryWrapperList { get; set; }
	public Id profileId { get; set; }
	public String profileName { get; set; }
	public transient Map<PermissionSet, ObjectPermissions> permissionSetMap { get; set; }
	public SObject organization { get; set; }
	public String fieldOrg { get; set; }
	public Boolean prSet { get; set; }
	public transient Set<UserRole> userRoleSet { get; set; }
	public UserRole currentUserRole { get; set; }
	public transient List<RecordType> recTypeList { get; set; }
	public String existRT { get; set; }
	public Boolean noUserRole { get; set; }
	public Boolean isGroupShr { get; set; }
	public transient Map<Id, SObject> shrGroupMap { get; set; }
	public transient Map<Id, User> userMap { get; set; }
	public transient Map<ID, UserRole> userRoleMap { get; set; }
	public transient Map<User, List<UserRole>> userSharingRoleMap { get; set; }
	public Boolean noSharingRole { get; set; }
	public PermissionSet userPermission { get; set; }
	public ObjectPermissions objPermission { get; set; }
	public transient List<PermissionSet> permisionSetList { get; set; }
	public Boolean isCustom { get; set; }
	public String sharingCriteriaRule { get; set; }
	public transient Map<Group, List<UserRole>> roleGroupMap { get; set; }
	public transient Map<Group, List<UserRole>> roleAndSubordinatesGroupMap { get; set; }
	public transient Map<Group, List<UserRole>> roleGroupSharingMap { get; set; }
	public transient Map<Group, User> userGroupSharingMap { get; set; }
	public Boolean isRolePublicGroupShare { get; set; }
	public Boolean isRoleGroupShare { get; set; }
	public Boolean isRoleSubordinatesGroupShare { get; set; }
	public String customShr { get; set; }
	public transient Map<String, String> sharingCriteriaRuleMap { get; set; }
	public transient List<String> recordTypeList { get; set; }
	
	public Boolean isExpandOrg { get; set; }
	public Boolean isExpandProf { get; set; }
	public Boolean isExpandPerm { get; set; }
	public Boolean isExpandRole { get; set; }
	public Boolean isExpandTerritory { get; set; }
	public Boolean isExpandSharing { get; set; }
	public Boolean isExpandGroupSharing { get; set; }
	public Boolean isExpandRecordType { get; set; }
	public Boolean pushGo { get; set; }
	public String isPdf { get; set; }
	public String userPDFID { get; set; }
	public String exportUser { get; set; }
	public static List<String> userNameList { get; set; }
	public String selectedUser { get; set; }
	
	@RemoteAction
	public static List<String> getUser(String userName) {
		if(userName.length() > 0) {
			userName = '%' + userName + '%';
			////system.debug('userName::' + userName);
			List<User> userList = [SELECT ID, Name, UserType, Profile.Name, UserRoleId  FROM User WHERE isActive = true AND Name LIKE :userName LIMIT 100];
			userNameList = new List<String>();
			
            if(userList.size()>0){
                for(User u : userList) {
				userNameList.add(u.Name);
                } 
            }
			return userNameList;
		} else {
			List<User> userList = [SELECT ID, Name, UserType, Profile.Name, UserRoleId  FROM User WHERE isActive = true AND Name LIKE :userName LIMIT 100];
			userNameList = new List<String>();
			for(User u : userList) {
				userNameList.add(u.Name);
			}
			return userNameList;
		}
	}
	
	
	public recordAccess() {
		sharingCriteriaRuleMap = new Map<String, String>();
		isPdf = ApexPages.currentPage().getParameters().get('isPdf');
		
		if (isPdf != 'true') {

			
			dummycontact = new SA_Audit__Test_Object__c(UserId__c = UserInfo.getUserId());
			//dummycontact = [SELECT ID, UserId__c FROM Test_Object__c where UserId__c != null LIMIT 1];
			//user = new User(FirstName = dummycontact.Owner.FirstName, LastName = dummycontact.Owner.LastName );
			//user = [SELECT ID, Name, UserType, Profile.Name, UserRoleId  FROM User WHERE Id =:dummycontact.UserId__c];
			/*List<User> userList = [SELECT ID, Name, UserType, Profile.Name, UserRoleId  FROM User WHERE isActive = true LIMIT 100];
			userNameList = new List<String>();
			user = new User();
			for(User u : userList) {
				userNameList.add( u.Name);
				if(u.Id == currentUserId) {
					user = u;
					//selectedUser = u.Name;
				}
			}*/
			pushGo = false;
		} else {
			exportUser = UserInfo.getName() != null ? UserInfo.getName() : '';
			userPDFID = ApexPages.currentPage().getParameters().get('userPDFID');
			currentId = (ID)ApexPages.currentPage().getParameters().get('currentId');
			go();
		}
		////system.debug('selectedUser:::' + selectedUser);
		////system.debug('userId:::' + selectedUserRecord.Id);
		////system.debug('userName:::' + selectedUserRecord.Name);
		
	}
	
	public PageReference redirectToWelcomeMetadataPage() {
		PageReference pageRef = Page.WelcomeMetadataPage;
		pageRef.getParameters().put('retPage', 'RecordAccess');
		pageRef.setRedirect(true);
		return pageRef;
	}
	public PageReference openContactUSLink(){
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/contact/');
        return pageRef;
    }

	public PageReference openHelpTraining(){
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/security-access-manager-help-training/');
        return pageRef;
    }

	public PageReference openReleaseNotes(){
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/security-access-manager-release-notes/');
        return pageRef;
    }
	
	public PageReference Go() {
		sharingCriteriaRuleMap = new Map<String, String>();
		//selectedUser = selectedUserRecord.Id;
		////system.debug('selectedUser:::' + selectedUser);
		////system.debug('userId:::' + selectedUserRecord.Id);
		////system.debug('userName:::' + selectedUserRecord.Name);
		pushGo = true;
		////system.debug('conection' + RollupService.checkMetadataAPIConnection());
		if(!RollupService.checkMetadataAPIConnection()) {
			return redirectToWelcomeMetadataPage();
		} else {
			/*if(!Schema.getGlobalDescribe().get('User').getDescribe().isAccessible()) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don\'t have access on User object');
				ApexPages.addMessage(myMsg);
				return null;
			}*/
			//if(Schema.getGlobalDescribe().get('User').getDescribe().isAccessible()) {
				if(isPdf == 'true') {
					user = [SELECT Name, UserRoleId, Profile.Name, Profile.USERLICENSE.Name FROM User WHERE Id = :userPDFID];
					//user = userMap.get((ID)userPDFID);
				} else {
				Id currentUserId = dummycontact.UserId__c;
				user = [SELECT ID, Name, UserRoleId, Profile.Name, Profile.USERLICENSE.Name FROM User WHERE Id = :currentUserId];
				}
			//}
			
			system.debug('$$user::' + user);
			if(user.Profile.USERLICENSE.Name.contains('Salesforce')) {
				userMap = new Map<Id, User>([SELECT Name, UserRoleId, Profile.Name FROM User WHERE IsActive = true AND Profile.USERLICENSE.Name LIKE '%Salesforce%']);
			} else {
				userMap = new Map<Id, User>([SELECT Name, UserRoleId, Profile.Name FROM User WHERE IsActive = true AND (NOT Profile.USERLICENSE.Name LIKE '%Salesforce%')]);
			}
			system.debug('$$userMap.keyae::' + userMap.keyset().size());
			/*Set<Id> userTempIdSet = new Set<Id>();
			userTempIdSet.addAll(userMap.KeySet());
			List<User> userTempList = new List<User>();
			userTempList = [SELECT Name, UserRoleId, Profile.Name FROM User WHERE IsActive = true AND Id Not IN :userTempIdSet AND Profile.USERLICENSE.Name LIKE '%Salesforce%'];
			for(User u : userTempList) {
				userMap.put(u.Id, u);
			}
			userTempList = new List<User>();*/
			userRoleMap = new Map<ID, UserRole>([SELECT Id, Name, DeveloperName, ParentRoleId  FROM UserRole WHERE PortalType = 'None' OR PortalType = 'CustomerPortal' OR PortalType = 'Partner']);
			//system.debug('userRoleMap::' + userRoleMap);
			isExpandOrg = true;
			isExpandProf = true;
			isExpandPerm = true;
			isExpandRole = true;
			isExpandTerritory = true;
			isExpandSharing = true;
			isExpandGroupSharing = true;
			isExpandRecordType = true;
			owdRW = false;
			noError = true;
			
			if(currentId != null) {
				try {
					sObjLabel = currentId.getSObjectType().getDescribe().getLabel();
					sObjName = currentId.getSObjectType().getDescribe().getName();
					////system.debug('sObjName::' + sObjName);
					//check if the currentId is in our org
					String query1;
					/*if(!Schema.getGlobalDescribe().get(sObjName).getDescribe().isAccessible()) {
						ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to ' + sObjName);
						ApexPages.addMessage(myMsg);
						noError = false;
						return null;
					}*/
					
					if(sObjName == 'Case') {
						query1 = 'SELECT Id, CaseNumber, OwnerId FROM ' + sObjName + ' WHERE ID = :currentId';
					} else {
						query1 = 'SELECT Id, Name FROM ' + sObjName + ' WHERE ID = :currentId';
					}
					////system.debug('String.escapeSingleQuotes(query1::' + String.escapeSingleQuotes(query1));
					sObj = Database.query(String.escapeSingleQuotes(query1));
					////system.debug('sObj::' + sObj);
					
				} catch(Exception e) {
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter a valid record ID.');
					ApexPages.addMessage(myMsg);
					noError = false;
				}
				if(noError) {
					SharringSetting();
					territoryManagement();
					profile();
					permissionSetAssigned();
					if(user.Profile.USERLICENSE.Name.contains('Salesforce')) RecordTypeAssigned();
				}
			} else {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Please enter record ID.');
					ApexPages.addMessage(myMsg);
					noError = false;
			}
		}
		////system.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
		userMap = new Map<Id, User>();
		return null;
	}
	
	public void SharringSetting() {
        system.debug('testing line 266');
		fieldOrg = '';
		isGroupShr = false;
		noSharing = false;
		
		isCustom = false;
		try {
            system.debug('testing line 273');
			String query2;
			/*if(!Schema.getGlobalDescribe().get('Organization').getDescribe().isAccessible()) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to Organization object');
				ApexPages.addMessage(myMsg);
				return;
			}*/
			if (!sObjName.contains('__c')) {
                system.debug('testing line 280');
				fieldOrg = 'Default' + sObjName + 'Access';
				if(SecurityUtil.getFieldDescribeMap('Organization').containsKey(fieldOrg.toLowerCase())) {
					query2 = 'SELECT Id, IsSandbox, Name, OrganizationType, PrimaryContact, ' + fieldOrg + ' FROM Organization';
				} else {
                    system.debug('testing line 286');
					query2 = 'SELECT Id, IsSandbox, Name, OrganizationType, PrimaryContact FROM Organization';
					fieldOrg ='';
				}
				organization = Database.query(query2);
                system.debug('testing line 291');
				////system.debug('query2:;' + query2);
				////system.debug('organization:;' + organization);
			} else {
                system.debug('testing line 295');
				query2 = 'SELECT Id, IsSandbox, Name, OrganizationType, PrimaryContact FROM Organization';
				organization = Database.query(query2);
				////system.debug('query2:;' + query2);
				////system.debug('organization:;' + organization);
				isCustom = true;
				fieldOrg = 'Default' + sObjLabel + 'Access';
			}
			
			//buil the query for the MyObject__Share
			String query;
			String pId;
			String ShareObject;
			if(query == null) {
				query = 'SELECT ';
			} else {
				query += ' ';
			}
			
			if (sObjName.contains('__c')) {
	
					String objName = sObjName.removeEnd('c');
					access = 'AccessLevel';
					pId = 'ParentId';
					ShareObject = objName + 'Share';
			} else {
					ShareObject = sObjName + 'Share';
					access = sObjName + 'AccessLevel';
					pId = sObjName + 'Id';
			}
			access1 = sObjLabel + ' Access Level';
			//check if the our organization has Sharing for the Object
			Map<String, Schema.SObjectType> tokens = Schema.getGlobalDescribe();
			/*if(!Schema.getGlobalDescribe().get(ShareObject).getDescribe().isAccessible()) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to' + ShareObject + ' object');
				ApexPages.addMessage(myMsg);
				return;
			}*/
			if(tokens.containsKey(ShareObject)) {
				
				tokens = null;
				query += access + ', RowCause, UserOrGroupId FROM '+ ShareObject + ' WHERE ' + pId + ' = :currentId';
				system.debug('testing line -query:;;' + query);
				List<SObject> shrList;
				shrList = Database.query(query);
				shrObjList = new List<SObject>();
				shrGroupMap = new Map<Id, SObject>();
				////system.debug('user.Id::' + user.Id);
				for(SObject shr : shrList) {
                    system.debug('testing line shr--'+ shr);
					if(shr.get('UserOrGroupId') == user.Id) {
						shrObjList.add(shr);
                           system.debug('testing line shrObjList--'+ shrObjList);
					} else {
						shrGroupMap.put((Id)shr.get('UserOrGroupId'), shr);
                          system.debug('testing line shrObjList--'+ shrObjList);
					}
				}
				system.debug('testing line shrObjList:;;' + shrObjList);
				if(shrObjList.size() == 0) {
					owdRW = true;
				}
				system.debug('testing shrGroupMap::' + shrGroupMap);
				if(shrGroupMap.KeySet().size() > 0) {
					GroupAsigned(shrGroupMap);
                    system.debug('testing line--GroupAsigned '+ ''+'--'+shrGroupMap);
					sharingHierarchyRole(shrGroupMap);
				}
			} else {
				owdRW = true;
			}
		} catch(Exception e) {
		   system.debug('testingline exception::' + e);
			noSharing = true;
		}
		try{
			readSharingRule(sObjName); 
		} catch(Exception e) {
		system.debug('testing line exception SharingRule::' + e);
		}
		if(isCustom){
			try{
				readCustomObject(sObjName); 
			} catch(Exception e) {
				system.debug('exception::' + e);
			}
		}
	}
	
	
	public void territoryManagement() {
        system.debug('testing line 382');
		noTerritory2 = false;
		noTerritory = false;
		enableTerritory = false;
		enableEnterpriseTerritory = false;
		enabledTerritory = '';
		//check for Territory Management for Account
		/*if(Schema.getGlobalDescribe().get('Territory2') != null && !Schema.getGlobalDescribe().get('Territory2').getDescribe().isAccessible()) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to Territory2 object');
			ApexPages.addMessage(myMsg);
			return;
		}
		if(Schema.getGlobalDescribe().get('Territory') != null && !Schema.getGlobalDescribe().get('Territory').getDescribe().isAccessible()) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to Territory object');
			ApexPages.addMessage(myMsg);
			return;
		}*/
		if(sObjName == 'Account' || sObjName == 'Opportunity') {
			String query;
			//check if it is enabled Enterprise Territory Management
			try {
                system.debug('testing line 402');
				Map<Id, Set<Id>> userTerr2Map = new Map<Id, Set<Id>>();
				Map<Id, Set<Id>> terr2UserMap = new Map<Id, Set<Id>>();
				query = 'SELECT RoleInTerritory2, UserId, Territory2Id FROM UserTerritory2Association';
				system.debug ('query;;' + query);
				List<Sobject> userTerList;
				userTerList = Database.query(query);
				for(Sobject userTerr : userTerList) {
					if(!userTerr2Map.KeySet().contains((Id)userTerr.get('UserId'))) {
						userTerr2Map.put((Id)userTerr.get('UserId'), new Set<Id>());
					}
					userTerr2Map.get((Id)userTerr.get('UserId')).add((Id)userTerr.get('Territory2Id'));
					if(!terr2UserMap.KeySet().contains((Id)userTerr.get('Territory2Id'))) {
						terr2UserMap.put((Id)userTerr.get('Territory2Id'), new Set<Id>());
					}
					terr2UserMap.get((Id)userTerr.get('Territory2Id')).add((Id)userTerr.get('UserId'));
				}
				system.debug('terr2UserMap::' + terr2UserMap);
				////system.debug('userTerr2Map::' + userTerr2Map);
				List<Sobject> objTer2List = new List<Sobject>();
				String AssociationCause;
				objTer2IdMap = new Map<Id, String>();
				Set<Id> objTer2IdSet = new Set<Id>();
				if(sObjName == 'Account') {
					query = 'SELECT id, AssociationCause, ObjectId, SobjectType, Territory2Id FROM ObjectTerritory2Association WHERE ObjectId = :currentId';
					objTer2List = Database.query(query);
				} else {
					Set<Id> groupIdSet = new Set<Id>();
					for(Id userOrGroupID : shrGroupMap.KeySet()) {
						if(shrGroupMap.get(userOrGroupID).get('RowCause') == 'Territory2Forecast' || shrGroupMap.get(userOrGroupID).get('RowCause') == 'ImplicitChild' ) {
							groupIdSet.add(userOrGroupID);
						}
					}
					query = 'SELECT id, DeveloperName, Name, RelatedId, Type FROM Group WHERE ID IN :groupIdSet';
					system.debug('queryGroup ::' + query);
					List<Sobject> groupList;
					groupList = Database.query(query);
					system.debug('groupList ::' + groupList);
					for(SObject gr : groupList) {
						if(gr.get('Type') == 'Territory') {
							objTer2IdSet.add((Id)gr.get('RelatedId'));
							objTer2IdMap.put((ID)gr.get('RelatedId'), (String)shrGroupMap.get(gr.Id).get('RowCause'));
						}
					}
					system.debug('objTer2IdSet ::' + objTer2IdSet);
					system.debug('objTer2IdSet.size() ::' + objTer2IdSet.size());
				}
				
				if(objTer2List.size() > 0 || objTer2IdSet.size() > 0) {
					system.debug('objTer2List.size()::' + objTer2List.size());
					if(objTer2List.size() > 0) {
						////system.debug('objTer2List::' + objTer2List);
						for (Sobject objTer2 : objTer2List) {
							AssociationCause = (String)objTer2.get('AssociationCause');
							objTer2IdMap.put((Id)objTer2.get('Territory2Id'), AssociationCause.substring(10));
							objTer2IdSet.add((Id)objTer2.get('Territory2Id'));
						}
					}
					query = 'SELECT Name, ParentTerritory2Id, AccountAccessLevel, CaseAccessLevel, ContactAccessLevel, Description, OpportunityAccessLevel FROM Territory2';
				system.debug('objTer2IdMap::' + objTer2IdMap);
					Map<Id, Sobject> territory2IdMap = new Map<Id, Sobject>(Database.query(query));
					system.debug('territory2IdMap::' + territory2IdMap);
					List<SObject> terList;
					Id currentTerParentID;
					Boolean existParentTer2;
					UserRole currUserRole = new UserRole();
					territory2WrapperList = new List<Territory2Wrapper>();
					system.debug('objTer2IdSet::' + objTer2IdSet);
					for(Id objTer2Id : objTer2IdSet) {
						existParentTer2 = false;
						Boolean isRoleTerritory;
						system.debug('userTerr2Map.get(user.Id)::' + userTerr2Map.get(user.Id));
						if (!userTerr2Map.containsKey(user.id) || !userTerr2Map.get(user.Id).contains(objTer2Id)) {
							terList = new List<Sobject>();
							terList.add(territory2IdMap.get(objTer2Id));
							currentTerParentID = (ID)territory2IdMap.get(objTer2Id).get('ParentTerritory2Id');
							system.debug('currentTerParentID::' + currentTerParentID);
							while (currentTerParentID != null) {
								terList.add(territory2IdMap.get(currentTerParentID));
								if(userTerr2Map.keySet().contains(user.id) && userTerr2Map.get(user.Id).contains(currentTerParentID)) {
									currentTerParentID = null;
									existParentTer2 = true;
								} else {
									currentTerParentID = (Id)territory2IdMap.get(currentTerParentID).get('ParentTerritory2Id');
								}
							}
							List<SObject> terRoleList = new List<SObject>();
							system.debug('terList::' + terList);
							isRoleTerritory = false;
							for (SObject ter2 : terList) {
								if(!isRoleTerritory) {
									terRoleList.add(ter2);
								}
							//check if in the territory exist user who has current user above in Role Hierarchy
								system.debug('terr2UserMap.get((Id)ter2.get(Id))::' + terr2UserMap.get((Id)ter2.get('Id')));
								if(terr2UserMap.get((Id)ter2.get('Id')) != null) {
									for (ID userId : terr2UserMap.get((Id)ter2.get('Id'))){
										if(!isRoleTerritory) {
											Id currentParentRoleId;
											
											currUserRole = userRoleMap.get(userMap.get(userId).UserRoleId);
											////system.debug('currUserRole;;' + currUserRole);
											if (currUserRole != null) {
												currentParentRoleId = currUserRole.ParentRoleId;
												userRoleSet = new Set<UserRole>();
												////system.debug('currentParentRoleId::;' + currentParentRoleId);
												while (currentParentRoleId != null) {
													userRoleSet.add(userRoleMap.get(currentParentRoleId));
													////system.debug('userMap.get(user.Id).UserRoleId::;' + userMap.get(user.Id).UserRoleId);
													if(currentParentRoleId == userMap.get(user.Id).UserRoleId) {
														currentParentRoleId = null;
														isRoleTerritory = true;
													} else {
														currentParentRoleId = userRoleMap.get(currentParentRoleId).ParentRoleId;
													}
												}
												//system.debug('userRoleSet::' + userRoleSet);
											}
										}
									}
								}
							}
							//system.debug('terRoleList::' + terRoleList);
							//system.debug('isRoleTerritory::' + isRoleTerritory);
							if(existParentTer2) {
								territory2WrapperList.add(new Territory2Wrapper(territory2IdMap.get(objTer2Id), terList, existParentTer2));
							}
							if(isRoleTerritory) {
								User userTerritory;
								for(Id userID : userMap.KeySet()) {
									if(userMap.get(userId).UserRoleId == currUserRole.Id) {
										userTerritory = userMap.get(userId);
										break;
									}
								}
								territory2WrapperList.add(new Territory2Wrapper(territory2IdMap.get(objTer2Id), terRoleList, true, userRoleSet, isRoleTerritory, userTerritory));
							} 
							
						} else {
							territory2WrapperList.add(new Territory2Wrapper(territory2IdMap.get(objTer2Id),  existParentTer2));
						}
					}
					system.debug ('territory2WrapperList;;' + territory2WrapperList);
					if (territory2WrapperList.size() > 0) {
						enableEnterpriseTerritory = True;
					} else {
						noTerritory2 = true;
					}
				}else {
					noTerritory2 = true;
				}
			} catch (Exception e) {
				system.debug('Eroare territory2::' + e);
				noTerritory2 = true;
			}
			//check if it is enabled Territory Management
			try {
				List<Sobject> accShrList;
				if(sObjName == 'Account') {
					query = 'SELECT  Id, UserOrGroupId, AccountId, RowCause FROM AccountShare WHERE AccountId = :currentId';
					query += ' AND RowCause IN (\'Territory\', \'TerritoryManual\', \'TerritoryRule\', \'Rule\')';
				} else {
					query = 'SELECT  Id, UserOrGroupId, OpportunityId, RowCause FROM OpportunityShare WHERE OpportunityId = :currentId';
				}
				
				accShrList = Database.query(query);
				system.debug('testing line-accShrList::' + accShrList);
				//check if the account is assigned to a territory
				if (accShrList.size() > 0){
					List<Sobject> userTerritoryList;
					//Id usrId = user.Id;
					query = 'SELECT TerritoryId, UserId FROM UserTerritory';
					system.debug ('testing line--query;;' + query);
					userTerritoryList = Database.query(query);
					Set<Id> userTerrIdSet = new Set<Id>();
					Map<Id, Set<Id>> terrUserMap = new Map<Id, Set<Id>>(); 
					for(Sobject userTerritory : userTerritoryList) {
						if(userTerritory.get('UserId') == user.Id) {
							userTerrIdSet.add((Id)userTerritory.get('TerritoryId'));
						}
						if(!terrUserMap.KeySet().contains((Id)userTerritory.get('TerritoryId'))) {
							terrUserMap.put((Id)userTerritory.get('TerritoryId'), new Set<Id>());
						}
						terrUserMap.get((Id)userTerritory.get('TerritoryId')).add((Id)userTerritory.get('UserId'));
					}
					system.debug('testing line-userTerrIdSet::' + userTerrIdSet);
					//check if the user is assigned to a territory
					if(userTerrIdSet.size() > 0) {
                        system.debug('testing line 591');
						objTer2IdMap = new Map<Id, String>();
						Set<Id> groupIdSet = new Set<Id>();
						for (Sobject accShr : accShrList) {
							groupIdSet.add((ID)accShr.get('UserOrGroupId'));
							objTer2IdMap.put((ID)accShr.get('UserOrGroupId'), (String)accShr.get('RowCause'));
						}
						query = 'SELECT Id, RelatedId FROM Group WHERE Id IN :groupIdSet AND Type = \'Territory\'';
						List<Sobject> groupList;
						system.debug('testing line ');
                        system.debug ('query;;' + query);
						groupList = Database.query(query);
						Set<Id> terIdSet = new Set<Id>();
						for (Sobject Gr : groupList) {
							terIdSet.add((ID)gr.get('RelatedId'));
						}
						
						query = 'SELECT ID, Name, ParentTerritoryId, AccountAccessLevel, OpportunityAccessLevel, CaseAccessLevel, ContactAccessLevel From Territory';
						Map<Id, Sobject> territoryIdMap = new Map<Id, Sobject>(Database.query(query));
						//system.debug('territoryIdMap::' + territoryIdMap);
						List<Sobject> terList;
						Id currentTerParentID;
						Boolean existParentTer;
						UserRole currUserRole = new UserRole();
						territoryWrapperList = new List<TerritoryWrapper>();
						for(Id terId : terIdSet) {
							existParentTer = false;
							if (!userTerrIdSet.contains(terId)) {
								terList = new List<Sobject>();
								terList.add(territoryIdMap.get(terId));
								currentTerParentID = (ID)territoryIdMap.get(terId).get('ParentTerritoryId');
								while (currentTerParentID != null) {
									terList.add(territoryIdMap.get(currentTerParentID));
									if(userTerrIdSet.contains(currentTerParentID)) {
										currentTerParentID = null;
										existParentTer = true;
									} else {
										currentTerParentID = (Id)territoryIdMap.get(currentTerParentID).get('ParentTerritoryId');
									}
								}
								
								//system.debug('terList::' + terList);
								Boolean isRoleTerritory;
								isRoleTerritory = false;
								List<SObject> terRoleList = new List<SObject>();
								for (SObject ter : terList) {
									if(!isRoleTerritory) {
										terRoleList.add(ter);
									}
									//check if in the territory exist user who has current user above in Role Hierarchy
									//system.debug('terrUserMap.get((Id)ter.get(Id))::' + terrUserMap.get((Id)ter.get('Id')));
									if(terrUserMap.get((Id)ter.get('Id')) != null) {
										for (ID userId : terrUserMap.get((Id)ter.get('Id'))){
											if(!isRoleTerritory && userMap.get(userId) != null) {
												Id currentParentRoleId;
												currUserRole = userRoleMap.get(userMap.get(userId).UserRoleId);
												//system.debug('currUserRole;;' + currUserRole);
												if (currUserRole != null) {
													currentParentRoleId = currUserRole.ParentRoleId;
													userRoleSet = new Set<UserRole>();
													//system.debug('currentParentRoleId::;' + currentParentRoleId);
													while (currentParentRoleId != null) {
														userRoleSet.add(userRoleMap.get(currentParentRoleId));
														//system.debug('userMap.get(user.Id).UserRoleId::;' + userMap.get(user.Id).UserRoleId);
														if(currentParentRoleId == userMap.get(user.Id).UserRoleId) {
															currentParentRoleId = null;
															isRoleTerritory = true;
														} else {
															currentParentRoleId = userRoleMap.get(currentParentRoleId).ParentRoleId;
														}
													}
													//system.debug('userRoleSet::' + userRoleSet);
												}
											}
										}
									}
								}
								//system.debug('terRoleList::' + terRoleList);
								if(existParentTer) {
									territoryWrapperList.add(new TerritoryWrapper(territoryIdMap.get(terId), terList, existParentTer));
								}else {
									if(isRoleTerritory) {
										User userTerritory;
										for(Id userID : userMap.KeySet()) {
											if(userMap.get(userId).UserRoleId == currUserRole.Id) {
												userTerritory = userMap.get(userId);
												break;
											}
										}
										territoryWrapperList.add(new TerritoryWrapper(territoryIdMap.get(TerId), terRoleList, true, userRoleSet, isRoleTerritory, userTerritory));
									} 
								}
							} else {
								territoryWrapperList.add(new TerritoryWrapper(territoryIdMap.get(terId),  existParentTer));
							}
						}
						//system.debug('territoryWrapperList::' + territoryWrapperList);
						if (territoryWrapperList.size() > 0) {
							enableTerritory = True;
						} else {
							noTerritory = true;
						}
					}
				}else {
					noTerritory = true;
				}
			} catch (Exception e) {
				//system.debug('Eroare territory::' + e);
				noTerritory = true;
			}
			
			if (noTerritory2 && noTerritory) {
				if(sObjName != 'Case') {
					enabledTerritory = ' The ' + sObj.get('Name') + ' Account has no assignament in Territory Management for this user';
				}
			}
		} 
	}
	
	public void Profile () {
        system.debug('testing line 711');
        
		profileName = user.Profile.Name;
		//system.debug('ProfileName::' + user.Profile.Name);
		/*if(!Schema.getGlobalDescribe().get('Profile').getDescribe().isAccessible() || 
		   !Schema.getGlobalDescribe().get('PermissionSet').getDescribe().isAccessible() ||
		   !Schema.getGlobalDescribe().get('ObjectPermissions').getDescribe().isAccessible()) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to Profile object');
				ApexPages.addMessage(myMsg);
				return;
			}*/
		userPermission = [SELECT Id, Name, PermissionsModifyAllData, Profile.Name 
							FROM PermissionSet where IsOwnedByProfile = true AND Profile.Name = :ProfileName];
		List<ObjectPermissions> objPermissionList = [SELECT Id, SobjectType, PermissionsRead, PermissionsEdit, PermissionsCreate, PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords 
							FROM ObjectPermissions WHERE SobjectType = :sObjName AND ParentId = :userPermission.Id];
		for(ObjectPermissions op : objPermissionList) {
			if(!((string)op.Id).startsWith('000')) {
				objPermission = op;
			}
		}
		//system.debug('userPermission::' + userPermission);
	}
	
	public void permissionSetAssigned() {
        system.debug('testing line 735');
		prSet = false;
		/*if(!Schema.getGlobalDescribe().get('PermissionSetAssignment').getDescribe().isAccessible()) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to PermissionSetAssignment object');
			ApexPages.addMessage(myMsg);
			return;
		}*/
		List<PermissionSetAssignment> permSetAssignList = new List<PermissionSetAssignment>();
		permSetAssignList = [SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :user.Id];
		Set<Id> idSet = new Set<Id>();
		for(PermissionSetAssignment permAssign : permSetAssignList) {
			idSet.add(permAssign.PermissionSetId);
		}
		//system.debug('permSetAssignList::' + permSetAssignList);
		permisionSetList = [SELECT Id, Name, Label, PermissionsModifyAllData, Profile.Name, 
							(SELECT Id, SobjectType, PermissionsRead, PermissionsEdit, PermissionsCreate, PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords from Objectperms where SobjectType = :sObjName) 
							FROM PermissionSet where IsOwnedByProfile = false AND Id IN :idSet];
		////system.debug('permisionSetList1::' + permisionSetList[0].Objectperms);
		permissionSetMap = new Map<PermissionSet, ObjectPermissions>();
		for (PermissionSet permSet : permisionSetList) {
			for (ObjectPermissions objPerm : permSet.ObjectPerms) {
				if(!((string)objPerm.Id).startsWith('000')) {
					permissionSetMap.put(permSet, objPerm);
					prSet = true;
				}
			}
		}
		permisionSetList = new List<PermissionSet>();
	}
	
	public void RecordTypeAssigned () {
		existRT = 'Record Type : ';
		/*List<String> names = new List<String>();
		List<Id> recTypeIds = new List<Id>();
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
		Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(sObjName);
		
		List<RecordTypeInfo> infos = SObjectTypeObj.getDescribe().getRecordTypeInfos();
		//system.debug('infos::' + infos);
		recTypeList = new List<RecordType>();
		if (infos.size() > 1) {
			for (RecordTypeInfo i : infos) {
				if (i.isAvailable() && !String.valueOf(i.getRecordTypeId()).endsWith('AAA')){
					names.add(i.getName());
				}else {
					names.add(infos[0].getName());
				}
			}
			recTypeList = [select Id,  Name, DeveloperName, BusinessProcessId from RecordType where Name IN :names];
		}
		//recTypeList = [SELECT Name, DeveloperName, BusinessProcessId  FROM RecordType WHERE SobjectType = :sObjName];
		//system.debug('recTypeList::' + recTypeList);
		if(recTypeList.size() == 0) {
			existRT = 'No Record Type';
		}*/
		recordTypeList = new List<String>();
		try {
			readProfileObject(profileName);
			/*if(!Schema.getGlobalDescribe().get('RecordType').getDescribe().isAccessible()) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to RecordType object');
				ApexPages.addMessage(myMsg);
				return;
			}*/
			List<RecordType> rTList = [SELECT Name, DeveloperName, BusinessProcessId  FROM RecordType WHERE sObjectType = :sObjName];
			//system.debug('rTList::' + rTList);
			recTypeList = new List<RecordType>();
			for(RecordType rt : rTList) {
				for(String rTName : recordTypeList) {
					if(rTName.contains(rt.DeveloperName)) {
						recTypeList.add(rt);
					}
				}
			}
			//system.debug('recTypeList::' + recTypeList);
			if(recTypeList.size() == 0) {
				existRT = 'No Record Type';
			}
		} catch (Exception e) {
			existRT = 'No Record Type';
		}
	}
	
	public void sharingHierarchyRole(Map<Id, SObject> shrGroupMap) {
		//system.debug('shrGroupMap:::::' + shrGroupMap);
		noUserRole = false;
		if (user.UserRoleId != null) {
			//Id currentUserRoleId = userRoleMap.get(user.UserRoleId).Id;
			Id currentUserRoleId = user.UserRoleId;
			////system.debug('currentUserRoleId:::::' + userRoleMap.get(user.UserRoleId));
			userSharingRoleMap = new Map<User, List<UserRole>>();
			List<UserRole> userRoleSharingList;
			UserRole sharingUserRole;
			for(Id userOrGroupId : shrGroupMap.keySet()) {
				if(userMap.KeySet().contains(userOrGroupId)) {
					noSharingRole = true;
					sharingUserRole = new UserRole();
					sharingUserRole = userRoleMap.get(userMap.get(userOrGroupId).userRoleId);
					////system.debug('sharingUserRole::' + sharingUserRole);
					Id parentRoleId;
					if (sharingUserRole != null) {
						userRoleSharingList = new List<UserRole>();
						userRoleSharingList.add(userRoleMap.get(sharingUserRole.Id));
						parentRoleId = sharingUserRole.ParentRoleId;
						while (parentRoleId != null) {
							userRoleSharingList.add(userRoleMap.get(parentRoleId));
							if(parentRoleId == currentUserRoleId) {
								parentRoleId = null;
								noSharingRole = false;
								noUserRole = true;
							} else {
								parentRoleId = userRoleMap.get(parentRoleId).ParentRoleId;
							}
						}
						////system.debug('userRoleSharingList;;;' + userRoleSharingList);
						////system.debug('noSharingRole;;;' + noSharingRole);
						if (!noSharingRole && !userSharingRoleMap.keySet().contains(userMap.get(userOrGroupId))) {
							Integer index = userRoleSharingList.size();
							//system.debug('index ;;;' + index );
							List<UserRole> urList = new UserRole[index];
							for(UserRole ur : userRoleSharingList) {
								index = index - 1;
								urList.add(index, ur);
							}
							
							////system.debug('urList;;;' + urList);
							userSharingRoleMap.put(userMap.get(userOrGroupId), new List<UserRole>(urList));
						}
					}
				}
			}
		}
	}
	
	public List<UserRole> RoleAsigned (User user) {
		List<UserRole> userRoleList = new List<UserRole>();
		Id currentParentRoleId;
		currentUserRole = userRoleMap.get(user.UserRoleId);
		//system.debug('currentUserRole::' + currentUserRole);
		if (currentUserRole != null) {
			currentParentRoleId = currentUserRole.ParentRoleId;
			//system.debug('currentParentRoleId::' + currentParentRoleId);
			while (currentParentRoleId != null) {
				userRoleList.add(userRoleMap.get(currentParentRoleId));
				currentParentRoleId = userRoleMap.get(currentParentRoleId).ParentRoleId;
			}
			//system.debug('userRoleList::' + userRoleList);
		}
		return userRoleList;
	}
	
	public void GroupAsigned (Map<Id, SObject> shrGroupMap) {
        system.debug('testing line 886');
		isRoleGroupShare = false;
		isRoleSubordinatesGroupShare = false;
		isRolePublicGroupShare = false;
		roleGroupMap = new Map<Group, List<UserRole>>();
		userGroupSharingMap = new Map<Group, User>();
		roleGroupSharingMap = new Map<Group, List<UserRole>>();
        //system.debug('$#$#testing=='+ userGroupSharingMap + '   roleGroupMap=='+ roleGroupMap);
		/*if(!Schema.getGlobalDescribe().get('Group').getDescribe().isAccessible()) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'You don\'t have access to Group object');
			ApexPages.addMessage(myMsg);
			return;
		}*/
		Map<Id, Group> groupMap = new Map<Id, Group>([SELECT ID, Type, Name, RelatedId, DeveloperName FROM Group LIMIT 1000]); //WHERE Type != 'Queue']);
		
        List<GroupMember> groupMemberList;
         system.debug('testing line 902');
		system.debug('shrGroupMap::' + shrGroupMap);
		Set<Id> groupIdSet = new Set<Id>();
         system.debug('testing line 905');
		groupIdSet.addAll(groupMap.Keyset());
		groupMemberList = [SELECT UserOrGroupId, GroupID FROM GroupMember WHERE GroupID IN :groupIdSet];
		groupList = new List<Group>();
		for(Id groupId : shrGroupMap.KeySet()) {
            
			if(groupMap.containsKey(groupId) ) { //&& groupMap.get(groupId).Type == 'Organization'
				groupList.add(groupMap.get(groupId));
                 system.debug('testing line 913');
			}
            if(groupMap.get(groupId).Type == 'Organization' ) {
				groupList.add(groupMap.get(groupId));
                 system.debug('testing line 920');
			}
            
		}
        
			
		groupIdSet = new Set<Id>();
		Map<Id, Set<ID>> GroupMemberMap = new Map<Id, Set<ID>>();
		Map<Id, Set<ID>> userOrGroupIdMemberMap = new Map<Id, Set<ID>>();
		system.debug('groupMemberList::' + groupMemberList);
         system.debug('testing line 920');
		for(GroupMember gm : groupMemberList){
			if(!GroupMemberMap.KeySet().contains(gm.GroupID)) {
				GroupMemberMap.put(gm.GroupID, new Set<Id>());
                 system.debug('testing line 924');
			}
			GroupMemberMap.get(gm.GroupID).add(gm.UserOrGroupId);
			if(!userOrGroupIdMemberMap.keySet().contains(gm.UserOrGroupId)){
				userOrGroupIdMemberMap.put(gm.UserOrGroupId,  new Set<Id>());
			}
			userOrGroupIdMemberMap.get(gm.UserOrGroupId).add(gm.GroupID);
		}
		system.debug('GroupMemberMap::' + GroupMemberMap);
		system.debug('userOrGroupIdMemberMap::' + userOrGroupIdMemberMap);
		Set<Id> groupSearchIdSet = new Set<Id>();
		for (ID UserOrGroupId : shrGroupMap.KeySet()) {
			//system.debug('GroupMemberMap.get(UserOrGroupId)::' + GroupMemberMap.get(UserOrGroupId));
			 system.debug('testing line 937');
			if(GroupMemberMap.containsKey(UserOrGroupId)) {
                 system.debug('testing line 939');
				if (GroupMemberMap.get(UserOrGroupId).contains(user.Id)){
					groupIdSet.add(UserOrGroupId);
				} else {
					List<UserRole> userRoleList;
                     system.debug('testing line 944');
					if(GroupMemberMap.containsKey(UserOrGroupId)) {
                         system.debug('testing line 946');
						for(Id userID : GroupMemberMap.get(UserOrGroupId)) {
							if(userMap.containsKey(userID)) {
                                 system.debug('testing line 949');
								userRoleList = new List<UserRole>();
								userRoleList.addAll(RoleAsigned(userMap.get(userID)));
								List<UserRole> roleList = new List<UserRole>();
								roleList.add(userRoleMap.get(userMap.get(userID).UserRoleId));
								for(UserRole ur : userRoleList) {
                                     system.debug('testing line 955');
									roleList.add(ur);
									if(ur.id == user.UserRoleId){
                                       isRolePublicGroupShare = true;
                                        system.debug('testing 958--isRolePublicGroupShare==' + isRolePublicGroupShare);
										isGroupShr = true;
										break;
									}
								}
                                system.debug('testing 964--isRolePublicGroupShare==' + isRolePublicGroupShare);
								if(isRolePublicGroupShare){
                                     system.debug('testing line 965--isRolePublicGroupShare'+isRolePublicGroupShare);
									List<UserRole> urList = new List<UserRole>(roleList);
									roleList.clear();
									Integer index = urList.size();
									for(UserRole ur : urList) {
                                         system.debug('testing line 970');
										index = index - 1;
										roleList.add(urList.get(index));
									}
									roleGroupSharingMap.put(groupMap.get(UserOrGroupId), roleList);
									userGroupSharingMap.put(groupMap.get(UserOrGroupId), userMap.get(userId));
                                    system.debug('testing line='+roleGroupSharingMap);
								}
							} else {
                                 system.debug('testing line 978');
								if(groupMap.containsKey(userID) && groupMap.get(userID).RelatedId == user.UserRoleId) {
                                     system.debug('testing line 980');
									groupIdSet.add(UserOrGroupId);
								} else {
                                     system.debug('testing line 983');
									groupSearchIdSet.add(userID);
								}
							}
						}
					}
				}
			}
		}
        system.debug('testing line 992--roleGroupSharingMap===='+roleGroupSharingMap +'--roleGroupSharingMapkey-=='+ roleGroupSharingMap.keySet());
		for(Group gr : roleGroupSharingMap.keySet()) {
             system.debug('testing line 1002 gr =='+ gr);
			if(!sharingCriteriaRuleMap.containsKey(gr.DeveloperName)) {
                system.debug('testing line --sharingCriteriaRuleMap'+ sharingCriteriaRuleMap + '&&'+ gr.DeveloperName );
				sharingCriteriaRuleMap.put(gr.DeveloperName, '');
                 system.debug('testing line 1006--sharingCriteriaRuleMap'+ sharingCriteriaRuleMap + '&&'+ gr.DeveloperName );

			}
             system.debug('testing line 1009--sharingCriteriaRuleMap=='+ sharingCriteriaRuleMap);
		}
		system.debug('testing 1011--roleGroupSharingMap:' + roleGroupSharingMap);
		if (groupSearchIdSet.size() > 0) {
            system.debug('testing line 1004');
			for(Id groupId : groupSearchIdSet) {
                 system.debug('testing line 1006-groupid=='+ groupId);
				if(GroupMemberMap.containsKey(groupId) && GroupMemberMap.get(groupId) != null) {
                      system.debug('testing line 1008');
					if(GroupMemberMap.get(groupId).contains(user.Id)) {
                          system.debug('testing line 1010');
						groupIdSet.add(groupId);
					}else {
                           system.debug('testing line 1013');
						groupSearchIdSet.addAll(GroupMemberMap.get(groupId));
					}
				}
			}
		}
		system.debug('testing line 1019--groupIdSet::' + groupIdSet);
		system.debug('testing line 1020--groupSearchIdSet::' + groupSearchIdSet);
		
		
		if (groupIdSet.size() > 0) {
            system.debug('testing line 1024');
			for(Id gr : groupMap.keySet()) {
                 system.debug('testing line 1026');
				if(groupIdSet.contains(gr)) {
					groupList.add(groupMap.get(gr));
				}
			}
			 system.debug('testing line 1031'+ groupList);
		}
		system.debug('groupMap::' + groupMap);
         system.debug('testing line 1034');
		roleAndSubordinatesGroupMap = new Map<Group, List<UserRole>>();
         system.debug('testing line 1036 roleAndSubordinatesGroupMap=='+roleAndSubordinatesGroupMap);
         system.debug('testing line 1037');
		for(Id grId : groupMap.keySet()) {
			Group groupItem = groupMap.get(grId);
			if(shrGroupMap.containsKey(grId)&& (groupItem.Type == 'Role' || groupItem.Type == 'RoleAndSubordinates')) { //
                system.debug('testing line 1041');
				if(groupItem.RelatedId != null && groupItem.RelatedId == user.UserRoleId) {
                     system.debug('testing line 1044');
					roleGroupMap.put(groupItem, new List<UserRole>());
					isRoleGroupShare = true;
					isGroupShr = true;
				} else {
                    
					//system.debug('userRoleMap1::' + groupItem.RelatedId);
					system.debug('testing line 1050');
					List<User> userList = new List<User>();
					for(Id userId: UserMap.KeySet()) {
						if(UserMap.get(userId).UserRoleId == groupItem.RelatedId) {
							userList.add(UserMap.get(userId));
						}
					}
                    	system.debug('testing line 1057');
					//system.debug('userList12:::' + userList);
					List<UserRole> userRoleList = new List<UserRole>();
					Boolean isRole;
					if(userList.size() > 0) {
						for(User usr : userList) {
							isRole = false;
							userRoleList.addAll(RoleAsigned(usr));
							List<UserRole> roleList = new List<UserRole>();
							if(userRoleList.size() > 0) {
								for(UserRole ur : userRoleList) {
									roleList.add(ur);
									if(ur.id == user.UserRoleId) {
										isRoleGroupShare = true;
										isGroupShr = true;
										isRole = true;
										break;
									}
								}
							}
							if(isRole){
								List<UserRole> urList = new List<UserRole>(roleList);
								roleList.clear();
								Integer index = urList.size();
								for(UserRole ur : urList) {
									index = index - 1;
									roleList.add(urList.get(index));
								}
								roleGroupMap.put(groupItem, roleList);
								
								break;
							}
						}
					}
				}
				
			}
			if(shrGroupMap.containsKey(grId) && (groupItem.Type == 'RoleAndSubordinates')) {
                	system.debug('testing line 1075');
				if(groupItem.RelatedId != null && groupItem.RelatedId != user.UserRoleId) {
					//system.debug('userRoleMap2::' + groupMap.get(grId).RelatedId);
					
					List<UserRole> userRoleSubordinatesList = new List<UserRole>(RoleAsigned(user));
					List<UserRole> roleList = new List<UserRole>();
					for(UserRole ur : userRoleSubordinatesList) {
                        	system.debug('testing line 1082');
						roleList.add(ur);
						if(ur.id == groupItem.RelatedId) {
							isRoleSubordinatesGroupShare = true;
							isGroupShr = true;
							break;
						}
					}
					if(isRoleSubordinatesGroupShare){
                        system.debug('testing line 1111');
						List<UserRole> urList = new List<UserRole>(roleList);
						roleList.clear();
						Integer index = urList.size();
						for(UserRole ur : urList) {
							index = index - 1;
							roleList.add(urList.get(index));
						}
						roleAndSubordinatesGroupMap.put(groupItem, roleList);
						//system.debug('roleAndSubordinatesGroupMap::' + roleGroupMap);
					}
				}
			}
		}
		for (Group gr : roleGroupMap.Keyset()) {
             system.debug('testing line 1126');
			if(!sharingCriteriaRuleMap.containsKey(gr.DeveloperName)) {
                 system.debug('testing line 1128');
				sharingCriteriaRuleMap.put(gr.DeveloperName, '');
			}
		}
		//system.debug('roleGroupMap::' + roleGroupMap);
		system.debug('testing line 1133--groupList;;' + groupList);
		if (groupList.size() > 0) {
             system.debug('testing line 1135');
            for (Group gr : groupList) {
                 system.debug('testing line 1137--gr =='+ gr);
                 system.debug('testing line 1138');
				system.debug('gr.DeveloperName::;;' + gr.DeveloperName);
				if(!sharingCriteriaRuleMap.containsKey(gr.DeveloperName)) {
                     system.debug('testing line 1141');
					sharingCriteriaRuleMap.put(gr.DeveloperName, '');
				}
			}
			isGroupShr = true;
             system.debug('testing line 1146 --isGroupShr=='+ isGroupShr);
			Set<Group> groupSet = new Set<Group>(groupList);
			groupList = new List<Group>(groupSet); 
            system.debug('testing line 1149--groupSet=='+groupSet+'---groupList=='+groupList);
		}
	}
	
	public static MetadataService.MetadataPort createService() { 
		MetadataService.MetadataPort service = new MetadataService.MetadataPort();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		service.timeout_x = 120000;
		return service;
	}
	
	public void readCustomObject(String objName) {
		//system.debug('customObjectMetadata::');
		MetadataService.MetadataPort service = createService();
		MetadataService.ReadCustomObjectResult rs = (MetadataService.ReadCustomObjectResult) 
			service.readMetadata('CustomObject', new String[] {objName});
		//system.debug('customObjectMetadata::' + rs);
		for (MetadataService.Metadata md : rs.getRecords()) {
			if (md != null) {
				MetadataService.CustomObject obj = (MetadataService.CustomObject) md;
				isCustom = true;
				customShr = (String)obj.sharingmodel;
				//system.debug('Custom object full name: ' + obj.fullName);
				//system.debug('Label: ' + obj.label);
				//system.debug('Sharing model: ' + obj.sharingmodel);
			} else {
				//system.debug('Empty metadata.');
			}
		}
	}
	
	public void readSharingRule(String objName){
        system.debug('testing line' + objNAme);
		// Read Sharing Rule
		MetadataService.MetadataPort service = createService();
		transient MetadataService.SharingRules sharingRules = (MetadataService.SharingRules) service.readMetadata('SharingRules',new String[] {objName}).getRecords()[0];
		system.debug('testing line--sharingRules::' + sharingRules);
		String sharingCriteriaRule;
		
		if(sharingRules.sharingCriteriaRules != null) {
			for(MetadataService.SharingCriteriaRule scr: sharingRules.sharingCriteriaRules) {
				system.debug('testing line--scr::' + scr);
				for(MetadataService.FilterItem crit : scr.criteriaItems){
					sharingCriteriaRule = crit.field + ' ' + crit.operation + ' ' + (crit.value != null ? crit.value : crit.valueField);
					system.debug('testing line--sharingCriteriaRule::' + sharingCriteriaRule);
					system.debug('testing line--sharingCriteriaRuleMap01::' + sharingCriteriaRuleMap);
					if(scr.sharedTo.group_x != null) {
						for(String groupName : scr.sharedTo.group_x) {
							system.debug('testing line-scr.sharedTo::' + groupName);
							sharingCriteriaRuleMap.put(groupName, sharingCriteriaRule);
                            system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.allCustomerPortalUsers != null) {
						sharingCriteriaRuleMap.put(scr.sharedTo.allCustomerPortalUsers, sharingCriteriaRule);
                         system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
					}
					if(scr.sharedTo.allInternalUsers != null) {
						sharingCriteriaRuleMap.put('AllInternalUsers', sharingCriteriaRule);
                         system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
					}
					if(scr.sharedTo.allPartnerUsers != null) {
						sharingCriteriaRuleMap.put(scr.sharedTo.allPartnerUsers, sharingCriteriaRule);
                         system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
					}
					if(scr.sharedTo.portalRole != null) {
						for(String portalUser : scr.sharedTo.portalRole) {
							sharingCriteriaRuleMap.put(portalUser, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.portalRoleandSubordinates != null) {
						for(String portalUser : scr.sharedTo.portalRoleandSubordinates) {
							sharingCriteriaRuleMap.put(portalUser, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.role != null) {
						for(String userRole : scr.sharedTo.role) {
							sharingCriteriaRuleMap.put(userRole + 'A', sharingCriteriaRule);
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.roleAndSubordinates != null) {
						for(String userRole : scr.sharedTo.roleAndSubordinates) {
							sharingCriteriaRuleMap.put(userRole + 'D', sharingCriteriaRule);
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.roleAndSubordinatesInternal != null) {
						for(String userRole : scr.sharedTo.roleAndSubordinatesInternal) {
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					if(scr.sharedTo.queue != null) {
						for(String que : scr.sharedTo.queue) {
							sharingCriteriaRuleMap.put(que, sharingCriteriaRule);
                             system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
						}
					}
					//system.debug('sharingCriteriaRuleMap1::' + sharingCriteriaRuleMap);
				 system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
				}
			}
			
			//system.debug('sharingCriteriaRuleMap::' + sharingCriteriaRuleMap.get('AllInternalUsers'));
			for(String x : sharingCriteriaRuleMap.Keyset()) {
				system.debug('testing--key::' + x);
				system.debug('testing--value::' + sharingCriteriaRuleMap.get(x));
				 system.debug('testing line---sharingCriteriaRuleMap:::'+sharingCriteriaRuleMap);
			}
		}
		if(sharingRules.sharingOwnerRules != null) {
			String userRoleDevName = userRoleMap.get(userMap.get((Id)sObj.get('OwnerId')).UserRoleId).DeveloperName;
			String userRoleLabel = userRoleMap.get(userMap.get((Id)sObj.get('OwnerId')).UserRoleId).Name;
			//system.debug('userRoleDevName:' + userRoleDevName);
			Set<String> userRoleDevNameSet = new Set<String>();
			List<UserRole> roleAssignedList = new List<UserRole>(RoleAsigned(userMap.get((Id)sObj.get('OwnerId'))));
			for(UserRole ur : roleAssignedList ) {
				userRoleDevNameSet.add(ur.DeveloperName);
			}
			Boolean isFound;
			for(MetadataService.SharingOwnerRule scr: sharingRules.sharingOwnerRules) {
				isFound = false;
				//system.debug('scr.sharedFrom::' + scr.sharedFrom);
				sharingCriteriaRule = 'Owner in  ';
				if(scr.sharedFrom.allCustomerPortalUsers != null && scr.sharedFrom.allCustomerPortalUsers == userRoleDevName) {
					sharingCriteriaRule += 'allCustomerPortalUsers(' + userRoleLabel + ')';
					isFound = true;
				}
				if(scr.sharedFrom.allInternalUsers != null && scr.sharedFrom.allInternalUsers == userRoleDevName) {
					sharingCriteriaRule += 'allInternalUsers (' + userRoleLabel + ')';
					isFound = true;
				}
				if(scr.sharedFrom.allPartnerUsers != null && scr.sharedFrom.allPartnerUsers == userRoleDevName) {
					sharingCriteriaRule += 'AllPartnerUsers(' + userRoleLabel + ')';
					isFound = true;
				}
				if(scr.sharedFrom.portalRole != null) {
					for(String portalRole : scr.sharedFrom.portalRole) {
						if(portalRole == userRoleDevName) {
							sharingCriteriaRule += 'PortalRole (' + userRoleLabel + ')';
							isFound = true;
						}
					}
					
				}
				if(scr.sharedFrom.portalRoleandSubordinates != null) {
					for(String portalRoleandSubordinates : scr.sharedFrom.portalRoleandSubordinates) {
						if(userRoleDevNameSet.contains(portalRoleandSubordinates)) {
							sharingCriteriaRule += 'PortalRoleandSubordinates (' + portalRoleandSubordinates + ')';
							isFound = true;
						}
					}
				}
				if(scr.sharedFrom.role != null) {
					for(String role : scr.sharedFrom.role) {
						if(role == userRoleDevName) {
							sharingCriteriaRule += 'Role (' + userRoleLabel + ')';
							isFound = true;
						}
					}
				}
				if(scr.sharedFrom.roleAndSubordinates != null) {
					for(String roleAndSubordinates : scr.sharedFrom.roleAndSubordinates) {
						//system.debug('roleAndSubordinates::' + roleAndSubordinates + '  ' + userRoleDevNameSet);
						if(userRoleDevNameSet.contains(roleAndSubordinates)) {
							sharingCriteriaRule += 'RoleAndSubordinates (' + roleAndSubordinates + ')';
							isFound = true;
						}
					}
				}
				if(scr.sharedFrom.roleAndSubordinatesInternal != null) {
					for(String roleAndSubordinatesInternal : scr.sharedFrom.roleAndSubordinatesInternal) {
						if(userRoleDevNameSet.contains(roleAndSubordinatesInternal)) {
							sharingCriteriaRule += 'RoleAndSubordinatesInternal (' + roleAndSubordinatesInternal + ')';
							isFound = true;
						}
					}
				}
				if(scr.sharedFrom.queue != null) {
					for(String queue : scr.sharedFrom.queue) {
						if(queue == userRoleDevName) {
							sharingCriteriaRule += 'Queue (' + userRoleLabel + ')';
							isFound = true;
						}
					}
				}
				sharingCriteriaRule += ' Shared With ';
				
				//system.debug('sharingCriteriaRule11::' + sharingCriteriaRule);
				//system.debug('scr.sharedTo::::' + scr.sharedTo.group_x );
				if(isFound) {
					if(scr.sharedTo.group_x != null) {
						for(String groupName : scr.sharedTo.group_x) {
							if(!sharingCriteriaRuleMap.containsKey(groupName)){
								//system.debug('groupName::::' + groupName );
								sharingCriteriaRule += groupName;
								sharingCriteriaRuleMap.put(groupName, sharingCriteriaRule);
							}
						}
					}
					//system.debug('sharingCriteriaRule12::' + sharingCriteriaRule);
					if(scr.sharedTo.allCustomerPortalUsers != null) {
						sharingCriteriaRule += 'allCustomerPortalUsers ' + scr.sharedTo.allCustomerPortalUsers;
						sharingCriteriaRuleMap.put(scr.sharedTo.allCustomerPortalUsers, sharingCriteriaRule);
					}
					if(scr.sharedTo.allInternalUsers != null) {
						sharingCriteriaRule += 'allInternalUsers ' + scr.sharedTo.allInternalUsers;
						sharingCriteriaRuleMap.put(scr.sharedTo.allInternalUsers, sharingCriteriaRule);
					}
					if(scr.sharedTo.allPartnerUsers != null) {
						sharingCriteriaRule += 'allPartnerUsers ' + scr.sharedTo.allPartnerUsers;
						sharingCriteriaRuleMap.put(scr.sharedTo.allPartnerUsers, sharingCriteriaRule);
					}
					if(scr.sharedTo.portalRole != null) {
						for(String portalUser : scr.sharedTo.portalRole) {
							sharingCriteriaRule += 'portalRole ' + portalUser;
							sharingCriteriaRuleMap.put(portalUser, sharingCriteriaRule);
						}
					}
					if(scr.sharedTo.portalRoleandSubordinates != null) {
						for(String portalUser : scr.sharedTo.portalRoleandSubordinates) {
							sharingCriteriaRule += 'portalRoleandSubordinates ' +  portalUser;
							sharingCriteriaRuleMap.put(portalUser, sharingCriteriaRule);
						}
					}
					if(scr.sharedTo.role != null) {
						for(String userRole : scr.sharedTo.role) {
							sharingCriteriaRule += 'Role ' + userRole;
							sharingCriteriaRuleMap.put(userRole + 'A', sharingCriteriaRule);
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
						}
					}
					if(scr.sharedTo.roleAndSubordinates != null) {
						for(String userRole : scr.sharedTo.roleAndSubordinates) {
							sharingCriteriaRule += 'RoleAndSubordinates ' + userRole;
							sharingCriteriaRuleMap.put(userRole + 'A', sharingCriteriaRule);
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
						}
					}
					if(scr.sharedTo.roleAndSubordinatesInternal != null) {
						for(String userRole : scr.sharedTo.roleAndSubordinatesInternal) {
							sharingCriteriaRule += 'RoleAndSubordinatesInternal' + userRole;
							sharingCriteriaRuleMap.put(userRole, sharingCriteriaRule);
						}
					}
					if(scr.sharedTo.queue != null) {
						for(String que : scr.sharedTo.queue) {
							sharingCriteriaRule += 'Queue ' + que;
							sharingCriteriaRuleMap.put(que, sharingCriteriaRule);
						}
					}
				}
				//system.debug('sharingCriteriaRuleMap1::' + sharingCriteriaRuleMap);
				
			}
			
			//system.debug('sharingCriteriaRuleMap::' + sharingCriteriaRuleMap);
		}
		////system.debug('sharingRules::' + sharingRules.sharingCriteriaRules[0].criteriaItems[0]);
	}
	
	public void readProfileObject(String profName) {
		MetadataService.MetadataPort service = createService();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		transient MetadataService.Profile profile = (MetadataService.Profile) service.readMetadata('Profile', new String[] {profName}).getRecords()[0];
		List<MetadataService.ProfileRecordTypeVisibility> profileRecordTypeList = profile.recordTypeVisibilities;
		//system.debug('profileRecordTypeList::' + profileRecordTypeList);
		//system.debug('profName::' + profName);
			recordTypeList = new List<String>();
			if(profile.recordTypeVisibilities != null) {
				for(MetadataService.ProfileRecordTypeVisibility rt : profile.recordTypeVisibilities) {
					//system.debug('rt::' + rt);
					if(rt.visible != null && rt.visible) {
						recordTypeList.add(rt.recordType);
					}
				}
			}
		//system.debug('recordTypeList::' + recordTypeList);
		//return profile.custom;
	}
	
	public void readRecordType(String recordTypeName) {
		MetadataService.MetadataPort service = createService();
		service.SessionHeader = new MetadataService.SessionHeader_element();
		service.SessionHeader.sessionId = UserInfo.getSessionId();
		MetadataService.RecordType recordType = (MetadataService.RecordType) service.readMetadata('RecordType', new String[] {recordTypeName}).getRecords()[0];
		//system.debug('recordType::' + recordType);
	}
	
	public void ExpandProf() {
		if (isExpandProf == false) {
			isExpandProf = true;
		}else {
			isExpandProf = false;
		}
	}
	
	public void ExpandOrg() {
		if (isExpandOrg == false) {
			isExpandOrg = true;
		}else {
			isExpandOrg = false;
		}
	}
	
	public void ExpandPerm() {
		if (isExpandPerm == false) {
			isExpandPerm = true;
		}else {
			isExpandPerm = false;
		}
	}
	
	public void ExpandRole() {
		if (isExpandRole == false) {
			isExpandRole = true;
		}else {
			isExpandRole = false;
		}
	}
	
	public void ExpandTerritory() {
		if (isExpandTerritory == false) {
			isExpandTerritory = true;
		}else {
			isExpandTerritory = false;
		}
	}
	
	public void ExpandSharing() {
		if (isExpandSharing == false) {
			isExpandSharing = true;
		}else {
			isExpandSharing = false;
		}
	}
	
	public void ExpandGroupSharing() {
		if (isExpandGroupSharing == false) {
			isExpandGroupSharing = true;
		}else {
			isExpandGroupSharing = false;
		}
	}
	
	public void ExpandRecordType() {
		if (isExpandRecordType == false) {
			isExpandRecordType = true;
		}else {
			isExpandRecordType = false;
		}
	}
	
	public pageReference printPDF() {
		PageReference pageRef;
		pageRef = new PageReference('/apex/RecordAccessPDF');
		pageRef.getParameters().put('isPdf', 'true');
		pageRef.getParameters().put('userPDFID', user.ID);
		pageRef.getParameters().put('currentId', currentId);
		return pageRef;
	}
	public class Territory2Wrapper {
		public Sobject territory2 { get; set; }
		public List<Sobject> territory2Hierarchy { get; set; }
		public Boolean existParentTer2 { get; set; }
		public List<UserRole> userRolelist { get; set; }
		public Boolean isRoleTerritory { get; set; }
		public User userTerritory { get; set; }
		public Integer lastTerritory { get; set; }
		
		public Territory2Wrapper(Sobject territory2, List<Sobject> territory2Hierarchy, Boolean existParentTer2, Set<UserRole> userRoleSet, Boolean isRoleTerritory, User  userTerritory) {
			this.territory2 = territory2;
			this.territory2Hierarchy = territory2Hierarchy;
			this.existParentTer2 = existParentTer2;
			this.userRolelist = new List<SObject>();
			this.userRolelist.addAll(userRoleSet);
			this.isRoleTerritory = isRoleTerritory;
			this.userTerritory = userTerritory;
			this.lastTerritory = territory2Hierarchy.size() - 1;
		}
		
		public Territory2Wrapper(Sobject territory2, List<Sobject> territory2Hierarchy, Boolean existParentTer2) {
			this.territory2 = territory2;
			this.territory2Hierarchy = territory2Hierarchy;
			this.existParentTer2 = existParentTer2;
		}
		
		public Territory2Wrapper(Sobject territory2,  Boolean existParentTer2) {
			this.territory2 = territory2;
			this.existParentTer2 = existParentTer2;
		}
	}
	
	public class TerritoryWrapper {
		public Sobject territory { get; set; }
		public List<Sobject> territoryHierarchy { get; set; }
		public Boolean existParentTer { get; set; }
		public List<UserRole> userRolelist { get; set; }
		public Boolean isRoleTerritory { get; set; }
		public User userTerritory { get; set; }
		public Integer lastTerritory { get; set; }
		
		public TerritoryWrapper(Sobject territory, List<Sobject> territoryHierarchy, Boolean existParentTer, Set<UserRole> userRoleSet, Boolean isRoleTerritory, User  userTerritory) {
			this.territory = territory;
			this.territoryHierarchy = territoryHierarchy;
			this.existParentTer = existParentTer;
			this.userRolelist = new List<SObject>();
			this.userRolelist.addAll(userRoleSet);
			this.isRoleTerritory = isRoleTerritory;
			this.userTerritory = userTerritory;
			this.lastTerritory = territoryHierarchy.size() - 1;
		}
		
		public TerritoryWrapper(Sobject territory, List<Sobject> territoryHierarchy, Boolean existParentTer) {
			this.territory = territory;
			this.territoryHierarchy = territoryHierarchy;
			this.existParentTer = existParentTer;
		}
		public TerritoryWrapper(Sobject territory,  Boolean existParentTer) {
			this.territory = territory;
			this.existParentTer = existParentTer;
		}
	}
}