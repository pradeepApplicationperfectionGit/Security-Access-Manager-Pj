@isTest
private class RecordAccessTest {
	public class WebServiceMockImpl implements WebServiceMock {
			public void doInvoke(Object stub, Object request, Map<String, Object> response,
								 String endpoint, String soapAction, String requestName,
								 String responseNS, String responseName, String responseType)
			{
				if(request instanceof MetadataService.retrieve_element)
					response.put('response_x', new MetadataService.retrieveResponse_element());
				else if(request instanceof MetadataService.checkDeployStatus_element)
					response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
				else if(request instanceof MetadataService.listMetadata_element)
					response.put('response_x', new MetadataService.listMetadataResponse_element());
				else if(request instanceof MetadataService.checkRetrieveStatus_element)
					response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
				else if(request instanceof MetadataService.describeMetadata_element)
					response.put('response_x', new MetadataService.describeMetadataResponse_element());
				else if(request instanceof MetadataService.deploy_element)
					response.put('response_x', new MetadataService.deployResponse_element());
				else if(request instanceof MetadataService.updateMetadata_element)
					response.put('response_x', new MetadataService.updateMetadataResponse_element());
				else if(request instanceof MetadataService.renameMetadata_element)
					response.put('response_x', new MetadataService.renameMetadataResponse_element());
				else if(request instanceof  MetadataService.cancelDeploy_element)
					response.put('response_x', new MetadataService.cancelDeployResponse_element());
				else if(request instanceof  MetadataService.deleteMetadata_element)
					response.put('response_x', new MetadataService.deleteMetadataResponse_element());
				else if(request instanceof  MetadataService.upsertMetadata_element)
					response.put('response_x', new MetadataService.upsertMetadataResponse_element());
				else if(request instanceof  MetadataService.createMetadata_element)
					response.put('response_x', new MetadataService.createMetadataResponse_element());
				else if(request instanceof  MetadataService.deployRecentValidation_element)
					response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
				else if(request instanceof MetadataService.describeValueType_element)
					response.put('response_x', new MetadataService.describeValueTypeResponse_element());
				else if(request instanceof MetadataService.readMetadata_element) {
				   system.debug('request::' + request);
					MetadataService.readMetadata_element requestReadMetadata_element = (MetadataService.readMetadata_element) request;
					  // This allows you to generalize the mock response by type of metadata read
					  if (requestReadMetadata_element.type_x == 'SharingRules') { 
						  system.debug('request1::' + requestReadMetadata_element.type_x );
						  MetadataService.readSharingRulesResponse_element sharingRuleResponse = new MetadataService.readSharingRulesResponse_element();
						  MetadataService.SharingRules sharingRule = new MetadataService.SharingRules();
						  MetadataService.SharingCriteriaRule shrCritRule = new MetadataService.SharingCriteriaRule();
						  shrCritRule.fullName = 'Test';
						  sharingRule.fullName = 'SA_Audit__Test_Object__c';
						  sharingRule.sharingCriteriaRules = new List<MetadataService.SharingCriteriaRule>{shrCritRule};
						  sharingRuleResponse.result = new MetadataService.ReadSharingRulesResult();  
						  sharingRuleResponse.result.records = new List<MetadataService.SharingRules>{sharingRule};
						  response.put('response_x', sharingRuleResponse);
					  }
					  else if (requestReadMetadata_element.type_x == 'Profile') { 
						  //response.put('response_x', 'Profile:[Metadata.fullName=null, apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), applicationVisibilities=(ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=SA_Audit__Force_com, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=SA_Audit__Security_Access_Rights_Audit, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=false, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__AppLauncher, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Community, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Content, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__LightningSales, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Marketing, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Platform, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=false, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Sales, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=true, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileApplicationVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), application=standard__Service, application_type_info=(application, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(application, default_x, visible), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ...), applicationVisibilities_type_info=(applicationVisibilities, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), classAccesses=(ProfileApexClassAccess:[apexClass=SA_Audit__AsyncMetadataWSDL, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MetadataService, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MetadataServiceTest, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MetadataWSDL, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MetadataWSDLTest, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MultiselectController, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__MultiselectControllerTest, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__ObjectAccess, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__ObjectAccessTest, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ProfileApexClassAccess:[apexClass=SA_Audit__ObjectsAccessExportToExcel, apexClass_type_info=(apexClass, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexClass, enabled)], ...), classAccesses_type_info=(classAccesses, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), custom=true, customPermissions=null, customPermissions_type_info=(customPermissions, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), custom_type_info=(custom, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), description=null, description_type_info=(description, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), externalDataSourceAccesses=null, externalDataSourceAccesses_type_info=(externalDataSourceAccesses, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), fieldPermissions=(ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.AccountNumber, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.AccountSource, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.AnnualRevenue, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.BillingAddress, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=false, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.DandbCompanyId, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.Description, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=false, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.DunsNumber, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.Fax, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=true, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.Industry, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=true, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileFieldLevelSecurity:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), editable=false, editable_type_info=(editable, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field=Account.IsExcludedFromRealign, field_order_type_info=(editable, field, readable), field_type_info=(field, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), readable=false, readable_type_info=(readable, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ...), fieldPermissions_type_info=(fieldPermissions, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), field_order_type_info=(fullName, applicationVisibilities, classAccesses, custom, customPermissions, description, externalDataSourceAccesses, fieldPermissions, layoutAssignments, loginHours, ...), fullName=Marketing Manager, fullName_type_info=(fullName, http://www.w3.org/2001/XMLSchema, string, 0, 1, false), layoutAssignments=(ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Account-SA_Audit__Account Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Asset-SA_Audit__Asset Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Campaign-SA_Audit__Campaign Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=CampaignMember-SA_Audit__Campaign Member Page Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Case-SA_Audit__Case Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=CaseClose-SA_Audit__Close Case Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=CaseInteraction-SA_Audit__Case Feed Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Contact-SA_Audit__Contact Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=ContentVersion-SA_Audit__General, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileLayoutAssignment:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(layout, recordType), layout=Contract-SA_Audit__Contract Layout, layout_type_info=(layout, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), recordType=null, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ...), layoutAssignments_type_info=(layoutAssignments, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), loginHours=null, loginHours_type_info=(loginHours, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), loginIpRanges=null, loginIpRanges_type_info=(loginIpRanges, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), objectPermissions=(ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=true, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Account, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=true, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Asset, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=true, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Campaign, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=true, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=false, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Case, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Contact, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Contract, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=false, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=false, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=false, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=DandBCompany, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Document, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=false, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=false, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Idea, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ProfileObjectPermissions:[allowCreate=true, allowCreate_type_info=(allowCreate, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowDelete=true, allowDelete_type_info=(allowDelete, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowEdit=true, allowEdit_type_info=(allowEdit, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), allowRead=true, allowRead_type_info=(allowRead, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(allowCreate, allowDelete, allowEdit, allowRead, modifyAllRecords, object_x, viewAllRecords), modifyAllRecords=false, modifyAllRecords_type_info=(modifyAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), object_x=Lead, object_x_type_info=(object, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), viewAllRecords=false, viewAllRecords_type_info=(viewAllRecords, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false)], ...), objectPermissions_type_info=(objectPermissions, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), pageAccesses=(ProfileApexPageAccess:[apexPage=SA_Audit__ObjectAccess, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__ObjectAccessExportToExcel, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__ObjectAccessPDF, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__ObjectsAndFieldsAccess, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__ObjectsAndFieldsAccessExportToExcel, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__ObjectsAndFieldsAccessPDF, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__RecordAccess, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__RecordAccessPDF, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)], ProfileApexPageAccess:[apexPage=SA_Audit__WelcomeMetadataPage, apexPage_type_info=(apexPage, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=false, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(apexPage, enabled)]), pageAccesses_type_info=(pageAccesses, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), recordTypeVisibilities=(ProfileRecordTypeVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(default_x, personAccountDefault, recordType, visible), personAccountDefault=null, personAccountDefault_type_info=(personAccountDefault, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), recordType=Idea.SA_Audit__InternalIdeasIdeaRecordType, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visible=false, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileRecordTypeVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(default_x, personAccountDefault, recordType, visible), personAccountDefault=null, personAccountDefault_type_info=(personAccountDefault, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), recordType=SA_Audit__Test_Object__c.SA_Audit__Test_Record_Type1, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visible=false, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileRecordTypeVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), default_x=false, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(default_x, personAccountDefault, recordType, visible), personAccountDefault=null, personAccountDefault_type_info=(personAccountDefault, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), recordType=SA_Audit__Test_Object__c.SA_Audit__Test_Record_Type2, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visible=false, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileRecordTypeVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), default_x=true, default_x_type_info=(default, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(default_x, personAccountDefault, recordType, visible), personAccountDefault=null, personAccountDefault_type_info=(personAccountDefault, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), recordType=SA_Audit__Test_Object__c.SA_Audit__Test_Record_Type3, recordType_type_info=(recordType, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visible=true, visible_type_info=(visible, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)]), recordTypeVisibilities_type_info=(recordTypeVisibilities, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), tabVisibilities=(ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=SA_Audit__Object_Access, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=SA_Audit__Objects_Fields, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=SA_Audit__Record_Access, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Account, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-AppLauncher, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Asset, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Campaign, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Case, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Coaching, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileTabVisibility:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(tab, visibility), tab=standard-Contact, tab_type_info=(tab, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), visibility=DefaultOn, visibility_type_info=(visibility, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ...), tabVisibilities_type_info=(tabVisibilities, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), type=Profile, type_att_info=(xsi:type), userLicense=Salesforce, userLicense_type_info=(userLicense, http://soap.sforce.com/2006/04/metadata, null, 0, 1, false), userPermissions=(ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=AllowUniversalSearch, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=AllowViewKnowledge, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=ApiEnabled, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=AssignTopics, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=ChatterFileLink, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=ConvertLeads, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=CreateCustomizeFilters, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=CreateTopics, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=DistributeFromPersWksp, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ProfileUserPermission:[apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), enabled=true, enabled_type_info=(enabled, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false), field_order_type_info=(enabled, name), name=EditEvent, name_type_info=(name, http://soap.sforce.com/2006/04/metadata, null, 1, 1, false)], ...), userPermissions_type_info=(userPermissions, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false)]');
						  MetadataService.readProfileResponse_element profileResponse = new MetadataService.readProfileResponse_element();
						  MetadataService.Profile profile = new MetadataService.Profile();
						  MetadataService.ProfileRecordTypeVisibility recordType = new MetadataService.ProfileRecordTypeVisibility();
						  recordType.recordType = 'SA_Audit__Test_Record_Type2';
						  recordType.default_x = true;
						  profile.fullName = 'System Administrator';
						  profile.recordTypeVisibilities = new List<MetadataService.ProfileRecordTypeVisibility>{recordType};
						  profileResponse.result = new MetadataService.ReadProfileResult();
						  profileResponse.result.records =  new  List<MetadataService.Profile>{profile};
						  system.debug('response_x::' + profileResponse);
						  response.put('response_x', profileResponse);
					  }
				}
					//system.debug('request:::' + request); 
					//response.put('response_x', 'SharingRules:[Metadata.fullName=null, apex_schema_type_info=(http://soap.sforce.com/2006/04/metadata, true, false), field_order_type_info=(fullName, sharingCriteriaRules, sharingOwnerRules, sharingTerritoryRules), fullName=SA_Audit__Test_Object__c, fullName_type_info=(fullName, http://www.w3.org/2001/XMLSchema, string, 0, 1, false), sharingCriteriaRules=null, sharingCriteriaRules_type_info=(sharingCriteriaRules, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), sharingOwnerRules=null, sharingOwnerRules_type_info=(sharingOwnerRules, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), sharingTerritoryRules=null, sharingTerritoryRules_type_info=(sharingTerritoryRules, http://soap.sforce.com/2006/04/metadata, null, 0, -1, false), type=SharingRules, type_att_info=(xsi:type)]');
					//response.put('response_x', new MetadataService.readMetadataResponse_element());IReadResponseElement
					//response.put('response_x', new MetadataService.readProfileResponse_element());
				return;
			}
		}

