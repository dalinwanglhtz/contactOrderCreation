public class ContactTriggerHandler {
    
    /*
     * description: update account contact relation role
     * @param: contacts inserted
     */
    public static void updateAccountContactRelation(List<Contact> contacts) {
        Map<Id, Boolean> accsHasPrimary = checkForPrimaryContactInACR(contacts);
        List<AccountContactRelation> acrs = new List<AccountContactRelation>();

        for(Contact ct: contacts) {
            AccountContactRelation acr = [SELECT Id, Roles, AccountId
                                         FROM AccountContactRelation
                                         WHERE ContactId = :ct.Id];
            if(ct.Contact_Role__c != null && 
               (!accsHasPrimary.containsKey(acr.AccountId) || 
                !accsHasPrimary.get(acr.AccountId) || 
                ct.Contact_Role__c != 'Primary Contact') ) {
                acr.Roles = ct.Contact_Role__c;
            }
            acrs.add(acr);
        }
        update acrs;
    }
    
    /*
     * description: check and collect all accounts having primary contact.
     * Each account should have only one Primary Contact
     * @param: contacts inserted
     */
    private static Map<Id, Boolean> checkForPrimaryContactInACR(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact: contacts) {
            if(contact.AccountId != null) {
                accountIds.add(contact.AccountId);
            }
        }
        
        Map<Id, Boolean> accountHasPrimary = new Map<Id, Boolean>();
        List<AccountContactRelation> acrs = [SELECT Id, AccountId, Roles
                                            FROM AccountContactRelation
                                            WHERE AccountId IN :accountIds];
        for(AccountContactRelation acr : acrs) {
            if(acr.Roles != null && acr.Roles.contains('Primary Contact')) {
                accountHasPrimary.put(acr.AccountId, true);
            }
        }
        
        return accountHasPrimary;
    }
}