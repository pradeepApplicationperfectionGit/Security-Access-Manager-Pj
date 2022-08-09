@isTest
private class SecurityUtilTest {
	static testMethod void myUnitTest() {
        String orgId = UserInfo.getOrganizationId();
        String NamespacePrefix = [SELECT Id , Name, NamespacePrefix FROM Organization WHERE ID = :orgID].NamespacePrefix;
    	List<SelectOption> prList = SecurityUtil.getAllProfilesList();
        system.assertNotEquals(prList.size(), 0);
        List<SelectOption> CustomPrList = SecurityUtil.getCustomProfileList();
        system.assertNotEquals(prList.size(), 0);
        List<SelectOption> objList = SecurityUtil.getObjectsList(NamespacePrefix, false);
        system.assertNotEquals(objList.size(), 0);
        Set<String> objType = SecurityUtil.getSObjectTypes();
        system.assertNotEquals(objType.size(), 0);
        List<String> objAPIList = SecurityUtil.getObjectsAPIList();
        List<SelectOption> profileList = SecurityUtil.getAllProfilesList();
        system.assertNotEquals(profileList.size(), 0);
        Map<String, Schema.DescribeFieldResult> fdMap = SecurityUtil.getFieldDescribeMap('Account');
    }
}