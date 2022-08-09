({
    doInit : function(component, event, helper) {
        component.set("v.showSpinner",true);
        
        var action = component.get("c.met1");
        //action.setParams({});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                
                component.set("v.header",response.getReturnValue().header);
                component.set("v.body",response.getReturnValue().body);
                component.set("v.showSpinner",false);
                
            }
        });
        $A.enqueueAction(action);
    },
    
})