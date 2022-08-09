/*
Author/Modified Code By : Himanshu Kr. Varshney
*/
public class HierarchyService{
    public static Map<Id, User> userMap1= new Map<Id, User>([SELECT Id, Name, UserRole.Name, Profile.Name FROM User WHERE IsActive = true LIMIT 50000]);
  
    @AuraEnabled
    public static List<User> getUserRoleList(){   
        return [SELECT Name, UserRoleId, UserRole.Name, LastLoginDate FROM User WHERE IsActive = true LIMIT 50000];
    }
    @AuraEnabled
    public static List<User> getUserProfileAndRoleList(){
        return [SELECT Name, IsActive, Manager.Name, UserRole.Name, UserRole.Id, Profile.Name, LastLoginDate From User WHERE IsActive = true LIMIT 50000];
    }
    @AuraEnabled
    public static List<SObject> getUserTerritoryList(){
        return (List<SObject>)database.query('SELECT Territory2Id, Territory2.Name, IsActive, RoleInTerritory2, UserId, User.Name, User.LastLoginDate FROM UserTerritory2Association WHERE User.IsActive = true limit 50000');
    }
    @AuraEnabled
    public static List<UserTerritoryInfo> getOldUserTerritoryList(){
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE IsActive = true LIMIT 50000]);
        Map<Id, sObject> territoryMap = new Map<Id, sObject>((List<sObject>)database.query('SELECT Id, Name FROM Territory'));
        Set<Id> userIdSet = userMap.keySet();
        String soql = 'SELECT TerritoryId, IsActive, UserId FROM UserTerritory WHERE UserId IN :userIdSet limit 50000';
        List<sObject> userTerritory = database.query(soql);
        List<UserTerritoryInfo> userTerritoryInfo = new List<UserTerritoryInfo>();
        UserTerritoryInfo uti;
        for(sObject ut: userTerritory){
            uti = new UserTerritoryInfo();
            uti.userName = userMap.get((Id)ut.get('UserId')).Name;
            uti.territoryName = (String)territoryMap.get((Id)ut.get('TerritoryId')).get('Name');
            uti.userTerr = ut;
            userTerritoryInfo.add(uti);
        }
        return userTerritoryInfo;
    }
    @AuraEnabled
    public static List<PermissionSetAssignment> getUserPermissionSetList(){
        
        return [SELECT Id, Assignee.Profile.Name, Assignee.UserRole.Name, AssigneeId, Assignee.Name, Assignee.LastLoginDate, PermissionSetId, PermissionSet.Name, PermissionSet.Label, PermissionSet.License.Name, PermissionSet.IsCustom FROM PermissionSetAssignment WHERE Assignee.IsActive = true  AND (NOT PermissionSet.Name LIKE 'X00%') limit 50000];
    }
    @AuraEnabled
    public static List<ParentChildren> getParentChildrenList(List<PermissionSetAssignment> recList, String parentObj){
        Map<Id, List<PermissionSetAssignment>> parentByChildrenMap = new Map<Id, List<SObject>>();
        Map<Id, User>usrProfileMap = new Map<Id, User>();
        String parentField = parentObj + 'Id';
        system.debug('========recList===>'+recList);
        
        for (PermissionSetAssignment rec : recList){
            system.debug('========rec===>'+rec);
            Id parentFieldId = (Id)rec.get(parentField);
            if(!parentByChildrenMap.containsKey(parentFieldId)){
                parentByChildrenMap.put(parentFieldId, new List<PermissionSetAssignment>());
            }
            parentByChildrenMap.get(parentFieldId).add(rec);
        }
        
        system.debug('========parentByChildrenMap======='+parentByChildrenMap);
        
        List<ParentChildren> parentChildrenList = new List<ParentChildren>();
        for (Id key:  parentByChildrenMap.keySet()){
            system.debug('========parentChildrenList===>'+parentByChildrenMap.get(key));
            parentChildrenList.add(new ParentChildren((String)parentByChildrenMap.get(key)[0].getSobject(parentObj).get('Name'), key, parentByChildrenMap.get(key)));
        }
        
        system.debug('======tttt=parentChildrenList===>'+parentChildrenList);
        return parentChildrenList;
    }
    @AuraEnabled
    public static List<ParentChildren> getOldParentChildrenList(List<UserTerritoryInfo> recList, String parentObj){
        Map<Id, List<UserTerritoryInfo>> parentByChildrenMap = new Map<Id, List<UserTerritoryInfo>>();
        String parentField = parentObj + 'Id';
        for (UserTerritoryInfo rec : recList){
            Id parentFieldId = (Id)rec.userTerr.get(parentField);
            if(!parentByChildrenMap.containsKey(parentFieldId)){
                parentByChildrenMap.put(parentFieldId, new List<UserTerritoryInfo>());
            }
            parentByChildrenMap.get(parentFieldId).add(rec);
        }
        system.debug('========parentByChildrenMap======='+parentByChildrenMap);
        List<ParentChildren> parentChildrenList = new List<ParentChildren>();
        for (Id key:  parentByChildrenMap.keySet()){
            parentChildrenList.add(new ParentChildren((String)parentByChildrenMap.get(key)[0].userName, key, parentByChildrenMap.get(key)));
        }
        return parentChildrenList;
    }
    @AuraEnabled
    public static List<HierarchyItem> getRolesHierarchyList(){
        //Get all Hierarchy Records Related to UserRole
        Map<Id, UserRole> mapHierarchy = new Map<Id, UserRole>([SELECT Id, Name, DeveloperName, CaseAccessForAccountOwner, ContactAccessForAccountOwner, OpportunityAccessForAccountOwner, 
                                                                ParentRoleId, ForecastUserId, MayForecastManagerShare, /*PortalRole,*/ PortalType, RollupDescription, LastModifiedBy.Name
                                                                FROM UserRole limit 50000]);
        return getHierarchyList(mapHierarchy, 'ParentRoleId', null, null);
    }
    @AuraEnabled
    public static List<HierarchyItem> getOldTerritoriesHierarchyList(){
        String soql = 'SELECT Id, Name, DeveloperName, AccountAccessLevel, CaseAccessLevel, ContactAccessLevel, OpportunityAccessLevel, ParentTerritoryID, Description, ForecastUserId, LastModifiedBy.Name FROM Territory';
        //Get all Hierarchy Records Related to UserRole
        Map<Id, SObject> mapHierarchy = new Map<Id, SObject>((List<SObject>) database.query(soql));
        return getHierarchyList(mapHierarchy, 'ParentTerritoryID', null, null);
    }
    @AuraEnabled
    public static List<HierarchyItem> getTerritoriesHierarchyList(){
        //Get all Hierarchy Records Related to UserRole
        String soql = 'SELECT Id, Name, DeveloperName, AccountAccessLevel, CaseAccessLevel, ContactAccessLevel, ';
        soql += ' OpportunityAccessLevel, ParentTerritory2Id, Description, ForecastUserId, Territory2ModelId, Territory2TypeId, LastModifiedBy.Name ';
        soql += ' FROM Territory2';
        Map<Id, SObject> mapHierarchy = new Map<Id, SObject>((List<SObject>) database.query(soql));
        Map<Id,SObject> territoryTypeMap = new Map<Id,SObject>((List<SObject>) database.query('SELECT Id, Priority, MasterLabel, Description FROM Territory2Type'));
        Map<Id,SObject> territoryModelMap = new Map<Id,SObject>((List<SObject>) database.query('SELECT Id, Name, ActivatedDate, DeactivatedDate, Description FROM Territory2Model'));
        return getHierarchyList(mapHierarchy, 'ParentTerritory2Id', territoryTypeMap, territoryModelMap);
    }
    @AuraEnabled
    public static List<HierarchyItem> getHierarchyList(Map<Id, SObject> mapHierarchy, String parentField, Map<Id,SObject> territoryTypeMap, Map<Id,SObject> territoryModelMap){
        Map<Id, List<Id>> parentToChildrenMap = new Map<Id,List<Id>>();
        List<HierarchyItem> parentHierarchyItemList = new List<HierarchyItem>();
        for (SObject rec: mapHierarchy.values()){
            if(rec.get(parentField) != null){
                if(!parentToChildrenMap.containskey((Id)rec.get(parentField))){
                    parentToChildrenMap.put((Id)rec.get(parentField), new List<Id>());
                }
                parentToChildrenMap.get((Id)rec.get(parentField)).add(rec.Id);
            } 
            else{
                if(parentField == 'ParentTerritory2Id'){
                    parentHierarchyItemList.add(new HierarchyItem(rec, 0, null, '', territoryTypeMap.get((Id)rec.get('Territory2TypeId')), territoryModelMap.get((Id)rec.get('Territory2ModelId'))));
                } 
                else{
                    parentHierarchyItemList.add(new HierarchyItem(rec, 0, null, '', null, null));
                }
            }
        }
        Integer hierarchyIndex = 0;
        Id chId;
        List<HierarchyItem> finalHierarchyItemList = new List<HierarchyItem>();
        for(HierarchyItem hi: parentHierarchyItemList){
            finalHierarchyItemList.add(hi);
            chId = hi.objItem.Id;
            getCh(parentToChildrenMap, chId,  finalHierarchyItemList, hierarchyIndex, mapHierarchy, territoryTypeMap, territoryModelMap);
        }
        return finalHierarchyItemList;
    }
    @AuraEnabled
    public static void getCh(Map<Id, List<Id>> parentToChildrenMap, Id keyId, List<HierarchyItem> hierarchyItemList, Integer hierarchyIndex, Map<Id, SObject> mapHierarchy, Map<Id,SObject> territoryTypeMap, Map<Id,SObject> territoryModelMap){
        if(parentToChildrenMap.containsKey(keyId) && parentToChildrenMap.get(keyId).size() > 0){
            hierarchyIndex ++;
            for(Id chId: parentToChildrenMap.get(keyId)){
                if(territoryTypeMap != null && !territoryTypeMap.isEmpty()){
                    hierarchyItemList.add(new HierarchyItem(mapHierarchy.get(chId), hierarchyIndex, keyId, (String)mapHierarchy.get(keyId).get('Name'), territoryTypeMap.get((Id)mapHierarchy.get(chId).get('Territory2TypeId')), territoryModelMap.get((Id)mapHierarchy.get(chId).get('Territory2ModelId'))));
                } 
                else{
                    hierarchyItemList.add(new HierarchyItem(mapHierarchy.get(chId), hierarchyIndex, keyId, (String)mapHierarchy.get(keyId).get('Name'), null, null));
                }
                getCh(parentToChildrenMap, chId,  hierarchyItemList, hierarchyIndex, mapHierarchy, territoryTypeMap, territoryModelMap);
            }
        }
    }
    //Inner Class for Maintaing Hierarchy Items
    public virtual class HierarchyItem{
        @AuraEnabled
        public String itemValue{ get; set; } 
        @AuraEnabled
        public Id reportsToId{ get; set; } 
        @AuraEnabled
        public String reportsToName{ get; set; }  
        @AuraEnabled
        public Integer hierarchyIndexNo{ get; set; } 
        @AuraEnabled
        public SObject objItem{ get; set; }
        @AuraEnabled
        public SObject territoryType{ get; set; }
        @AuraEnabled
        public SObject territoryModel{ get; set; }
        public HierarchyItem(SObject objItem, Integer hierarchyIndexNo, Id reportsToId, String reportsToName, SObject territoryType, SObject territoryModel){
            String spaceCount = '';
            for(integer i = 0; i < hierarchyIndexNo; i++){
                spaceCount = spaceCount  + '--';//'&nbsp;&nbsp;';
            }
            this.objItem = objItem;
            this.itemValue = spaceCount + objItem.get('Name');
            this.hierarchyIndexNo = hierarchyIndexNo;
            this.reportsToId = reportsToId;
            this.reportsToName = reportsToName;
            this.territoryType = territoryType;
            this.territoryModel = territoryModel;
        }
    }
    public class ParentChildren{
        @AuraEnabled
        public String parentName{ get; set; }
         @AuraEnabled
        public String profileName{ get; set; }
         @AuraEnabled
        public String roleName{ get; set; }
        @AuraEnabled
        public String parentId{ get; set; }
        @AuraEnabled
        public List<List<PermissionSetAssignment>> bigChildrenList{ get; set; }
        @AuraEnabled
        public List<UserTerritoryInfo> utChildrenList{ get; set;}
        
        public ParentChildren(String parentName, Id parentId, List<PermissionSetAssignment> childrenList){
           // system.debug('====54645654==childrenList ==>>'+childrenList.size() );
           // id asgID ;
            
           // for(PermissionSetAssignment perm : childrenList){
             //   system.debug('perm==>'+perm);
              //  Schema.SObjectType sObjectType = perm.getSObjectType();   
              //  Map<string, Object> fieldsToValue = perm.getPopulatedFieldsAsMap(); 
               // system.debug('fieldsToValue'+fieldsToValue); 
               // System.debug('@@@@=='+'AssigneeId' + '=' + fieldsToValue.get('AssigneeId'));
               // asgID = fieldsToValue.get('AssigneeId').toString();
                
            //}
           // system.debug('asgID==>'+asgID);
           // system.debug('childrenList==>>'+parentId);
        //    List<user> profiles = [select id, name, profile.name, userrole.name from user where id =: asgID ]; 
         //   System.debug('profiles query@@'+ profiles);
          
           // if(userMap1.containskey(asgID)){
               // if(userMap1.get(asgID).name=='James Burgess'){
               //     system.debug('========in==');
                  //  this.profileName= 'System Administrator';
                      //  this.roleName = 'CEO';
                //}else{
                //  	this.profileName = userMap1.get(asgID).profile.name;
                ///	this.roleName = userMap1.get(asgID).userrole.name;  
               // }
                
            //}
       //     this.profileName = 'Test';
         //  this.roleName = profiles[0].userrole.name;
           // system.debug('profileName==>'+profileName);

            this.parentId = parentId;
            Integer i = 0;
            bigChildrenList = new List<List<SObject>>();
            List<PermissionSetAssignment> tempChildren = new List<PermissionSetAssignment>();

            for(PermissionSetAssignment ch: childrenList){
                if(i < 1000){                
                    tempChildren.add(ch);
                    i++;
                 system.debug('====2==tempChildren ==>>'+tempChildren );
                } 
                else{
                    bigChildrenList.add(tempChildren);
                    system.debug('===1===bigChildrenList===>>>>'+bigChildrenList);
                    i = 1;
                    tempChildren = new List<SObject>();
                    tempChildren.add(ch);
                }
            }
            if(tempChildren.size() > 0){
                bigChildrenList.add(tempChildren);
            }
             system.debug('========123333===bigChildrenList===>>>>'+bigChildrenList);
        }
        
        public ParentChildren(String parentName, Id parentId, List<UserTerritoryInfo> childrenList){
            
            this.parentName = parentName;
            this.parentId = parentId;
            this.utChildrenList = childrenList;
            system.debug('utChildrenList=->'+utChildrenList);
        }
    } 
    public class UserTerritoryInfo{
        @AuraEnabled
        public String userName{ get; set; }
        @AuraEnabled
        public String territoryName{ get; set; }
        @AuraEnabled
        public sObject userTerr{ get; set; }
    }
}