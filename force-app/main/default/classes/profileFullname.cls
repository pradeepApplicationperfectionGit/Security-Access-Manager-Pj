public with sharing class  profileFullname {
    
    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
    public static void getTabSettings(){
        MetadataService.MetadataPort service = createService();
        MetadataService.Profile admin = (MetadataService.Profile) service.readMetadata('Profile', new String[] { 'System Administrator' }).getRecords()[0];
        for(MetadataService.ProfileTabVisibility ptv : admin.tabVisibilities){
            system.debug('tab name = ' + ptv.tab + ' & ' + 'visibility = ' + ptv.visibility);
        }
    }
}