({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
    
    getObjectNameAndLabel: function(component, objectID) {
        var action = component.get("c.getObjectNameAndLabel");
        action.setParams({
            'objectId': objectID,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse[0] === 'true') {
                    component.find('notifLib').showNotice({
                        "variant": "error",
                        "header": "Something has gone wrong!",
                        "message": storeResponse[1]
                    });
                } else {
                    var myDiv = component.find("myDiv");                    
                   	$A.util.addClass(myDiv, 'divShow');
                    component.set("v.objectName", storeResponse[2]);
                    component.set("v.objectLabel", storeResponse[1]);
                    console.log('1111' + storeResponse[2]);
                    var owdCmp = component.find("OWDcmp");
                    owdCmp.doInit(storeResponse[1], storeResponse[2], function(result) {
                        console.log("result: " + result);
                    });
                    var owd = component.find("OWD");
                    $A.util.addClass(owd, 'divShow');
                    
                    var userID = component.get("v.selectedLookUpRecord.Id");
                    var profileCmp = component.find("profileCmp");
                    profileCmp.doInit(userID, storeResponse[1], function(result) { });
                    var profile = component.find("profile");
                    $A.util.addClass(profile, 'divShow');
                    
                    var userRoleCmp = component.find("userRoleCmp");
                    userRoleCmp.doInit(userID, objectID, function(result) { });
                    var userRole = component.find("userRole");
                    $A.util.addClass(userRole, 'divShow');
                    
                    var permSetCmp = component.find("permSetCmp");
                    permSetCmp.doInit(userID, storeResponse[1], function(result) {
                        console.log('perm set result0:' + result);
                        var permSet = component.find("permSet");
                        if(result) {
                            console.log('perm set result:' + result);
                            $A.util.addClass(permSet, 'divShowPermSet');
                        } else {
                            $A.util.addClass(permSet, 'divHiddenPermSet');
                        }
                    });
                    
                    component.set('v.loaded', true);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getProfile: function(component, userID) {
        var action = component.get("c.Profile");
        action.setParams({
            'userID': userID,
        });
    }
})