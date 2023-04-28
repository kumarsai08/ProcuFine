@istest
public class Pf_DeliveryAutomationTest {
    @TestSetup static void datasetup(){
        Order Objorder=new Order();
        Objorder.Name='test order';
        Objorder.status='Order Placed';
        Objorder.OpportunityId='0065g00000X59FfAAJ';
        Objorder.AccountId ='0015g000015vYpPAAU';
        Objorder.EffectiveDate=system.today();
        insert Objorder;
        Batch_Number__c objBatch_Number=new Batch_Number__c();       
        objBatch_Number.Order__c=Objorder.id;
        objBatch_Number.Delivery_date__c=system.today();
        objBatch_Number.Child_Assets_Count__c=4;
        insert objBatch_Number;
        account objAccount = new account();
        objAccount.name='test account';
        insert objAccount;
        contact objContact= new contact ();
        objContact.FirstName = 'test';
        objContact.LastName = 'record';
        objContact.AccountId = objAccount.id;
        insert objContact;       
        asset objasset=new asset();
        objasset.Name='test asset';
        objasset.Sales_Order__c=Objorder.id;
        objasset.InstallDate=system.today();
        objasset.AccountId=objAccount.Id;
        objasset.ContactId=objContact.id;
        objasset.Batch_Number_lookup__c=objBatch_Number.Id;       
        insert objasset;       
    }
    @IsTest static void testdeliveryAutomationmethod(){
        order Record_orderrecord=[select id,
                                  name
                                  from order 
                                  where name='test order'];
        system.debug(Record_orderrecord);
        Batch_Number__c Record_batchnumberid=[select id,
                                              name 
                                              from Batch_Number__c];        
        list<string> List_batchnumber=new list<string>{Record_batchnumberid.id};
            list<integer> List_inputquantity=new list<integer>{1};
         test.startTest();
        PF_DeliveryAutomation.DeliveryAutomation(List_batchnumber,List_inputquantity,Record_orderrecord.id);
        test.stopTest();        
    }
    
    
}