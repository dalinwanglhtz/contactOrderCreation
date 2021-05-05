@isTest
public class OrderTriggerHandlerTest {
	
    @testSetup static void setup() {
        Account testAcct = new Account(Name = 'Test Account 1');
        insert testAcct;
        
        Account testAcct1 = new Account(Name = 'Test Account 2');
        insert testAcct1;
        
        Contact testCont = new Contact(LastName = 'Test Contact 1');
        testCont.AccountId = testAcct1.Id;
        testCont.Email = 'test@email.com';
        testCont.MobilePhone = '431532';
        insert testCont;
    }
    
    @isTest static void should_create_link_to_primary_contact() {
 		Account acct = [SELECT Id FROM Account WHERE Name = 'Test Account 1'];
        Contact cont = [SELECT Id FROM Contact WHERE LastName = 'Test Contact 1'];
        
        AccountContactRelation testAcctContRel = new AccountContactRelation();
        testAcctContRel.AccountId = acct.Id;
        testAcctContRel.ContactId = cont.Id;
        testAcctContRel.Roles = 'Primary Contact';
        insert testAcctContRel;
        
        Order testOrder = new Order();
        testOrder.EffectiveDate = Date.today();
        testOrder.AccountId = acct.Id;
        testOrder.Status = 'Draft';
        insert testOrder;
        
        Order resultOrder = [SELECT Id, CustomerAuthorizedById
                            FROM Order
                            WHERE Id = :testOrder.Id];
        System.assertEquals(cont.Id, resultOrder.CustomerAuthorizedById, 
                            'Customer Authorized By ID should equal to the Primary Contact');
    }
    
    @isTest static void should_not_create_link_to_primary_contact() {
 		Account acct = [SELECT Id FROM Account WHERE Name = 'Test Account 1'];
        Contact cont = [SELECT Id FROM Contact WHERE LastName = 'Test Contact 1'];
        
        AccountContactRelation testAcctContRel = new AccountContactRelation();
        testAcctContRel.AccountId = acct.Id;
        testAcctContRel.ContactId = cont.Id;
        testAcctContRel.Roles = 'Delegated Contact';
        insert testAcctContRel;
        
        Order testOrder = new Order();
        testOrder.EffectiveDate = Date.today();
        testOrder.AccountId = acct.Id;
        testOrder.Status = 'Draft';
        insert testOrder;
        
        Order resultOrder = [SELECT Id, CustomerAuthorizedById
                            FROM Order
                            WHERE Id = :testOrder.Id];
        System.assertEquals(null, resultOrder.CustomerAuthorizedById, 
                            'Customer Authorized By ID should be empty');
    }
}