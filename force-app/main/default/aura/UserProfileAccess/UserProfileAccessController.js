({
    init : function(component, event, helper) {
        // call the apex class method 
        var action = component.get("c.getProfileOptions");
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
                    //console.log("storeResponse: " + storeResponse[0].profile.Name);
                    //console.log(Object.getOwnPropertyNames(storeResponse[0].profile));
                    component.set("v.profile", storeResponse[0].profile);
                    component.set("v.options", storeResponse);
                    
                    if(storeResponse.length > 1) {
                        component.set("v.values", [storeResponse[0].value, storeResponse[1].value]);
                        var myColumns = [
                            {label: 'Fields Name', fieldName: 'Fields Name',  type: 'text'},
                            {label: storeResponse[0].profile.Name, fieldName: storeResponse[0].profile.Id, type: 'text'},
                            {label: storeResponse[1].profile.Name, fieldName: storeResponse[1].profile.Id, type: 'text'}];
                        component.set('v.columns', myColumns);
                        var selectedProfileList = [storeResponse[0], storeResponse[1]];
                        helper.getData(component, event, selectedProfileList);
                    } else {
                       component.set('v.columns', [
                           {label: 'Fields Name', fieldName: 'Fields Name',  type: 'text'},
                           {label: storeResponse[0].profile.Name, fieldName: storeResponse[0].profile.Name, type: 'text'}
                        ]);
                        var selectedProfileList = [storeResponse[0], storeResponse[1]];
                        helper.getData(component, event, selectedProfileList);
                    }
                    //helper.getProfile(component, event);
                }
                // set searchResult list with return value from server.
                
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})