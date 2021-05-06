public class OrderTriggerHandler {
    
    /*
     * description: assign primary contact from related account
     * @param: orders inserted
     */
    public static void assignPrimaryContact(List<Order> orders) {
        List<Contact> contactsToAdd = new List<Contact>();
        for(Order order: orders) {
            if(order.AccountId != null) {
                try {
                    AccountContactRelation acctContRel = [SELECT Id, ContactId 
                                                          FROM AccountContactRelation
                                                          WHERE Roles includes ('Primary Contact')
                                                          AND AccountId = :order.AccountId LIMIT 1];
                    order.CustomerAuthorizedById = acctContRel.ContactId;
                } catch (Exception e) {
                    System.debug('The following error has occurred: Selected Account does not have a Primary Contact. '+e.getMessage());
                }
            }
        }
    }
}