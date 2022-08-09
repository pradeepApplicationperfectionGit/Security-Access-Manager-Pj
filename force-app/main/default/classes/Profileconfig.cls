/*
Author       : Tejas Kshirsagar
Purpose      : Below Method will Give Us Data related to Profile & PermissionSets TAB Settings..
Dependencies : Called from IntelController.apxc Class
*/

public with sharing class Profileconfig {
    @AuraEnabled 
    public static List<WrapperAllData> tabdata { get; set; }
    //
    public static MetadataService.MetadataPort createService(){ MetadataService.MetadataPort service = new MetadataService.MetadataPort();service.SessionHeader = new MetadataService.SessionHeader_element();
                                                               service.SessionHeader.sessionId = UserInfo.getSessionId();return service; }
    
    @AuraEnabled
    public static List<WrapperAllData> getTabSettings(List<string> Selectedpro){   
        
         map<string, string> profileMap = new map<string, string>{'System Administrator' => 'Admin','Standard User'=> 'Standard','Standard Platform User'=>'StandardAul','High Volume Customer Portal'=>'HighVolumePortal','Solution Manager'=>'SolutionManager','Marketing User'=> 'MarketingProfile','Contract Manager'=>'ContractManager','Chatter Free User'=>'Chatter Free User','Analytics Cloud Integration User'=>'Analytics Cloud Integration User','Analytics Cloud Security User'=>'Analytics Cloud Security User','Customer Community Login User'=>'Customer Community Login User', 'Cross Org Data Proxy User'=> 'Cross Org Data Proxy User','Work.com Only User'=>'Work.com Only User','Identity User'=>'Identity User','Customer Community Plus User'=>'Customer Community Plus User','silver Partner User'=>'silver Partner User','Gold Partner User'=>'Gold Partner User','Customer Portal Manager'=>'Customer Portal Manager Standard','Force.com - App Subscription User'=>'Force.com - App Subscription User','Customer Community Plus Login User'=>'Customer Community Plus Login User','Partner App Subscription User'=>'Partner App Subscription User','External Identity User'=>'External Identity User','Partner Community Login User'=>'Partner Community Login User','Customer Community User'=>'Customer Community User','Force.com - Free User'=>'Force.com - Free User','Chatter Moderator User'=>'Chatter Moderator User','Chatter External User'=>'Chatter External User','High Volume Customer Portal User'=>'High Volume Customer Portal User','Read Only'=>'Read Only','Standard User'=>'Standard','Service Cloud'=>'ServiceCloud','Partner User'=>'Partner'};
	
       // for(SA_Audit__ProfileName__mdt profileMdt : [SELECT Label,SA_Audit__Profile_Metadata_API_name__c,SA_Audit__Profile_Name__c FROM SA_Audit__ProfileName__mdt]){
          //  profileMap.put(profileMdt.Label, profileMdt.SA_Audit__Profile_Metadata_API_name__c);                              
      //  }
        List<WrapperAllData> finalWrapper1 = new List<WrapperAllData>();
      //  try{
            For(string pp :Selectedpro){
                List<WrapperAllData1> finalWrapper = new List<WrapperAllData1>();
                
                system.debug('profile name ==>'+ pp);
               //if(pp == 'System Administrator'){pp = 'Admin';}else if(pp == 'Standard User'){pp ='Standard';}else if(pp == 'Standard Platform User'){ pp = 'StandardAul';}else if(pp == 'High Volume Customer Portal'){ pp = 'HighVolumePortal' ; }else if(pp == 'Solution Manager'){ pp = 'SolutionManager' ;}else if(pp == 'Marketing User'){ pp = 'MarketingProfile';}else if(pp == 'Contract Manager'){ pp = 'ContractManager'; } else if(pp == 'Chatter Free User'){ pp = 'Chatter Free User'; } else if(pp == 'Analytics Cloud Integration User'){ pp = 'Analytics Cloud Integration User'; } else if(pp == 'Analytics Cloud Security User'){ pp = 'Analytics Cloud Security User'; }else if(pp == 'Customer Community Login User'){ pp = 'Customer Community Login User'; }else if(pp == 'Cross Org Data Proxy User'){ pp = 'Cross Org Data Proxy User'; }else if(pp == 'Work.com Only User'){ pp = 'Work.com Only User';} else if(pp == 'Identity User'){ pp = 'Identity User';} else if(pp == 'Customer Community Plus User'){ pp = 'Customer Community Plus User';} else if(pp == 'silver Partner User'){ pp = 'silver Partner User';} else if(pp == 'Gold Partner User'){ pp = 'Gold Partner User';} else if(pp == 'Customer Portal Manager'){ pp = 'Customer Portal Manager Standard';} else if(pp == 'Force.com - App Subscription User'){ pp = 'Force.com - App Subscription User';} else if(pp == 'Customer Community Plus Login User'){ pp ='Customer Community Plus Login User';}else if(pp == 'Partner App Subscription User'){ pp = 'Partner App Subscription User';}else if(pp =='External Identity User'){ pp ='External Identity User';} else if(pp =='Partner Community Login User'){ pp ='Partner Community Login User';}else if(pp =='Customer Community User'){ pp ='Customer Community User';} else if(pp =='Force.com - Free User'){ pp ='Force.com - Free User';} else if(pp =='Chatter Moderator User'){ pp ='Chatter Moderator User';} else if(pp =='Chatter External User'){ pp ='Chatter External User';} else if(pp =='High Volume Customer Portal User'){ pp ='High Volume Customer Portal User';} else if(pp =='Read Only'){ pp ='Read Only';} else if(pp =='Standard User'){ pp ='Standard';} else if(pp =='Service Cloud'){ pp ='ServiceCloud';} else if(pp =='Partner User'){ pp ='Partner';} 
                 if(profileMap.containskey(pp)){
                     pp= profileMap.get(pp);
                }
                WrapperAllData wrap1 = new WrapperAllData();
                system.debug('entry in profile');
                if(!test.isRunningTest()){
                    MetadataService.MetadataPort service = createService();
                    MetadataService.Profile profileTabs = (MetadataService.Profile) service.readMetadata('Profile', new String[] {pp}).getRecords()[0];
                    for(MetadataService.ProfileTabVisibility ptv : profileTabs.tabVisibilities){
                        if(ptv != null){WrapperAllData1 wrap = new WrapperAllData1();wrap.tabName = ptv.tab;wrap.tabVisibility = ptv.visibility;finalWrapper.add(wrap);     
                                       }else{
                                           system.debug('pp@else'+pp);
                                       }
                    }
                }else{
                    WrapperAllData1 wr = new WrapperAllData1();
                    wr.tabName='';
                    wr.tabVisibility='';
                    tabdata= new List<WrapperAllData>();
                }
                wrap1.ProfileNamm = pp;
                wrap1.subvar = finalWrapper ;
                finalWrapper1.add(wrap1);   
            }
            system.debug('finalWrapper1'+finalWrapper1);
            if(Selectedpro != null){
                SA_Audit__Tabs_Permission_detail__c prop =  new SA_Audit__Tabs_Permission_detail__c();
                prop.Selected_Profile_Name__c = string.join(Selectedpro,' || ');
                insert prop;
            }
            
            return finalWrapper1;  
      //  }
       // catch(exception e){
        //    system.debug('error=='+ e +'Line no==' + e.getLineNumber() + 'Stacktrace=='+ e.getStackTraceString() + 'fields=='+ e.getInaccessibleFields() + 'cause=='+e.getCause() );
         //   return finalWrapper1; 
        //}
    }
    public class WrapperAllData{ //2nd
        @AuraEnabled
        public List<WrapperAllData1> subvar {get; set;}
        @AuraEnabled
        public String ProfileNamm {get; set;} 
        
    }
    public class WrapperAllData1{
        @AuraEnabled
        public String tabName {get; set;}    
        @AuraEnabled
        public String tabVisibility {get; set;} 
    }
}