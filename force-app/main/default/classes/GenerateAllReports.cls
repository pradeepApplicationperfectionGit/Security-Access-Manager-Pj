/*
Author       : Himanshu Kr. Varshney
Description  : Batch Apex to generate the Reports for all Options on Intel tab page and it will send an email as zip file to loggedin user's email address 
Dependencies : Called from IntelController.apxc Class
*/
public with sharing class GenerateAllReports implements Database.Batchable<String>, Database.AllowsCallouts, Database.Stateful{
    public List<String> excelFilesNames;
    public List<Attachment> attachmentList = new List<Attachment>();
    public List<String> listOfIDs{ get; set; }
    public GenerateAllReports(List<String> listOfIDs){
        this.listOfIDs = listOfIDs;
    }
    public Iterable<String> start(Database.BatchableContext BC){
        excelFilesNames = new List<STring>();
        for(Integer i = 1; i < 22; i++){
            excelFilesNames.add('option' + i);
        }
        return excelFilesNames;
    }
    public void execute(Database.BatchableContext BC, List<String> scope){
        for(String s : scope){
            if(s != 'option2' && s != 'option1' && s != 'option11' && s != 'option12' && s != 'option20'){
                attachmentList.add(getExportFile(s));
            }
        }
    }
    public void finish(Database.BatchableContext BC){
        List<Messaging.EmailFileAttachment> finalAttachmentList = new List<Messaging.EmailFileAttachment>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new String[]{UserInfo.getUserEmail()};
        String body = '';
        SA_Audit__OWD_Sharing_Report__c owdObjRecord = new SA_Audit__OWD_Sharing_Report__c();
        if(Schema.sObjectType.SA_Audit__OWD_Sharing_Report__c.fields.SA_Audit__Type__c.isCreateable()){
            owdObjRecord.SA_Audit__Type__c = 'AllReports';
            insert owdObjRecord;
        }
        for(Attachment attach: attachmentList){
            attach.parentId = owdObjRecord.Id;
        }
        insert attachmentList;
        //String fileName = 'RolesReport';
        //getExport(owdObjRecord.Id, fileName); 
        List<Attachment> listOfAttachment = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: owdObjRecord.Id];
        for(Attachment attach: listOfAttachment){
            Messaging.EmailFileAttachment emailAtt = new Messaging.EmailFileAttachment();
            emailAtt.setFileName(attach.Name);
            emailAtt.setBody(attach.Body);
            finalAttachmentList.add(emailAtt);
        }
        email.setFileAttachments(finalAttachmentList);
        email.setToAddresses(toAddresses);
        email.setSubject('Your Security & Access Manager Intel');
        body = 'Dear <b>' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + '</b>,';
        body += '<br/>';
        body += '<br/>';
        body += 'Your Security & Access Manager Intel reports attached.';
        body += '<br/>';
        body += '<br/>';
        body += '<b>1. Roles report -</b> All the internal and external roles in your org with role label, name, role reports to, forecast manager, default opportunity and case access etc';
        body += '<br/>';
        body += '<b>2. User Role report -</b> Active users with role assigned';
        body += '<br/>';
        body += '<b>3. User Profile And Role report -</b> Active users with their profile, role and manager';
        body += '<br/>';
        body += '<b>4. User Profile report -</b> Active users with their profile';
        body += '<br/>';
        body += '<b>5. Territories report -</b> Territory label, name, parent territory, forecast manager, default opportunity, case and account access';
        body += '<br/>';
        body += '<b>6. User Territories report -</b> Active user, user id and territory name';
        body += '<br/>';
        body += '<b>7. Users and their Permission Sets report -</b> Users and their permission sets assigned.';
        body += '<br/>';
        body += '<b>8. Permission Sets with assigned users report -</b> Permission sets with users assigned';
        body += '<br/>';
        body += '<b>9. Sharing Settings -</b> A report showing all sharing settings';
        body += '<br/>';
        body += '<b>10. Org Wide Defaults -</b> A report showing all org wide defaults';
        body += '<br/>';
        body += '<b>11. Permission sets with or without users assigned -</b> A report showing any permission sets with no users assigned';
        body += '<br/>';
        body += '<b>12. Profiles with or without users assigned -</b> A report showing any profiles with no users assigned';
        body += '<br/>';
        body += '<b>13. Apex Triggers and Apex Classes -</b> A summary of all Apex triggers and classes and when they were created and last modified';
        body += '<br/>';
        body += '<b>14. Public Group -</b> A summary of all Public groups and if they include active or inactive users';
        body += '<br/>';
        body += '<b>15. Managed Package License assignment -</b> Which users have managed package licenses assigned';
        body += '<br/>';
        body += '<br/>';
        body += 'Best regards,';
        body += '<br/>';
        body += '<b>Security & Access Manager</b>';
        body += '<br/>';
        body += '<b>By Application Perfection Ltd.</b>';
        email.setHTMLBody(body);
        Messaging.SendEmailResult [] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    public static Attachment getExportFile(String s){
        //GenerateAllReports obj = new GenerateAllReports();
        Blob excelData;
        String fileName;
        PageReference generateExcel;
        /*if(s == 'option1'){
            generateExcel = Page.SA_Audit__FolderSharesExcel;
            generateExcel.getParameters().put('jobId', obj.listOfIDs[0]);
            }
            else if(s == 'option2'){
            generateExcel = Page.SA_Audit__FolderSharesExcel;
            generateExcel.getParameters().put('jobId', obj.listOfIDs[1]);
        }*/
        if(s == 'option3'){
            generateExcel = Page.SA_Audit__RolesExcel;
            fileName = 'UserRolesReport';
        }
        else if(s == 'option4'){
            generateExcel = Page.SA_Audit__UserRoleExcel;
            fileName = 'RolesReport';
        }
        else if(s == 'option5'){
            generateExcel = Page.SA_Audit__UserProfileAndRoleExcel;
            fileName = 'UserProfilesAndRolesReport';
        }
        else if(s == 'option6'){
            generateExcel = Page.SA_Audit__UserProfileExcel;
            fileName = 'UserProfileReport';
        }
        else if(s == 'option7'){
            generateExcel = Page.SA_Audit__TerritoriesExcel;
            fileName = 'TerritoriesReport';
        }
        else if(s == 'option8'){
            generateExcel = Page.SA_Audit__UserTerritoryExcel;
            fileName = 'UserTerritoriesReport';
        }
        else if(s == 'option9'){
            generateExcel = Page.SA_Audit__UserPermissionSetExcel;
            fileName = 'UserPermissionSetsReport';
        } 
        else if(s == 'option10'){
            generateExcel = Page.SA_Audit__PermissionSetsWithUsersExcel;
            fileName = 'PermissionSetsWithUsersReport';
        }
        /*else if(s == 'option11'){
            generateExcel = Page.SA_Audit__InstalledPackagesReportExcel;
            generateExcel.getParameters().put('jobId', obj.listOfIDs[2]);
            }
            else if(s == 'option12'){
            generateExcel = Page.SA_Audit__RolesExcel;
        }*/
        else if(s == 'option13'){
            generateExcel = Page.SA_Audit__SharingRulesExcel;
            fileName = 'SharingRulesReport';
        }
        else if(s == 'option14'){
            generateExcel = Page.SA_Audit__OWDReportExcel;
            fileName = 'OrgWideDefaultsReport';
        }
        else if(s == 'option15'){
            generateExcel = Page.SA_Audit__PermissionSetWithNoUsersExcel;
            fileName = 'PermissionSetsWithNoUsersReport';
        }
        else if(s == 'option16'){
            generateExcel = Page.SA_Audit__ProfilesWithNoUserExcel;
            fileName = 'ProfilesWithNoUsersReport';
        }
        else if(s == 'option17'){
            generateExcel = Page.SA_Audit__ApexTriggersAndApexClassesExcel;
            fileName = 'ApexTriggersAndApexClassesReport';
        }
        else if(s == 'option18'){
            generateExcel = Page.SA_Audit__PublicGroupExcel;
            fileName = 'PublicGroupsReport';
        }
        else if(s == 'option19'){
            generateExcel = Page.SA_Audit__ManagedPackageLicenseExcel;
            fileName = 'ManagedPackageLicensesReport';
        }
        else if(s == 'option21'){
            generateExcel = Page.SA_Audit__DashboardReportExcel;
            fileName = 'DashboardReport';
        }
        /*else if(s == 'option20'){
            generateExcel = Page.SA_Audit__ValidationRulesExcel;
         }*/
        if(Test.isRunningTest()){ 
            excelData = blob.valueOf('Unit.Test');
        }
        else{
            excelData = generateExcel.getContent();
        }
        Attachment attach = new Attachment();
        //attach.parentId = parentId;
        attach.Name = fileName + '.xls';
        attach.Body = excelData;
        //obj.attachmentList.add(attach);
        return attach;
    }
}