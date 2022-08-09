/*
Author       : Himanshu Kr. Varshney
Description  : Apex Controller for Intel Tab(It will Generate the Reports for Layouts and its fields)
Dependencies : Called from intelTab.cmp
*/
public with sharing class IntelController{
    public Boolean isEdit { get; set; }
    //public Integer counter { get; set; }
    public Id jobId { get; set; }
    public Boolean keepPolling { get; set; }
    public String selectedReport { get; set; }
    public Boolean noEndpointMetadata { get; set; }
    public String sfdcUrl { get; set; }
    public static String staticSfdcUrl { get; set; }
    public static Set<String> nameSpacesList = new Set<String>();
    public static MAP<String, String> objectMapWithNameSpace = new MAP<String, String>();
    //xls Variables:
    public String xmlheader {get;set;}
    public String endfile {get;set;} 
    public IntelController(){
        xmlheader = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        endfile = '</Workbook>';
    }
    // for get profile list 
    // -----------------------------------
    @AuraEnabled
    public List<Id> customProfilesIdList { get; set; }
    @AuraEnabled
    public List<SelectOption> remainingProfiles1 { get; set; }
    @AuraEnabled
    public Map<Id, String> profileMap { get; set; }
    @AuraEnabled
    public String standardProfileIds { get; set; }
    @AuraEnabled
    public List<SelectOption> remainingProfiles { get; set; }
    @AuraEnabled
    public Boolean existCustomProfiles { get; set; }
    @AuraEnabled
    public List<SelectOption> selectedProfiles { get; set; }
    @AuraEnabled
    public Boolean isAccessible { get; set; }
    
    //--------------------------------------
    public Pagereference exportAll(){
        return new Pagereference('/apex/ExportAll');
    }
    public class CustomException extends Exception{ 
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below Method will Give Us List of Standard and Custom Objects
*/  
    @AuraEnabled
    public static List<ObjectDetails> getAllObjectNames(){
        List<ObjectDetails> sObjectList = new List<ObjectDetails>();
        try{
            for(Schema.SObjectType objTyp : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()){
                Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
                String name = describeSObjectResultObj.getName();
                ObjectDetails objDetails = new ObjectDetails();
                if(!describeSObjectResultObj.isCreateable())
                    continue;
                if(describeSObjectResultObj.getRecordTypeInfos().size() > 0 
                   && !describeSObjectResultObj.isCustomSetting() 
                   && describeSObjectResultObj.isCreateable() 
                   && !name.containsignorecase('history') 
                   && !name.containsignorecase('tag') 
                   && !name.containsignorecase('share') 
                   && !name.containsignorecase('feed') 
                   && name != null){ 
                    objDetails.label = describeSObjectResultObj.getLabel();
                    objDetails.value = describeSObjectResultObj.getName();
                    objDetails.type = describeSObjectResultObj.isCustom();
                    objDetails.pluralName = describeSObjectResultObj.getLabelPlural();
                    objDetails.objectPrefix = describeSObjectResultObj.getKeyPrefix();
                }
                sObjectList.add(objDetails);
            }
        }
        catch(Exception ex){
            //It Will Show Exception on UI.
            throw new AuraHandledException(ex.getMessage()); 
        }
        return sObjectList;     
    }
/*------------------------------------------------------------------------------------------------------------------------------------------------*/
//Tejas
@AuraEnabled
    public static List<ProfileData> getProfilesList() {
        List<ProfileData> Allprofiles = new List<ProfileData>();
        List<profile> Profiles = [select Name from profile limit 45000];
        
        for(profile pr: Profiles){
            ProfileData pro = new ProfileData();
            pro.label = pr.Name;
            pro.value = pr.Name;
            Allprofiles.add(pro);
        }
        
        return Allprofiles;
        
    }
   
/*---------------------------------------------------------------------------------------------------------------------------------------------------*/    
 /*
Author  : Himanshu Kr. Varshney
Purpose : Below Method will Give Us Object Id Based on Object API Name(It is for Custom Object Only)
*/
   
    public static string getSobjectId(String objName){
        HttpRequest req = new HttpRequest(); 
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        string endPoint = sfdcURL + '/services/data/v41.0/tooling/query/?q=Select+Id+From+CustomObject+Where+DeveloperName+=\'' + String.escapeSingleQuotes(objName) + '\'';
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        String sessionId = UserInfo.getSessionId();
        String authorizationHeader = 'OAuth ' + sessionId;
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HttpResponse res = http.send(req);
        string strResponse = res.getBody();
        Result jsonField = (Result)System.JSON.deserialize(strResponse, Result.class);
        return jsonField.records[0].Id;
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below method will give us the Scheduled Reports Data(It is Option 23 in Intel Tab)
*/
    @AuraEnabled
    public static List<ScheduledReportsData> fetchTableDataOption23(){
        List<ScheduledReportsData> scheduledReportsDataList = new List<ScheduledReportsData>();
        SA_Audit__BatchApexStatus__c customSettingRecord = SA_Audit__BatchApexStatus__c.getValues('ScheduledReports');
        system.debug('testing fst');
        if(customSettingRecord != null){
               system.debug('testing scnd');
            if(!customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c){
                   system.debug('testing thrd---customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c=='+ customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c);
                String scheduledReportsBatchApexId = Database.executeBatch(new ScheduledReportsBatchApex(),100);
                customSettingRecord.SA_Audit__Batch_Apex_Id__c = scheduledReportsBatchApexId;
                customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c = true; 
                update customSettingRecord;
                   system.debug('testing frth');
            }
            else{
                try{
                       system.debug('testing fifth');
                    
                AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status FROM AsyncApexJob WHERE Id =: customSettingRecord.SA_Audit__Batch_Apex_Id__c];
                system.debug('$$AsyncApexJob' + job);
                    if(job.Status != 'Completed'){
                           system.debug('testing 6');
                           system.debug('testing 6=='+ job.NumberOfErrors+ '==' + job.Status);
                    String errorMessage = 'We are in the ' + job.Status.toLowerCase() + ' status...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
                    throw new CustomException(errorMessage);
                }
                else{
                    system.debug('testing 7');
                    SA_Audit__OWD_Sharing_Report__c objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'ScheduledReports' ORDER BY CreatedDate DESC LIMIT 1];
                    system.debug('$$objData'+objData);
                    Attachment attach = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: objData.Id LIMIT 1];
                    scheduledReportsDataList = (List<ScheduledReportsData>)System.JSON.deserialize(attach.Body.toString(), List<ScheduledReportsData>.class);
                    system.debug('$$scheduledReportsDataList=='+scheduledReportsDataList);
                    system.debug('$$atach==' + attach);
                     system.debug('$$objData'+objData);
                }
                }catch(Exception e){
                    system.debug('testing 6');
                    string ExpError = e.getMessage();
                    system.debug('error'+ ExpError);
                    system.debug('error'+ e);
                    
                }
            }
        }
        else{
            system.debug('testing 7');
            customSettingRecord = new SA_Audit__BatchApexStatus__c();
            customSettingRecord.Name = 'ScheduledReports';
            insert customSettingRecord;
            system.debug('testing 7=='+ customSettingRecord);
        }
        system.debug('$$scheduledReportsDataList=='+scheduledReportsDataList);
        return scheduledReportsDataList; 
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below method will fetch Data of All the Reports which has either Cross or Field Filter(It is Option 24 in Intel tab)
*/
    @AuraEnabled
    public static List<FilteredReportsData> fetchTableDataOption24(){ 
        List<FilteredReportsData> filteredReportList = new List<FilteredReportsData>();
        SA_Audit__BatchApexStatus__c customSettingRecord = SA_Audit__BatchApexStatus__c.getValues('FilteredReports');
        if(test.isRunningTest()){
            customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c = true;
        }
        if(customSettingRecord != null){
            if(!customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c){
                String filteredBatchApexId = Database.executeBatch(new FilteredReportsBatchApex(),30);
                customSettingRecord.SA_Audit__Batch_Apex_Id__c = filteredBatchApexId;
                customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c = true; 
                update customSettingRecord;
            }
            else{
            try{
                    AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status FROM AsyncApexJob WHERE Id =: customSettingRecord.SA_Audit__Batch_Apex_Id__c];
              	
                if(job.Status != 'Completed'){ 
                    String errorMessage = 'We are in the ' + job.Status.toLowerCase() + ' status...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
                    throw new CustomException(errorMessage);
                } 
                else{
                    SA_Audit__OWD_Sharing_Report__c objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'FilteredReport' ORDER BY CreatedDate DESC LIMIT 1];
                    Attachment attach = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: objData.Id LIMIT 1];
                    filteredReportList = (List<FilteredReportsData>)System.JSON.deserialize(attach.Body.toString(), List<FilteredReportsData>.class);
                }
         }catch(Exception e){
                //if(e != null){
               //     AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status FROM AsyncApexJob WHERE Id =: customSettingRecord.SA_Audit__Batch_Apex_Id__c]; 	
               // String errorMessage = 'We are in the ' + job.Status.toLowerCase() + ' status...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
               // throw new CustomException(errorMessage);
               // }
				system.debug('error'+e);
                   
               
              }
              
          }
          
                   
        }
       else{
            customSettingRecord = new SA_Audit__BatchApexStatus__c();
            customSettingRecord.Name = 'FilteredReports';
            insert customSettingRecord;
        }
        return filteredReportList;
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below Wrapper class will store the JSON Data for Filtered Reports
*/
    public class FilteredReportsData{
        @AuraEnabled 
        public String reportName { get; set; }
        @AuraEnabled 
        public String folderName { get; set; }
        @AuraEnabled 
        public String reportUniqueName { get; set; }
        @AuraEnabled 
        public String filterBy { get; set; }
        @AuraEnabled 
        public String filterType { get; set; }
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below Wrapper class will store the JSON Data for Scheduled Reports
*/
    public class ScheduledReportsData{
        @AuraEnabled 
        public String reportName { get; set; }
        @AuraEnabled 
        public String folderName { get; set; }
        @AuraEnabled 
        public String reportUniqueName { get; set; }
        @AuraEnabled 
        public String runningUserName { get; set; }
        @AuraEnabled 
        public DateTime startTime { get; set; }
        @AuraEnabled 
        public DateTime endTime { get; set; } 
        @AuraEnabled 
        public DateTime previousRunTime { get; set; } 
        @AuraEnabled 
        public DateTime nextRunTime { get; set; } 
        @AuraEnabled 
        public String freequency { get; set; } 
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below method will fetch Data related to all Folders(It is option 25 in Intel Tab)
*/
    @AuraEnabled 
    public static List<FoldersData> fetchTableDataOption25(){
        List<FoldersData> customFoldersData = new List<FoldersData>();
        List<Folder> folderList = [SELECT Id, Name, DeveloperName, CreatedDate FROM Folder WHERE DeveloperName != 'Report_Manager_Archive_Folder' AND DeveloperName != null AND Name != null LIMIT 5];
        List<Report> reportList = [SELECT Id, OwnerId FROM Report WHERE FolderName != null];
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        for(Folder folderOneRecord: folderList){
            Integer reportCount = 0;
            FoldersData customFolderOneRecord = new FoldersData();
            customFolderOneRecord.folderName = folderOneRecord.Name;
            customFolderOneRecord.folderUniqueName = folderOneRecord.DeveloperName;
            customFolderOneRecord.url = sfdcURL + '/' + folderOneRecord.Id;
            customFolderOneRecord.createdDate = folderOneRecord.CreatedDate;
            for(Report reportOneRecord: reportList){
                if(reportOneRecord.OwnerId == folderOneRecord.Id){
                    reportCount++;
                }
            }
            customFolderOneRecord.reportsCount = reportCount;
            customFoldersData.add(customFolderOneRecord);
        }
        return customFoldersData;
    }
/*
Author            : Himanshu Kr. Varshney
Purpose of method : Below Wrapper class will store the JSON Data for all the Folders
*/
    public class FoldersData{
        @AuraEnabled 
        public String folderName { get; set; }
        @AuraEnabled 
        public String folderUniqueName { get; set; }
        @AuraEnabled 
        public String url { get; set; }
        @AuraEnabled 
        public DateTime createdDate { get; set; }
        @AuraEnabled 
        public Integer reportsCount { get; set; }
    }
/*
Author  : Pradeep
Purpose : Below method will Give us  App visibility details for all the profiles
*/
    @auraEnabled
    public static object fetchTableDataOption26(){
        map<string,string>appId2Name=new map<string,string>();
        map<string,string>appName2Vis=new map<string,string>();
        map<string,map<string,string>>profile2visMap=new map<string,map<string,string>>();
        
        for(AppMenuItem ami:[SELECT ApplicationId,Name,IsAccessible,IsVisible FROM AppMenuItem]){
            appId2Name.put(ami.ApplicationId,ami.name);
            appName2Vis.put(ami.name,' ');
        }
        for(profile p:[select id,name from profile]){
            map<string,string>cloneMap=appName2Vis.clone();
            profile2visMap.put(p.name,cloneMap);
        }
        for(SetupEntityAccess sea:[SELECT Id,Parent.IsOwnedByProfile,Parent.Profile.Name,SetupEntityId,SetupEntityType FROM SetupEntityAccess 
                                   WHERE (Parent.IsOwnedByProfile=true AND SetupEntityId in:appId2Name.keySet())]){
                                       map<string,string>tmpMap=profile2visMap.get(sea.Parent.Profile.Name);
                                       tmpMap.put(appId2Name.get(sea.SetupEntityId),'V');
                                       profile2visMap.put(sea.Parent.Profile.Name,tmpMap);      
                                   }
        list<object>retList=new list<object>();
        list<string>appNames=new list<string>{' '};
            list<list<string>>visList=new list<list<string>>();
        appNames.addAll(appName2Vis.keySet());
        for(string str:profile2visMap.keySet()){
            map<string,string>tmpMap=profile2visMap.get(str);
            list<string>tmpList=new list<string>();
            for(string str1:appNames){
                if(tmpMap.containsKey(str1)){
                    tmpList.add(tmpMap.get(str1));
                }else{
                    tmpList.add(str);
                }
            }
            visList.add(tmpList);
        }
        map<string,object>respMap=new map<string,object>{'header'=>appNames,'body'=>visList};
            /*system.debug(JSON.serializePretty(appNames.size()));
system.debug(JSON.serializePretty(visList[0].size()));
system.debug(JSON.serializePretty(visList[1].size()));
system.debug(JSON.serializePretty(visList[2]));*/
            return respMap;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Give us all Object Details like Fields API Name, Label etc for a List of Object
*/
    @AuraEnabled
    public static List<JSONData> getAllObjectDetails(List<String> objectNames){ 
        List<PackageLicense> packageLicenseList = [SELECT NamespacePrefix FROM PackageLicense Limit 2000];
        for(PackageLicense onePackageLicense: packageLicenseList){
            nameSpacesList.add(onePackageLicense.NamespacePrefix + '__');
        }
        String currentOrgNameSpace = [SELECT NamespacePrefix FROM Organization Limit 1].NamespacePrefix;
        if(String.isNotBlank(currentOrgNameSpace)){
            nameSpacesList.add(currentOrgNameSpace + '__');
        }
        List<JSONData> allJsonData = new List<JSONData>();
        List<String> layoutNames = new List<String>();
        for(String objName : objectNames){
            JSONData oneJsonData = new JSONData();
            oneJsonData.objectName = objName;
            if(objName.endsWith('__c')){
                String key = objName;
                String str = objName.substring(0, objName.length() - 3);
                for(String nameSpace: nameSpacesList){
                    if(str.contains(nameSpace)){
                        str = str.substring(nameSpace.length(), str.length());
                        objectMapWithNameSpace.put(key, nameSpace);
                        break;
                    }
                }
                oneJsonData.developerName = str;
                oneJsonData.allFieldInfos = getAllFields(objName);
                layoutNames = getLayouts(str, true);
                oneJsonData.layoutDatas = getLayoutFields(objName, layoutNames);
            }
            else{
                oneJsonData.allFieldInfos = getAllFields(objName);
                layoutNames = getLayouts(objName, false);
                oneJsonData.layoutDatas = getLayoutFields(objName, layoutNames);
            }
            allJsonData.add(oneJsonData);
        }
        return allJsonData;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Give us all Details of a Layout for an Object
*/
    @AuraEnabled
    public static List<String> getLayouts(String objName, Boolean isCustom){
        List<String> layouts = new List<String>();
        string objectId;
        if(isCustom){
            objectId = getSobjectId(objName);
        }
        else{
            objectId = objName;
        }
        HttpRequest req = new HttpRequest();
        string layoutType = 'Standard';
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        string endpoint =  sfdcURL + '/services/data/v47.0/tooling/query/?q=SELECT+Id,Name+FROM+Layout+WHERE+TableEnumOrId+=\'' + objectId + '\'+and+LayoutType+=\'' + layoutType + '\'';
        String sessionId = UserInfo.getSessionId();
        String authorizationHeader = 'OAuth ' + sessionId;
        req.setHeader('Authorization', authorizationHeader);
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        String strResponse = res.getBody();
        Result jsonField = (Result) System.JSON.deserialize(strResponse, Result.class);
        for(Record recordObj : jsonField.records){
            layouts.add(recordObj.Name);
        }
        return layouts;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Give us all field Details for an Object
*/
    @AuraEnabled
    public static List<FieldInfo> getAllFields(String objectAPIName){
        try{
            List<FieldInfo> fieldNames = new List<FieldInfo>();
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap();
            for(Schema.SObjectField sfield : fieldMap.Values()){
                Schema.DescribeFieldResult dfield = sfield.getDescribe();
                String type = String.valueOf(dfield.getType());
                FieldInfo fieldInfo = new FieldInfo();
                fieldInfo.label = dfield.getLabel();
                fieldInfo.apiName = dfield.getName();
                fieldInfo.type = type;
                fieldNames.add(fieldInfo);
            }
            return fieldNames;
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Give us all fields Details of Layouts for an Object
*/
    @AuraEnabled
    public static List<LayoutData> getLayoutFields(String objectName, List<String> layoutNames){
        List<LayoutData> allLayoutData = new List<LayoutData>();
        for(String layout: layoutNames){
            LayoutData oneLayoutData = new LayoutData();
            oneLayoutData.layoutName = layout;
            String prefix = objectMapWithNameSpace.get(objectName) != null ? objectMapWithNameSpace.get(objectName) : '';
            String layoutName = String.format('{0}-{1}', new String[]{objectName, prefix + layout}); 
            List<Metadata.Metadata> layouts = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String>{layoutName});
            //Get Only Layout Name
            List<String> fields = new List<String>();
            Metadata.Layout layoutMd = (Metadata.Layout)layouts.get(0);
            for(Metadata.LayoutSection section : layoutMd.layoutSections){
                for(Metadata.LayoutColumn column : section.layoutColumns){
                    if(column.layoutItems != null){
                        for(Metadata.LayoutItem item : column.layoutItems){
                            fields.add(item.field);
                        }
                    }
                }
                oneLayoutData.fieldInfos = fields;
            }
            allLayoutData.add(oneLayoutData);
        }
        return allLayoutData;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 3
*/
    @AuraEnabled
    public static List<HierarchyService.HierarchyItem> fetchTableDataOption3(){
        List<HierarchyService.HierarchyItem> hierarchyItemList = HierarchyService.getRolesHierarchyList();
        return hierarchyItemList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 4
*/
    @AuraEnabled
    public static List<User> fetchTableDataOption4(){
        List<User> userRoles = HierarchyService.getUserRoleList();
        return userRoles;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 5
*/
    @AuraEnabled
    public static List<User> fetchTableDataOption5(){
        List<User> userRoles = HierarchyService.getUserProfileAndRoleList();
        return userRoles;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 6
*/
    @AuraEnabled
    public static List<User> fetchTableDataOption6(){
        List<User> userRoles = HierarchyService.getUserProfileAndRoleList();
        return userRoles;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 19
*/
    @AuraEnabled
    public static List<ManagedPackageLicenseFutureController.ManagedPackageDetailsClass> fetchTableDataOption19(){
        SA_Audit__OWD_Sharing_Report__c owdSharingReport = [SELECT Id, SA_Audit__Type__c, SA_Audit__Managed_Package_License_Datails__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'ManagedPackaged' ORDER BY CreatedDate DESC LIMIT 1];
        List<ManagedPackageLicenseFutureController.ManagedPackageDetailsClass> finalList = (List<ManagedPackageLicenseFutureController.ManagedPackageDetailsClass>)System.JSON.deserialize(owdSharingReport.SA_Audit__Managed_Package_License_Datails__c, List<ManagedPackageLicenseFutureController.ManagedPackageDetailsClass>.class);
        return finalList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 7
*/
    @AuraEnabled
    public static List<HierarchyService.HierarchyItem> fetchTableDataOption7(){
        Type objName = Type.forName('','Territory');
        List<HierarchyService.HierarchyItem> hierarchyItemList;
        if(objName != null){
            hierarchyItemList = HierarchyService.getOldTerritoriesHierarchyList();
        }
        else{
            hierarchyItemList = HierarchyService.getTerritoriesHierarchyList();
        }
        return hierarchyItemList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 8
*/
    @AuraEnabled
    public static List<HierarchyService.ParentChildren> fetchTableDataOption8(){
        Type objName = Type.forName('','Territory');
        List<HierarchyService.ParentChildren> parentChildren;
        if(objName != null){
            parentChildren = HierarchyService.getOldParentChildrenList(HierarchyService.getOldUserTerritoryList(),'User');
        }
        else{
            parentChildren = HierarchyService.getParentChildrenList(HierarchyService.getUserTerritoryList(), 'User');
        }
        return parentChildren;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 14
*/
    @AuraEnabled
    public static String fetchTableDataOption14(){
        SA_Audit__OWD_Sharing_Report__c objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'OWDReport' ORDER BY CreatedDate DESC LIMIT 1];
        //List<OrgWideDefaultsController.OWDData> owdListData = (List<OrgWideDefaultsController.OWDData>)System.JSON.deserialize(objData.OWD_Data_Field__c, List<OrgWideDefaultsController.OWDData>.class);
        return objData.SA_Audit__OWD_Data_Field__c;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will check the Progress of the Batch
*/
    @AuraEnabled
    public static String checkBatchApexProgress(String jobId){
        AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status FROM AsyncApexJob WHERE Id =: jobId];
        String message;
        system.debug('testing jobId'+jobId);
        if(job.Status == 'Queued' || job.Status == 'Holding' || job.Status == 'Preparing'){
            message = 'We are in the ' + job.Status.toLowerCase() + ' status...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
        } 
        else if(job.Status != 'Completed' && job.Status != 'Aborted'){
            message = 'We are in ' + job.Status.toLowerCase() + ' status: ' + Math.floor(100.0 * job.JobItemsProcessed/job.TotalJobItems) + '%...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
        } 
        else if(job.Status == 'Completed'){
            message = 'Completed';
        }
        return message;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 1
*/
    @AuraEnabled
    public static List<List<FolderShareExcelController.Folder>> fetchTableDataOption1(String jobId){
        List<List<FolderShareExcelController.Folder>> allFolderList = new List<List<FolderShareExcelController.Folder>>();
        List<SA_Audit__Helper__c> helperList = new List<SA_Audit__Helper__c>([SELECT Id, SA_Audit__ResultBody_1__c, SA_Audit__ResultBody_2__c, SA_Audit__ResultBody_3__c, SA_Audit__ResultBody_4__c, SA_Audit__ResultBody_5__c,
                                                                              SA_Audit__ResultBody_6__c, SA_Audit__ResultBody_7__c, SA_Audit__ResultBody_8__c, SA_Audit__ResultBody_9__c, SA_Audit__ResultBody_10__c,
                                                                              SA_Audit__ResultBody_11__c, SA_Audit__ResultBody_12__c, SA_Audit__ResultBody_13__c, SA_Audit__ResultBody_14__c, SA_Audit__ResultBody_15__c,
                                                                              SA_Audit__ResultBody_16__c, SA_Audit__ResultBody_17__c, SA_Audit__ResultBody_18__c, SA_Audit__ResultBody_19__c, SA_Audit__ResultBody_20__c FROM SA_Audit__Helper__c WHERE SA_Audit__JobId__c =: jobId LIMIT 1]);
        system.debug('testing helperList=='+helperList);
        List<FolderShareExcelController.Folder> foldersList = new List<FolderShareExcelController.Folder>();
        FolderShareExcelController.Folder f;
        String reportBody;
        for(Integer i = 1; i <= 20; i++){
            reportBody = helperList != null && helperList.size() > 0 ? (String) helperList[0].get('SA_Audit__ResultBody_' + i + '__c') : null;
            if(reportBody != null){
                List<String> recs = reportBody.split('/n');
                for(String rec : recs){
                    String [] fields = rec.split('~#~');
                    f = new FolderShareExcelController.Folder();
                    f.name = fields[0];
                    f.accessType = fields[1];
                    f.shareType = fields[2];
                    f.sharedWith = fields[3];
                    foldersList.add(f);
                }
            }    
        }
        Integer i = 0;
        allFolderList = new List<List<FolderShareExcelController.Folder>>();
        List<FolderShareExcelController.Folder> tempFolder = new List<FolderShareExcelController.Folder>();
        for(FolderShareExcelController.Folder fol : foldersList){
            if(i < 1000){                
                tempFolder.add(fol);
                i++;
            } 
            else{
                allFolderList.add(tempFolder);
                i = 1;
                tempFolder = new List<FolderShareExcelController.Folder>();
                tempFolder.add(fol);
            }
        }
        if(tempFolder.size() > 0){
            allFolderList.add(tempFolder);
        } 
        return allFolderList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 11
*/
    @AuraEnabled
    public static List<InstalledPackagesReportExcelController.InstalledPackageFinal> fetchTableDataOption11(String jobId){
        List<InstalledPackagesReportExcelController.InstalledPackageFinal> packageList = new List<InstalledPackagesReportExcelController.InstalledPackageFinal>();
        List<SA_Audit__Helper__c> helperList = new List<SA_Audit__Helper__c>([SELECT Id, SA_Audit__ResultBody_1__c, SA_Audit__ResultBody_2__c, SA_Audit__ResultBody_3__c, SA_Audit__ResultBody_4__c, SA_Audit__ResultBody_5__c,
                                                                              SA_Audit__ResultBody_6__c, SA_Audit__ResultBody_7__c, SA_Audit__ResultBody_8__c, SA_Audit__ResultBody_9__c, SA_Audit__ResultBody_10__c,
                                                                              SA_Audit__ResultBody_11__c, SA_Audit__ResultBody_12__c, SA_Audit__ResultBody_13__c, SA_Audit__ResultBody_14__c, SA_Audit__ResultBody_15__c,
                                                                              SA_Audit__ResultBody_16__c, SA_Audit__ResultBody_17__c, SA_Audit__ResultBody_18__c, SA_Audit__ResultBody_19__c, SA_Audit__ResultBody_20__c FROM SA_Audit__Helper__c WHERE SA_Audit__JobId__c =: jobId LIMIT 1]);
        String reportBody = '';
        for(Integer i = 1; i <= 20; i++){
            reportBody += helperList != null && helperList.size() > 0 ? (String) helperList[0].get('SA_Audit__ResultBody_'+ i +'__c') : null;
             system.debug('testing reportBody inside for'+ reportBody);
        }
        system.debug('testing reportBody'+ reportBody);
        List<InstalledPackagesReportBatch.InstalledPackage> ipList = (List<InstalledPackagesReportBatch.InstalledPackage>)JSON.deserialize(reportBody, List<InstalledPackagesReportBatch.InstalledPackage>.class);
        Map<String, List<PackageLicense>> match = new Map<String, List<PackageLicense>>();
        Map<String, InstalledPackagesReportBatch.InstalledPackage> matchSelect = new Map<String, InstalledPackagesReportBatch.InstalledPackage>();        
        for(InstalledPackagesReportBatch.InstalledPackage ipf : ipList){
            matchSelect.put(ipf.nameSpacePrefix, ipf); 
        }
        for(PackageLicense pl : [SELECT NamespacePrefix, Status, AllowedLicenses, UsedLicenses, CreatedDate, LastModifiedDate, ExpirationDate FROM PackageLicense LIMIT 2000]){
            packageList.add(new InstalledPackagesReportExcelController.InstalledPackageFinal(matchSelect.get(pl.NamespacePrefix), pl));
        }
        system.debug('testing packageList'+ packageList);
        return packageList;
        
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 2
*/
    @AuraEnabled
    public static List<List<FolderShareExcelController.Folder>> fetchTableDataOption2(String jobId){
        List<List<FolderShareExcelController.Folder>> allFolderList = new List<List<FolderShareExcelController.Folder>>();
        List<SA_Audit__Helper__c> helperList = new List<SA_Audit__Helper__c>([SELECT Id, SA_Audit__ResultBody_1__c, SA_Audit__ResultBody_2__c, SA_Audit__ResultBody_3__c, SA_Audit__ResultBody_4__c, SA_Audit__ResultBody_5__c,
                                                                              SA_Audit__ResultBody_6__c, SA_Audit__ResultBody_7__c, SA_Audit__ResultBody_8__c, SA_Audit__ResultBody_9__c, SA_Audit__ResultBody_10__c,
                                                                              SA_Audit__ResultBody_11__c, SA_Audit__ResultBody_12__c, SA_Audit__ResultBody_13__c, SA_Audit__ResultBody_14__c, SA_Audit__ResultBody_15__c,
                                                                              SA_Audit__ResultBody_16__c, SA_Audit__ResultBody_17__c, SA_Audit__ResultBody_18__c, SA_Audit__ResultBody_19__c, SA_Audit__ResultBody_20__c FROM SA_Audit__Helper__c WHERE SA_Audit__JobId__c =: jobId LIMIT 1]);
        List<FolderShareExcelController.Folder> foldersList = new List<FolderShareExcelController.Folder>();
        FolderShareExcelController.Folder f;
        String reportBody;
        for(Integer i = 1; i <= 20; i++){
            reportBody = helperList != null && helperList.size() > 0 ? (String) helperList[0].get('SA_Audit__ResultBody_' + i + '__c') : null;
            if(reportBody != null){
                List<String> recs = reportBody.split('/n');
                for(String rec : recs){
                    String [] fields = rec.split('~#~');
                    f = new FolderShareExcelController.Folder();
                    f.name = fields[0];
                    f.accessType = fields[1];
                    f.shareType = fields[2];
                    f.sharedWith = fields[3];
                    foldersList.add(f);
                }
            }    
        }
        Integer i = 0;
        allFolderList = new List<List<FolderShareExcelController.Folder>>();
        List<FolderShareExcelController.Folder> tempFolder = new List<FolderShareExcelController.Folder>();
        for(FolderShareExcelController.Folder fol : foldersList){
            if(i < 1000){                
                tempFolder.add(fol);
                i++;
            } 
            else{
                allFolderList.add(tempFolder);
                i = 1;
                tempFolder = new List<FolderShareExcelController.Folder>();
                tempFolder.add(fol);
            }
        }
        if(tempFolder.size() > 0){
            allFolderList.add(tempFolder);
        } 
        return allFolderList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch all the Job Ids of Batch Apex 
*/
    @AuraEnabled
    public static List<Id> getBatchApexJOBIds(){
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        List<Id> listOfIDs = new List<Id>();
        String firstJobId = Database.executeBatch(new InstalledPackagesReportBatch(sfdcURL), 10);
        List<Folder> folderList = [SELECT Id, Name, Type FROM Folder WHERE Type = 'Report'];
        try{
            if(folderList.size() > 0){
            String secondJobId = Database.executeBatch(new ReportFolderBatch('Report', sfdcURL),10);
            listOfIDs.add(secondJobId);
        }
        List<Folder> secondFolderList = [SELECT Id, Name, Type FROM Folder WHERE Type = 'Dashboard'];
       // if(secondFolderList.size() > 0){
            String thirdJobId = Database.executeBatch(new ReportFolderBatch('Dashboard', sfdcURL),10);
            listOfIDs.add(thirdJobId);
       // }
        }catch(Exception  e){
            string error  = e.getMessage();
            if(error != null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please Try Again ,Batch Is In Process!!.');
			ApexPages.addMessage(myMsg);
            }
           
        }
        String forthJobId = Database.executeBatch(new ValidationRulesBatch(), 10);
        String fifthJobId = Database.executeBatch(new ListViewBatchApex(), 20);
        listOfIDs.add(firstJobId);
        listOfIDs.add(forthJobId);
        listOfIDs.add(fifthJobId);
        return listOfIDs;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 16
*/
    @AuraEnabled
    public static List<ProfilesWithNoUserDetails.WrapperData> fetchTableDataOption16(){
        List<ProfilesWithNoUserDetails.WrapperData> wrapperDataList = new List<ProfilesWithNoUserDetails.WrapperData>();
        wrapperDataList = ProfilesWithNoUserDetails.getProfilesData();
        return wrapperDataList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 17
*/
    @AuraEnabled
    public static ApexTriggerAndApexClassController.WrapperData fetchTableDataOption17(){
        ApexTriggerAndApexClassController.WrapperData finalWrapperData = new ApexTriggerAndApexClassController.WrapperData();
        finalWrapperData = ApexTriggerAndApexClassController.getApexTriggersAndApexClassDetails();
        return finalWrapperData;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 18
*/
    @AuraEnabled
    public static List<PublicGroupController.WrapperData> fetchTableDataOption18(){
        List<PublicGroupController.WrapperData> finalWrapperData = PublicGroupController.getPublicGroupDetails();
        return finalWrapperData;
    }
    // Tejas
    @AuraEnabled
    public static List<PublicGroupController.WrapperData> fetchTableDataOption27(){
        List<PublicGroupController.WrapperData> finalWrapperData = PublicGroupController.getPublicGroupMembersDetails();
        return finalWrapperData;
    }//Tejas
    
    
    
/*
Author  : Tejas kshirsagar
Purpose : Below method will fetch Table Data for Option 28
*/  
    @AuraEnabled
    public static List<profileconfig.WrapperAllData> fetchTableDataOption28(List<string> Selectedpro){ 
        system.debug('Selectedpro'+Selectedpro);
            List<profileconfig.WrapperAllData> finalWrapper = profileconfig.getTabSettings(Selectedpro); 
            system.debug('finalWrapper--'+finalWrapper);
            return finalWrapper; 
    }
    
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 15
*/
    @AuraEnabled
    public static List<PermissionSetsWithNoUsersBatchApex.WrapperData> fetchTableDataOption15(){
        SA_Audit__BatchApexStatus__c customSettingRecord = SA_Audit__BatchApexStatus__c.getValues('PermissionSet');
        List<PermissionSetsWithNoUsersBatchApex.WrapperData> wrapperDataList = new List<PermissionSetsWithNoUsersBatchApex.WrapperData>();
        if(customSettingRecord != null){
            if(!customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c){
                String permissionSetBatchApexId = Database.executeBatch(new PermissionSetsWithNoUsersBatchApex(), 100);
                customSettingRecord.SA_Audit__Batch_Apex_Id__c = permissionSetBatchApexId;
                customSettingRecord.SA_Audit__Is_Batch_Apex_Executed__c = true; 
                update customSettingRecord;
            }
            else{
                AsyncApexJob job = [SELECT JobItemsProcessed, TotalJobItems, Status FROM AsyncApexJob WHERE Id =: customSettingRecord.SA_Audit__Batch_Apex_Id__c];
                if(job.Status != 'Completed'){
                    String errorMessage = 'We are in the ' + job.Status.toLowerCase() + ' status...' + 'We are processing this report to see the latest status press View Data/Export to Excel button again.';
                    throw new CustomException(errorMessage);
                }
                else{
                    SA_Audit__OWD_Sharing_Report__c objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'PermissionSet' ORDER BY CreatedDate DESC LIMIT 1];
                    Attachment attach = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: objData.Id LIMIT 1];
                    wrapperDataList = (List<PermissionSetsWithNoUsersBatchApex.WrapperData>)System.JSON.deserialize(attach.Body.toString(), List<PermissionSetsWithNoUsersBatchApex.WrapperData>.class);
                }
            }
        }
        else{
            customSettingRecord = new SA_Audit__BatchApexStatus__c();
            customSettingRecord.Name = 'PermissionSet';
            insert customSettingRecord;
        }
        return wrapperDataList; 
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 13
*/
    @AuraEnabled
    public static List<SharingSettingsFutureController.SharingRulesData> fetchTableDataOption13(){
        SA_Audit__OWD_Sharing_Report__c objData = [SELECT Id, SA_Audit__OWD_Data_Field__c, SA_Audit__Sharing_Rules_Details__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'OWDReport' ORDER BY CreatedDate DESC LIMIT 1];
        system.debug('^^^objDAta' + objData);
        List<SharingSettingsFutureController.SharingRulesData> sharingRuleFinalList = new List<SharingSettingsFutureController.SharingRulesData>();
        String fieldData = objData.SA_Audit__Sharing_Rules_Details__c;
        Integer flag = 3;
        while((fieldData != null) && (flag > 0)){
            List<String> secondPartList = new List<String>();
            SharingSettingsFutureController.SharingRulesData sharingRulesOneRecord = new SharingSettingsFutureController.SharingRulesData();
            String firstPart = fieldData.substringBetween('PerObjectRelatedDataStarts', 'PerObjectRelatedDataENDs');
            fieldData = fieldData.substringAfter('PerObjectRelatedDataENDs');
            flag = fieldData.trim().length();
            system.debug('^^^firstpart=='+ firstPart + 'fieldData' + fieldData+ 'flag'+ flag );
            //Below String will store the Object Name
            String secondPart = firstPart.substringBetween('ObjectNameStarts', 'ObjectNameEnds');
            secondPartList.add(secondPart);
            system.debug('^^^Secondpart'+ secondPart);
            firstPart = firstPart.substringAfter('ObjectNameEnds');
            String thirdPart = firstPart.substringBetween('HeaderDataStarts', 'HeaderDataEnds');
            firstPart = firstPart.substringAfter('HeaderDataEnds');
            //Below List will Store the Header Part
            List<String> headerPart = thirdPart.split('\\++');
            headerPart.remove(headerPart.size() - 1);
            //Below List of List will Store the Body Part
            List<List<String>> bodyPartData = new List<List<String>>();
            String forthPart = firstPart.substringBetween('LeftDataStarts', 'LeftDataEnds');
            //firstPart = firstPart.substringAfter('BodyDataStarts');
            Integer flagSecond = 3;
            List<String> anotherList = new List<String>();
            while((forthPart != null) && (flagSecond > 0)){
                String fifthString = forthPart.substringBetween('BodyDataStarts', 'BodyDataEnds');
                if(fifthString != null){
                    anotherList = fifthString.split('\\?');  
                    anotherList.remove(anotherList.size() - 1);
                    forthPart = forthPart.substringAfter('BodyDataEnds');
                    flagSecond = forthPart.trim().length();
                    bodyPartData.add(anotherList);
                }
                else{
                    break;
                }
            }
            for(Integer k = 0; k < (anotherList.size() - 1); k++){
                secondPartList.add('');
            }
            sharingRulesOneRecord.sharingRuleObjectName = secondPartList;
            sharingRulesOneRecord.headerData = headerPart;
            sharingRulesOneRecord.bodyData = bodyPartData;
            //headerPart.clear();
            //bodyPartData.clear();
            if(sharingRulesOneRecord.bodyData != null && sharingRulesOneRecord.headerData !=null && sharingRulesOneRecord.bodyData.size() != 0 && sharingRulesOneRecord.headerData.size() != 0){
                sharingRuleFinalList.add(sharingRulesOneRecord);
                
            }
            system.debug('sharingRuleFinalList'+sharingRuleFinalList);
        }
        return sharingRuleFinalList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will call the Future method to get the OWD Data
*/
    @AuraEnabled
    public static void fetchOWDRelatedData(){
        SharingSettingsFutureController.getOWDDetails();
    }
/*
Author  : Tj
Purpose : Below method will sync the data for Permission set ,fitlred Report and Schedule report Data.
*/
 
    @AuraEnabled
    public static void fetchDeleteRecords(){
        DeletePermissionSetRecords.DeleteRecords();
    }   
    
    
    
    
    
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 9
*/
    @AuraEnabled
    public static List<HierarchyService.ParentChildren> fetchTableDataOption9(){
        List<HierarchyService.ParentChildren> parentChildren = HierarchyService.getParentChildrenList(HierarchyService.getUserPermissionSetList(), 'Assignee');
        return parentChildren;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 20
*/
    @AuraEnabled
    public static List<ValidationRulesBatch.FinalClass> fetchTableDataOption20(){
        SA_Audit__OWD_Sharing_Report__c owdSharingReport = [SELECT Id, SA_Audit__Type__c, SA_Audit__Validation_Rules_JSON__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'ValidationRules' ORDER BY CreatedDate DESC LIMIT 1];
        Attachment attach = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: owdSharingReport.Id LIMIT 1];
        List<ValidationRulesBatch.FinalClass> finalList = (List<ValidationRulesBatch.FinalClass>)System.JSON.deserialize(attach.Body.toString(), List<ValidationRulesBatch.FinalClass>.class);
        return finalList;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 21
*/
    @AuraEnabled
    public static List<DashboardClass> fetchTableDataOption21(){
        List<DashboardClass> dashboardWrapperData = new List<DashboardClass>();
        List<Dashboard> dashboardList = [SELECT Id, Title, NamespacePrefix, Description, RunningUser.Name, RunningUserId FROM Dashboard Limit 2000];
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        String userId = UserInfo.getUserId();
        for(Dashboard dashboardRecord: dashboardList){
            DashboardClass dashboardWrapperOneRecord = new DashboardClass();
            dashboardWrapperOneRecord.dashboardName = dashboardRecord.Title;
            dashboardWrapperOneRecord.url = sfdcURL + '/' + dashboardRecord.Id;
            if(userId != dashboardRecord.RunningUserId){
                dashboardWrapperOneRecord.setToSpecifiedUser = 'Yes';
                dashboardWrapperOneRecord.userName = dashboardRecord.RunningUser.Name;
            }
            else{
                dashboardWrapperOneRecord.setToSpecifiedUser = 'No';
            }
            dashboardWrapperData.add(dashboardWrapperOneRecord);
        }
        return dashboardWrapperData;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will execute the Batch to generate all reports and send it as zip file to Loggedin user's Email address
*/
    @AuraEnabled
    public static void batchApexExecutionToSendAnEmail(List<String> listOfIDs){
        Database.executeBatch(new GenerateAllReports(listOfIDs), 200);
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Execute the Batch Apex to get the List Views Details for All of the Objects in the JSON format 
*/
    @AuraEnabled
    public static List<ListViewBatchApex.FinalClass> fetchTableDataOption22(){
        SA_Audit__OWD_Sharing_Report__c owdSharingReport = [SELECT Id, SA_Audit__Type__c, SA_Audit__List_View_JSON__c FROM SA_Audit__OWD_Sharing_Report__c WHERE SA_Audit__Type__c = 'ListView' ORDER BY CreatedDate DESC LIMIT 1];
        Attachment attach = [SELECT Id, Name, Body, ParentId FROM Attachment WHERE ParentId =: owdSharingReport.Id LIMIT 1];
        List<ListViewBatchApex.FinalClass> finalList = (List<ListViewBatchApex.FinalClass>)System.JSON.deserialize(attach.Body.toString(), List<ListViewBatchApex.FinalClass>.class);
        return finalList;
        /*List<FinalClass> finalDataList = new List<FinalClass>();
        Integer totalListViews = [SELECT Count() FROM ListView WHERE Id != null AND SObjectType != null];
        if(offsetValue > totalListViews){
            offsetValue -= totalListViews;
        }
        List<ListView> listViewRecords = new List<ListView>();
        listViewRecords = [SELECT Id, Name, DeveloperName, NamespacePrefix, SobjectType FROM ListView WHERE Id != null AND SObjectType != null ORDER BY SobjectType ASC LIMIT 90 OFFSET : offsetValue];
        for(ListView listviewRecord: listViewRecords){
            FinalClass finalDataOneRecord = new FinalClass();
            String selectedFields = '';
            String whereConditions = '';
            String toolingAPIURL = '/services/data/v32.0/sobjects/' + listviewRecord.SobjectType + '/listviews/' + listviewRecord.Id + '/describe'; 
            HttpResponse response = getListViewDetails(toolingAPIURL);
            if(response.getStatusCode() == 200){
                ListViewJSONData finalResponse = (ListViewJSONData)JSON.deserialize(response.getBody(), ListViewJSONData.class);
                for(Columns firstColumnData: finalResponse.columns){
                    if(!firstColumnData.hidden){
                        selectedFields += firstColumnData.fieldNameOrPath + ', ';
                    }
                }
                finalDataOneRecord.sobjectType = finalResponse.sobjectType;
                finalDataOneRecord.filterByOwner = finalResponse.scope;
                if(finalDataOneRecord.filterByOwner == null){
                    finalDataOneRecord.filterByOwner = 'All OWD Sharing Reports';
                }
                else{
                    finalDataOneRecord.filterByOwner = 'My OWD Sharing Reports';
                }
                if(finalResponse.whereCondition.conditions != null){
                    for(Conditions oneConditionsRec : finalResponse.whereCondition.conditions){
                        if(oneConditionsRec.field != null && oneConditionsRec.operator != null && oneConditionsRec.values.size() > 0){
                            whereConditions += oneConditionsRec.field + ' ' + oneConditionsRec.operator + ' ' + oneConditionsRec.values[0] + ' ,';
                        }
                    }
                }
                finalDataOneRecord.viewName = listviewRecord.Name;
                finalDataOneRecord.viewUniqueName = listviewRecord.DeveloperName;
                finalDataOneRecord.additionalFilters = whereConditions;
                finalDataOneRecord.selectedFields = selectedFields;
                finalDataOneRecord.totalRecords = totalListViews;
                finalDataList.add(finalDataOneRecord);
            }
        }
        return finalDataList;*/
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Execute the Batch Apex to get the all List View Records 
*/
    @AuraEnabled
    public static String listViewBatchExecution(){
        String listViewBatchApexId = Database.executeBatch(new ListViewBatchApex(),20);
        return listViewBatchApexId;
    }
    public class FinalClass{
        @AuraEnabled
        public String viewName { get; set; }
        @AuraEnabled
        public String sobjectType { get; set; }
        @AuraEnabled
        public String viewUniqueName { get; set; }
        @AuraEnabled
        public String filterByOwner { get; set; }
        @AuraEnabled
        public String additionalFilters { get; set; }
        @AuraEnabled
        public String selectedFields { get; set; }
        @AuraEnabled
        public Integer totalRecords { get; set; }
    } 
    public class ListViewJSONData{
        @AuraEnabled
        public List<Columns> columns { get; set; }
        @AuraEnabled
        public String scope { get; set; }
        @AuraEnabled
        public String sobjectType { get; set; }
        @AuraEnabled
        public WhereConditions whereCondition { get; set; }
    }
    public class Columns{
        @AuraEnabled
        public String fieldNameOrPath { get; set; }
        @AuraEnabled
        public Boolean hidden { get; set; }
    }
    public class WhereConditions{
        @AuraEnabled
        public List<Conditions> conditions { get; set; }
    }
    public class Conditions{
        @AuraEnabled
        public String field { get; set; }
        @AuraEnabled
        public String operator { get; set; }
        @AuraEnabled
        public List<String> values { get; set; }
    }

/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will Execute to get the Data for ListView 
*/
    public static HttpResponse getListViewDetails(String toolingAPIURL){
        HttpRequest req = new HttpRequest();
        String sfdcURL = System.URL.getOrgDomainUrl().toExternalForm();
        req.setEndpoint(sfdcURL + toolingAPIURL);
        req.setMethod('GET');
        req.setTimeout(120000);
        String sessionId = UserInfo.getSessionId();
        String authorizationHeader = 'OAuth ' + sessionId;
        req.setHeader('Authorization', authorizationHeader);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will run Future method to get Managed Package Assigned Users details
*/
    @AuraEnabled
    public static void fetchManagedPackageLicenseData(){
        ManagedPackageLicenseFutureController.getManagedPackageDetails();
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below method will fetch Table Data for Option 10
*/
    @AuraEnabled
    public static List<HierarchyService.ParentChildren> fetchTableDataOption10(){
        List<HierarchyService.ParentChildren> parentChildren = HierarchyService.getParentChildrenList(HierarchyService.getUserPermissionSetList(), 'PermissionSet');
        system.debug('=======parentChildren===>===intel==='+parentChildren.size());
        system.debug('=======parentChildren===>===intel=123=='+parentChildren);
        return parentChildren;
    }
    public class Result{
        @AuraEnabled
        public List<Record> records{
            get;
            set;
        }
    }
    public class Record{
        @AuraEnabled
        public string Id{
            get;
            set;
        }
        @AuraEnabled
        public string Name{
            get;
            set;
        }
    }
    //It will Store the JSON as Custom and Standard Object Information
    public class ObjectDetails{   
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Boolean type;
        @AuraEnabled
        public String pluralName;
        @AuraEnabled
        public String objectPrefix;   
    }
    public class ProfileData{   
        @AuraEnabled
        public String label;
		 @AuraEnabled
        public String value;        
          
    }
    
    
    //Below Wrapper Class will Store Data Related to Layouts
    public class JSONData{
        @AuraEnabled
        public String objectName{
            get;
            set;
        }
        @AuraEnabled
        public String developerName{
            get;
            set;
        }
        @AuraEnabled
        public List<LayoutData> layoutDatas{
            get;
            set;
        }
        @AuraEnabled
        public List<FieldInfo> allFieldInfos{
            get;
            set;  
        }
    }
    public class LayoutData{
        @AuraEnabled
        public String layoutName{
            get;
            set;
        }
        @AuraEnabled
        public List<String> fieldInfos{
            get;
            set;  
        }
    }
    public class FieldInfo{
        @AuraEnabled
        public string label{
            get; set;
        }
        @AuraEnabled
        public string apiName{
            get; set;
        }
        @AuraEnabled
        public string type{
            get; set;
        }
    }  
    //Below Wrapper Class will Save the Data of Store in Custom Object
    public class RefactorDataToGenerateExcel{
        @AuraEnabled
        public string objectName{
            get; set;
        }
        @AuraEnabled
        public List<List<String>> fieldInfo{
            get; set;
        }
    }
    //Below Wrapper Class will store the Data for Option 21
    public class DashboardClass{
        @AuraEnabled
        public string dashboardName{
            get; set;
        }
        @AuraEnabled
        public String url{
            get; set;
        }
        @AuraEnabled
        public String setToSpecifiedUser{
            get; set;
        }
        @AuraEnabled
        public String userName{
            get; set;
        }
    }
}