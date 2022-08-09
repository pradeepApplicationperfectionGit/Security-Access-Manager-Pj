/*
Author       : Himanshu Kr. Varshney
Description  : Apex Controller for Intel Tab(For Option 18)
Dependencies : Called from IntelController.apxc Class
*/
public with sharing class PublicGroupController{
    @AuraEnabled
    public String xmlheader{ get; set; }
    @AuraEnabled
    public Utils.ReportInfos reportInfos{ get; set; }
    @AuraEnabled
    public List<WrapperData> publicGroupData{ get; set; }
    public List<GroupMember> userGroups {get; set;}
    public PublicGroupController(){
        xmlheader = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        publicGroupData = getPublicGroupDetails();
        PublicGroupData = getPublicGroupMembersDetails();
        reportInfos = Utils.getReportsInfos(); 
    }
/*
Author  : Himanshu Kr. Varshney
Purpose : Below Method will Give Us Data related to Public Group
*/
    @AuraEnabled
    public static List<WrapperData> getPublicGroupDetails(){
        List<Group> groupList = [SELECT Id, (SELECT UserOrGroupId FROM GroupMembers), Name, DeveloperName, LastModifiedDate, CreatedDate, CreatedBy.Name, Type FROM Group WHERE Type = 'Regular'];
        List<WrapperData> finalWrapperData = new List<WrapperData>();
        Set<Id> listOfActiveUsersIds = new Map<Id, User>([SELECT Id, isActive FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember) AND isActive = true]).keySet();
        Set<Id> listOfInActiveUsersIds =  new Map<Id, User>([SELECT Id, isActive FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember) AND isActive = false]).keySet();
        for(Group groupRecord : groupList){
            WrapperData wrapperDataOne = new WrapperData();
            wrapperDataOne.label = groupRecord.Name;
            wrapperDataOne.groupName = groupRecord.DeveloperName;
            wrapperDataOne.createdBy = groupRecord.CreatedBy.Name;
            wrapperDataOne.createdDate = groupRecord.CreatedDate.format('MM/dd/yyyy hh:mm a');
            wrapperDataOne.lastModifiedDate = groupRecord.LastModifiedDate.format('MM/dd/yyyy hh:mm a');
            for(GroupMember groupMemberRecord: groupRecord.GroupMembers){
                if(listOfActiveUsersIds.contains(groupMemberRecord.UserOrGroupId)){
                    wrapperDataOne.memberIncludesActiveUser = 'Yes';
                }
                else if(listOfInActiveUsersIds.contains(groupMemberRecord.UserOrGroupId)){
                    wrapperDataOne.memberIncludesInActiveUser = 'Yes';
                }
            }
            finalWrapperData.add(wrapperDataOne);
        }
        System.debug('finalWrapperData--'+finalWrapperData);
        return finalWrapperData;
    }
  /*
   Tejas kshirsagar
   Purpose : Below Method will Give Us Data related to Public Group Membership details.
*/
    @AuraEnabled
    public static List<WrapperData> getPublicGroupMembersDetails(){
        System.debug('Testing getPublicGroupMembersDetails');
        List<string> userss = new List<string>();
        List<string> groups = new List<string>();
        List<Group> groupList = [ SELECT Id, (SELECT UserOrGroupId,Group.Name FROM GroupMembers), Name, DeveloperName, LastModifiedDate,LastModifiedby.name, CreatedDate, CreatedBy.Name, Type FROM Group ];
        System.debug('groupList--'+groupList);
        List<WrapperData> finalWrapperData = new List<WrapperData>();
        Map<Id,User> listOfActiveUsersIds = new Map<Id, User>([SELECT Id,Alias,Name,UserName, Userrole.name,IsActive,Profile.Name,LastLoginDate FROM User WHERE Id IN (SELECT UserOrGroupId FROM GroupMember )]);
       /*(id userList : listOfActiveUsersIds.keyset()){
            userss.add(userList);
            system.debug('userList'+userList);
        }*/
        List<GroupMember> userGroups = [SELECT Id, Group.name FROM GroupMember WHERE UserOrGroupId IN (SELECT Id FROM User where Id IN:  listOfActiveUsersIds.keyset())];
        for(GroupMember grpList:userGroups){
            groups.add(grpList.Group.name);
            
        }
        system.debug('groups '+groups);
        System.debug('listOfActiveUsersIds--'+listOfActiveUsersIds.keyset());
        for(Group groupRecord : groupList){
            
             for(GroupMember groupMemberRecord: groupRecord.GroupMembers){
                 string val ='';
                    system.debug('entry');
              if(listOfActiveUsersIds.containsKey( groupMemberRecord.UserOrGroupId )){
                  val += groupMemberRecord.group.name ;
                  system.debug('val@@'+Val);
                  WrapperData wrapperDataOne = new WrapperData(); 
                  wrapperDataOne.label = groupRecord.Name;
                  System.debug('groupRecord.Name--'+groupRecord.Name);
                  wrapperDataOne.groupName = groupRecord.DeveloperName;
                  wrapperDataOne.createdBy = groupRecord.CreatedBy.Name;
                  wrapperDataOne.createdDate = groupRecord.CreatedDate.format('MM/dd/yyyy hh:mm a');
                  wrapperDataOne.modifyby = groupRecord.LastModifiedby.name;
                  system.debug('entry');
                    wrapperDataOne.Alias = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).Alias;
                    wrapperDataOne.Name = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).Name;
                    wrapperDataOne.UserName = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).UserName;
                    wrapperDataOne.UserRole = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).Userrole.name;
                  if(groups.contains(val)){
                      system.debug('entry@@');
                      wrapperDataOne.SubGroups = val; //List to string conversion reference                      
                  }
                  
                  wrapperDataOne.Active = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).IsActive;
                    wrapperDataOne.ProfileName = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).Profile.Name;
                    wrapperDataOne.LastLogin = listOfActiveUsersIds.get(groupMemberRecord.UserOrGroupId).LastLoginDate;					
                    System.debug('wrapperDataOne--'+wrapperDataOne);
                 finalWrapperData.add(wrapperDataOne);
              }
                 
				

            }  
            
            
                /*else if(listOfInActiveUsersIds.contains(groupMemberRecord.UserOrGroupId)){
                    wrapperDataOne.memberIncludesInActiveUser = 'Yes';
Select id,name,(select userorGroupID from groupmember) from group where type = ‘regular’

Select id.,alias,name,username,userrole.name,isactive,profile.name,lastlogindate from user where id IN (select userorgroupid from groupmember)
                }*/
            
            
        }
        System.debug('finalWrapperData---'+finalWrapperData);
        return finalWrapperData;
    }
    //
    //Below Wrapper Class will store the Data which will be Related to Public Groups
    public class WrapperData{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String groupName {get; set;}
        @AuraEnabled
        public String createdBy {get; set;}
        @AuraEnabled
        public String createdDate {get; set;}
        @AuraEnabled
        public String lastModifiedDate {get; set;}
        @AuraEnabled
        public String modifyby {get; set;}
        @AuraEnabled
        public String memberIncludesActiveUser {get; set;}
        @AuraEnabled
        public String memberIncludesInActiveUser {get; set;}
        
        //getPublicGroupMembersDetails @TEJAS
         @AuraEnabled
        public String Alias {get; set;}
        @AuraEnabled
        public String Name {get; set;}
        @AuraEnabled
        public String UserName {get; set;}
        @AuraEnabled
        public String UserRole {get; set;}
        @AuraEnabled
        public Boolean Active {get; set;}
        @AuraEnabled
        public String ProfileName {get; set;}
        @AuraEnabled
        public DateTime LastLogin {get; set;}
        @AuraEnabled
        public String SubGroups {get; set;}


        
    }
}