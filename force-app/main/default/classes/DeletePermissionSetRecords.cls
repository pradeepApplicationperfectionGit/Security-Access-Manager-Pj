public class DeletePermissionSetRecords {
    public static void DeleteRecords(){
        SA_Audit__BatchApexStatus__c customSettingRecord = SA_Audit__BatchApexStatus__c.getValues('PermissionSet');
        if(customSettingRecord != null){
            database.delete(customSettingRecord);
        }
        List<SA_Audit__BatchApexStatus__c> OWDObjectRecord = [Select SA_Audit__Is_Batch_Apex_Executed__c from SA_Audit__BatchApexStatus__c];
        database.delete(OWDObjectRecord);
         List<SA_Audit__OWD_Sharing_Report__c> objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c 
                                                          FROM SA_Audit__OWD_Sharing_Report__c
                                                          WHERE SA_Audit__Type__c = 'PermissionSet' 
                                                          OR SA_Audit__Type__c = 'FilteredReport'
                                                          OR SA_Audit__Type__c ='ScheduledReports'];
        database.delete(objData);
    }
    
}