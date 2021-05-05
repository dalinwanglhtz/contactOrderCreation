@isTest
public class ContactTriggerHandlerTest {

    @isTest static void should_update_account_contact_relation_role() {
        Account testAcct = new Account(Name = 'Test Account 1');
        insert testAcct;
        
        Contact testCont = new Contact(LastName = 'Test Contact 1');
        testCont.AccountId = testAcct.Id;
        testCont.Email = 'test@email.com';
        testCont.MobilePhone = '431532';
        testCont.Contact_Role__c = 'Primary Contact';
        insert testCont;
        
        AccountContactRelation acr = [SELECT Id, Roles
                                      FROM AccountContactRelation
                                      WHERE ContactId = :testCont.Id];
        System.assertEquals(testCont.Contact_Role__c, acr.Roles, 'Account Contact Relation role should contain the new contact role');
    }
}