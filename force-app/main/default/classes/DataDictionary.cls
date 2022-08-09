/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 10-13-2021
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class DataDictionary {
    public List<SelectOption> objectsList { get; set; }
    public List<SelectOption> objectsList1 { get; set; }
    public String selectedObject { get; set; }
    public Boolean OrgIsAccessible { get; set; }
    public Map<String, List<String>> fieldDescriptionMap { get; set; }
    public Map<String, List<String>> fieldDeployMap { get; set; }
    public Map<String, Boolean> fieldGDPRMap { get; set; }
    public Boolean isEdit { get; set; }
    public Boolean isReadyToDownload { get; set; }
    public Boolean isDeploy { get; set; }
    public String ZipData { get; set; }
    public String xmlheader { get; set; }
    public String endfile { get; set; }
    public String currentLanguage { get; set; }
    public String exportUser { get; set; }
    public Organization org { get; set; }
    public Boolean noEndpointMetadata { get; set; }
    public Boolean editAccess { get; set; }
    //public transient Map<String, MetadataService.CustomField> metadataMap { get; set; }
    public Map<String, String> fieldTypeMap { get; set; }
    public String selectedType { get; set; }
    public Boolean isManaged { get; set; }
    public List<SelectOption> selectedObjectsList { get; set; }
    public Boolean displayPopup { get; set; }
    public List<DataDictionaryWrapper> ddWList { get; set; }
    public String selectedPerm { get; set; }
    public String selectedProfile { get; set; }
    public String selectedProfileName { get; set; }
    public List<SelectOption> profilesList { get; set; }
    public String permSetId { get; set; }
    public List<SensitiveDataReportWrapper> sensitiveDataReportWrapperList { get; set; }
    
    public MetadataService.AsyncResult AsyncResult {get; private set;}
    
    public List<SelectOption> getObjectsType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Organization Object','Organization Object'));
        options.add(new SelectOption('Managed Object','Managed Object'));
        return options;
    }
    
    public List<SelectOption> getPermissionType() {
        List<SelectOption> options = new List<SelectOption>();
        options.addAll(SecurityUtil.getPermissionType());
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
    	public DataDictionary() {

		sensitiveDataReportWrapperList = new List<SensitiveDataReportWrapper> ();
		xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
		endfile = '</Workbook>';
		currentLanguage = 'US';
		exportUser = UserInfo.getName();
		Id currentUserId = UserInfo.getUserId();
		editAccess = false;
		displayPopup = false;
		selectedPerm = 'Organization Profiles & Permission Sets';
		fieldGDPRMap = new Map<String, Boolean>();
		fieldDescriptionMap = new Map<String, List<String>>();
		ddWList = new List<DataDictionaryWrapper>();
		selectedObjectsList = new List<SelectOption>();
		List<SelectOption> profileTempList = new List<SelectOption>(SecurityUtil.getAllOrganizationProfilesList());
		profilesList = new List<SelectOption>();
		profileTempList = SecurityUtil.sortAfterLabelSelectOptionList(profileTempList);
		profilesList.add(new SelectOption('-------- None -------', '-------- None -------'));
		if(profileTempList.size() > 999) {
			for(Integer i = 1; i< 999; i++) {
				profilesList.add(profileTempList[i]);
			}
		} else {
			profilesList.addAll(profileTempList);
		}
		selectedProfile = '-------- None -------';
		selectedProfileName = 'None';
		
		User currentUser = [SELECT Id, Name, Profile.Name, profile.permissionscustomizeapplication FROM User WHERE Id =: currentUserId];
		if(currentUser.Profile.Name.contains('System Administrator') || currentUser.profile.permissionscustomizeapplication) {
			editAccess = true;
		}
		objectsList = new List<SelectOption>();
		//metadataMap = new Map<String, MetadataService.CustomField>();
		if(!Schema.getGlobalDescribe().get('Organization').getDescribe().isAccessible()) {
			OrgIsAccessible = false;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don\'t have access on Organization object');
			ApexPages.addMessage(myMsg);
		} else {
			OrgIsAccessible = true;
			isDeploy = false;
			isEdit = false;
			noEndpointMetadata = false;
			String orgId = UserInfo.getOrganizationId();
			org = [SELECT Id , Name, NamespacePrefix FROM Organization WHERE ID = :orgID];
			
			selectedObject = 'Account';
			objectsList = SecurityUtil.getObjectsList(org.NamespacePrefix, false);
			objectsList = SecurityUtil.sortAfterLabelSelectOptionList(objectsList);
			//system.debug('objectsList::' + objectsList.size());
			if(!RollupService.checkMetadataAPIConnection()) {
				noEndpointMetadata = true;
				//system.debug('aloooo:');
			}
			retrieveRecords();
			if(!noEndpointMetadata){
				fieldDeployMap = new Map<String, List<String>>();
				for(String field : fieldDescriptionMap.keySet()) {
					fieldDeployMap.put(field, new List<String>(fieldDescriptionMap.get(field)));
					String gdpr = fieldGDPRMap.get(field) ? 'true' : 'false';
					fieldDeployMap.get(field).add(gdpr);
				}
				//system.debug('inceput::' + fieldDeployMap);
			}
		}
		//System.debug('5. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
	}
    
    public PageReference CreateEndpoint() {
        if(noEndpointMetadata) {
            return redirectToWelcomeMetadataPage();
        }
        return null; 
    }
    
    public void changeType() {
        if(selectedType == 'Organization Object') {
            isManaged = false;
        } else {
            isManaged = true;
        }
        objectsList = new List<SelectOption>();
        objectsList1 = new List<SelectOption>();
        List<SelectOption> objectsListTemp = new List<SelectOption>();
        objectsList = SecurityUtil.getObjectsList(org.NamespacePrefix, isManaged);
        objectsList = SecurityUtil.sortAfterLabelSelectOptionList(objectsList);
        
        if(objectsList.size() > 900) {
            objectsListTemp.addAll(objectsList);
            objectsList = new List<SelectOption>();
            Integer i = 0;
            for(SelectOption so : objectsListTemp) {
                if(i < 900) {
                    objectsList.add(new SelectOption(so.getValue(), so.getLabel()));
                } else {
                    objectsList1.add(new SelectOption(so.getValue(), so.getLabel()));
                }
                i++;
            }
        }
        /*List<SelectOption> tempList = new List<SelectOption>();
if(objectsList.size() > 1000) {
for(Integer i = 0; i < 900; i++) {
tempList.add(objectsList[i]);
}
objectsList = new List<SelectOption>();
objectsList.addAll(tempList);
tempList = new List<SelectOption>();
}*/
        
        
        selectedObject = objectsList[0].getValue();
       system.debug('selectedObject:::' + selectedObject);
        retrieveRecords();
        fieldDeployMap = new Map<String, List<String>>();
        for(String field : fieldDescriptionMap.keySet()) {
            fieldDeployMap.put(field, new List<String>(fieldDescriptionMap.get(field)));
            system.debug('Testing line no 187 -fieldDescriptionMap.get(field)'+ fieldDescriptionMap.get(field)); 
            String gdpr = fieldGDPRMap.get(field) ? 'true' : 'false';
            fieldDeployMap.get(field).add(gdpr);
        }
        //system.debug('*&*&*fieldDeployMap'+fieldDeployMap);
      //  System.debug('6. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
    }
    
    public void retrieveRecords() {
        isReadyToDownload = false;
        ddWList = new List<DataDictionaryWrapper>();
        
        //system.debug('noEndpointMetadata::' + noEndpointMetadata);
        if(!noEndpointMetadata) {
            if(selectedProfile != '-------- None -------') {
                List<Objectpermissions> objPermList = new List<objectpermissions>();
                List<PermissionSet> permisionSetList = [SELECT Id, Name, PermissionsModifyAllData, Profile.Name, ProfileId, Profile.UserLicenseId, Label, LicenseId
                                                        FROM PermissionSet 
                                                        WHERE ProfileId = :selectedProfile OR Id = :selectedProfile];
                permSetId = permisionSetList[0].Id;
                selectedProfileName = permisionSetList[0].Profile.Name != null ? permisionSetList[0].Profile.Name : permisionSetList[0].Label;
                //system.debug('permisionSetList.size():::' + permisionSetList.size());
                objPermList = [SELECT Id, ParentId, SobjectType, PermissionsRead, PermissionsEdit, PermissionsCreate, PermissionsDelete, PermissionsViewAllRecords, PermissionsModifyAllRecords 
                               FROM Objectpermissions WHERE SobjectType = :selectedObject AND ParentId = :permSetId];
                //system.debug('objPermList.size():::' + objPermList.size());
                //system.debug('selectedProfile:::' + selectedProfile);
                if(objPermList.size() == 0) {
                    String profName = permisionSetList[0].Profile.Name == null ? permisionSetList[0].Label : permisionSetList[0].Profile.Name;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Selected profile/permission set ' + profName + ' don\'t has access on ' + selectedObject + ' object');
                    ApexPages.addMessage(myMsg);
                    fieldGDPRMap = new Map<String, Boolean>();
                    fieldDescriptionMap = new Map<String, List<String>>();
                    return;
                } 
            }
            
            
            createDescriptionMap();
        }
        System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());
    }
    
    public void createDescriptionMap(){
        fieldGDPRMap = new Map<String, Boolean>();
        List<SA_Audit__Sensitive_Data__c> gdprObjectList = [SELECT Id, Name FROM SA_Audit__Sensitive_Data__c WHERE Name = :selectedObject];
        Id gdprObjectId;
        gdprObjectId = gdprObjectList.size() > 0 ? gdprObjectList[0].Id : null;
        List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsList = new List<SA_Audit__Sensitive_Data_Field__c>();
        gdprFieldsList = [SELECT ID, Name, SA_Audit__Sensitive_Data__c, SA_Audit__Sensitive_Field_API__c FROM SA_Audit__Sensitive_Data_Field__c WHERE SA_Audit__Sensitive_Data_ObjectId__c = :gdprObjectId];
        for(SA_Audit__Sensitive_Data_Field__c gdprFieldName : gdprFieldsList) {
            fieldGDPRMap.put(gdprFieldName.SA_Audit__Sensitive_Field_API__c, gdprFieldName.SA_Audit__Sensitive_Data__c);
        }
        fieldDescriptionMap = new Map<String, List<String>>();
        system.debug('testing line no240 =fieldDescriptionMap=='+fieldDescriptionMap); 
        readCustomObject1(selectedObject);
         }
    
    public void changePermType() {
       
        profilesList = new List<SelectOption>();
        profilesList.add(new SelectOption('-------- None -------', '-------- None -------'));
        
        List<SelectOption> profileTempList = new List<SelectOption>();
        profileTempList = SecurityUtil.changetPermissionType(selectedPerm);
        if(profileTempList.size() > 999) {
            for(Integer i = 1; i< 999; i++) {
                profilesList.add(profileTempList[i]);
            }
        } else {
            profilesList.addAll(profileTempList);
        }
        profilesList.addAll(profileTempList);
        selectedProfile = '-------- None -------';
        retrieveRecords();
    }
    
    public PageReference redirectToWelcomeMetadataPage() {
        PageReference pageRef = Page.WelcomeMetadataPage;
        pageRef.getParameters().put('retPage', 'DataDictionary');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static MetadataService.MetadataPort createService() { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        service.timeout_x = 60000;
        return service;
    }
    
    public void readCustomObject1(String objName) {
        
        Map<String, String> fieldPermMap = new Map<String, String>();
        
        if(selectedProfile != '-------- None -------') {
            List<FieldPermissions> fieldPermissionsList = [SELECT ParentId, SobjectType, Field, PermissionsRead, PermissionsEdit 
                                                           FROM FieldPermissions 
                                                           WHERE SobjectType = :selectedObject AND ParentId = :permSetId];
            
            for(FieldPermissions fp : fieldPermissionsList) {
                fieldPermMap.put(fp.Field.toLowerCase().substringAfterLast('.'), '');
                
            }
        }
        
        List<EntityParticle> fieldsList  = [SELECT DataType,NamespacePrefix, FieldDefinition.QualifiedApiName, inlineHelpText, FieldDefinition.Description, Label 
                                            FROM EntityParticle WHERE EntityDefinition.QualifiedApiName =: objName];
        
        if(fieldsList.size()>0){
            for(EntityParticle field : fieldsList) {
                
                if(field.FieldDefinition.QualifiedApiName != null && !field.FieldDefinition.QualifiedApiName.containsIgnoreCase('__pc') &&
                   field.FieldDefinition.QualifiedApiName != 'Name' && !field.FieldDefinition.QualifiedApiName.containsIgnoreCase('address')) {
                       
                       if(selectedProfile != '-------- None -------' && fieldPermMap.containsKey(field.FieldDefinition.QualifiedApiName.toLowerCase())) {
                          
                           String fieldLabelString = field.Label;
                           fieldLabelString += ' (' + field.FieldDefinition.QualifiedApiName.toLowerCase() + ')';
                           fieldDescriptionMap.put(fieldLabelString, new List<String>());
                           system.debug('$#$# fieldDescriptionMap'+fieldDescriptionMap);
                           fieldDescriptionMap.get(fieldLabelString).add(field.FieldDefinition.description != null ? field.FieldDefinition.description : '');
                           system.debug('testing line fields'+ field);
                           fieldDescriptionMap.get(fieldLabelString).add(field.inlineHelpText != null ? field.inlineHelpText : '');
                           String fieldAPI = field.FieldDefinition.QualifiedApiName.removeEndIgnoreCase('__c');
                           if(!field.FieldDefinition.QualifiedApiName.endsWithIgnoreCase('__c') || fieldAPI.contains('__')) {
                               fieldDescriptionMap.get(fieldLabelString).add('false');
                           } else {
                               fieldDescriptionMap.get(fieldLabelString).add('true');
                           }
                           if(!fieldGDPRMap.containsKey(fieldLabelString)) {
                               fieldGDPRMap.put(fieldLabelString, false);
                           }
                           
                           if(field.NamespacePrefix != Null){
                               fieldDescriptionMap.get(fieldLabelString).add('true');
                           } else {
                                fieldDescriptionMap.get(fieldLabelString).add('false');
                           }
                       } 
                       if(selectedProfile == '-------- None -------') {
                           String fieldLabelString = field.Label;
                           fieldLabelString += ' (' + field.FieldDefinition.QualifiedApiName.toLowerCase() + ')';
                           fieldDescriptionMap.put(fieldLabelString, new List<String>());
                           fieldDescriptionMap.get(fieldLabelString).add(field.FieldDefinition.description != null ? field.FieldDefinition.description : '');
                           fieldDescriptionMap.get(fieldLabelString).add(field.inlineHelpText != null ? field.inlineHelpText : '');
                           String fieldAPI = field.FieldDefinition.QualifiedApiName.removeEndIgnoreCase('__c');
                         
                           if(!field.FieldDefinition.QualifiedApiName.endsWithIgnoreCase('__c') || fieldAPI.contains('__')) {
                               fieldDescriptionMap.get(fieldLabelString).add('false');
                           } else {
                               fieldDescriptionMap.get(fieldLabelString).add('true');
                           }
                           if(!fieldGDPRMap.containsKey(fieldLabelString)) {
                               fieldGDPRMap.put(fieldLabelString, false);
                           }
                         
                           if(field.NamespacePrefix != Null){
                               fieldDescriptionMap.get(fieldLabelString).add('true');
                           } else {
                                fieldDescriptionMap.get(fieldLabelString).add('false');
                           }
                       }
                   }
                
            }
            
        }
        
        for(String field : fieldDescriptionMap.keySet()) {
            if(fieldDescriptionMap.get(field).size() == 0){
                fieldDescriptionMap.get(field).add('');
                fieldDescriptionMap.get(field).add('');
               
            }
           system.debug('testing line no392--fielddescription='+field +'fieldDescriptionMap=='+ fieldDescriptionMap.keySet());
        
        }
    }
    public Map<String, DataDictionaryService.CustomField> readCustomObjectForDeploy1(String objName) {
        Map<String, DataDictionaryService.CustomField> metadataMap = new Map<String, DataDictionaryService.CustomField>();
        DataDictionaryService.CustomObject obj = DataDictionaryService.retrieveCustomObjectMetadata(objName);
       System.debug('$#$#metadataMap: ' + metadataMap);
        system.debug('Custom object full name: ' + obj.fullName);
        System.debug('Label: ' + obj.label);
        if (obj.fields != null) {
            for(DataDictionaryService.CustomField field : obj.fields) {
               System.debug('$#$# description: ' + field.fullName + '  type=== ' +  field.type_x);
                if(field.fullName != null) {
                    metadataMap.put(field.fullName.toLowerCase(), field);
                    
                }
            }
        }
        return metadataMap;
    }
    public Map<String, MetadataService.CustomField> readCustomObjectForDeploy(String objName) {
        Map<String, MetadataService.CustomField> metadataMap = new Map<String, MetadataService.CustomField>();
        MetadataService.MetadataPort service = createService();
        MetadataService.ReadCustomObjectResult rs = (MetadataService.ReadCustomObjectResult) 
            service.readMetadata('CustomObject', new String[] {objName});
        //system.debug('customObjectMetadata for deploy::' + rs);
        for (MetadataService.Metadata md : rs.getRecords()) {
            if (md != null) {
                MetadataService.CustomObject obj = (MetadataService.CustomObject) md;
                if(obj.fields == null) continue;
                for(MetadataService.CustomField field : obj.fields) {
                    if(field.fullName != null) {
                        metadataMap.put(field.fullName.toLowerCase(), field);
                    }
                }
            } else {
                
            }
        }
        return metadataMap;
    }
    
    public void changeObject() {
        isEdit = false;
        isDeploy = false;
        try {
            retrieveRecords();
            fieldDeployMap = new Map<String, List<String>>();
            for(String field : fieldDescriptionMap.keySet()) {
                fieldDeployMap.put(field, new List<String>(fieldDescriptionMap.get(field)));
                String gdpr = fieldGDPRMap.get(field) ? 'true' : 'false';
                fieldDeployMap.get(field).add(gdpr);
            }
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You don\'t have rights on the ' + selectedObject));
          }
    }
    
    public void changeProfile() {
        
    }
    
    public void Edit() {
        for(String field : fieldDescriptionMap.keySet()) {
        
        }
        isEdit = true;
    }
    
    public void SaveMap() {
        for(String field : fieldDescriptionMap.keySet()) {
            String gdpr = fieldGDPRMap.get(field) ? 'true' : 'false';
            if(fieldDescriptionMap.get(field)[0] != fieldDeployMap.get(field)[0] 
               || fieldDescriptionMap.get(field)[1] != fieldDeployMap.get(field)[1]
               || fieldDeployMap.get(field)[3] != gdpr){
                   isDeploy = true;
                   break;
               } else {
                   isDeploy = false;
               }
        }
              isEdit = false;
        
    }
    
    public void Cancel() {
        isEdit = false;
        fieldDescriptionMap = new Map<String, List<String>>();
        fieldGDPRMap = new Map<String, Boolean>();
        for(String field : fieldDeployMap.keySet()) {
            fieldDescriptionMap.put(field, new List<String>(fieldDeployMap.get(field)));
            Boolean gdpr = fieldDeployMap.get(field)[3] == 'true' ? true : false;
            fieldGDPRMap.put(field, gdpr);
        }
    }
    
    public void SelectObjectForExportToExcel() {
        isReadyToDownload = true;
        if(selectedObjectsList.size() > 50) {  
            objectsList.addAll(selectedObjectsList);		 
            selectedObjectsList = new List<SelectOption>();
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'You can Export to Excel only 50 Objects');
            ApexPages.addMessage(myMsg);
            displayPopup = true;
        } else if(selectedObjectsList.size() == 0) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,'Select at least one object up to 50');
            ApexPages.addMessage(myMsg);
            displayPopup = true;
        } else {
            displayPopup = false;
        }
        objectsList.addAll(selectedObjectsList);
        objectsList = SecurityUtil.sortAfterLabelSelectOptionList(objectsList);
      
    }
    
    public PageReference ExportToExcel() {
        if(selectedObjectsList.size() == 0) {
            ddWList.add(new DataDictionaryWrapper(selectedObject, fieldDescriptionMap, fieldGDPRMap));
        } else {
            Set<String> selectedObjAPISet = new Set<String>();
            for(SelectOption obj : selectedObjectsList) {
                
                selectedObjAPISet.add(obj.getValue()); 
            }
            
            List<SA_Audit__Sensitive_Data__c> gdprObjectList = [SELECT Id, Name FROM SA_Audit__Sensitive_Data__c WHERE Name IN :selectedObjAPISet];
            Map<String, Id> sdMap = new Map<String, Id>();
            for(SA_Audit__Sensitive_Data__c sd: gdprObjectList) {
                sdMap.put(sd.Name, sd.Id);
            }
            List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsList = new List<SA_Audit__Sensitive_Data_Field__c>();
            gdprFieldsList = [SELECT ID, Name, SA_Audit__Sensitive_Data__c, SA_Audit__Sensitive_Field_API__c 
                              FROM SA_Audit__Sensitive_Data_Field__c WHERE SA_Audit__Sensitive_Data_ObjectId__c IN :gdprObjectList];
            for(SelectOption obj : selectedObjectsList) {
                fieldGDPRMap = new Map<String, Boolean>();
                if(sdMap.containsKey(obj.getValue())) {
                    for(SA_Audit__Sensitive_Data_Field__c gdprField : gdprFieldsList) {
                        if(gdprField.Id == sdMap.get(obj.getValue())) {
                            fieldGDPRMap.put(gdprField.SA_Audit__Sensitive_Field_API__c, gdprField.SA_Audit__Sensitive_Data__c);
                        }
                    }
                }
                selectedObject = obj.getValue();
                createDescriptionMap();
                ddWList.add(new DataDictionaryWrapper(obj.getLabel(), fieldDescriptionMap, fieldGDPRMap));
            }
        }
        selectedObject = 'Account';
        selectedObjectsList = new List<SelectOption>();
        //system.debug('ddWList.size::' + ddWList.size());
        return Page.DataDictionaryExportToExcel;
    }
    
    public PageReference reportSensitiveData() {

        sensitiveDataReportWrapperList = new List<SensitiveDataReportWrapper> ();
        List<SA_Audit__Sensitive_Data__c> gdprObjectListReport = new List<SA_Audit__Sensitive_Data__c>();
        gdprObjectListReport = [SELECT Id, Name FROM SA_Audit__Sensitive_Data__c LIMIT 2000];
        Map<Id, String> sdMap = new Map<Id, String>();
        for(SA_Audit__Sensitive_Data__c sd: gdprObjectListReport) {
            sdMap.put(sd.Id, sd.Name);
        }
        List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsListReport = new List<SA_Audit__Sensitive_Data_Field__c>();
        gdprFieldsListReport = [SELECT ID, Name, SA_Audit__Sensitive_Data__c, SA_Audit__Sensitive_Field_API__c, SA_Audit__Description__c, 
                                SA_Audit__Help__c, SA_Audit__Sensitive_Data_ObjectId__c
                                FROM SA_Audit__Sensitive_Data_Field__c 
                                WHERE SA_Audit__Sensitive_Data_ObjectId__c IN :gdprObjectListReport
                                AND SA_Audit__Sensitive_Data__c = true];
        
        for(SA_Audit__Sensitive_Data_Field__c sd : gdprFieldsListReport) {
            sensitiveDataReportWrapperList.add(new SensitiveDataReportWrapper(sdMap.get(sd.SA_Audit__Sensitive_Data_ObjectId__c), 
                                                                              sd.SA_Audit__Sensitive_Field_API__c, sd.SA_Audit__Help__c, sd.SA_Audit__Description__c,
                                                                              sd.SA_Audit__Sensitive_Data__c)
                                              );
        }

        return Page.DataDictionaryReport;
    }
    
    public void yesPopUp() {
        displayPopUp = true;
        isReadyToDownload = false;
        selectedObjectsList = new List<SelectOption>();

    }
    
    public void closePopup() {
        objectsList.addAll(selectedObjectsList);
        selectedObjectsList = new List<SelectOption>();
        objectsList = SecurityUtil.sortAfterLabelSelectOptionList(objectsList);
        displayPopup = false;
    }
    
    //methods for metadata deploy
    
    public String getPackageXml() {
        Map<String, MetadataService.CustomField> metadataMap = new Map<String, MetadataService.CustomField>();
        //Map<String, DataDictionaryService.CustomField> metadataMap = new Map<String, DataDictionaryService.CustomField>();
        metadataMap = readCustomObjectForDeploy(selectedObject);
        String packageXml = '<?xml version="1.0" encoding="UTF-8"?>';
        packageXml += '<Package xmlns="http://soap.sforce.com/2006/04/metadata">';
        packageXml += '<types>';
        for(String field : fieldDescriptionMap.keySet()) {
            if(fieldDescriptionMap.get(field)[0] != fieldDeployMap.get(field)[0] 
               || fieldDescriptionMap.get(field)[1] != fieldDeployMap.get(field)[1]){
                   
                   String fieldname = field.substringBeforeLast(')');
                   fieldname = fieldname.substringAfterLast('(');
                   fieldname = fieldname.toLowerCase();
                   if(!metadataMap.containsKey(fieldname)) continue;
                   packageXml += '<members>' + selectedObject + '.' + metadataMap.get(fieldname).fullName + '</members>';
                   
               }
        }
        packageXml += '<name>CustomField</name>';
        packageXml += '</types>';
        packageXml += '<version>41.0</version>';
        packageXml += '</Package>';
        return packageXml;
    }
    
    public String getNewDescription() {
        
        Map<String, DataDictionaryService.CustomField> metadataMap = new Map<String, DataDictionaryService.CustomField>();
        metadataMap = readCustomObjectForDeploy1(selectedObject);
        system.debug('testing line');
        String packageXml = '<?xml version="1.0" encoding="UTF-8"?>';
        packageXml += '<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">';
        for(String field : fieldDescriptionMap.keySet()) {
            system.debug('testing line--fieldDescriptionMap='+fieldDescriptionMap);
            system.debug('testing line');
            if(fieldDescriptionMap.get(field)[0] != fieldDeployMap.get(field)[0] 
               || fieldDescriptionMap.get(field)[1] != fieldDeployMap.get(field)[1]){
                   system.debug('testing line');
                   String fieldname = field.substringBeforeLast(')');
                   system.debug('fieldname'+ fieldname);
                   fieldname = fieldname.substringAfterLast('(');
                   system.debug('fieldname'+ fieldname);
                   fieldname = fieldname.toLowerCase();
                   system.debug('fieldname'+ fieldname);
                  
                   
                   if(!metadataMap.containsKey(fieldname)) {
                       system.debug('testing line');
                       
                       continue;
                   }
                if( metadataMap.get(fieldname).type_x == null) {
                    system.debug('testing line');
                       packageXml += '<fields>';
                       packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                       packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                       packageXml += '</fields>';
                   } else {
                       system.debug('testing line');
                       if (metadataMap.get(fieldname).type_x == 'Number'){
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Number</type>';
                           packageXml += '<precision>' + metadataMap.get(fieldname).precision + '</precision>';
                           packageXml += '<scale>' + metadataMap.get(fieldname).scale + '</scale>';
                          
                           system.debug('$#$# fieldname123::' + fieldname);
                           System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                           system.debug('$#$# fieldname123::' + fieldname);
                           System.debug('$#$# metadataMap????' + metadataMap);
                           system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                           system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           // 
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                               system.debug('$#$# fieldname123::' + fieldname);
                               System.debug('$#$# metadataMap????' + metadataMap);
                               system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                               system.debug('$#$# val:::' + metadataMap.get(fieldname));
                               // 
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                               System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                               system.debug('$#$# fieldname123::' + fieldname);
                               System.debug('$#$# metadataMap????' + metadataMap);
                               system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                               system.debug('$#$# val:::' + metadataMap.get(fieldname));
                                
                           }
                           packageXml += '</fields>';
                       }
                       if (metadataMap.get(fieldname).type_x == 'Text'){
                           system.debug('testing line');
                            packageXml += '<fields>';
                           packageXml += '<fullName>' + metadataMap.get(fieldname).fullName + '</fullName>';
                           system.debug('packageXml'+packageXml);
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Text</type>';
                           
                           
                           if(metadataMap.get(fieldname).length != null) {
                               system.debug('testing line');
                               packageXml += '<length>' + metadataMap.get(fieldname).length  + '</length>';
                               system.debug('packageXml==='+packageXml);
                                                  
                           }
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               
                           }
                           if(metadataMap.get(fieldname). formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                        
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'LongTextArea'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>' + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>LongTextArea</type>';
                           packageXml += '<visibleLines>' + metadataMap.get(fieldname).visibleLines  + '</visibleLines>';
                          // System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                          // system.debug('$#$# fieldname123::' + fieldname);
                          // System.debug('$#$# metadataMap????' + metadataMap);
                         //  system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                         //  system.debug('$#$# val:::' + metadataMap.get(fieldname));
                         //   
                           if(metadataMap.get(fieldname).length != null) {
                               system.debug('testing line');
                               packageXml += '<length>' + metadataMap.get(fieldname).length  + '</length>';
                             //  System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                             //  system.debug('$#$# fieldname123::' + fieldname);
                             //  System.debug('$#$# metadataMap????' + metadataMap);
                             //  system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                             //  system.debug('$#$# val:::' + metadataMap.get(fieldname));
                            //    
                           }
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                             //  System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                             //  system.debug('$#$# fieldname123::' + fieldname);
                             //  System.debug('$#$# metadataMap????' + metadataMap);
                             //  system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                             //  system.debug('$#$# val:::' + metadataMap.get(fieldname));
                             //   
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           //    System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                           //    system.debug('$#$# fieldname123::' + fieldname);
                           //    System.debug('$#$# metadataMap????' + metadataMap);
                           //    system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                           //    system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           //     
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if(metadataMap.get(fieldname).type_x == 'Html') {
							system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>' + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Html</type>';
                           packageXml += '<visibleLines>' + metadataMap.get(fieldname).visibleLines  + '</visibleLines>';
                         //  System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                         //  system.debug('$#$# fieldname123::' + fieldname);
                         //  System.debug('$#$# metadataMap????' + metadataMap);
                         //  system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                         //  system.debug('$#$# val:::' + metadataMap.get(fieldname));
                        //    
                           if(metadataMap.get(fieldname).length != null) {
                               system.debug('testing line');
                               packageXml += '<length>' + metadataMap.get(fieldname).length  + '</length>';
                          //     System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                          //     system.debug('$#$# fieldname123::' + fieldname);
                          //     System.debug('$#$# metadataMap????' + metadataMap);
                          //     system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                          //     system.debug('$#$# val:::' + metadataMap.get(fieldname));
                          //      
                           }
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                          //     System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                          //     system.debug('$#$# fieldname123::' + fieldname);
                          //     System.debug('$#$# metadataMap????' + metadataMap);
                          //     system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                          //     system.debug('$#$# val:::' + metadataMap.get(fieldname));
                          //      
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                          //     System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                          //     system.debug('$#$# fieldname123::' + fieldname);
                          //     System.debug('$#$# metadataMap????' + metadataMap);
                          //     system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                          //     system.debug('$#$# val:::' + metadataMap.get(fieldname));
                          //      
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'EncryptedText' ){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>' + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>EncryptedText</type>';
                           packageXml += '<maskChar>' + metadataMap.get(fieldname).maskChar + '</maskChar>';
                           packageXml += '<maskType>' + metadataMap.get(fieldname).maskType  + '</maskType>';
                           if(metadataMap.get(fieldname).length != null) {
                               system.debug('testing line');
                               packageXml += '<length>' + metadataMap.get(fieldname).length  + '</length>';
                           }
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'TextArea'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>' + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>TextArea</type>';
                        //   System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                        //   system.debug('$#$# fieldname123::' + fieldname);
                        //   System.debug('$#$# metadataMap????' + metadataMap);
                        //   system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                        //   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                        //    
                           if(metadataMap.get(fieldname).length != null) {
                               system.debug('testing line');
                               packageXml += '<length>' + metadataMap.get(fieldname).length  + '</length>';
                           }
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Date'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Date</type>';
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'DateTime'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>DateTime</type>';
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Percent'){
                           system.debug('testing line');

                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Percent</type>';
                           packageXml += '<precision>' + metadataMap.get(fieldname).precision + '</precision>';
                           packageXml += '<scale>' + metadataMap.get(fieldname).scale + '</scale>';	
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Checkbox'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Checkbox</type>';
                       //    System.debug('$#$# metadataMap.get(fieldname).type_x ' + metadataMap.get(fieldname).type_x);
                       //    system.debug('$#$# fieldname123::' + fieldname);
                       //    System.debug('$#$# metadataMap????' + metadataMap);
                       //    system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                       //    system.debug('$#$# val:::' + metadataMap.get(fieldname));
                       //     
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula == null) {
                               system.debug('testing line');
                               packageXml += '<defaultValue>' + metadataMap.get(fieldname).defaultValue + '</defaultValue>';								   }
                           
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Currency'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Currency</type>';
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           packageXml += '<precision>' + metadataMap.get(fieldname).precision + '</precision>';
                           packageXml += '<scale>' + metadataMap.get(fieldname).scale + '</scale>';
                           if(metadataMap.get(fieldname).formula != null) {
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Email'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Email</type>';
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                       }
                       if (metadataMap.get(fieldname).type_x == 'Location'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Location</type>';
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           packageXml += '<scale>' + metadataMap.get(fieldname).scale + '</scale>';
                           if(metadataMap.get(fieldname).formula != null) {
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Phone'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Phone</type>';
                        //   system.debug('$#$# fieldname123::' + fieldname);
                        //   System.debug('$#$# metadataMap????' + metadataMap);
                        //   system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                        //   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               system.debug('testing line');
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Time'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Time</type>';
                           if(fieldname.contains('__c')) {
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Url'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Url</type>';
                       //    system.debug('$#$# fieldname123::' + fieldname);
                       //    System.debug('$#$# metadataMap????' + metadataMap);
                       //    system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                       //    system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'Hierarchy'){
                           system.debug('testing line');
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Hierarchy</type>';
                     //      system.debug('$#$# fieldname123::' + fieldname);
                     //      System.debug('$#$# metadataMap????' + metadataMap);
                     //     system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                     //     system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               system.debug('$#$# fieldname123::' + fieldname);
                               System.debug('$#$# metadataMap????' + metadataMap);
                               system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                               system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                               system.debug('$#$# fieldname123::' + fieldname);
                               System.debug('$#$# metadataMap????' + metadataMap);
                               system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                               system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           }
                           packageXml += '</fields>';
                       }
                       if (metadataMap.get(fieldname).type_x == 'Picklist'){
                           system.debug('testing line');
                           System.debug('testing  metadataMap.get(fieldname).fullName????' + metadataMap.get(fieldname).fullName);
                           System.debug('testing fieldDescriptionMap.get(field)[0]????' + fieldDescriptionMap.get(field)[0]);
                           //System.debug('testing  fieldDescriptionMap.get(field)[1]????' + fieldDescriptionMap.get(field)[1]);
                           //system.debug('testing ' + metadataMap.get(fieldname).valueSet.valueSetDefinition);
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Picklist</type>';
                          // system.debug('$#$# fieldname123::' + fieldname);
                           //System.debug('$#$# metadataMap????' + metadataMap);
                           //system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                           //system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               system.debug('testing packagexml'+packageXml);
                               
                               //System.debug('$#$# metadataMap.get(fieldname).label????' + metadataMap.get(fieldname).label);
                               //system.debug('$#$# fieldname123::' + fieldname);
                               //System.debug('$#$# metadataMap????' + metadataMap);
                             //  system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                               //system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           }
                           
                           //System.debug('$#$# fieldname' + fieldname);
                           //system.debug('$#$# metadataMap'+ metadataMap);
                           if(metadataMap.get(fieldname).valueSet != null && fieldname.contains('__c')){
                               system.debug('testing line');
                               packageXml += '<StandardValueSet>';
                               System.debug('$#$# metadataMap.get(fieldname).valueSet' + metadataMap.get(fieldname).valueSet);
                               if(metadataMap.get(fieldname).valueSet.controllingField != null) {
                                   system.debug('testing line');
                                   packageXml += '<controllingField>' + metadataMap.get(fieldname).valueSet.controllingField + '</controllingField>';
                               }
                               System.debug('$#$# metadataMap.get(fieldname).valueSet.controllingField????' + metadataMap.get(fieldname).valueSet.controllingField);
                               system.debug('$#$# metadataMap'+ metadataMap);
                               if(metadataMap.get(fieldname).valueSet.restricted != null) {
                                   system.debug('testing line');
                                   packageXml += '<restricted>' + metadataMap.get(fieldname).valueSet.restricted + '</restricted>';
                               }
                               System.debug('$#$# metadataMap.get(fieldname).valueSet.restricted????' + metadataMap.get(fieldname).valueSet.restricted);
                               system.debug('$#$# metadataMap'+ metadataMap);
                               //packageXml += '<valueSetName>' + metadataMap.get(fieldname).valueSet.valueSetName + '</valueSetName>';
                               
                               if(metadataMap.get(fieldname).valueSet.valueSetName == null) {
                                   system.debug('testing line');
                                   //  packageXml += '<valueSetDefinition>';
                                   
                                   system.debug('$#$# fieldname123::' + fieldname);
                                   System.debug('$#$# metadataMap????' + metadataMap);
                                   //system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);.
                                   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                                
                                   // for(DataDictionaryService.CustomValue val : metadataMap.get(fieldname).valueSet.valueSetDefinition.value) {
                                   for(DataDictionaryService.CustomValue val :metadataMap.get(fieldname).valueSet.valueSetDefinition.value) {
                                       system.debug('testing line');
                                       packageXml += '<value>';
                                       packageXml += '<fullName>' + val.fullName + '</fullName>';
                                       //packageXml += '<controllingFieldValues>' + val.fullName + '</controllingFieldValues>';
                                       //packageXml += '<default>' + val.fullName + '</default>';
                                       packageXml += '</value>';
                                       system.debug('$#$# valfullname:::' + val.fullName);
                                       system.debug('$#$# for+val'+ val);
                                       system.debug('$#$# fieldname123::' + fieldname);
                                       System.debug('$#$# metadataMap????' + metadataMap);
                                       //system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                                       system.debug('$#$# val:::' + metadataMap.get(fieldname));
                                   }
                                   
                                   
                                   
                                   system.debug('testing line');
                                   
                                   
                                   
                                   
                                   packageXml += '</valueSetDefinition>';
                               } else {
                                   system.debug('testing line');
                                   packageXml += '<valueSetName>';
                                   packageXml += metadataMap.get(fieldname).valueSet.valueSetName;
                                   packageXml += '</valueSetName>';
                                   system.debug('$#$#val_else:::' + metadataMap.get(fieldname));
                                   
                               }
                               packageXml += '</valueSet>';
                           } /*else if(metadataMap.get(fieldname).picklist != null){
if(metadataMap.get(fieldname).picklist.controllingField != null) {
packageXml += '<controllingField>' + metadataMap.get(fieldname).picklist.controllingField + '</controllingField>';
}
if(metadataMap.get(fieldname).picklist.restrictedPicklist != null) {
packageXml += '<restrictedPicklist>' + metadataMap.get(fieldname).picklist.restrictedPicklist + '</restrictedPicklist>';
}
packageXml += '<picklistValues>';
for(MetadataService.PicklistValue val : metadataMap.get(fieldname).picklist.PicklistValue) {
packageXml += '<picklistValues>';
packageXml += '<fullName>' + val.fullName + '</fullName>';
packageXml += '</picklistValues>';
}
packageXml += '</picklistValues>';
}*/
                           packageXml += '</fields>';
                       }
                       
                       if (metadataMap.get(fieldname).type_x == 'MultiselectPicklist'){
                           system.debug('testing line');
                           system.debug('$#$#FieldName.valuedef::' + metadataMap.get(fieldname).valueSet.valueSetDefinition);
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>MultiselectPicklist</type>';
                           packageXml += '<visibleLines>' + metadataMap.get(fieldname).visibleLines + '</visibleLines>';
                           system.debug('$#$# fieldname123::' + fieldname);
                           System.debug('$#$# metadataMap????' + metadataMap);
                           system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                           system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).valueSet != null) {
                               system.debug('testing line');
                               packageXml += '<valueSet>';
                               //packageXml += '<controllingField>' + metadataMap.get(fieldname).valueSet.controllingField + '</controllingField>';
                               if(metadataMap.get(fieldname).valueSet.restricted != null) {
                                   system.debug('testing line');
                                   packageXml += '<restricted>' + metadataMap.get(fieldname).valueSet.restricted + '</restricted>';
                               }
                               //packageXml += '<valueSetName>' + metadataMap.get(fieldname).valueSet.valueSetName + '</valueSetName>';
                               packageXml += '<valueSetDefinition>';
                               for(DataDictionaryService.CustomValue val : metadataMap.get(fieldname).valueSet.valueSetDefinition.value) {
                                   system.debug('testing line');
                                   //system.debug('val:::' + val.fullName);
                                   packageXml += '<value>';
                                   packageXml += '<fullName>' + val.fullName + '</fullName>';
                                   //packageXml += '<controllingFieldValues>' + val.fullName + '</controllingFieldValues>';
                                   //packageXml += '<default>' + val.fullName + '</default>';
                                   packageXml += '</value>';
                                   system.debug('$#$# fieldname123::' + fieldname);
                                   System.debug('$#$# metadataMap????' + metadataMap);
                                   system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                                   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                               }
                               packageXml += '</valueSetDefinition>';
                               packageXml += '</valueSet>';
                           }
                           packageXml += '</fields>';
                           system.debug('testing line');
                       }
                       if (metadataMap.get(fieldname).type_x == 'AutoNumber'){
                           system.debug('testing line');
                           system.debug('$#$# FieldName::' + metadataMap.get(fieldname));
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>AutoNumber</type>';
                        //   system.debug('$#$# fieldname123::' + fieldname);
                        //   System.debug('$#$# metadataMap????' + metadataMap);
                        //   system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                        //   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                           }
                           if(metadataMap.get(fieldname).formula != null) {
                               system.debug('testing line');
                               packageXml += '<formula>' + metadataMap.get(fieldname).formula + '</formula>';
                           }
                           packageXml += '</fields>';
                       }
                       if (metadataMap.get(fieldname).type_x == 'Lookup'){
                           system.debug('testing line');
                           system.debug('$#$#FieldName::' + metadataMap.get(fieldname));
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>Lookup</type>';
                        //   system.debug('$#$#fieldname123::' + fieldname);
                        //   System.debug('$#$#metadataMap????' + metadataMap);
                       //    system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                        //   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               packageXml += '<referenceTo>' + metadataMap.get(fieldname).referenceTo + '</referenceTo>';
                               packageXml += '<relationshipName>' + metadataMap.get(fieldname).relationshipName + '</relationshipName>';
                           }
                           packageXml += '</fields>';
                       }
                       if (metadataMap.get(fieldname).type_x == 'MasterDetail'){
                           system.debug('testing line');
                           system.debug('$#$#fieldname123::' + metadataMap.get(fieldname));
                           packageXml += '<fields>';
                           packageXml += '<fullName>'  + metadataMap.get(fieldname).fullName + '</fullName>';
                           packageXml += '<description>' + fieldDescriptionMap.get(field)[0] + '</description>';
                           packageXml += '<inlineHelpText>' + fieldDescriptionMap.get(field)[1] + '</inlineHelpText>';
                           packageXml += '<type>MasterDetail</type>';
                        //   system.debug('$#$#fieldname123::' + fieldname);
                        //   System.debug('$#$#metadataMap????' + metadataMap);
                        //   system.debug('$#$# metadataMap.field'+ metadataMap.get(fieldname).valueSet);
                        //   system.debug('$#$# val:::' + metadataMap.get(fieldname));
                           if(fieldname.contains('__c')) {
                               system.debug('testing line');
                               packageXml += '<label>' + metadataMap.get(fieldname).label + '</label>';
                               packageXml += '<referenceTo>' + metadataMap.get(fieldname).referenceTo + '</referenceTo>';
                               packageXml += '<relationshipName>' + metadataMap.get(fieldname).relationshipName + '</relationshipName>';
                           }
                           packageXml += '</fields>';
                       }
                       //} else {}
                   }   
               }
        }
        
        packageXml += '</CustomObject>';
        //system.debug('packageXml::' + packageXml);
        return packageXml;
        /*}catch(Exception e){
system.debug('Error'+ e.getMessage() + 'stackTrace '+e.getStackTraceString());

return null;
}*/
    }
    public PageReference checkAsyncRequest() {
        // Check the status of the retrieve request
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployResult deployResult = service.checkDeployStatus(AsyncResult.Id, true);
        if(deployResult.done) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deployment complete'));
            
            // Deployment errors?
            if(deployResult.details!=null && deployResult.details.componentFailures!=null)
                for(MetadataService.DeployMessage deployMessage : deployResult.details.componentFailures)
                if(deployMessage.problem!=null)
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.Error, 
                                          deployMessage.fileName + 
                                          ' (Line: ' + deployMessage.lineNumber + ': Column:' + deployMessage.columnNumber + ') : ' + 
                                          deployMessage.problem));
            AsyncResult = null;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
        }   
        return null;
    } 
    
    public void Deploy() {
        //system.debug('isDeploy::' + isDeploy);
        isDeploy = false;
        //system.debug('isDeploy::' + isDeploy);
        Boolean messageDisplayed = false;
        for(String field : fieldDescriptionMap.keySet()) {
            if(fieldDescriptionMap.get(field)[0] != fieldDeployMap.get(field)[0] 
               || fieldDescriptionMap.get(field)[1] != fieldDeployMap.get(field)[1]){
                   messageDisplayed = true;
               }
        }
        if(messageDisplayed) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Your changes are queued for deploy. Please wait for the deploy to complete before making further changes  to this object. You can monitor the deploy status in the setup menu under Deployment Status'));
            
        }
        
    }
    
    public PageReference deployZip() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Deploying...'));
        //system.debug('ZipData::' + ZipData);
        // Deploy zip file posted back from the page action function				
        MetadataService.MetadataPort service = createService();
        MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
        deployOptions.allowMissingFiles = false;
        deployOptions.autoUpdatePackage = false;
        deployOptions.checkOnly = false;
        deployOptions.ignoreWarnings = false;
        deployOptions.performRetrieve = false;
        deployOptions.purgeOnDelete = false;
        deployOptions.rollbackOnError = true;
        deployOptions.testLevel = 'RunSpecifiedTests';
        String[] tests = new List<String>();
        tests.add('');
        deployOptions.runTests = tests;
        deployOptions.singlePackage = true;	 
        AsyncResult = service.deploy(ZipData, DeployOptions);
        //system.debug('AsyncResult::' + AsyncResult);
        //fieldDeployMap = fieldDescriptionMap;
        isDeploy = false;
        
        //save GDPR in the GDPR Object and GDPR Fields
        List<SA_Audit__Sensitive_Data__c> gdprObjectList = [SELECT Id, Name FROM SA_Audit__Sensitive_Data__c WHERE Name = :selectedObject];
        Id gdprObjectId = null;
        for(SA_Audit__Sensitive_Data__c gdprObject : gdprObjectList) {
            if(gdprObject.Name == selectedObject) {
                gdprObjectId = gdprObject.Id;
            }
        }
        if(gdprObjectId != null) {
            List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsList = new List<SA_Audit__Sensitive_Data_Field__c>();
            List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsListToDelete = new List<SA_Audit__Sensitive_Data_Field__c>();
            List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsListToUpsert = new List<SA_Audit__Sensitive_Data_Field__c>();
            gdprFieldsList = [SELECT ID, Name, SA_Audit__Sensitive_Field_API__c, SA_Audit__Sensitive_Data__c, SA_Audit__Help__c, SA_Audit__Description__c 
                              FROM SA_Audit__Sensitive_Data_Field__c 
                              WHERE SA_Audit__Sensitive_Data_ObjectId__c = :gdprObjectId];
            Set<String> sensitiveFielAPISet = new Set<String>();
            for(SA_Audit__Sensitive_Data_Field__c gdprField : gdprFieldsList) {
                if(fieldGDPRMap.containsKey(gdprField.SA_Audit__Sensitive_Field_API__c)) {
                    if(gdprField.Sensitive_Data__c != fieldGDPRMap.get(gdprField.SA_Audit__Sensitive_Field_API__c)) {
                        if(Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data__c.isCreateable() && 
                           Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Description__c.isCreateable() &&
                           Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Help__c.isCreateable() && 
                           Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data__c.isUpdateable() &&
                           Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Description__c.isUpdateable() &&
                           Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Help__c.isUpdateable()){
                               gdprField.SA_Audit__Sensitive_Data__c = fieldGDPRMap.get(gdprField.SA_Audit__Sensitive_Field_API__c);
                               gdprField.SA_Audit__Description__c = fieldDescriptionMap.get(gdprField.SA_Audit__Sensitive_Field_API__c)[0];
                               gdprField.SA_Audit__Help__c = fieldDescriptionMap.get(gdprField.SA_Audit__Sensitive_Field_API__c)[1];
                               gdprFieldsListToUpsert.add(gdprField);
                           }
                        //system.debug('gdprField:: ' + gdprField);
                    } 
                    sensitiveFielAPISet.add(gdprField.SA_Audit__Sensitive_Field_API__c);
                } else {
                    gdprFieldsListToDelete.add(gdprField);
                }
            }
            for(String field : fieldGDPRMap.keySet()) {
                if(!sensitiveFielAPISet.contains(field)) {
                    SA_Audit__Sensitive_Data_Field__c gdprField = new SA_Audit__Sensitive_Data_Field__c();
                    if(Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Field_API__c.isCreateable() && 
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data__c.isCreateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data_ObjectId__c.isCreateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Description__c.isCreateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Help__c.isCreateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Field_API__c.isUpdateable() && 
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data__c.isUpdateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data_ObjectId__c.isUpdateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Description__c.isUpdateable() &&
                       Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Help__c.isUpdateable()){
                           gdprField.SA_Audit__Sensitive_Field_API__c = field;
                           gdprField.SA_Audit__Sensitive_Data__c = fieldGDPRMap.get(field);
                           gdprField.SA_Audit__Sensitive_Data_ObjectId__c = gdprObjectId;
                           gdprField.SA_Audit__Description__c = fieldDescriptionMap.get(field)[0];
                           gdprField.SA_Audit__Help__c = fieldDescriptionMap.get(field)[1];
                           gdprFieldsListToUpsert.add(gdprField);
                           
                       }
                }
            }
            if(SA_Audit__Sensitive_Data_Field__c.sObjectType.getDescribe().isDeletable()){
                delete gdprFieldsListToDelete;
            }
            upsert gdprFieldsListToUpsert;
        } else {
            SA_Audit__Sensitive_Data__c gdprObject = new SA_Audit__Sensitive_Data__c();
            if(Schema.sObjectType.SA_Audit__Sensitive_Data__c.fields.Name.isCreateable()){
                gdprObject.Name = selectedObject;
                insert gdprObject;
            }
            List<SA_Audit__Sensitive_Data_Field__c> gdprFieldsListToInsert = new List<SA_Audit__Sensitive_Data_Field__c>();
            for(String field : fieldGDPRMap.keySet()) {
                //if(fieldGDPRMap.get(field)) {
                SA_Audit__Sensitive_Data_Field__c gdprField = new SA_Audit__Sensitive_Data_Field__c();
                if(Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Field_API__c.isCreateable() && 
                   Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data__c.isCreateable() &&
                   Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Sensitive_Data_ObjectId__c.isCreateable() &&
                   Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Description__c.isCreateable() &&
                   Schema.sObjectType.SA_Audit__Sensitive_Data_Field__c.fields.SA_Audit__Help__c.isCreateable()){
                       gdprField.SA_Audit__Sensitive_Field_API__c = field;
                       gdprField.SA_Audit__Sensitive_Data__c = fieldGDPRMap.get(field);
                       gdprField.SA_Audit__Sensitive_Data_ObjectId__c = gdprObject.Id;
                       gdprField.SA_Audit__Description__c = fieldDescriptionMap.get(field)[0];
                       gdprField.SA_Audit__Help__c = fieldDescriptionMap.get(field)[1];
                       gdprFieldsListToInsert.add(gdprField);
                   }
                //}
            }
            //try {
            insert gdprFieldsListToInsert;
            
            //} catch(Exception e) {
            //  system.debug('Eroare save GDPR::' + e.getMessage());
            //}
        }
        fieldDeployMap = new Map<String, List<String>>();
        for(String field : fieldDescriptionMap.keySet()) {
            fieldDeployMap.put(field, new List<String>(fieldDescriptionMap.get(field)));
            String gdpr = fieldGDPRMap.get(field) ? 'true' : 'false';
            fieldDeployMap.get(field).add(gdpr);
        }
        return null;
    }
    
    public class DataDictionaryWrapper {
        public String objectName { get; set; }
        public Map<String, List<String>> fieldDescriptionMap { get; set; }
        //static Map<String, List<String>> fieldDeployMap;
        public Map<String, Boolean> fieldGDPRMap { get; set; }
        
        public DataDictionaryWrapper(String objectName, Map<String, List<String>> fieldDescriptionMap, Map<String, Boolean> fieldGDPRMap) {
            objectName = objectName.replaceAll('/', '');
            objectName = objectName.unescapeEcmaScript();
            //system.debug('objn:: ' + objectName);
            this.objectName = objectName;
            this.fieldDescriptionMap = fieldDescriptionMap;
            this.fieldGDPRMap = fieldGDPRMap;
        }
        
    }
    
    public class SensitiveDataReportWrapper {
        public String objName { get; set; }
        public String fieldName { get; set; }
        public String helpText { get; set; }
        public String description { get; set; }
        public Boolean sensitiveData { get; set; }
        
        public SensitiveDataReportWrapper(String objName , String fieldName, String helpText, String description, Boolean sensitiveData) {
            this.objName = objName;
            this.fieldName = fieldName;
            this.helpText = helpText;
            this.description = description;
            this.sensitiveData = sensitiveData;
        }
        
    }
    
    
}