@isTest
private class ProfileconfigExcelControllerTEST{
 /*   private class ProfileconfigExcelController_Testing implements HttpCalloutMock{
        protected Integer code;
        protected String status;
        protected String body;
        protected Map<String,String> headers;
        public ProfileconfigExcelController_Testing(Integer code,String status,String body,Map<String,String> headers){
            this.code=code;
            this.status=status;
            this.body=body;
            this.headers=headers;
        }
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res=new HttpResponse();
            res.setStatusCode(this.code);
            res.setStatus(this.status);
            res.setBody(this.body);
            if(this.headers!=null){
                for(String key:this.headers.keySet()){
                    res.setHeader(key,this.headers.get(key));
                }
            }
            return res;
        }
    }*/
    @isTest
    private static void getTabSettings_TGN_TEST(){
        Test.startTest();
        //ProfileconfigExcelController_Testing httpMock;
        //httpMock=new ProfileconfigExcelController_Testing(200,'Complete','{}',null);
        //Test.setMock(HttpCalloutMock.class,httpMock);
        //ProfileconfigExcelController.getTabSettings(new List<String>{'a'});
        // httpMock=new ProfileconfigExcelController_Testing(200,'Complete','{}',null);
        //Test.setMock(HttpCalloutMock.class,httpMock);
        ProfileconfigExcelController.getTabSettings(new List<string> {'Admin'});
        Test.stopTest();
    }
   @isTest(SeeAllData=true)
    private static void ProfileconfigExcelController_TEST(){
        ProfileconfigExcelController obj = new ProfileconfigExcelController();
    }
    @isTest(SeeAllData=true)
    private static void WrapperAllData_TGN_TEST(){
        ProfileconfigExcelController.WrapperAllData obj = new ProfileconfigExcelController.WrapperAllData();
    }
    /* */
}