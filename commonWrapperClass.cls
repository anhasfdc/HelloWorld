public with sharing class commonWrapperClass
{
        @AuraEnabled public boolean wIsSelected;
        @AuraEnabled public String wId;
	    @AuraEnabled public String wSubject;
    	@AuraEnabled public String wOrigin;
	    @AuraEnabled public String wStatus;
    	@AuraEnabled public String wPriority;
    	@AuraEnabled public Datetime wCreatedDate;
        @AuraEnabled public String wNumber;
        @AuraEnabled public String wOwnerId;
        @AuraEnabled public String wOwnerName;
        @AuraEnabled public String wAccountId;
        @AuraEnabled public String wAccountName;
        @AuraEnabled public String wContactId;
        @AuraEnabled public String wContactName;
        public commonWrapperClass()
        {
            wisSelected = false;
            wSubject = '';
            wOrigin = '';
            wStatus = '';
            wPriority = '';
            wCreatedDate = date.today();
            wNumber = '';
            wOwnerId = '';
            wOwnerName = '';
            wAccountId = '';
            wAccountName = '';
            wContactId = '';
            wContactName = '';
        }
}