@isTest
private class CSVIteratorTest{
    @isTest
    private static void nextRow_test(){
        Test.startTest();
        CSVIterator obj = new CSVIterator('');
        obj.nextRow();
        Test.stopTest();
    }
    @isTest
    private static void nextRow1_test(){
        Test.startTest();
        CSVIterator obj = new CSVIterator('x');
        //obj.body = 'a';
        obj.nextRow();
        Test.stopTest();
    }
    @isTest
    private static void ROW_getColumnValue_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValue('a');
        obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValue('');
        Test.stopTest();
    }
    @isTest
    private static void ROW_getColumnValueAsDate_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDate('a');
        obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDate('');
        Test.stopTest();
    }
    @isTest
    private static void ROW_getColumnValueAsDateTime_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDateTime('a');
        obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDateTime('');
        Test.stopTest();
    }
    @isTest
    private static void ROW_getColumnValueAsDecimal_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDecimal('a');
        obj = new CSVIterator.ROW(null,'a',1);
        obj.getColumnValueAsDecimal('');
        Test.stopTest();
    }
    @isTest
    private static void ROW_getTotalColumns_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getTotalColumns();
        Test.stopTest();
    }
    @isTest
    private static void ROW_getRowLine_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getRowLine();
        Test.stopTest();
    }
    @isTest
    private static void ROW_getLineNumber_test(){
        Test.startTest();
        CSVIterator.ROW obj = new CSVIterator.ROW(null,'a',1);
        obj.getLineNumber();
        Test.stopTest();
    }

}