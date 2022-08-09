public  with sharing class RecordtypeExcelController {


/*Author  : Tejas K kshirsagar
Purpose : Below Method will Give Us Data related to Sharing Rules
*/  
   @RemoteAction
   public String xmlheader{ get; set; }
    @RemoteAction
    public Utils.ReportInfos reportInfos{ get; set; }
    @RemoteAction
    public  List<RecordTypeFinderForProfileController.getrecordsType1> RecordtypeExcelListItmes{ get; set; }
   
    public RecordtypeExcelController(){
         system.debug('RecordtypeExcelListItmes');
           xmlheader = '<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        RecordtypeExcelListItmes = RecordTypeFinderForProfileController.getrecordsType();
        system.debug('RecordtypeExcelListItmes'+RecordtypeExcelListItmes);
		reportInfos = Utils.getReportsInfos(); 
    }
}