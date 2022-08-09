/*
Author       : Himanshu Kr. Varshney
Description  : Apex Controller for Intel Tab(For Option 16)
Dependencies : Called from IntelController.apxc Class
*/
public with sharing class ProfilesWithNoUserDetails{
    @AuraEnabled
    public String xmlheader{ get; set; }
    @AuraEnabled
    public Utils.ReportInfos reportInfos{ get; set; }
    @AuraEnabled
    public List<WrapperData> profilesWithNoUsers{ get; set; }
    public ProfilesWithNoUserDetails(){
        xmlheader = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        profilesWithNoUsers = getProfilesData();
        reportInfos = Utils.getReportsInfos();
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below Method will Give Us Data related to Profiles
*/  
    @AuraEnabled
    @RemoteAction
    public static List<WrapperData> getProfilesData(){
        string ActiveUserCount1 = '0';
        string InActiveUserCount1 = '0';
        List<WrapperData> wrapperDataList = new List<WrapperData>();
        List<PermissionSet> profileList = [SELECT ProfileId, isCustom, Profile.Name, Profile.UserLicense.Name FROM PermissionSet WHERE ProfileId != null];
        List<User> userList = [SELECT Id, ProfileId, isActive  FROM User Where ProfileId != null];
       // Integer assignedUsers = [ SELECT count() FROM User WHERE IsActive = true AND ProfileId IN userList.ProfileId ];

        for(PermissionSet permissionSetRecord: profileList){
              ActiveUserCount1 = '0';
             InActiveUserCount1 = '0';
             
            WrapperData oneWrapperData = new WrapperData();
            oneWrapperData.profileName = permissionSetRecord.Profile.Name;
            oneWrapperData.licenseName = permissionSetRecord.Profile.UserLicense.Name;
     
            if(permissionSetRecord.isCustom){
                oneWrapperData.isCustomProfile = permissionSetRecord.isCustom;
            }
            else{
                oneWrapperData.isCustomProfile = permissionSetRecord.isCustom;
            }
            for(User userOneRecord: userList){
               /* if(userOneRecord.IsActive == true){
                    ActiveUserCount1 = ActiveUserCount1 + 1;
                       system.debug('ActiveUserCount1'+ ActiveUserCount1); 
                }
                 else{
					 InActiveUserCount1 =InActiveUserCount1 + 1;
                 }*/
                
                if(userOneRecord.profileId == permissionSetRecord.ProfileId){
                    if(userOneRecord.isActive){
                        oneWrapperData.usedByActiveUser = 'Yes ';
                       // oneWrapperData.ActiveUserCount =  ActiveUserCount1;
                       //ActiveUserCount1++ ;
                        ActiveUserCount1 =  String.valueOf(Integer.ValueOf(ActiveUserCount1)+1); 
                        
                    }
                    
                    else{
                        oneWrapperData.usedByInactiveUser = 'Yes ';
                        
                       // oneWrapperData.InActiveUserCount = InActiveUserCount1;
                       //InActiveUserCount1++ ;
                       InActiveUserCount1 =  String.valueOf(Integer.ValueOf(InActiveUserCount1)+1);
                   
                            
                    }
                     system.debug('ActiveUserCount1'+ InActiveUserCount1); 
                }
            }
            oneWrapperData.ActiveUserCount =  ActiveUserCount1;
            oneWrapperData.InActiveUserCount = InActiveUserCount1;
            If(oneWrapperData.ActiveUserCount == '0'){
                oneWrapperData.ActiveUserCount = 'No';
            }
            if(oneWrapperData.InActiveUserCount == '0'){
                 oneWrapperData.InActiveUserCount = 'No';
            }
            system.debug('testing ActiveUserCount'+ActiveUserCount1 +'----'+InActiveUserCount1);
            wrapperDataList.add(oneWrapperData);
        }
        return wrapperDataList;
    }
    //Below Class will Hold the Wrapper Data
    public class WrapperData{
        @AuraEnabled
        public String profileName {get; set;}
        @AuraEnabled
        public String licenseName {get; set;}
        @AuraEnabled
        public String usedByActiveUser {get; set;}
        @AuraEnabled
        public String usedByInactiveUser {get; set;}
        @AuraEnabled
        public Boolean isCustomProfile {get; set;}
        @AuraEnabled
        public string ActiveUserCount {get; set;}
        @AuraEnabled
        public string InActiveUserCount {get; set;}
    }
}