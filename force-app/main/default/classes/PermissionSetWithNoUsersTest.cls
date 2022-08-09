/*
Author       : Himanshu Kr. Varshney
Description  : Apex Test Class for PermissionSetWithNoUsers.apxc
Dependencies : PermissionSetWithNoUsers.apxc, IntelController.apxc, PermissionSetsWithNoUsersBatchApex.apxc
*/
@isTest
public with sharing class PermissionSetWithNoUsersTest{
    private static List<SA_Audit__OWD_Sharing_Report__c> permissionSetsList = new List<SA_Audit__OWD_Sharing_Report__c>();
    static final Integer size = 1;
    @testSetup
    static void setUpData(){
        SA_Audit__OWD_Sharing_Report__c permissionSetsOneRecord = new SA_Audit__OWD_Sharing_Report__c();
        permissionSetsOneRecord = createPermissionSetsRecord();
        permissionSetsList.add(permissionSetsOneRecord);
        insert permissionSetsList;
        Attachment attach = new Attachment();
        attach.Name = 'PermissionSetsWithNoUsersReport';
        attach.ContentType = 'text/plain';
        attach.parentId = permissionSetsList[0].Id;
        attach.Body = Blob.valueOf('[{"permissionSetName":"Security & Access Rights Audit Developer","usedByActiveUser":"Yes"},{"permissionSetName":"Test Permission Set","usedByActiveUser":"Yes"},{"permissionSetName":"Security & Access Manager View Licence","usedByActiveUser":"Yes"},{"permissionSetName":"Password never expires","usedByActiveUser":"Yes"},{"permissionSetName":"Access to DiscoverOrg"},{"permissionSetName":"Access to DiscoverOrg - Administrator"},{"permissionSetName":"Access to DiscoverOrg - Inline Only"},{"permissionSetName":"Agile Accelerator Admin","usedByActiveUser":"Yes"},{"permissionSetName":"Agile Accelerator User"},{"permissionSetName":"Composer Administrator"},{"permissionSetName":"Composer Salesforce Community User"},{"permissionSetName":"Composer User"},{"permissionSetName":"Salesforce CMS Integration Admin"},{"permissionSetName":"Security Center Integration User"},{"permissionSetName":"Salesforce Console User","usedByActiveUser":"Yes"},{"permissionSetName":"Tableau CRM Platform User","usedByActiveUser":"Yes"},{"permissionSetName":"Tableau CRM Platform Admin","usedByActiveUser":"Yes"}]');
        insert attach;
        SA_Audit__BatchApexStatus__c customSettingRecord = new SA_Audit__BatchApexStatus__c();
        customSettingRecord.Name = 'PermissionSet';
        insert customSettingRecord;
    }
    static SA_Audit__OWD_Sharing_Report__c createPermissionSetsRecord(){
        SA_Audit__OWD_Sharing_Report__c permissionSetsOneRecord = new SA_Audit__OWD_Sharing_Report__c();
        permissionSetsOneRecord.Name = 'Test';
        permissionSetsOneRecord.SA_Audit__Type__c = 'PermissionSet';
        return permissionSetsOneRecord;
    }
    static List<SA_Audit__OWD_Sharing_Report__c> getPermissionSetsRecords(){
        List<SA_Audit__OWD_Sharing_Report__c> permissionSetsList = [SELECT Id, Name, SA_Audit__Type__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'PermissionSet' LIMIT 1];
        return permissionSetsList;
    }
    @isTest
    static void getPermissionSetsDetailsTest(){
        Test.startTest();
        permissionSetsList = getPermissionSetsRecords();
        PermissionSetWithNoUsers obj = new PermissionSetWithNoUsers();
        System.assertEquals(size, permissionSetsList.size());
        System.assertNotEquals(null, obj.permissionSetsList);
        Test.stopTest();
    }
}