/*
Author     : Himanshu Kr. Varshney
Description: Lightning component Helper for Intel Tab.
*/
({
    //It will fetch the all Standard and Custom Objects Data
    getObjectNames: function(component, event, helper){
        var action = component.get("c.getAllObjectNames");
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   var listData = [];
                                   for(var i = 0; i < response.getReturnValue().length; i++)
                                   {
                                       if(response.getReturnValue()[i].label    != undefined 
                                          && response.getReturnValue()[i].value != undefined)
                                       {
                                           listData.push({
                                               'label'        :   response.getReturnValue()[i].label,
                                               'value'        :   response.getReturnValue()[i].value,
                                               'type'         :   response.getReturnValue()[i].type,
                                               'pluralName'   :   response.getReturnValue()[i].pluralName,
                                           });
                                       }
                                   }
                                   //console.log('listdata'+listData);
                                   component.set("v.optionsDualList", listData);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                                   //this.getListOfIDs(component, event, helper);
                               }
                               else
                               {
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured, Please Try Again Later';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        
        $A.enqueueAction(action);
    },

   getProfileNames : function(component, event, helper){
       console.log('entry getProfilesList');
        var action = component.get("c.getProfilesList");
       action.setCallback(this, function(response)
                           {
                               //console.log('entry64'+' response.getReturnValue()'+ response.getReturnValue());
                               var state = response.getState();
                               console.log('entry66'); 
                               console.log('state'+ state);
                               // console.log(' response.getReturnValue===='+ JSON.stringify(response.getReturnValue()));
                              // console.log('response.getReturnValue====' + response.getReturnValue());
                               if(state === "SUCCESS")
                               {
                                   console.log('success'+ state);
                                   component.set("v.ProfileDualList",response.getReturnValue());
                                   //console.log('ProfileDualList'+component.get("v.ProfileDualList"));
                                   
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                                      
                               }
                               else
                               {
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured, Please Try Again Later';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        
        $A.enqueueAction(action);
       
       /* action.setCallback(this, function(response)
                           {
                               console.log('state entry');
                               var state = response.getState();
                               console.log('state'+state);
                               if(state === "SUCCESS")
                               {
                                  console.log('response.getReturnValue()'+response.getReturnValue());
                                   component.set("v.ProfileDualList", response.getReturnValue());
                                   
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                                   //this.getListOfIDs(component, event, helper);
                               }
                               else
                               {
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured, Please Try Again Later';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        
        $A.enqueueAction(action);*/
    },
     //sync data button
    DeleteRecordsCall: function(component, event, helper){
         
        var action = component.get("c.fetchDeleteRecords"); 
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('Filtered state' + state);
            if(state === "SUCCESS"){
                console.log('Delete op.Complete'+state);
                component.set("v.showSpinner", false);
                  component.set("v.titleOfsucBool", true);
                component.set("v.severityErr", "CONFIRM");
               component.set("v.titleOfsuc", "Sync Data Complete !!");
      
                
                
            }
            else{
                component.set("v.showSpinner", false);
                var errorMessage = '';
                if(state === "INCOMPLETE"){
                    errorMessage = 'Some Error is Occured.';
                }
                else if(state === "ERROR"){
                    errorMessage = action.getError()[0].message;
                    console.log('Filtererrormessage>>>' + errorMessage);
                } 
                component.set("v.errorMsgBool", true);
                component.set("v.titleOfErr", "");
                component.set("v.severityErr", "");
                component.set("v.errMsgSecond", errorMessage);
            }
        });
        $A.enqueueAction(action);
    },
      

    getAllObjectDetails: function(component, event, helper){
        var selectedOptions = component.get("v.selectedOptions");
        var action          = component.get("c.getAllObjectDetails");
        action.setParams({
            objectNames: selectedOptions
        })
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   var jsonData = response.getReturnValue();
                                   //console.log('jsonData>>>>>' + JSON.stringify(jsonData));
                                   var dataJSON = {};
                                   var layoutJSONData = {};
                                   var dataJSON1 = [];
                                   for(let i = 0; i < jsonData.length; i++)
                                   {
                                       var dataJSON = {};
                                       dataJSON["objectName"] = jsonData[i].objectName;
                                       var data = [];
                                       var firstColumn = [];
                                       firstColumn.push("Object Name");
                                       firstColumn.push("Field Name");
                                       firstColumn.push("API Name");
                                       firstColumn.push("Page Layout Name");
                                       data.push(firstColumn);
                                       var secondColumn = [];
                                       secondColumn.push(jsonData[i].objectName);
                                       secondColumn.push('');
                                       secondColumn.push('');
                                       var dummyCells = jsonData[i].layoutDatas.length;
                                       for(let h = 0; h < dummyCells; h++)
                                       {
                                           secondColumn.push(jsonData[i].layoutDatas[h].layoutName);
                                       }
                                       data.push(secondColumn);
                                       for(let j = 0; j < jsonData[i].allFieldInfos.length; j++)
                                       {
                                           var thirdColumn = [];
                                           thirdColumn.push('');
                                           thirdColumn.push(jsonData[i].allFieldInfos[j].label);
                                           thirdColumn.push(jsonData[i].allFieldInfos[j].apiName);
                                           var fieldApiName = jsonData[i].allFieldInfos[j].apiName;
                                           for(let k = 0; k < jsonData[i].layoutDatas.length; k++)
                                           {
                                               var fieldInfoList = jsonData[i].layoutDatas[k].fieldInfos;
                                               if(fieldInfoList.indexOf(fieldApiName) >= 0)
                                               {
                                                   thirdColumn.push("Yes");
                                               }
                                               else{
                                                   thirdColumn.push("No");
                                               }
                                           }
                                           data.push(thirdColumn);
                                       }
                                       dataJSON["fieldInfo"] = data;
                                       dataJSON1.push(dataJSON);
                                   }
                                   component.set("v.showSpinner", false);
                                   component.set("v.jsonData", dataJSON1);
                                   component.set("v.isModalOpen", false);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.readyToDownload", true);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                                   //component.set("v.readyToDownload", true); 
                               }
                               else
                               {
                                   component.set("v.showSpinner", false);
                                   component.set("v.isModalOpen", false);
                                   component.set("v.readyToDownload", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    downloadExcel: function(component, event, helper){
        var selectedValue = component.get("v.value");
        var listOfIDs = component.get("v.listOfBatchIDs");
        var url = "https://" + window.location.hostname;
        if(selectedValue == 'option12'){
            var selectedOptions = component.get("v.selectedOptions");
            url += "/apex/SA_Audit__multipleExcelGenerator?recordId=" + selectedOptions; 
        
        }
        else if(selectedValue == 'option11'){
            component.set("v.showSpinner", true);
            this.getStatusOfAsyncProcess(component, event, helper);
        }
        else if(selectedValue == 'option10'){
            url += "/apex/SA_Audit__PermissionSetsWithUsersExcel";      
        }
        else if(selectedValue == 'option9'){
            url += "/apex/SA_Audit__UserPermissionSetExcel";          
        }
        else if(selectedValue == 'option8'){
            url += "/apex/SA_Audit__UserTerritoryExcel";            
        }
        else if(selectedValue == 'option7'){
            url += "/apex/SA_Audit__TerritoriesExcel";                
        }
        else if(selectedValue == 'option6'){
            url += "/apex/SA_Audit__UserProfileExcel";                 
        }
		else if(selectedValue == 'option5'){
            url += "/apex/SA_Audit__UserProfileAndRoleExcel";                         
		}
		else if(selectedValue == 'option4'){
            url += "/apex/SA_Audit__UserRoleExcel";
		} 
		else if(selectedValue == 'option3'){
            url += "/apex/SA_Audit__RolesExcel";                                
		}
		else if(selectedValue == 'option2'){
            component.set("v.showSpinner", true);
            this.getStatusOfAsyncProcess(component, event, helper);
		}
		else if(selectedValue == 'option1'){
            component.set("v.showSpinner", true);
            this.getStatusOfAsyncProcess(component, event, helper);
		}
        else if(selectedValue == 'option22'){
            component.set("v.showSpinner", true);
            this.getStatusOfAsyncProcess(component, event, helper);
		}
        else if(selectedValue == 'option13'){
            url += "/apex/SA_Audit__SharingRulesExcel";
        }
        else if(selectedValue == 'option14'){
            url += "/apex/SA_Audit__OWDReportExcel";
        }
        else if(selectedValue == 'option15'){
            url += "/apex/SA_Audit__PermissionSetWithNoUsersExcel";
        }
        else if(selectedValue == 'option16'){
            url += "/apex/SA_Audit__ProfilesWithNoUserExcel";
        }
        else if(selectedValue == 'option17'){
            url += "/apex/SA_Audit__ApexTriggersAndApexClassesExcel";
        }
        else if(selectedValue == 'option18'){
            url += "/apex/SA_Audit__PublicGroupExcel";
        }
        else if(selectedValue == 'option19'){
             url += "/apex/SA_Audit__ManagedPackageLicenseExcel";
        }
        else if(selectedValue == 'option21'){
             url += "/apex/SA_Audit__DashboardReportExcel";
        }
        else if(selectedValue == 'option23'){
             url += "/apex/SA_Audit__ScheduledReportsExcel";
        }
        else if(selectedValue == 'option24'){
             url += "/apex/SA_Audit__FilterReportsExcel";
        }
        else if(selectedValue == 'option25'){
             url += "/apex/SA_Audit__EmptyReportsExcel";
        }
        else if(selectedValue == 'option26'){
             url += "/apex/SA_Audit__customAppExcel";
        }
          else if(selectedValue == 'option27'){
             url += "/apex/SA_Audit__PublicGroupMembersExcel";
        }
          else if(selectedValue == 'option28'){
              var sPro = component.get("v.selectedProfile");
 
              console.log('spro'+sPro);
              url += "/apex/SA_Audit__profileconfigExcel?selectedprofile=" + JSON.stringify(sPro);
              console.log('sporJSON'+JSON.stringify(sPro));
              
        }
        
        else if(selectedValue == 'option20'){
            //url += "/apex/SA_Audit__ManagedPackageLicenseExcel";
            component.set("v.showSpinner", true);
            this.getStatusOfAsyncProcess(component, event, helper);
        }
        if(selectedValue != 'option1' && selectedValue != 'option2' && selectedValue != 'option11' && selectedValue != 'option20' && selectedValue != 'option22'){
            window.open(url);
        }
        component.set("v.showSpinner", false);
    },
    
    generateTable: function(component, event, helper){
        var selectedValue = component.get("v.value");
        var listOfIDs = component.get("v.listOfBatchIDs");
        if(selectedValue == 'option2'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[1]
            })        
        }
        if(selectedValue == 'option1'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[0]
            })
        }
        if(selectedValue == 'option11'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[2]
            })
        }
        if(selectedValue == 'option20'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[3]
            })
        }
        if(selectedValue == 'option22'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[4]
            })
        }
        if(selectedValue == 'option3')
        {
            var action = component.get("c.fetchTableDataOption3");
        }
        if(selectedValue == 'option4'){
            var action = component.get("c.fetchTableDataOption4");
        }
        if(selectedValue == 'option5'){
            var action = component.get("c.fetchTableDataOption5");
        }
        if(selectedValue == 'option6'){
            var action = component.get("c.fetchTableDataOption6");
        }
        if(selectedValue == 'option7'){
            var action = component.get("c.fetchTableDataOption7"); 
        }
        if(selectedValue == 'option8'){
            var action = component.get("c.fetchTableDataOption8"); 
        }
        if(selectedValue == 'option9'){
            var action = component.get("c.fetchTableDataOption9"); 
        }
        if(selectedValue == 'option10'){
            var action = component.get("c.fetchTableDataOption10"); 
        }
        if(selectedValue == 'option13'){
            var action = component.get("c.fetchTableDataOption13"); 
        }
        if(selectedValue == 'option14'){
            var action = component.get("c.fetchTableDataOption14"); 
              console.log('-action--'+ action);
             
        }
        if(selectedValue == 'option15'){
            var action = component.get("c.fetchTableDataOption15");
        }
        if(selectedValue == 'option16'){
            var action = component.get("c.fetchTableDataOption16");
        }
        if(selectedValue == 'option17'){
            var action = component.get("c.fetchTableDataOption17");  
        }
        if(selectedValue == 'option18'){
            var action = component.get("c.fetchTableDataOption18");  
        }
        if(selectedValue == 'option19'){
            var action = component.get("c.fetchTableDataOption19");  
        }
        if(selectedValue == 'option21'){
            var action = component.get("c.fetchTableDataOption21");  
        }
        if(selectedValue == 'option23'){
            var action = component.get("c.fetchTableDataOption23");  
        }
        if(selectedValue == 'option24'){
            var action = component.get("c.fetchTableDataOption24");  
        }
        if(selectedValue == 'option25'){
            var action = component.get("c.fetchTableDataOption25");   
        }
        if(selectedValue == 'option26'){
            var action = component.get("c.fetchTableDataOption26");   
        }
        
        if(selectedValue == 'option27'){
            var action = component.get("c.fetchTableDataOption27");   
        }
         if(selectedValue == 'option28'){
            var action = component.get("c.fetchTableDataOption28");   
             action.setParams({Selectedpro : component.get("v.selectedProfile")})
             console.log('Intelhelper432 -selected value'+ selectedValue);
             console.log('-action.setParams--'+ action.setParams);
             
        }
        
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   if(selectedValue == 'option14'){
                                       component.set("v.jsonData", response.getReturnValue());
                                       var finalList = [];
                                       var strList = [];
                                       strList = response.getReturnValue().split('|');
                                       console.log('strList'+strList)
                                       for(var i = 0; i < strList.length; i++){
                                           var secondList = [];
                                           secondList = strList[i].split('?');
                                           finalList.push(secondList);
                                         
                                       }
                                       
                                         console.log('finalList' + finalList);
                                       component.set("v.jsonData", finalList);
                                       console.log('jsonData in Option14???' + JSON.stringify(component.get("v.jsonData")));
                                       component.set("v.showSpinner", false);
                                       component.set("v.readyToDownload", false);
                                       component.set("v.readyToDownloadSecond", true);
                                       component.set("v.errorMsgBool", false);
                                       component.set("v.titleOfErr", "");
                                       component.set("v.severityErr", "");
                                       component.set("v.errMsgSecond", "");
                                   }
                                   else if(selectedValue == 'option26'){
                                       component.set("v.header",response.getReturnValue().header);
                					   component.set("v.allData",response.getReturnValue().body);
                                       component.set('v.filteredData', response.getReturnValue().body);
                    				   this.preparePagination(component, response.getReturnValue().body);
                                       component.set("v.showSpinner", false);
                                       component.set("v.readyToDownload", false);
                                       component.set("v.readyToDownloadSecond", true);
                                       component.set("v.errorMsgBool", false);
                                       component.set("v.titleOfErr", "");
                                       component.set("v.severityErr", "");
                                       component.set("v.errMsgSecond", "");
                                   }
                                       else if(selectedValue == 'option1' || selectedValue == 'option2' || selectedValue == 'option11' || selectedValue == 'option20' || selectedValue == 'option22'){
                                           var status = response.getReturnValue();
                                           component.set("v.errorMsgBool", true);
                                           component.set("v.titleOfErr", "Warning");
                                           component.set("v.severityErr", "Warning");
                                           component.set("v.errMsgSecond", status);
                                           component.set("v.showSpinner", false);
                                           if(status == 'Completed'){
                                               component.set("v.showSpinner", true);
                                               this.viewDataForManaged(component, event, helper);
                                           }
                                       }
                                           else if(selectedValue == 'option28' ){
                                             
                                               var ReturnDatavalue = response.getReturnValue();
                                               
                                               const wrapperToChangeDataFromFuncToSuitableForTable = () => {
												
                                                   const newStructureForData = [JSON.parse(JSON.stringify(ReturnDatavalue[0]))]; 
                                                   const objToKeepTrackOfPositionOfElementInArray = {};
                                               if(ReturnDatavalue.length > 0) {
                                                   ReturnDatavalue.forEach((data, index) => {
                                                  if (index === 0) {
                                                      newStructureForData[0].ProfileNamm = [data.ProfileNamm];
                                                        
                                                  }else{
                                                       newStructureForData[0].ProfileNamm.push(data.ProfileNamm);
                                                     
                                                   }                                              
                                                 data.subvar.forEach((innerData, index1) => {
                                             
                                                  if (index === 0) {
                                                  objToKeepTrackOfPositionOfElementInArray[`${innerData.tabName}`] = index1;
                                                  newStructureForData[0].subvar[index1].tabVisibility = [innerData.tabVisibility];
                                                  } else {
                                                   const pos = objToKeepTrackOfPositionOfElementInArray[`${innerData.tabName}`];
                                                   
                                                   if (newStructureForData[0].subvar[index1]) {
                                                	newStructureForData[0].subvar[index1].tabVisibility.push(innerData.tabVisibility);
                                                   }
                                               }
                                              })
                                             })
                                            }
                                            return (newStructureForData);
										}  
                                               console.log('IN  Option28 CAll=='+ JSON.stringify(wrapperToChangeDataFromFuncToSuitableForTable()));
                                               component.set("v.jsonData", wrapperToChangeDataFromFuncToSuitableForTable());
                                               component.set("v.showSpinner", false);
                                               component.set("v.readyToDownload", false);
                                               component.set("v.readyToDownloadSecond", true);
                                               component.set("v.errorMsgBool", false);
                                               component.set("v.titleOfErr", "");
                                               component.set("v.severityErr", "");
                                               component.set("v.errMsgSecond", "");
                                           }
                                               else{
                                                   console.log('IN  CAll')
                                                   component.set("v.jsonData", response.getReturnValue());
                                                   component.set("v.showSpinner", false);
                                                   component.set("v.readyToDownload", false);
                                                   component.set("v.readyToDownloadSecond", true);
                                                   component.set("v.errorMsgBool", false);
                                                   component.set("v.titleOfErr", "");
                                                   component.set("v.severityErr", "");
                                                   component.set("v.errMsgSecond", "");
                                                   /*if(selectedValue == 'option22'){
                                           console.log('response.getReturnValue()>>>>>' + response.getReturnValue());
                                           var total = response.getReturnValue()[0].totalRecords;
                                           component.set("v.total", total);
                                           component.set("v.pages", Math.ceil(total / 50));
                                           console.log('>>>>>' + component.get("v.pages"));
                                       }*/
                                   }
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   
                                   
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   if((selectedValue == 'option8' || selectedValue == 'option7') && errorMessage.includes('If you are attempting to use a custom object, be sure to append the ')){
                                       component.set("v.errMsgSecond", "Territory management is not enabled for your org.");
                                   }
                                   else{
                                       component.set("v.errMsgSecond", errorMessage);
                                   }
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    getOWDData: function(component, event, helper){
        var action = component.get("c.fetchOWDRelatedData"); 
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   component.set("v.jsonData", response.getReturnValue());
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", true);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    getListOfIDs: function(component, event, helper){
        var action = component.get("c.getBatchApexJOBIds"); 
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.listOfBatchIDs", response.getReturnValue());
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", true);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    viewDataForManaged: function(component, event, helper){
        var selectedValue = component.get("v.value");
        var listOfIDs = component.get("v.listOfBatchIDs");
        if(selectedValue == 'option11'){
            var action = component.get("c.fetchTableDataOption11");
            action.setParams({
                jobId: listOfIDs[2]
            })  
        }
        else if(selectedValue == 'option1'){
            var action = component.get("c.fetchTableDataOption1");
            action.setParams({
                jobId: listOfIDs[0]
            })  
        }
        else if(selectedValue == 'option2'){
            var action = component.get("c.fetchTableDataOption2");
            action.setParams({
                jobId: listOfIDs[1]
            })    
        }
        else if(selectedValue == 'option20'){
            var action = component.get("c.fetchTableDataOption20");
        }
        else if(selectedValue == 'option22'){
            var action = component.get("c.fetchTableDataOption22");
        }
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   component.set("v.jsonData", response.getReturnValue());
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", true);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    getStatusOfAsyncProcess: function(component, event, helper){
        var selectedValue = component.get("v.value");
        var listOfIDs = component.get("v.listOfBatchIDs");
        if(selectedValue == 'option11'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[2]
            })  
        }
        else if(selectedValue == 'option1'){
            var action = component.get("c.checkBatchApexProgress");
            action.setParams({
                jobId: listOfIDs[0]
            })  
        }
        else if(selectedValue == 'option2'){
              var action = component.get("c.checkBatchApexProgress");
              action.setParams({
                  jobId: listOfIDs[1]
              })    
        }
        else if(selectedValue == 'option20'){
              var action = component.get("c.checkBatchApexProgress");
              action.setParams({
                  jobId: listOfIDs[3]
              })    
        }
        else if(selectedValue == 'option22'){
              var action = component.get("c.checkBatchApexProgress");
              action.setParams({
                  jobId: listOfIDs[4]
              })    
        }
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   var status = response.getReturnValue();
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Waring");
                                   component.set("v.severityErr", "warning");
                                   component.set("v.errMsgSecond", status);
                                   component.set("v.showSpinner", false);
                                   if(status == 'Completed'){
                                       var url;
                                       if(selectedValue == 'option2'){
                                           url += "/apex/SA_Audit__FolderSharesExcel?jobId=" + listOfIDs[1];
                                       }
                                       else if(selectedValue == 'option1'){
                                           url += "/apex/SA_Audit__FolderSharesExcel?jobId=" + listOfIDs[0];
                                       }
                                       else if(selectedValue == 'option11'){
                                           url += "/apex/SA_Audit__InstalledPackagesReportExcel?jobId=" + listOfIDs[2];   
                                       }
                                       else if(selectedValue == 'option20'){
                                           url += "/apex/SA_Audit__ValidationRulesExcel";   
                                       }
                                       else if(selectedValue == 'option22'){
                                           url += "/apex/SA_Audit__ListViewExcel";   
                                       }
                                       window.open(url);
                                       component.set("v.showSpinner", false);
                                       component.set("v.readyToDownload", false);
                                       component.set("v.errorMsgBool", false);
                                       component.set("v.titleOfErr", "");
                                       component.set("v.severityErr", "");
                                       component.set("v.errMsgSecond", "");
                                   }
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    getManagedPackageLicenseData: function(component, event, helper){
        var listOfIDs = component.get("v.listOfBatchIDs");
        var action = component.get("c.fetchManagedPackageLicenseData"); 
        action.setParams({
            listOfIDs: listOfIDs
        })   
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   component.set("v.errorMsgBool", false);
                                   component.set("v.titleOfErr", "");
                                   component.set("v.severityErr", "");
                                   component.set("v.errMsgSecond", "");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    batchApexExecutionToSendAnEmail: function(component, event, helper){
        var action = component.get("c.batchApexExecutionToSendAnEmail"); 
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Warning");
                                   component.set("v.severityErr", "warning");
                                   component.set("v.errMsgSecond", "Please don't refresh the Page, Your Email execution is in Progress. Please check your Email...");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var counter, keys, columnDivider, lineDivider;
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        const items = objectRecords;
        const replacer = (key, value) => value === null ? '' : value // specify how you want to handle null values here
        var header = Object.keys(items[0]);
        var selectedValue = component.get("v.value");
        if(selectedValue == 'option4')
        {
            header = ["Name", "UserRoleId", "LastLoginDate", "Id", "UserRole"];
        }
        var csv = [
            header.join(','), // header row first
            ...items.map(row => header.map(fieldName => JSON.stringify(row[fieldName], replacer)).join(','))
            ];
        if(selectedValue == 'option4')
        {
            csv[0] = ["USER NAME","ROLE NAME","ROLE ID","LAST LOGIN DATE"];
        }
        
       // return the CSV formate String
       console.log(csv);
       return csv.join('\r\n');        
    },
    listViewExport: function(component, event, helper){
        var action = component.get("c.listViewBatchExecution"); 
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               if(state === "SUCCESS"){
                                   console.log('>>>>>' + JSON.stringify(response.getReturnValue()));
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Warning");
                                   component.set("v.severityErr", "warning");
                                   component.set("v.errMsgSecond", "Please don't refresh the Page, Your Batch execution for List View Data is in Progress. You will receive an Email Shortly...");
                               }
                               else{
                                   component.set("v.showSpinner", false);
                                   component.set("v.readyToDownload", false);
                                   component.set("v.readyToDownloadSecond", false);
                                   var errorMessage = '';
                                   if(state === "INCOMPLETE")
                                   {
                                       errorMessage = 'Some Error is Occured.';
                                   }
                                   else if(state === "ERROR")
                                   {
                                       errorMessage = action.getError()[0].message;
                                   } 
                                   component.set("v.errorMsgBool", true);
                                   component.set("v.titleOfErr", "Error");
                                   component.set("v.severityErr", "error");
                                   component.set("v.errMsgSecond", errorMessage);
                               }
                           } 
                          );
        $A.enqueueAction(action);
    },
    preparePagination: function (component, imagesRecords) {
        let countTotalPage = Math.ceil(imagesRecords.length/component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },
 
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.tableData", data);
    },
 
    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++){
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }
        component.set("v.tableData", data);
    },
})