/*
Author       : Himanshu Kr. Varshney
Description  : Apex Test Class for ManagedPackageLicenseController.apxc
Dependencies : ManagedPackageLicenseController.apxc
*/
@isTest
public with sharing class ManagedPackageLicenseControllerTest{
    private static List<SA_Audit__OWD_Sharing_Report__c> managedPackageLicensesList = new List<SA_Audit__OWD_Sharing_Report__c>();
    static final Integer size = 1;
    @testSetup
    static void setUpData(){
        SA_Audit__OWD_Sharing_Report__c managedPackageLicenseOneRecord = new SA_Audit__OWD_Sharing_Report__c();
        managedPackageLicenseOneRecord = createManagedPackageLicenseRecord();
        managedPackageLicensesList.add(managedPackageLicenseOneRecord);
        insert managedPackageLicensesList;
    }
    static SA_Audit__OWD_Sharing_Report__c createManagedPackageLicenseRecord(){
        SA_Audit__OWD_Sharing_Report__c managedPackageLicenseOneRecord = new SA_Audit__OWD_Sharing_Report__c();
        managedPackageLicenseOneRecord.Name = 'Test';
        managedPackageLicenseOneRecord.SA_Audit__Managed_Package_License_Datails__c = '[{"userName":"james@applicationperfection.co.uk.development","role":"CEO","profile":"System Administrator","packageName":"Conga Composer","name":"James Burgess","activeBoolean":true}]';
        managedPackageLicenseOneRecord.SA_Audit__Type__c = 'ManagedPackaged';
        return managedPackageLicenseOneRecord;
    }
    static List<SA_Audit__OWD_Sharing_Report__c> getManagedPackageLicensesRecords(){
        return [SELECT Id, Name, SA_Audit__OWD_Data_Field__c, SA_Audit__Managed_Package_License_Datails__c, SA_Audit__Sharing_Rules_Details__c, SA_Audit__Type__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'ManagedPackaged'];
    }
    @isTest
    static void fetchManagedPackageLicensesRecordsTest(){
        Test.startTest();
        ManagedPackageLicenseController classObj = new ManagedPackageLicenseController();
        managedPackageLicensesList = getManagedPackageLicensesRecords();
        System.assertEquals(size, managedPackageLicensesList.size());
        Test.stopTest();
    }
}