@isTest
global class RemoteSiteSettingControllerTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
	static testMethod void test1() { 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RemoteSiteSettingControllerTest());

        RemoteSiteSettingController ctrl = new RemoteSiteSettingController();
        system.assertNotEquals(ctrl.getDeployXml(), '');
        Boolean x = RemoteSiteSettingController.isRssPresent;
        system.assertEquals(x, true);
       
        
        Test.stopTest(); 
    }
}