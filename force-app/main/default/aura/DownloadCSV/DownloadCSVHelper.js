({
	onLoad: function(component, event) {
      //call apex class method
      var action = component.get('c.fetchContact');
      action.setCallback(this, function(response){
         //store state of response
         var state = response.getState();
         if (state === "SUCCESS") {
            //set response value in ListOfContact attribute on component.
            component.set('v.ListOfContact', response.getReturnValue());
         }
      });
      $A.enqueueAction(action);
   },
    
   convertArrayOfObjectsToXLS : function(component,objectRecords){
        // declare variables
        var xlsStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate XLS values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in XLS file header  
        keys = ['FirstName','LastName','Department','MobilePhone','Id' ];
        
        xlsStringResult = '';
        xlsStringResult += keys.join(columnDivider);
        xlsStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
 
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      xlsStringResult += columnDivider; 
                   }   
               
               xlsStringResult += '"'+ objectRecords[i][skey]+'"'; 
               
               counter++;
 
            } // inner for loop close 
             xlsStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return xlsStringResult;        
    },

})