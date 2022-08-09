@isTest
Public class ProfileconfigTest{
    
/*    private class profileconfigTesting implements HttpCalloutMock{
        protected Integer code;
        protected String status;
        protected String body;
        protected Map<String,String> headers;
        public profileconfigTesting(Integer code,String status,String body,Map<String,String> headers){
            this.code=code;
            this.status=status;
            this.body=body;
            this.headers=headers;
        }
       public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }*/
    @isTest
    Public static void getTabSettings(){
        Test.startTest();
        //profileconfigTesting httpMock;
        //httpMock=new profileconfigTesting(200,'Complete','{}',null);
        //Test.setMock(HttpCalloutMock.class,httpMock);
        //  profileconfig.getTabSettings(new List<String>{'a'});
        // httpMock=new profileconfigTesting(200,'Complete','{}',null);
        //   Test.setMock(HttpCalloutMock.class,httpMock);
        profileconfig.getTabSettings(new List<string> {'Admin'});
        Test.stopTest();
    }
 /*   @isTest
    private static void profileconfigTest(){
        profileconfig obj = new profileconfig();
          MetadataService.ProfileTabVisibility mm = new MetadataService.ProfileTabVisibility();
    }
    @isTest
    private static void WrapperAllData(){
        profileconfig.WrapperAllData obj1 = new profileconfig.WrapperAllData();
    }
    @isTest
    private static void WrapperAllData1(){
        profileconfig.WrapperAllData1 obj2 = new profileconfig.WrapperAllData1();
    }*/
}