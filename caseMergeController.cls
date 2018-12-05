public with sharing class caseMergeController 
{   
    @AuraEnabled
    public static Case OriginalCase(Id caseId)
    {
        system.debug('#### In OriginalCase');
        Case originalCase = new Case();
        try
        {
            if (Schema.SObjectType.Case.isQueryable() &&
                Schema.SObjectType.Case.fields.Id.isAccessible() &&
                Schema.SObjectType.Case.fields.Subject.isAccessible())
            {
                originalCase = [Select id, subject from Case where id = :caseId limit 1];
            }
            else
            {
                System.debug('#### Insufficient Access To Case Object/Fields.');
            }
            return originalCase;           
        }
        catch (Exception ex)
        {
            System.debug('#### Exception: ' + ex);
            return null;
        }
    }
    
    @AuraEnabled
    public static List<String> getOriginList()
    {
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Case.Origin.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('');
        for( Schema.PicklistEntry value : ple)
        {
            if (value.isActive() == true)
            {
                options.add(value.getLabel());
            }
        }       
        return options;
    }
    
    @AuraEnabled
    public static List<String> getStatusList()
    {
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('');
        for( Schema.PicklistEntry value : ple)
        {
            if (value.isActive() == true)
            {
                options.add(value.getLabel());
            }
        }       
        return options;
    }
    
    @AuraEnabled
    public static List<String> getPriorityList()
    {
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Case.Priority.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('');
        for( Schema.PicklistEntry value : ple)
        {
            if (value.isActive() == true)
            {
                options.add(value.getLabel());
            }
        }       
        return options;
    }
    
    //Get Related Lists of Case SObject
    @AuraEnabled
    public static List<String> getRelatedLists()
    {
        List<String> relatedList = new List<String>();
        for( ChildRelationship r: Case.SObjectType.getDescribe().getChildRelationships())
        {
            relatedList.add(string.valueOf(r.getChildSObject()));
        }
        return relatedList;
    }
    
    //Find Duplicate Cases
    @AuraEnabled
    public static List<commonWrapperClass.duplicateCaseListDisplay> getDuplicateCases(String subjectPicklist, String caseSubject, String caseOrigin, String casePriority, String caseStatus, String numberOfCases, String fromDate, String toDate)
    {
        List<commonWrapperClass.duplicateCaseListDisplay> duplicateCaseList = new List<commonWrapperClass.duplicateCaseListDisplay>();
        List<Case> caseList = new List<Case>();
        
        system.debug('#### In getDuplicateCases.');
        
        String subjectQuery = '';
        if (subjectPicklist == 'Equals')
        {
            subjectQuery = 'Select id, subject, origin, priority, status, createdDate, caseNumber, Owner.name, OwnerId, Contact.name, ContactId, Account.name, AccountId from Case where subject = \'' + String.escapeSingleQuotes(caseSubject) + '\'';
        }
        else if (subjectPicklist == 'Contains')
        {
            subjectQuery = 'Select id, subject, origin, priority, status, createdDate, caseNumber, Owner.name, OwnerId, Contact.name, ContactId, Account.name, AccountId from Case where subject like \'%' + String.escapeSingleQuotes(caseSubject) + '%\'';
        }
        String originQuery = '';
        String priorityQuery = '';
        String statusQuery = '';
        String dateRangeQuery = '';
        String dateOrderQuery = ' Order by CreatedDate ASC limit ' + String.escapeSingleQuotes(numberOfCases);
            
        if (caseOrigin != '' && caseOrigin != null)
        {
            originQuery = ' AND origin = \'' + String.escapeSingleQuotes(caseOrigin) + '\'';
        }
        
        if (casePriority != '' && casePriority != null)
        {
            priorityQuery = ' AND priority = \'' + String.escapeSingleQuotes(casePriority) + '\'';
        }
        
        if (caseStatus != '' && caseStatus != null)
        {
            statusQuery = ' AND status = \'' + String.escapeSingleQuotes(caseStatus) + '\'';
        }
        
        if (FromDate != null && ToDate != null && FromDate != '' && ToDate != '')
        {
            DateTime fDate = Date.valueOf(FromDate);
            String formatedFDate = fDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            DateTime tDate = Date.valueOf(ToDate);
            String formatedTDate = TDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            
            dateRangeQuery = ' AND createdDate > ' + formatedFDate + ' AND createdDate < ' + formatedTDate;
        }
        
        String totalQuery = subjectQuery + originQuery + priorityQuery + statusQuery + dateRangeQuery + dateOrderQuery;
        
        try
        {
            if (Schema.SObjectType.Case.isQueryable() &&
                Schema.SObjectType.Case.fields.Id.isAccessible() &&
                Schema.SObjectType.Case.fields.Subject.isAccessible() &&
                Schema.SObjectType.Case.fields.Origin.isAccessible() &&
                Schema.SObjectType.Case.fields.Priority.isAccessible() &&
                Schema.SObjectType.Case.fields.Status.isAccessible() &&
                Schema.SObjectType.Case.fields.createdDate.isAccessible() &&
                Schema.SObjectType.Case.fields.caseNumber.isAccessible() &&
                Schema.SObjectType.Case.fields.ownerId.isAccessible() &&
                Schema.SObjectType.Case.fields.AccountId.isAccessible() &&
                Schema.SObjectType.Case.fields.contactId.isAccessible() )
            {
                caseList = Database.Query(totalQuery);
            }
            else
            {
                System.debug('#### Insufficient Access To Case Object/Fields.');
            }
        }
        catch (Exception ex)
        {
            System.debug('#### Exception: ' + ex);
        }
        
        if (caseList != null && caseList.size() > 0)
        {
            for (Case dCase : caseList)
            {
                commonWrapperClass.duplicateCaseListDisplay wrapperObj = new commonWrapperClass.duplicateCaseListDisplay();
                wrapperObj.wId = dCase.Id;
                wrapperObj.wSubject = dCase.Subject;
                wrapperObj.wOrigin = dCase.Origin;
                wrapperObj.wStatus = dCase.Status;
                wrapperObj.wPriority = dCase.Priority;
                wrapperObj.wCreatedDate = dCase.CreatedDate;
                wrapperObj.wNumber = dCase.caseNumber;
                wrapperObj.wOwnerId = dCase.OwnerId;
                wrapperObj.wOwnerName = dCase.Owner.name;
                wrapperObj.wContactId = dCase.ContactId;
                wrapperObj.wContactName = dCase.Contact.name;
                wrapperObj.wAccountId = dCase.AccountId;
                wrapperObj.wAccountName = dCase.Account.name;
                
                duplicateCaseList.add(wrapperObj);
            }
        }
        return duplicateCaseList;
    }
    
    @AuraEnabled
    public static List<commonWrapperClass.duplicateCaseListDisplay> showSecondList(String listofDuplicateCases)
    {
        List<commonWrapperClass.duplicateCaseListDisplay> selectedCaseList = new List<commonWrapperClass.duplicateCaseListDisplay>();
        
        if (!string.isBlank(listofDuplicateCases))
        {
            List<commonWrapperClass.duplicateCaseListDisplay> listDuplicateCases= (List<commonWrapperClass.duplicateCaseListDisplay>)System.JSON.deserialize(listofDuplicateCases, List<commonWrapperClass.duplicateCaseListDisplay>.class);
            
            for (commonWrapperClass.duplicateCaseListDisplay cases: listDuplicateCases)
            {
                if (cases.wIsSelected == true)
                {
                    cases.wIsSelected = false;
                    selectedCaseList.add(cases);                    
                }
            }
            
            selectedCaseList[0].wIsSelected = true;     //for pre-selection of oldest case 
            
            return selectedCaseList;
        }
        else    //if listofDuplicateCases == blank
        {
            return null;
        }
    }
    
    @AuraEnabled
    public static void mergeCases(String listofSelectedCases, String masterCaseId)
    {
        System.debug('#### In mergeCases');
        
        List<Case> casesToBeClosed = new List<Case>();
        Set<Id> caseIdSet = new Set<Id>();
        
        if (!string.isBlank(listofSelectedCases))
        {
            //deserialize JSON
            List<commonWrapperClass.duplicateCaseListDisplay> listSelectedCases = (List<commonWrapperClass.duplicateCaseListDisplay>)System.JSON.deserialize(listofSelectedCases, List<commonWrapperClass.duplicateCaseListDisplay>.class);
            
            if (masterCaseId == null || masterCaseId == '')
            {
                masterCaseId = listSelectedCases[0].wId;
            }
            
            for (commonWrapperClass.duplicateCaseListDisplay cases: listSelectedCases)
            {
                if (cases.wId == masterCaseId)
                {
                    cases.wIsSelected = true;
                }
                else
                {
                    cases.wIsSelected = false;
                }
            }
            
            for (commonWrapperClass.duplicateCaseListDisplay cases: listSelectedCases)
            {
                if (cases.wIsSelected == false)
                {
                    Case caseObject = new Case();
                    caseObject.Status = 'Closed';
                    caseObject.Id = cases.wId;
                    casesToBeClosed.add(caseObject);
                    caseIdSet.add(caseObject.Id);
                }
            }    
            
            for (Case cases: casesToBeClosed)
            {
                cases.parentId = masterCaseId;
            }
            
            try
            {
                if (Schema.sObjectType.Case.fields.parentId.isUpdateable() &&
                    Schema.sObjectType.Case.fields.status.isUpdateable() )
                {
                    update casesToBeClosed;
                }
                else
                {
                    System.debug('Insufficient Access');
                }                
                
                //For Emails List
                List<EmailMessage> listOldEM = new List<EmailMessage>();
                List<EmailMessage> listNewEM = new List<EmailMessage>();
                List<Id> EMIdList = new List<Id>();
                if (Schema.SObjectType.EmailMessage.isQueryable() &&
                    Schema.SObjectType.EmailMessage.fields.Id.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.parentId.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.ActivityId.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.BccAddress.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.CcAddress.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.FromAddress.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.FromName.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.Headers.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.HtmlBody.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.Incoming.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.IsDeleted.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.IsExternallyVisible.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.MessageDate.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.RelatedToId.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.ReplyToEmailMessageId.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.Status.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.Subject.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.TextBody.isAccessible() &&
                    Schema.SObjectType.EmailMessage.fields.ToAddress.isAccessible() )
                {
                    listOldEM = [Select id, parentId, ActivityId, BccAddress, CcAddress, FromAddress, FromName, Headers, HtmlBody, Incoming, IsDeleted, IsExternallyVisible, MessageDate, RelatedToId, ReplyToEmailMessageId, Status, Subject, TextBody, ToAddress from emailmessage where parentid in :caseIdSet];
                    for(EmailMessage eMessage : listOldEM)
                    {   
                        EMIdList.add(eMessage.Id);
                        EmailMessage newEM = eMessage.clone(false, true);
                        newEm.parentId = masterCaseId;
                        listNewEM.add(newEM);
                    }
                    
                    if (Schema.SObjectType.EmailMessage.fields.parentId.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.ActivityId.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.BccAddress.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.CcAddress.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.FromAddress.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.FromName.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.Headers.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.HtmlBody.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.Incoming.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.IsDeleted.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.IsExternallyVisible.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.MessageDate.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.RelatedToId.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.ReplyToEmailMessageId.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.Status.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.Subject.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.TextBody.isCreateable() &&
                        Schema.SObjectType.EmailMessage.fields.ToAddress.isCreateable() )
                    {
                        insert listNewEM;
                    }
                    else
                    {
                        System.debug('Insufficient Access.');
                    }
                }
                else
                {
                    System.debug('Insufficient Access.');
                }
                
                
                //For Attachments List
                List<Attachment> listOldAttachments = new List<Attachment>();
                List<Attachment> listNewAttachments = new List<Attachment>();
                if (Schema.SObjectType.Attachment.isQueryable() &&
                    Schema.SObjectType.Attachment.fields.Id.isAccessible() &&
                    Schema.SObjectType.Attachment.fields.parentId.isAccessible() &&
                    Schema.SObjectType.Attachment.fields.name.isAccessible() &&
                    Schema.SObjectType.Attachment.fields.body.isAccessible() &&
                    Schema.SObjectType.Attachment.fields.contentType.isAccessible() )
                {
                    listOldAttachments = [Select id, parentId, name, body, contentType from Attachment where parentId in :caseIdSet];
                    for (Attachment att: listOldAttachments)
                    {
                        Attachment a = att.clone();
                        a.ParentId = masterCaseId;
                        listNewAttachments.add(a);
                    }
                    
                    if (Schema.SObjectType.Attachment.fields.parentId.isCreateable() &&
                        Schema.SObjectType.Attachment.fields.name.isCreateable() &&
                        Schema.SObjectType.Attachment.fields.body.isCreateable() &&
                        Schema.SObjectType.Attachment.fields.contentType.isCreateable() )
                    {
                        insert listNewAttachments;
                    }                             
                    else
                    {
                        System.debug('Insufficient Access.');
                    }
                }
                else
                {
                    System.debug('Insufficient Access.');
                }
                
                
                //For Case Comments List
                List<CaseComment> listOldComments = new List<CaseComment>();
                List<CaseComment> listNewComments = new List<CaseComment>();
                if (Schema.SObjectType.CaseComment.isQueryable() &&
                    Schema.SObjectType.CaseComment.fields.Id.isAccessible() &&
                    Schema.SObjectType.CaseComment.fields.parentId.isAccessible() &&
                    Schema.SObjectType.CaseComment.fields.CommentBody.isAccessible() )
                {
                    listOldComments = [Select id, parentId, CommentBody from CaseComment where parentId in :caseIdSet];
                    for (CaseComment cCo : listOldComments)
                    {
                        CaseComment cc = cCo.clone();
                        cc.ParentId = masterCaseId;
                        listNewComments.add(cc);
                    }
                    System.debug('#### listNewComments: ' + listnewComments);
                    if (Schema.SObjectType.CaseComment.fields.parentId.isCreateable() &&
                        Schema.SObjectType.CaseComment.fields.CommentBody.isCreateable() )
                    {
                        insert listNewComments;
                    }                
                    else
                    {
                        System.debug('Insufficient Access.');
                    }
                }
                else
                {
                    System.debug('Insufficient Access.');
                }
            }
            catch (Exception ex)
            {
                System.debug('#### DML Exception While Merging Cases: ' + ex);
            }
        }
    }
}