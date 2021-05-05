public class ContactTriggerHandler {
    
    /*
     * description: update account contact relation role
     * @param: contacts inserted
     */
    public static void updateAccountContactRelation(List<Contact> contacts) {
        Map<Id, Account> acctsMap = getAccountsMap(contacts);
        Map<Id, AccountContactRelation> acrsMap = getACRsMap(contacts);
        List<AccountContactRelation> acrs = new List<AccountContactRelation>();
        List<Account> accountsToUpdate = new List<Account>();

        for(Contact ct: contacts) {
            AccountContactRelation acr = acrsMap.get(ct.Id);
            
            if(ct.Contact_Role__c != null && 
               			(!acctsMap.containsKey(acr.AccountId) || 
                		acctsMap.get(acr.AccountId).Primary_Contact__c == null || 
                		ct.Contact_Role__c != 'Primary Contact') ) {
                acr.Roles = ct.Contact_Role__c;
                            
                if(acr.Roles == 'Primary Contact') {
                    Account acc = acctsMap.get(acr.AccountId);
                    acc.Primary_Contact__c = ct.Id;
                    accountsToUpdate.add(acc);
                }
            }
            acrs.add(acr);
        }
        
        if(!acrs.isEmpty()) {
        	update acrs;    
        }
        
        if(!accountsToUpdate.isEmpty()) {
        	update accountsToUpdate;    
        }
    }
    
    /*
     * description: get list of accounts map including Primary Contact field for checking
     * @param: contacts inserted
     */
    private static Map<Id, Account> getAccountsMap(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact: contacts) {
            if(contact.AccountId != null) {
                accountIds.add(contact.AccountId);
            }
        }
        
        return new Map<Id, Account>([SELECT Id, Name, Primary_Contact__c
                              		FROM Account
                              		WHERE Id IN :accountIds]);
    }
    
    /*
     * description: get list of AccountContactRelation map for checking
     * @param: contacts inserted
     */
    private static Map<Id, AccountContactRelation> getACRsMap(List<Contact> contacts) {
        Set<Id> contactIds = new Set<Id>();
        for(Contact contact: contacts) {
            if(contact.Id != null) {
                contactIds.add(contact.Id);
            }
        }
        
        Map<Id, AccountContactRelation> acrsMap = new Map<Id, AccountContactRelation>();
        for(AccountContactRelation acr : [SELECT Id, Roles, AccountId, ContactId
                                         FROM AccountContactRelation
                                         WHERE ContactId IN :contactIds]) {
            acrsMap.put(acr.ContactId, acr);                                  
        }
        return acrsMap;
    }
}