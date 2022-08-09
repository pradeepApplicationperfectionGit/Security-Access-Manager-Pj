({
	getProfile : function(component) {
		 // call the apex class method 
        var action = component.get("c.getProfileFields");
        // set param to method  
        
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                    //console.log("storeResponse: " + storeResponse);
                    component.set("v.fieldsName", storeResponse);                    
                }
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
	},
    getData : function(component, event, selectedProfileList) {
        
    }
})