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
    
    @isTest static void should_not_update_role_when_account_has_primary() {
		Account testAcct = new Account(Name = 'Test Account 1');
        insert testAcct;
        
        Contact testCont = new Contact(LastName = 'Test Contact 1');
        testCont.AccountId = testAcct.Id;
        testCont.Email = 'test@email.com';
        testCont.MobilePhone = '431532';
        testCont.Contact_Role__c = 'Primary Contact';
        insert testCont;

		Contact testCont1 = new Contact(LastName = 'Test Contact 2');
        testCont1.AccountId = testAcct.Id;
        testCont1.Email = 'test2@email.com';
        testCont1.MobilePhone = '431534';
        testCont1.Contact_Role__c = 'Primary Contact';
        insert testCont1;
        
        AccountContactRelation acr = [SELECT Id, Roles
                                      FROM AccountContactRelation
                                      WHERE ContactId = :testCont1.Id];
        System.assertEquals(null, acr.Roles, 'Role should be empty when account already has Primary contact');
    }
}