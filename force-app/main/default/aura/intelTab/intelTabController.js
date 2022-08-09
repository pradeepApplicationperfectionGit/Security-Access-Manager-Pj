/*
Author     : Himanshu Kr. Varshney
Description: Lightning component Controller for Intel Tab.
*/
({
    exportToExcel : function(component, event, helper){
        var selectedValue   = component.get("v.value");
        var selectedOptions = component.get("v.selectedOptions");
        //Condition if We Click Directly on Export to Excel Option
        if(selectedValue == ''){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Error");
            component.set("v.severityErr", "error");
            component.set("v.errMsgSecond", "Please Select an Option");
        }
        //Condition if We Click Directly on Export to Excel Option without Selecting any Object
        else if(selectedOptions  == '' 
                && selectedValue == 'option12'){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Error");
            component.set("v.severityErr", "error");
            component.set("v.errMsgSecond", "Please Select At least One Object");
        }
        else{
            component.set("v.errorMsgBool", false);
            component.set("v.titleOfErr", "");
            component.set("v.severityErr", "");
            component.set("v.errMsgSecond", "");
            component.set("v.showSpinner", true);
            helper.downloadExcel(component, event, helper);
        }
    },
    doInit: function(component, event, helper){
        component.set("v.showSpinner", false);
        console.log('>>>??????' + ((typeof sforce != 'undefined') && sforce && (!!sforce.one)));
        //It will Call Helper Method to get all Standard and Custom Objects Data(Name etc.)
        helper.getObjectNames(component, event, helper);
        helper.getOWDData(component, event, helper);
        helper.getListOfIDs(component, event, helper); 
        helper.getManagedPackageLicenseData(component, event, helper);
        helper.getProfileNames(component, event, helper);
    },
    closeModel: function(component, event, helper){
        //Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    closeProfileModel: function(component, event, helper){
        //Set isModalOpen attribute to false  
        component.set("v.isProfileModal", false);
    },
    submitDetails: function(component, event, helper){
        var selectedOptions = component.get("v.selectedOptions");
        //If We click on Directly Save Button without Selecting any Object
        if(selectedOptions == ''){
        }
        else{
            component.set("v.isModalOpen", false);
        }
    },
    SyncData: function(component,event,helper){
        component.set("v.showSpinner", true);
     //   helper.deleteExistingReports(component, event, helper);
        helper.DeleteRecordsCall(component, event, helper);
         component.set("v.titleOfsucBool", true);
         component.set("v.titleOfsuc", "   Sync Data Complete !!"); 
    },
    
    viewData: function(component, event, helper){
        var selectedValue   = component.get("v.value");
        var selectedOptions = component.get("v.selectedOptions");
        var selectedOption = component.get("v.selectedProfile");
        //Condition if We Click Directly on View Data Button
        if(selectedValue == ''){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Error");
            component.set("v.severityErr", "error");
            component.set("v.errMsgSecond", "Please Select an Option");
        }
        
        //Condition if We Click Directly on Export to Excel Option without Selecting any Object
        else if(selectedOptions  == '' 
                && selectedValue == 'option12'){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Error");
            component.set("v.severityErr", "error");
            component.set("v.errMsgSecond", "Please Select At least One Object");
        }
        else if(selectedOption == '' 
                && selectedValue == 'option28'){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Error");
            component.set("v.severityErr", "error");
            component.set("v.errMsgSecond", "Please Select At least One Profile");
        }
       
        else{
            if(selectedValue != 'option12'){
                component.set("v.showSpinner", true);
                component.set("v.readyToDownloadSecond", false);
                helper.generateTable(component, event, helper);
            }
            else{
                component.set("v.showSpinner", true);
            	//Method to get All Data like Layouts etc. of Selected Objects
            	helper.getAllObjectDetails(component, event, helper);
            }
            component.set("v.errorMsgBool", false);
            component.set("v.titleOfErr", "");
            component.set("v.severityErr", "");
            component.set("v.errMsgSecond", "");
            component.set("v.titleOfsucBool", false);
            //Method to get All Data like Layouts etc. of Selected Objects
            //helper.getAllObjectDetails(component, event, helper);
        }
    },
    handleChange: function (component, event, helper){
        var selectedOptionValue = event.getParam("value");
        component.set("v.selectedOptions", selectedOptionValue);
         console.log('selectedOptions'+component.set("v.selectedOptions", selectedOptionValue));
    },
    handleChange1: function (component, event, helper){
        var selectedprofileValue = event.getParam("value");
        component.set("v.selectedProfile", selectedprofileValue);
        console.log('selectedProfile'+component.set("v.selectedProfile", selectedprofileValue));
    },
    submitProfileDetails: function (component, event, helper){
       var selectedOption = component.get("v.selectedProfile");
        console.log('selectedproileoption'+selectedOption)
        //If We click on Directly Save Button without Selecting any Object
        if(selectedOption == ''){
        }
        else{
            component.set("v.isProfileModal", false);
        }
    },
    //Below function is being called whenever Radio Button is Being Selected
    valueChnage: function(component, event, helper){
        component.set("v.value", event.getSource().get('v.value'));
        var selectedValue = component.get("v.value");   
        if(selectedValue == 'option12'){
            component.set("v.isModalOpen", true);
        }
        console.log('entry'+'selectedValue'+selectedValue);
        if(selectedValue == 'option28'){
            
            component.set("v.isProfileModal", true);
        }
        
        /*if(selectedValue == 'option17'){
            component.set("v.errorMsgBool", true);
            component.set("v.titleOfErr", "Warning");
            component.set("v.severityErr", "warning");
            component.set("v.errMsg", "You can fetch Apex Triggers and Apex Classes upto 1000");
            component.set("v.errMsgSecond", "");
        }
        else{
            component.set("v.errorMsgBool", false);
            component.set("v.titleOfErr", "");
            component.set("v.severityErr", "");
            component.set("v.errMsg", "");

        }*/
        component.set("v.readyToDownload", false);
        component.set("v.readyToDownloadSecond", false);
    },
    openContactUSLink: function(component, event, helper){
        var buttonLabel=event.getSource('').get('v.label');
        if(buttonLabel === 'Request a feature/support'){
            window.open('https://applicationperfection.com/contact/');
        }else if(buttonLabel === 'Help/Training'){
            window.open('https://applicationperfection.com/security-access-manager-help-training/');
        }else if(buttonLabel === 'Release Notes'){
            window.open('https://applicationperfection.com/security-access-manager-release-notes/');
        }
    },
    exportAllReports: function(component, event, helper){
        helper.batchApexExecutionToSendAnEmail(component, event, helper);
    },
    /*listViewExportAll: function(component, event, helper){
        helper.listViewExport(component, event, helper);
    },
    previousPage: function(component, event, helper){
        component.set("v.showSpinner", true);
        var page = component.get("v.page");
        page -= 1;
        component.set("v.page", page);
        var offSetValue = component.get("v.offSetValue");
        offSetValue -= 50;
        component.set("v.offSetValue", offSetValue);
        console.log('page>>>>' + page);
        helper.generateTable(component, event, helper);
    },
    nextPage: function(component, event, helper){
        var offSetValue = component.get("v.offSetValue");
        offSetValue += 50;
        component.set("v.offSetValue", offSetValue);
        component.set("v.showSpinner", true);
        var page = component.get("v.page");
        page += 1;
        component.set("v.page", page);
        console.log('page>>>>' + page);
        helper.generateTable(component, event, helper);
    }*/

    downloadCsv: function(component, event, helper){
        // get the Records [report] list from 'jsonData' attribute 
        var reportData = component.get("v.jsonData");
        
        // call the helper function which "return" the CSV data as a String   
        var csv = helper.convertArrayOfObjectsToCSV(component,reportData);   
        if (csv == null){return;}
        var selectedValue = component.get("v.value");
        var fileName =  selectedValue + '_exportData.csv';
		var blob = new Blob([csv], {
            type: "data:application/vnd.ms-excel;charset=utf-8,\uFEFF"
        });   
        if (navigator.msSaveBlob) { // IE 10+
        	navigator.msSaveBlob(blob, exportedFilenmae);
    	} else {
            var link = document.createElement("a");
            if (link.download !== undefined) { // feature detection
                // Browsers that support HTML5 download attribute
                var url = URL.createObjectURL(blob);
                link.setAttribute("href", url);
                link.setAttribute("download", fileName);
                link.style.visibility = 'hidden';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
    	}
    },
 
    onNext: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber + 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onPrev: function(component, event, helper) {        
        let pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber - 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onFirst: function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);
        helper.setPageDataAsPerPagination(component);
    },
     
    onLast: function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));
        helper.setPageDataAsPerPagination(component);
    },
 
    onPageSizeChange: function(component, event, helper) {        
        helper.preparePagination(component, component.get('v.filteredData'));
    },
    
})