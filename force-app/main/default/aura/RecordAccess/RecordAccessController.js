({
    
    handleClick : function(component,event,helper){
        
        var userID = component.get("v.selectedLookUpRecord.Id");
        var objectID = component.get("v.objectID");
        console.log('aaaa::' + userID);
        console.log('objectID::' + objectID);
        if(!userID || !objectID) {
            console.log('intra');
            component.find('notifLib').showNotice({
                "variant": "error",
                "header": "Something has gone wrong!",
                "message": "You must enter an User Name and a Record Id."
            });
        } else {
            helper.getObjectNameAndLabel(component, objectID);
         
        }
        
    },
    
    printPdf: function(component,event,helper){
    	var pageForPrint = component.find("pageForPrint");
        pageForPrint.Print();  
    },
   
})