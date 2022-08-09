({
	// ## function call on component load  
    loadContactList: function(component, event, helper){
       helper.onLoad(component, event);
    },
    
    // ## function call on Click on the "Download As CSV" Button. 
    downloadXls : function(component,event,helper){
        
        // get the Records [contact] list from 'ListOfContact' attribute 
        var stockData = component.get("v.ListOfContact");
        
        // call the helper function which "return" the CSV data as a String   
        var xls = helper.convertArrayOfObjectsToXLS(component,stockData);   
         if (xls == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/xls;charset=utf-8,' + encodeURI(xls);
          hiddenElement.target = '_self'; // 
          hiddenElement.download = 'ExportData.xls';  // CSV file Name* you can change it.[only name not .xls] 
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download xls file
         
         
        
        },
    applyCSS: function(cmp, event) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.addClass(cmpTarget, 'changeMe');
    },
})