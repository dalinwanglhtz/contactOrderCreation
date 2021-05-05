public class ContactTriggerHandler {
    
    /*
     * description: update account contact relation role
     * @param: contacts inserted
     */
    public static void updateAccountContactRelation(List<Contact> contacts) {
        List<AccountContactRelation> acrs = new List<AccountContactRelation>();
        for(Contact ct: contacts) {
            AccountContactRelation acr = [SELECT Id, Roles
                                         FROM AccountContactRelation
                                         WHERE ContactId = :ct.Id];
            if(ct.Contact_Role__c != null) {
                acr.Roles = ct.Contact_Role__c;
            }
            acrs.add(acr);
        }
        update acrs;
    }
}