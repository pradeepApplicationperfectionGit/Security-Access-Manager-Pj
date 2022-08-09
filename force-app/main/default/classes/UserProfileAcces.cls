/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class UserProfileAcces {
	public static List<SelectOption> profilesList { get; set; }
	public List<SelectOption> remainingProfileList { get; set; }
	public List<SelectOption> selectedProfileList { get; set; }
	public List<Id> selectedProfileIdList { get; set; }
	public List<String> fieldNameList { get; set; }
	public Map<String, List<String>> fieldNameLabelMap { get; set; }
	public String selectedPerm { get; set; }
	public Map<Id, sObject> profileMap { get; set; }
	public String xmlheader { get; set; }
	public String endfile { get; set; }
	public String currentLanguage { get; set; }
	public Organization org { get; set; }
	public String exportUser { get; set; }
	public String indAcrossCell { get; set; }
	public Boolean OrgIsAccessible { get; set; }
	public List<SelectOption> profList { get; set; }
	public List<SelectOption> selectedProfileExcel { get; set; }
	public Boolean displayPopup { get; set; }
	
	/*@AuraEnabled
	public static List<SelectOptionWrapper> getProfileOptions() {
		List<String> fieldNameList = new List<String>(getProfileFields());
		String query = 'SELECT';
		for(String profileField : fieldNameList) {
			query += ' ' + profileField + ',';
			
		}
		query = query.removeEnd(',') + ' FROM Profile';
		system.debug('query::' + query);
		List<Profile> profileList = Database.Query(query);
		Map<Id, Profile> profileMap = new Map<Id, Profile>();
		List<SelectOptionWrapper> selectOptionWrapperList = new List<SelectOptionWrapper>();
		List<String> sortList = new  List<String>();
		Map<String, String> valueLabelMap = new Map<String, String>();
		for(sObject p : profileList) {
			valueLabelMap.put((String)p.get('Name'), (Id)p.get('Id'));
			sortList.add((String)p.get('Name'));
			profileMap.put((Id)p.get('Id'), (Profile)p);
		}
		sortList.sort();
		for(String item : sortList) {
			selectOptionWrapperList.add(new SelectOptionWrapper(valueLabelMap.get(item), item, profileMap.get(valueLabelMap.get(item))));
			system.debug('aaaaaa::  ' + valueLabelMap.get(item));
		}
		return selectOptionWrapperList;
	}
	
	@AuraEnabled
	public static List<String> getProfileFields() {
		Map<String, Schema.DescribeFieldResult> profileFieldsMap = SecurityUtil.getFieldDescribeMap('Profile');
		List<String> fieldNameList = new List<String>(profileFieldsMap.keySet());
		fieldNameList.sort();
		return fieldNameList;
	}*/
	
	public List<SelectOption> getPermissionType() {
		List<SelectOption> options = new List<SelectOption>();
		options.addAll(SecurityUtil.getPermissionType());
		return options;
	}
	
	public UserProfileAcces() {
		selectedPerm = 'Organization Profiles & Permission Sets';
		displayPopup = false;
		OrgIsAccessible = true;
		selectedProfileExcel = new List<SelectOption>();
		if(!Schema.getGlobalDescribe().get('Organization').getDescribe().isAccessible()) {
			OrgIsAccessible = false;
		} else {
			String orgId = UserInfo.getOrganizationId();
			org = [SELECT Id , Name, NamespacePrefix FROM Organization WHERE ID = :orgID];
		}
		xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
		endfile = '</Workbook>';
		currentLanguage = 'US';
		if(Schema.getGlobalDescribe().get('Profile').getDescribe().isAccessible()) {
			profilesList = new List<SelectOption>(SecurityUtil.getAllOrganizationProfilesList());
			profilesList.addAll(SecurityUtil.getAllOrganizationPermissionSetList());
			profilesList = sortAfterLabelSelectOptionList(profilesList);
			fieldNameList = new List<String>();
			fieldNameLabelMap = new Map<String, List<String>>();
			List<EntityParticle> profileFieldList = [SELECT DataType, IsCalculated, IsCreatable, IsUpdatable, IsPermissionable, 
														QualifiedApiName, DeveloperName, Label, NamespacePrefix
														FROM EntityParticle WHERE EntityDefinition.QualifiedApiName = 'Profile'];
			List<EntityParticle> permSetFieldList = [SELECT DataType, IsCalculated, IsCreatable, IsUpdatable, IsPermissionable, 
														QualifiedApiName, DeveloperName, Label, NamespacePrefix
														FROM EntityParticle WHERE EntityDefinition.QualifiedApiName = 'PermissionSet'];
			Set<String> fieldExcluded = new Set<String>();
			for(EntityParticle profileField : profileFieldList) {
				Boolean isFound = false;
				for(EntityParticle permSetField : permSetFieldList) {
					if(profileField.QualifiedApiName == permSetField.QualifiedApiName) {
						isFound = true;
						break;
					}
				}
				if(!isFound){
					 fieldExcluded.add(profileField.QualifiedApiName);
					 system.debug('excluded::' + profileField.QualifiedApiName);
				}
			}
			
			for(EntityParticle profileField : profileFieldList) {
				if(!fieldExcluded.contains(profileField.QualifiedApiName)) {
					fieldNameList.add(profileField.QualifiedApiName);
					fieldNameLabelMap.put(profileField.QualifiedApiName, new List<String>());
					fieldNameLabelMap.get(profileField.QualifiedApiName).add(profileField.Label);
					if(profileField.DataType.containsIgnoreCase('boolean')){
						fieldNameLabelMap.get(profileField.QualifiedApiName).add('boolean');
					}else {
						fieldNameLabelMap.get(profileField.QualifiedApiName).add('other');
					}
					system.debug('profileField::' + profileField);
				}
			}
			fieldNameList.sort();
			createSelectList();
			retrieveRecords();
		}
	}
	
	public List<SelectOption> sortAfterLabelSelectOptionList(List<SelectOption> source) {
		List<String> sortList = new  List<String>();
		List<SelectOption> options = new List<SelectOption>();
		Map<String, String> valueLabelMap = new Map<String, String>();
		for(SelectOption so: source) {
			sortList.add(so.getLabel());
			valueLabelMap.put(so.getLabel(), so.getValue());
		}
		sortList.sort();
		for(String item : sortList) {
			options.add(new  SelectOption(valueLabelMap.get(item), item));
		}
		return options;
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
	public void createSelectList() {
		selectedProfileList = new List<SelectOption>();
		selectedProfileIdList = new List<Id>();
		if(profilesList.size() > 1) {
			selectedProfileIdList.add((Id)profilesList[0].getValue());
			selectedProfileIdList.add((Id)profilesList[1].getValue());
			selectedProfileList.add(new SelectOption(profilesList[0].getValue(), profilesList[0].getLabel()));
			selectedProfileList.add(new SelectOption(profilesList[1].getValue(), profilesList[1].getLabel()));
			profilesList.remove(0);
			profilesList.remove(0);
		} else { 
			if(profilesList.size() == 1) { 
				selectedProfileIdList.add((Id)profilesList[0].getValue());
				selectedProfileList.add(new SelectOption(profilesList[0].getValue(), profilesList[0].getLabel()));
				profilesList.remove(0);
			}
		}
		system.debug('profilesList::' + profilesList);
		remainingProfileList = new List<SelectOption>();
		remainingProfileList = sortAfterLabelSelectOptionList(profilesList);
		system.debug('remainingProfileList::' + remainingProfileList);
		profilesList = new List<SelectOption>();
	}
	
	public void retrieveRecords(){
		profileMap = new Map<Id, sObject>();
		String query = 'SELECT';
		for(String profileField : fieldNameList) {
			query += ' ' + profileField + ',';
			
		}
		String permissionQuery = query;
		Set<Id> profileIdSet = new Set<Id>(selectedProfileIdList);
		query = query.removeEnd(',') + ' FROM Profile Where Id IN :profileIdSet';
		system.debug('query::' + query);
		List<Profile> profileList = Database.Query(query);
		system.debug('profileList::' + profileList);
		for(Profile pr : profileList){
			if(!profileMap.containsKey(pr.id)) {
				profileMap.put(pr.id, (Profile)pr);
			}
		}
		permissionQuery = permissionQuery.removeEnd(',') + ' FROM PermissionSet Where Id IN :profileIdSet';
		List<PermissionSet> permissionSetList = Database.Query(permissionQuery);
		for(PermissionSet ps : permissionSetList){
			if(!profileMap.containsKey(ps.id)) {
				profileMap.put(ps.id, (PermissionSet)ps);
			}
		}
	}
	
	public void Go(){
		selectedProfileIdList = new List<Id>();
		system.debug('selectedProfileList::' + selectedProfileList);
		Boolean isMoreProfiles = false;
		for (SelectOption so : selectedProfileList) {
			if(!isMoreProfiles) {
				selectedProfileIdList.add(so.getValue());
				if(selectedProfileIdList.size() > 10) {
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Select only 10 profiles / permissionSet');
					ApexPages.addMessage(myMsg);
					Id profId = selectedProfileIdList.remove(10);
					isMoreProfiles = true;
					remainingProfileList.add(new SelectOption(profId, so.getLabel()));
				}
			}else {
				remainingProfileList.add(new SelectOption(so.getValue(), so.getLabel()));
			}
		}
		if(isMoreProfiles){
			List<SelectOption> profileTempList = new List<SelectOption>();
			profileTempList.addAll(selectedProfileList);
			selectedProfileList = new List<SelectOption>();
			Integer i = 0;
			for (SelectOption so : profileTempList) {
				selectedProfileList.add(new SelectOption(so.getValue(), so.getLabel()));
				i++;
				if(i > 9) break;
			}
		}
		remainingProfileList = sortAfterLabelSelectOptionList(remainingProfileList);
		retrieveRecords();
	}
	
	public void changePermType() {
		profilesList = new List<SelectOption>();
		/*if(selectedPerm == 'Profiles') {
			profilesList = new List<SelectOption>(sortAfterLabelSelectOptionList(SecurityUtil.getAllProfilesList()));
		} else if(selectedPerm == 'All'){
			profilesList = new List<SelectOption>(SecurityUtil.getAllProfilesList());
			List<PermissionSet> permissionSetsList = [SELECT Id, ProfileId, Name, Label, NamespacePrefix FROM PermissionSet 
														WHERE IsOwnedByProfile = false AND isCustom = true];
			for(PermissionSet ps : permissionSetsList) {
				profilesList.add(New SelectOption(ps.Id, ps.Label));
			}
			profilesList = sortAfterLabelSelectOptionList(profileList);
		} else {
			profilesList = new List<SelectOption>();
			List<PermissionSet> permissionSetsList = [SELECT Id, ProfileId, Name, Label, NamespacePrefix FROM PermissionSet 
														WHERE IsOwnedByProfile = false AND isCustom = true];
			for(PermissionSet ps : permissionSetsList) {
				profilesList.add(New SelectOption(ps.Id, ps.Label));
			}
			profilesList = sortAfterLabelSelectOptionList(profilesList);
		}*/
		profilesList = new List<SelectOption>(SecurityUtil.changetPermissionType(selectedPerm));
		createSelectList();
		retrieveRecords();
	}
	
	public void Save() {
		List<Profile> profileForUpdateList = new List<Profile>();
		//profileForUpdateList.addAll(profileMap.values());
		//update profileForUpdateList;
	}
	public PageReference ExportToExcel() {
		indAcrossCell = String.valueOf(selectedProfileIdList.size());
		system.debug('indAcrossCell::' + indAcrossCell);
		User user = new User();
		if(Schema.getGlobalDescribe().get('User').getDescribe().isAccessible()) {
			Id currentUserId = UserInfo.getUserId();
			user = [SELECT ID, Name FROM User WHERE Id = :currentUserId];
		}
		if(user != null) {
			exportUser = user.Name;
		} else {
			exportUser = '';
		}
		selectedProfileIdList = new List<Id>();
		if(selectedProfileExcel.size() > 0) {
			for(SelectOption so : selectedProfileExcel) {
				selectedProfileIdList.add((Id)so.getValue());
			}
		} else {
			for(SelectOption so : selectedProfileList) {
				selectedProfileIdList.add((Id)so.getValue());
			}
		}
		retrieveRecords();
		selectedProfileList = new List<SelectOption>();
		return Page.UserProfileAccesExportToExcel;
	}
	
	public void yesPopUp() {
		displayPopUp = true;
		profList = new List<SelectOption>();
		for(SelectOption so : remainingProfileList) {
			profList.add(new SelectOption(so.getValue(), so.GetLabel()));
			if(profList.size() > 998 -  selectedProfileList.size()) break;
		}
		profList = sortAfterLabelSelectOptionList(profList);
		selectedProfileExcel = new List<SelectOption>();
		for(SelectOption so : selectedProfileList) {
			selectedProfileExcel.add(new SelectOption(so.getValue(), so.GetLabel()));
		}
		//system.debug('displayPopUp::' + displayPopUp);
	}
	
	public void closePopup() {
		//objectsNameList.addAll(selectedObjectsList);
		selectedProfileExcel = new List<SelectOption>();
		profList = new List<SelectOption>();
		displayPopup = false;
	}
	
	public void SelectProfilesForExportToExcel() {
	   
		if(selectedProfileExcel.size() > 1000) {
			profList.addAll(selectedProfileExcel);
			
			selectedProfileExcel = new List<SelectOption>();
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'You can Export to Excel only 1000 Profiles');
			ApexPages.addMessage(myMsg);
		} else {
			if(selectedProfileExcel.size() == 0) {
				ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Select at least one profile up to 1000');
				ApexPages.addMessage(myMsg);
			} else {
				profList = new List<SelectOption>();
				displayPopup = false;
			}
		}
	}
	
	/*public class SelectOptionWrapper {
		public SelectOptionWrapper(String value, String label, Profile profile) {
			this.value = value;
			this.label = label;
			this.disabled = false;
			this.escapeItem = false;
			this.profile = profile;
		}
	
		public SelectOptionWrapper(String value, String label, Boolean isDisabled) {
			this.value = value;
			this.label = label;
			this.disabled = isDisabled;
			this.escapeItem = false;
		}
	
		@AuraEnabled
		public String label { get;set; }
		@AuraEnabled
		public String value { get;set; }
		@AuraEnabled
		public Profile profile { get; set; }
		@AuraEnabled
		public Boolean disabled { get;set; }
		@AuraEnabled
		public Boolean escapeItem { get;set; }

	}
	
	//Wrapper class to hold Columns with headers
	public class DataTableRows {
		@AuraEnabled
		public String fieldName {get;set;}


		//Create and set three variables label, fieldname and type as required by the lightning:datatable
		public DataTableRows(String label, String fieldName, String type){
			this.fieldName = fieldName;
			//this.type = type;			
		}
	}
	
	//Wrapper calss to hold response - This response is used in the lightning:datatable component
	public class DataTableResponse {
		@AuraEnabled
		public List<DataTableRows> lstDataTableRows {get;set;}
		public DataTableResponse(){
			lstDataTableRows = new List<DataTableRows>();
		}
	}*/
}