	static testMethod void testWrongID() {
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Case testCase = new Case();
		insert testCase;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
		
		Test.startTest();
		 
		RecordAccess ctrl = new RecordAccess();
 		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		MetadataService metaDataService = new MetadataService();
		MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();

		ctrl.currentId = testCase.Id;
        //ctrl.dummycontact.OwnerId = UserInfo.getUserId();
		ctrl.Go();
		system.assertEquals(ctrl.sObjName, 'Case');
		ctrl.currentId = '0012400000mWwRu';
		ctrl.Go();
		system.assertEquals(ctrl.noError, false);
		Test.stopTest();
	}
	
	static testMethod void testCustomObject() {
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
		
		SA_Audit__Test_Object__c testObj = new SA_Audit__Test_Object__c();
		testObj.SA_Audit__Test_Field__c = 'Test';
		insert testObj;
		
		Test.startTest();
		 
		RecordAccess ctrl = new RecordAccess();
		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		MetadataService metaDataService = new MetadataService();
		MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
		ctrl.currentId = testObj.Id;
        //ctrl.dummycontact.OwnerId = UserInfo.getUserId();
		ctrl.Go();
		system.assertEquals(ctrl.sObjName, 'SA_Audit__Test_Object__c');
		Test.stopTest();
	}
	
	
	static testMethod void myUnitTest() {
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;
		
		Contact cont = new Contact();
		cont.FirstName='Test';
		cont.LastName='Test';
		cont.Accountid= testAccount.id;
		insert cont;
		
		SA_Audit__Test_Object__c testObj = new SA_Audit__Test_Object__c();
		testObj.SA_Audit__Test_Field__c = 'Test';
		insert testObj;
		
		User u = new User(
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
			LastName = 'last',
			Email = 'puser000@amamama.com',
			Username = 'puser000@amamama.com' + System.currentTimeMillis(),
			CompanyName = 'TEST',
			Title = 'title',
			Alias = 'alias',
			TimeZoneSidKey = 'America/Los_Angeles',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US'
			//UserRoleId = r.Id
		);
		
		User u1 = new User(
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
			LastName = 'last1',
			Email = 'puser000@amamama.com',
			Username = 'puser000@amamama.com' + System.currentTimeMillis(),
			CompanyName = 'TEST',
			Title = 'title',
			Alias = 'alias',
			TimeZoneSidKey = 'America/Los_Angeles',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US'
			//UserRoleId = r1.Id
		);
		
		User u2 = new User(
			ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
			LastName = 'last2',
			Email = 'puser000@amamama.com',
			Username = 'puser000@amamama.com' + System.currentTimeMillis(),
			CompanyName = 'TEST',
			Title = 'title',
			Alias = 'alias',
			TimeZoneSidKey = 'America/Los_Angeles',
			EmailEncodingKey = 'UTF-8',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US'
			//UserRoleId = r2.Id
		);
		
		Group gr = new Group();
		gr.Name = 'Test Group';
		insert gr;
		GroupMember gm = new GroupMember();
		gm.GroupId =gr.Id;

		Group gr2 = new Group();
		gr2.Name = 'Test Group';
		insert gr2;

		GroupMember gm2 = new GroupMember();
		gm2.GroupId =gr2.Id;
		
		Map<String, Schema.SObjectType> globalDescMap=Schema.getGlobalDescribe();
		Schema.SObjectType targetType = globalDescMap.get('Territory2Model');
		Group groupRoleAndSubordinates;
		Group groupRole;
		
		System.RunAs(u) {
			UserRole r = new UserRole(DeveloperName = 'customCEO', Name = 'CEO');
		 	insert r;
			u.UserRoleId = r.Id;
			update u;
			gm.UserOrGroupId = u.Id;
			Insert gm;
			UserRole r1 = new UserRole(DeveloperName = 'customMarketing', Name = 'Marketing', ParentRoleId = r.id);
			insert r1;
			
			UserRole r2 = new UserRole(DeveloperName = 'customSales', Name = 'Sales', ParentRoleId = r1.id);
			insert r2;
			groupRoleAndSubordinates = [Select id, type, relatedId from group where relatedId = :r.id and Type = 'RoleAndSubordinates'];
			groupRole = [Select id, type, relatedId from group where relatedId = :r1.id and Type = 'Role'];
			system.debug('groupRoleAndSubordinates:::::' + groupRoleAndSubordinates);
			sObject terr2Model = targetType.newSObject();
				Object o = terr2Model.get('Name');
				terr2Model.put('Name', 'test territory model');
				o = terr2Model.get('DeveloperName');
				terr2Model.put('DeveloperName', 'test_dev_name');
			insert terr2Model;
			sObject terr2type  = Database.query('SELECT id, DeveloperName from Territory2Type LIMIT 1');
			targetType = globalDescMap.get('Territory2');
			sObject terr2 = targetType.newSObject();
				o = terr2.get('Name');
				terr2.put('Name', 'Parent territory');
				o = terr2.get('Territory2TypeId');
				terr2.put('Territory2TypeId', terr2type.id);
				o = terr2.get('Territory2ModelId');
				terr2.put('Territory2ModelId', terr2Model.Id);
				o = terr2.get('DeveloperName');
				terr2.put('DeveloperName', 'test_territory2');
			insert terr2;
			sObject terr21 = targetType.newSObject();
				o = terr21.get('Name');
				terr21.put('Name', 'Test territory');
				o = terr21.get('ParentTerritory2Id');
				terr21.put('ParentTerritory2Id', terr2.id);
				o = terr21.get('Territory2ModelId');
				terr21.put('Territory2TypeId', terr2type.id);
				o = terr21.get('Territory2ModelId');
				terr21.put('Territory2ModelId', terr2Model.Id);
				o = terr21.get('DeveloperName');
				terr21.put('DeveloperName', 'test_territory21');
			insert terr21;
			targetType = globalDescMap.get('ObjectTerritory2Association');
			sObject objTerr2A = targetType.newSObject();
				o = objTerr2A.get('AssociationCause');
				objTerr2A.put('AssociationCause', 'Territory2Manual');
				o = objTerr2A.get('Territory2Id');
				objTerr2A.put('Territory2Id', terr21.id);
				o = objTerr2A.get('ObjectId');
				objTerr2A.put('ObjectId', testAccount.id);
			insert objTerr2A;
			System.RunAs(u1) {
				u1.UserRoleId = r1.Id;
				update u1;
				targetType = globalDescMap.get('UserTerritory2Association');
				sObject ut2a = targetType.newSObject();
					o = ut2a.get('Territory2Id');
					ut2a.put('Territory2Id', terr2.id);
					o = ut2a.get('UserId');
					ut2a.put('UserId', u1.id);
				insert ut2a;
			}
			System.RunAs(u2) {
				u2.UserRoleId = r2.Id;
				update u2;
				gm2.UserOrGroupId = u2.Id;
				Insert gm2;
				sObject ut2a1 = targetType.newSObject();
					o = ut2a1.get('Territory2Id');
					ut2a1.put('Territory2Id', terr21.id);
					o = ut2a1.get('UserId');
					ut2a1.put('UserId', u2.id);
				insert ut2a1;
			}
		}
		targetType = globalDescMap.get('AccountShare');
		sObject acctshareRS = targetType.newSObject();
			Object o = acctshareRS.get('AccountId');
			acctshareRS.put('AccountId', testAccount.id);
			o = acctshareRS.get('UserOrGroupId');
			acctshareRS.put('UserOrGroupId', groupRoleAndSubordinates.id);
			o = acctshareRS.get('AccountAccessLevel');
			acctshareRS.put('AccountAccessLevel', 'Edit');
			o = acctshareRS.get('OpportunityAccessLevel');
			acctshareRS.put('OpportunityAccessLevel', 'Edit');
			o = acctshareRS.get('CaseAccessLevel');
			acctshareRS.put('CaseAccessLevel', 'Edit');
		insert acctshareRS;
		sObject acctshareGroupRole = targetType.newSObject();
			o = acctshareGroupRole.get('AccountId');
			acctshareGroupRole.put('AccountId', testAccount.id);
			o = acctshareGroupRole.get('UserOrGroupId');
			acctshareGroupRole.put('UserOrGroupId', groupRole.id);
			o = acctshareGroupRole.get('AccountAccessLevel');
			acctshareGroupRole.put('AccountAccessLevel', 'Edit');
			o = acctshareGroupRole.get('OpportunityAccessLevel');
			acctshareGroupRole.put('OpportunityAccessLevel', 'Edit');
			o = acctshareGroupRole.get('CaseAccessLevel');
			acctshareGroupRole.put('CaseAccessLevel', 'Edit');
		insert acctshareGroupRole;
		sObject acctshare2 = targetType.newSObject();
			o = acctshare2.get('AccountId');
			acctshare2.put('AccountId', testAccount.id);
			o = acctshare2.get('UserOrGroupId');
			acctshare2.put('UserOrGroupId', gr2.id);
			o = acctshare2.get('AccountAccessLevel');
			acctshare2.put('AccountAccessLevel', 'Edit');
			o = acctshare2.get('OpportunityAccessLevel');
			acctshare2.put('OpportunityAccessLevel', 'Edit');
			o = acctshare2.get('CaseAccessLevel');
			acctshare2.put('CaseAccessLevel', 'Edit');
		system.debug('acctshare2:: ' + acctshare2);
		insert acctshare2;
		sObject acctshare = targetType.newSObject();
			o = acctshare.get('AccountId');
			acctshare.put('AccountId', testAccount.id);
			o = acctshare.get('UserOrGroupId');
			acctshare.put('UserOrGroupId', gr.id);
			o = acctshare.get('AccountAccessLevel');
			acctshare.put('AccountAccessLevel', 'Edit');
			o = acctshare.get('OpportunityAccessLevel');
			acctshare.put('OpportunityAccessLevel', 'Edit');
			o = acctshare.get('CaseAccessLevel');
			acctshare.put('CaseAccessLevel', 'Edit');
		insert acctshare;
		sObject acctshareGR2 = targetType.newSObject();
			o = acctshareGR2.get('AccountId');
			acctshareGR2.put('AccountId', testAccount.id);
			o = acctshareGR2.get('UserOrGroupId');
			acctshareGR2.put('UserOrGroupId', gr.id);
			o = acctshareGR2.get('AccountAccessLevel');
			acctshareGR2.put('AccountAccessLevel', 'Edit');
			o = acctshareGR2.get('OpportunityAccessLevel');
			acctshareGR2.put('OpportunityAccessLevel', 'Edit');
			o = acctshareGR2.get('CaseAccessLevel');
			acctshareGR2.put('CaseAccessLevel', 'Edit');
		insert acctshareGR2;
		sObject acctshareRole = targetType.newSObject();
			o = acctshareRole.get('AccountId');
			acctshareRole.put('AccountId', testAccount.id);
			o = acctshareRole.get('UserOrGroupId');
			acctshareRole.put('UserOrGroupId', u2.id);
			o = acctshareRole.get('AccountAccessLevel');
			acctshareRole.put('AccountAccessLevel', 'Edit');
			o = acctshareRole.get('OpportunityAccessLevel');
			acctshareRole.put('OpportunityAccessLevel', 'Edit');
			o = acctshareRole.get('CaseAccessLevel');
			acctshareRole.put('CaseAccessLevel', 'Edit');
		insert acctshareRole;
		
		Test.startTest();
		
		RecordAccess ctrl = new RecordAccess();
		System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
		MetadataService metaDataService = new MetadataService();
		MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
		ctrl.selectedUser = u.name;
        ctrl.selectedUser = u.Name;
		ctrl.Go();
		system.assertEquals(ctrl.noError, false);
		ctrl.currentId = testAccount.Id;
		ctrl.selectedUser = u.name;
        //ctrl.dummycontact.OwnerId = u.Id;
		ctrl.Go();
		//system.assertnotEquals(ctrl.roleGroupMap.size(), 0);
		ctrl.currentId = testAccount.Id;
		ctrl.selectedUser = u1.name;
        //ctrl.dummycontact.OwnerId = u1.Id;
		ctrl.Go();
		system.assertEquals(ctrl.sObjName, 'Account');
		ctrl.currentId = testAccount.Id;
		ctrl.selectedUser = u2.name;
        //ctrl.dummycontact.OwnerId = u2.Id;
		ctrl.Go();
		ctrl.user = u2;
		system.assertNotEquals(ctrl.RoleAsigned(ctrl.user).size(), 0);
		
		ctrl.ExpandProf();
		system.assertEquals(ctrl.isExpandProf, false);
		ctrl.ExpandOrg();
		system.assertEquals(ctrl.isExpandOrg, false);
		ctrl.ExpandPerm();
		system.assertEquals(ctrl.isExpandPerm, false);
		ctrl.ExpandRole();
		system.assertEquals(ctrl.isExpandRole, false);
		ctrl.ExpandTerritory();
		system.assertEquals(ctrl.isExpandTerritory, false);
		ctrl.ExpandSharing();
		system.assertEquals(ctrl.isExpandSharing, false);
		ctrl.ExpandGroupSharing();
		system.assertEquals(ctrl.isExpandGroupSharing, false);
		ctrl.ExpandProf();
		system.assertEquals(ctrl.isExpandProf, true);
		ctrl.ExpandOrg();
		system.assertEquals(ctrl.isExpandOrg, true);
		ctrl.ExpandPerm();
		system.assertEquals(ctrl.isExpandPerm, true);
		ctrl.ExpandRole();
		system.assertEquals(ctrl.isExpandRole, true);
		ctrl.ExpandTerritory();
		system.assertEquals(ctrl.isExpandTerritory, true);
		ctrl.ExpandSharing();
		system.assertEquals(ctrl.isExpandSharing, true);
		ctrl.ExpandGroupSharing();
		system.assertEquals(ctrl.isExpandGroupSharing, true);
		ctrl.ExpandRecordType();
		system.assertEquals(ctrl.isExpandRecordType, false);
		ctrl.ExpandRecordType();
		system.assertEquals(ctrl.isExpandRecordType, true);
		ctrl.printPDF();

		Test.stopTest();
	}
    static testMethod void openContactUSLinkTest(){
        Test.startTest();
        PageReference pageRef;
        pageRef = new PageReference('https://applicationperfection.com/contact/');
        RecordAccess ctrl = new RecordAccess();
        ctrl.openContactUSLink();
        System.assertNotEquals(null, pageRef);
        Test.stopTest();
    }
}