/*
Author       : Tejas Kshirsagar
Purpose      : Below Method will Give Us Data related to Profile & PermissionSets TAB Settings..
Dependencies : Called from IntelController.apxc Class
*/
public class ProfileconfigExcelController
{
    @AuraEnabled
    public static List<WrapperAllData> tabdata { get; set; }
    @AuraEnabled
    public static String xmlheader{ get; set; }
    @AuraEnabled
    public Utils.ReportInfos reportInfos{ get; set; }
    public ProfileconfigExcelController(){
        xmlheader = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        reportInfos = Utils.getReportsInfos(); 
         String Props ;
        if(!test.isRunningTest()){
             Props = ApexPages.currentPage().getParameters().get('selectedprofile');
        }else{
            Props = '["Force.com - App Subscription User","Sales Manager"]';
        }
        List<string> deserializedProps = (List<string>)JSON.deserialize(Props, List<string>.class);
        system.debug('deserializedProps==='+deserializedProps);
        getTabSettings(deserializedProps);
    }
    public static MetadataService.MetadataPort createService(){ MetadataService.MetadataPort service = new MetadataService.MetadataPort();service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = UserInfo.getSessionId();return service; }
    @AuraEnabled
    public static List<WrapperAllData> getTabSettings(List<string> Selectedpro){
        tabdata = new List<WrapperAllData>();
        For(string pp :Selectedpro){
              if(pp == 'System Administrator'){pp = 'Admin';}else if(pp == 'Standard User'){pp ='Standard';}else if(pp == 'Standard Platform User'){ pp = 'StandardAul';}else if(pp == 'High Volume Customer Portal'){ pp = 'HighVolumePortal' ; }else if(pp == 'Solution Manager'){ pp = 'SolutionManager' ;}else if(pp == 'Marketing User'){ pp = 'MarketingProfile';}else if(pp == 'Contract Manager'){ pp = 'ContractManager'; } else if(pp == 'Chatter Free User'){ pp = 'Chatter Free User'; } else if(pp == 'Analytics Cloud Integration User'){ pp = 'Analytics Cloud Integration User'; } else if(pp == 'Analytics Cloud Security User'){ pp = 'Analytics Cloud Security User'; }else if(pp == 'Customer Community Login User'){ pp = 'Customer Community Login User'; }else if(pp == 'Cross Org Data Proxy User'){ pp = 'Cross Org Data Proxy User'; }else if(pp == 'Work.com Only User'){ pp = 'Work.com Only User';} else if(pp == 'Identity User'){ pp = 'Identity User';} else if(pp == 'Customer Community Plus User'){ pp = 'Customer Community Plus User';} else if(pp == 'silver Partner User'){ pp = 'silver Partner User';} else if(pp == 'Gold Partner User'){ pp = 'Gold Partner User';} else if(pp == 'Customer Portal Manager'){ pp = 'Customer Portal Manager Standard';} else if(pp == 'Force.com - App Subscription User'){ pp = 'Force.com - App Subscription User';} else if(pp == 'Customer Community Plus Login User'){ pp ='Customer Community Plus Login User';}else if(pp == 'Partner App Subscription User'){ pp = 'Partner App Subscription User';}else if(pp =='External Identity User'){ pp ='External Identity User';} else if(pp =='Partner Community Login User'){ pp ='Partner Community Login User';}else if(pp =='Customer Community User'){ pp ='Customer Community User';} else if(pp =='Force.com - Free User'){ pp ='Force.com - Free User';} else if(pp =='Chatter Moderator User'){ pp ='Chatter Moderator User';} else if(pp =='Chatter External User'){ pp ='Chatter External User';} else if(pp =='High Volume Customer Portal User'){ pp ='High Volume Customer Portal User';} else if(pp =='Read Only'){ pp ='Read Only';} else if(pp =='Standard User'){ pp ='Standard';} else if(pp =='Service Cloud'){ pp ='ServiceCloud';} else if(pp =='Partner User'){ pp ='Partner';} 
     
            if(!test.isRunningTest()){
                MetadataService.MetadataPort service = createService();
                MetadataService.Profile profileTabs = (MetadataService.Profile) service.readMetadata('Profile', new String[] {pp}).getRecords()[0]; 
                for(MetadataService.ProfileTabVisibility ptv : profileTabs.tabVisibilities){
                    if(ptv != null){WrapperAllData wrap = new WrapperAllData();wrap.tabName = ptv.tab;wrap.tabVisibility = ptv.visibility; wrap.ProfileNamm = pp;tabdata.add(wrap);     
                    } 
                }
            }else{
                WrapperAllData wr = new WrapperAllData();
                wr.tabName='';
                wr.tabVisibility='';
                wr.ProfileNamm = '';
                tabdata= new List<WrapperAllData>();
            }
        }
        return tabdata;
    }
    public class WrapperAllData{
        @AuraEnabled
        public String tabName {get; set;}    
        @AuraEnabled
        public String tabVisibility {get; set;} 
        @AuraEnabled
        public String ProfileNamm {get; set;}     }
}