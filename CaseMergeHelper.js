({
	setCaseSubject : function(component)
    {
		var caseDetails = component.get("c.OriginalCase");
        component.set("v.isProcessing", true);
        caseDetails.setParams({
            "caseId" : component.get("v.recordId")
        });
        caseDetails.setCallback(this, function(response){
        	var state = response.getState();
            var OriginalCase = response.getReturnValue();
            if (component.isValid() && state=='SUCCESS')
            {
                component.set("v.isProcessing", false);
                component.set("v.OriginalCase", OriginalCase);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(caseDetails);        
	},
    
    getCaseOriginList: function(component)
    {
        var caseOrigins = component.get("c.getOriginList");
        component.set("v.isProcessing", true);
        caseOrigins.setCallback(this, function(response){
            var state = response.getState();
            var OriginsList = response.getReturnValue();
            if (component.isValid() && state=='SUCCESS')
            {
                component.set("v.isProcessing", false);
                component.set("v.CaseOrigin", OriginsList);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(caseOrigins);
    },
    
    getCaseStatusList: function(component)
    {
        var caseStatus = component.get("c.getStatusList");
        component.set("v.isProcessing", true);
        caseStatus.setCallback(this, function(response){
            var state = response.getState();
            var StatusList = response.getReturnValue();
            if (component.isValid() && state=='SUCCESS')
            {
                component.set("v.isProcessing", false);
                component.set("v.CaseStatus", StatusList);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(caseStatus);
    },
    
    getCasePriorityList: function(component)
    {
        var casePriority = component.get("c.getPriorityList");
        component.set("v.isProcessing", true);
        casePriority.setCallback(this, function(response){
            var state = response.getState();
            var PriorityList = response.getReturnValue();
            if (component.isValid() && state=='SUCCESS')
            {
                component.set("v.isProcessing", false);
                component.set("v.CasePriority", PriorityList);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(casePriority);
    },
    
    getRelatedList: function(component)
    {
        var action = component.get("c.getRelatedLists");
        component.set("v.isProcessing", true);
        action.setCallback(this, function(response){
            var state = response.getState();
            var rLists = response.getReturnValue();
            if (component.isValid() && state=='SUCCESS')
            {
                component.set("v.isProcessing", false);
                component.set("v.RelatedList", rLists);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    findDuplicatesButtonFunctionHelper: function(component)
    {
        var action = component.get("c.getDuplicateCases");
        component.set("v.isProcessing", true);
        
        var dateFrom = component.find("createdDateFrom").get("v.value");
        var dtFrom = new Date(dateFrom);
        var dateTo = component.find("createdDateTo").get("v.value");
        var dtTo = new Date(dateTo);
        
        if (dateFrom != null && dateTo == null)
        {
            component.set("v.isProcessing", false);
            component.set("v.hasErrors", true);
            component.set("v.showErrorMessage", 'Enter \'To Date\'.');
        }
        else if (dateFrom == null && dateTo != null)
        {
            component.set("v.isProcessing", false);
            component.set("v.hasErrors", true);
            component.set("v.showErrorMessage", 'Enter \'From Date\'.');
        }
        else if (dtTo < dtFrom)
        {
            component.set("v.isProcessing", false);
            component.set("v.hasErrors", true);
            component.set("v.showErrorMessage", '\'To Date\' cannot be less than \'From Date\'.');
        }
        else
        {
            action.setParams({
            	"subjectPicklist" : component.find("SubCriteria").get("v.value"),
	            "caseSubject" : component.find("Subject_Input").get("v.value"),
    	        "caseOrigin" : component.find("Case_Origin").get("v.value"),
        	    "caseStatus" : component.find("Case_Status").get("v.value"),
            	"casePriority" : component.find("Case_Priority").get("v.value"),
            	"numberOfCases" : component.find("Number_Of_Cases").get("v.value"),
                "fromDate" : component.find("createdDateFrom").get("v.value"),
                "toDate" : component.find("createdDateTo").get("v.value")
        });
        action.setCallback(this, function(response){
            var CaseList = response.getReturnValue();
            var state = response.getState();
            if (component.isValid() && state == 'SUCCESS')
            {
                component.set("v.IsFindDupClicked", true);
                component.set("v.isProcessing", false);
                var dupListLength = component.set("v.sizeOfDuplicateList", CaseList.length);
                var showCaseList = component.set("v.DuplicateCaseList", CaseList);
            }
            else if (state=='ERROR')
            {
                component.set("v.isProcessing", false);
                component.set("v.hasErrors", true);
                var error = response.getError();
                if(error[0] && error[0].message)
                {
                    component.set("v.showErrorMessage",error[0].message);
                }
                else if (error[0] && error[0].pageErrors)	//DML Error
                {
                    component.set("v.showErrorMessage",
                                  'DML Error: ' + error[0].pageError[0].message);
                }
            }
        });
        $A.enqueueAction(action);
        }
    },
    
    mergeCases: function(component, event)
    {
        var SelectedCasesList = component.get("v.SelectedCaseList");
        component.set("v.isProcessing", true);
        if (!$A.util.isUndefined(SelectedCasesList))
        {
            var action = component.get("c.mergeCases");
            component.set("v.isProcessing", true);
            var selCaseList = JSON.stringify(SelectedCasesList);
            var masterCase = component.get("v.IdForMasterCase");
        	action.setParams({
                listofSelectedCases : selCaseList,
                masterCaseId : masterCase
        	});
        	action.setCallback(this, function(response){
	        	var state = response.getState();
                component.set("v.isProcessing", false);
                if (component.isValid() && state == 'SUCCESS')
                {
                    component.set("v.hasErrors", false);
                    component.set("v.isMergedButtonClickedwithSuccess", true);
                    component.set("v.showSuccessMessage", 
                                  "Selected Duplicate Cases Merged Into Master Case: ");
                    
                    var toastEvent = $A.get("e.force:showToast");
			        toastEvent.setParams({
        				"title": "Success!",
			        	"message": "Cases Merged",
            			"type": "success",
			            "mode": "sticky"
			    	});
    				toastEvent.fire();
                }
                else if (state == 'ERROR')
                {
                    component.set("v.isMergedButtonClickedwithSuccess", false);
                    var error = response.getError();
                    var errorMsg = '';
                    if (error[0] && error[0].message)
                	{
                        errorMsg = error[0].message;
                	}
                    else if (error[0] && error[0].pageErrors)	//DML Error
                    {
                        errorMsg = 'DML Error: ' + error[0].pageError[0].message;
                    }                    
                    var toastEvent = $A.get("e.force:showToast");
			        toastEvent.setParams({
        				"title": "Error!",
			        	"message": errorMsg,
            			"type": "error",
			            "mode": "sticky"
			    	});
    				toastEvent.fire();
                    
                }                
    	    });
        	$A.enqueueAction(action);
        }
        else
        {
            component.set("v.isProcessing", false);
            component.set("v.showErrorMessage", 'Empty List.');
        }
    }
})