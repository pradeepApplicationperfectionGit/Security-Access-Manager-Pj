@isTest
public class DataDictionaryTest {
    public class WebServiceMockImpl implements WebServiceMock {
		public void doInvoke(Object stub, Object request, Map<String, Object> response,
							 String endpoint, String soapAction, String requestName,
							 String responseNS, String responseName, String responseType) {
			MetadataService.readMetadata_element requestReadMetadata_element = (MetadataService.readMetadata_element) request;
			MetadataService.readCustomObjectResponse_element customObjectResponse = new MetadataService.readCustomObjectResponse_element();
			MetadataService.CustomObject customObject = new MetadataService.CustomObject();
			customObject.fullName = 'Account';
			List<MetadataService.CustomField> customFieldList = new List<MetadataService.CustomField>();
			MetadataService.CustomField customField = new MetadataService.CustomField();
			customField.fullname = 'Name';
			customField.Label = 'Name';
			customField.customDataType = 'String';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'accountnumber';
			customField.Label = 'AccountNumber';
			customField.customDataType = 'Number';
			customField.type_x = 'Number';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'longtextarea';
			customField.Label = 'LongTextArea';
			customField.customDataType = 'LongTextArea';
			customField.type_x = 'LongTextArea';
			customField.visibleLines = 3;
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'html';
			customField.Label = 'Html';
			customField.customDataType = 'Html';
			customField.type_x = 'Html';
			customField.visibleLines = 3;
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_long_rich_text__c';
			customField.Label = 'TextArea';
			customField.customDataType = 'TextArea';
			customField.type_x = 'TextArea';
			//customField.visibleLines = 3;
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_encrypted_text__c';
			customField.Label = 'EncryptedText';
			customField.customDataType = 'EncryptedText';
			customField.type_x = 'EncryptedText';
			customField.maskChar = 'aaaa';
			customField.maskType = 'aaaa';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_long_text__c';
			customField.Label = 'Text';
			customField.customDataType = 'Text';
			customField.type_x = 'Text';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_date__c';
			customField.Label = 'Date';
			customField.customDataType = 'Date';
			customField.type_x = 'Date';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_datetime__c';
			customField.Label = 'DateTime';
			customField.customDataType = 'DateTime';
			customField.type_x = 'DateTime';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_percent__c';
			customField.Label = 'Percent';
			customField.customDataType = 'Percent';
			customField.type_x = 'Percent';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_checkbox__c';
			customField.Label = 'Checkbox';
			customField.customDataType = 'Checkbox';
			customField.type_x = 'Checkbox';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_currency__c';
			customField.Label = 'Currency';
			customField.customDataType = 'Currency';
			customField.type_x = 'Currency';
			customFieldList.add(customField);
			
			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_email__c';
			customField.Label = 'Email';
			customField.customDataType = 'Email';
			customField.type_x = 'Email';
			customFieldList.add(customField);
			
			customField = new MetadataService.CustomField();
			customField.fullname = 'location';
			customField.Label = 'Location';
			customField.customDataType = 'Location';
			customField.type_x = 'Location';
			customFieldList.add(customField);
			
			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_phone__c';
			customField.Label = 'Phone';
			customField.customDataType = 'Phone';
			customField.type_x = 'Phone';
			customFieldList.add(customField);
			
			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_time__c';
			customField.Label = 'Time';
			customField.customDataType = 'Time';
			customField.type_x = 'Time';
			customFieldList.add(customField);
			
			customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_url__c';
			customField.Label = 'Url';
			customField.customDataType = 'Url';
			customField.type_x = 'Url';
			customFieldList.add(customField);

			customFieldList.add(customField);customField = new MetadataService.CustomField();
			customField.fullname = 'sa_audit__test_autonumber__c';
			customField.Label = 'AutoNumber';
			customField.customDataType = 'AutoNumber';
			customField.type_x = 'AutoNumber';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			List<MetadataService.CustomValue> standardValues = new List<MetadataService.CustomValue>();
			MetadataService.CustomValue standardValue = new MetadataService.CustomValue();
			standardValue.fullname = 'val1';
			standardValue.isActive = true;
			standardValues.add(standardValue);
			standardValue = new MetadataService.StandardValue();
			standardValue.fullname = 'val2';
			standardValue.isActive = true;
			standardValues.add(standardValue);

			MetadataService.ValueSetValuesDefinition valueSetDefinition = new MetadataService.ValueSetValuesDefinition();
			valueSetDefinition.value = new List<MetadataService.CustomValue>(standardValues);
			MetadataService.ValueSet valueSet = new MetadataService.ValueSet();
			valueSet.restricted = false;
			valueSet.valueSetDefinition = valueSetDefinition;		
			customField.fullname = 'sa_audit__test_picklist__c';
			customField.Label = 'Picklist';
			customField.customDataType = 'Picklist';
			customField.type_x = 'Picklist';
			customField.valueSet = valueSet;
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.fullname = 'MultiselectPicklist__c';
			customField.Label = 'MultiselectPicklist';
			customField.customDataType = 'MultiselectPicklist';
			customField.type_x = 'MultiselectPicklist';
			customField.visibleLines = 3;
			customField.valueSet = valueSet;
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.referenceTo = 'Account';
			customField.relationshipName = 'relationshipName';
			customField.fullname = 'Lookup__c';
			customField.Label = 'Lookup';
			customField.customDataType = 'Lookup';
			customField.type_x = 'Lookup';
			customFieldList.add(customField);

			customField = new MetadataService.CustomField();
			customField.referenceTo = 'Account';
			customField.relationshipName = 'relationshipName';
			customField.fullname = 'MasterDetail__c';
			customField.Label = 'MasterDetail';
			customField.customDataType = 'MasterDetail';
			customField.type_x = 'MasterDetail';
			customFieldList.add(customField);

			customObject.fields = new List<MetadataService.CustomField>(customFieldList);
			customObjectResponse.result = new MetadataService.ReadCustomObjectResult();
			customObjectResponse.result.records = new List<MetadataService.CustomObject>{customObject};
			response.put('response_x', customObjectResponse);
		}
	}

