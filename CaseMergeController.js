({
    doInit : function(component, event, helper)
    {
        component.set("v.isMergedButtonClickedwithSuccess", false);
        component.set("v.hasErrors", false);
        helper.setCaseSubject(component);
        helper.getCaseOriginList(component);
        helper.getCaseStatusList(component);
        helper.getCasePriorityList(component);
        helper.getRelatedList(component);
        
    },
    
    onOriginChange : function(component, event, helper)
    {
        component.set("v.hasErrors", false);
        var selectedOrigin = component.find("Case_Origin").get("v.value");
    },
    
    onStatusChange : function(component, event, helper)
    {
        component.set("v.hasErrors", false);
        var selectedStatus = component.find("Case_Status").get("v.value");
    },
    
    onPriorityChange : function(component, event, helper)
    {
        component.set("v.hasErrors", false);
        var selectedPriority = component.find("Case_Priority").get("v.value");
    },
    
    onNumberOfCasesChange : function(component, event, helper)
    {
        component.set("v.hasErrors", false);
        var selectedNum = component.find("Number_Of_Cases").get("v.value");
    },
    
    findDuplicatesButtonFunction : function(component, event, helper) 
    {
        component.set("v.hasErrors", false);
        var setSecondList = component.set("v.SelectedCaseList", null);
        helper.findDuplicatesButtonFunctionHelper(component);
    },
    
    nextButtonFunction : function(component, event, helper)
    {
        component.set("v.hasErrors", false);
		var duplicateCasesList = component.get("v.DuplicateCaseList");
        component.set("v.isProcessing", true);
		if (!$A.util.isEmpty(duplicateCasesList) && !$A.util.isUndefined(duplicateCasesList))
        {
            var action = component.get("c.showSecondList");
            component.set("v.isProcessing", true);
            var dupCaseList = JSON.stringify(duplicateCasesList);
            action.setParams({
                listofDuplicateCases : dupCaseList
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var selectedCaseList = response.getReturnValue();
                if (component.isValid() && state == 'SUCCESS')
                {
                    component.set("v.hasErrors", false);
                    component.set("v.isProcessing", false);
                    var showSelectedCaseList = component.set("v.SelectedCaseList", selectedCaseList);
                }
                else if (state == 'ERROR')
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
        else
        {
            component.set("v.hasErrors", true);
            component.set("v.isProcessing", false);
            component.set("v.showErrorMessage", 'Empty List.');
        }
    },
    
    onRelatedListChange : function(component, event, helper)
    {
        var selectedRLists = component.find("RList").get("v.value");
        var splitSelectedRLists = component.find("RList").get("v.value").split(';');
        var setAttribute = component.set("v.selectedRLists", splitSelectedRLists);
        var showSelected = component.find("showSelectedRLists").set("v.value", selectedRLists);
    },
    
    onMasterRadioChange : function(component, event, helper)
    {
        var getSelectedId = event.getSource().get("v.text");
        var setAttribute = component.set("v.IdForMasterCase", getSelectedId);
    },
    
    mergeButtonFunction : function(component, event, helper)
    {
        helper.mergeCases(component);
    }
})