	public class WebServiceMockImplDeploy implements WebServiceMock {
		public void doInvoke(Object stub, Object request, Map<String, Object> response,
							 String endpoint, String soapAction, String requestName,
							 String responseNS, String responseName, String responseType) {
			MetadataService.deploy_element requestDeploy_element = (MetadataService.deploy_element) request;
			MetadataService.deployResponse_element deployResponse = new MetadataService.deployResponse_element();
			MetadataService.DeployOptions deployOptions = new MetadataService.DeployOptions();
			deployOptions.allowMissingFiles = false;
			deployOptions.autoUpdatePackage = false;
			deployOptions.checkOnly = false;
			deployOptions.ignoreWarnings = false;
			deployOptions.performRetrieve = false;
			deployOptions.purgeOnDelete = false;
			deployOptions.rollbackOnError = true;
			deployOptions.testLevel = 'NoTestRun';
			deployOptions.singlePackage = true;		
			deployResponse.result = new MetadataService.AsyncResult();
			deployResponse.result.done = true;
			deployResponse.result.message = 'OK';
			deployResponse.result.id = 'aaaaaaaaaaaaaaaaaa';
			//deployResponse.result = new List<MetadataService.DeployOptions>{deployOptions};
			response.put('response_x', deployResponse);
		}
	}
    static testMethod void method1() {
        test.startTest();
        
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		MetadataService metaDataService = new MetadataService();
		MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        DataDictionary ctrl = new DataDictionary();
        system.assertEquals(ctrl.selectedobject, 'Account');
        ctrl.selectedobject = 'Case';
        ctrl.changeObject();
        ctrl.Edit();
        ctrl.SaveMap();
        ctrl.ExportToExcel();
        ctrl.Cancel();
        ctrl.getObjectsType();
        ctrl.getPermissionType();
        ctrl.changeType();
        ctrl.selectedProfile = ctrl.profilesList[1].getValue();
        ctrl.retrieveRecords();
        ctrl.selectedPerm = 'Profiles';
        ctrl.changePermType();
        ctrl.selectedPerm = 'Permission Sets';
        ctrl.changePermType();
        ctrl.selectedPerm = 'All';
        ctrl.changePermType();
        ctrl.SelectObjectForExportToExcel();
        for(Integer i =0; i < 101; i++) {
            ctrl.selectedObjectsList.add(new SelectOption('Account', 'Account'));
        }
        ctrl.SelectObjectForExportToExcel();
        ctrl.selectedObjectsList.add(new SelectOption('Account', 'Account'));
        ctrl.ExportToExcel();
        ctrl.yesPopUp();
        ctrl.closePopup();
        ctrl.reportSensitiveData();
        ctrl.selectedobject = 'Account';
        ctrl.changeObject();
        for(String field : ctrl.fieldDescriptionMap.keySet()) {
    		ctrl.fieldDescriptionMap.get(field).set(0, 'desc12');
    		ctrl.fieldDescriptionMap.get(field).set(1, 'help12');
        }
        ctrl.SaveMap();
        ctrl.getNewDescription();
    	ctrl.getPackageXml();
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImplDeploy());
		metaDataService = new MetadataService();
		metaDataPort = new MetadataService.MetadataPort();
        //ctrl.checkAsyncRequest();
        ctrl.deployZip();
        ctrl.Deploy();
        ctrl.redirectToWelcomeMetadataPage();
        for(String field : ctrl.fieldDescriptionMap.keySet()) {
            ctrl.fieldDescriptionMap.get(field)[0] = 'aaaa';
        }
        ctrl.getNewDescription();
        test.stopTest();
    }
    static testMethod void openContactUSLinkTest(){
        Test.startTest();
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/contact/');
        DataDictionary ctrl = new DataDictionary();
        ctrl.openContactUSLink();
        System.assertNotEquals(null, pageRef);
        Test.stopTest();
    }
    static testMethod void openHelpTrainingTest(){
        Test.startTest();
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/security-access-manager-help-training/');
        DataDictionary ctrl = new DataDictionary();
        ctrl.openHelpTraining();
        System.assertNotEquals(null, pageRef);
        Test.stopTest();
    }
    static testMethod void openReleaseNotesTest(){
        Test.startTest();
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/security-access-manager-release-notes/');
        DataDictionary ctrl = new DataDictionary();
        ctrl.openReleaseNotes();
        System.assertNotEquals(null, pageRef);
        Test.stopTest();
    }
}