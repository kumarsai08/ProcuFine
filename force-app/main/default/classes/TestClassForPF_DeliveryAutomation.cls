@istest
public class TestClassForPF_DeliveryAutomation {
    @TestSetup static void datasetup(){
        Order orr=new Order();
        orr.Name='test order';
        orr.status='Order Placed';
        orr.OpportunityId='0065g00000X59FfAAJ';
        orr.AccountId ='0015g000015vYpPAAU';
        orr.EffectiveDate=system.today();
        insert orr;
        Batch_Number__c bn=new Batch_Number__c();
        
        bn.Order__c=orr.id;
        bn.Delivery_date__c=system.today();
        bn.Child_Assets_Count__c=4;
        insert bn;
        account acc = new account();
        acc.name='test account';
        insert acc;
        contact con= new contact ();
        con.FirstName = 'test';
        con.LastName = 'record';
        con.AccountId = acc.id;
        insert con;
        
        
        
        
        
        asset assetrecord=new asset();
        assetrecord.Name='test asset';
        assetrecord.Sales_Order__c=orr.id;
        assetrecord.InstallDate=system.today();
        assetrecord.AccountId=acc.Id;
        assetrecord.ContactId=con.id;
        assetrecord.Batch_Number_lookup__c=bn.Id;
        
        insert assetrecord;
        
    }
    @IsTest static void testdeliveryAutomationmethod(){
        order orderrecord=[select id,name from order where name='test order'];
        system.debug(orderrecord);
        Batch_Number__c batchnumberid=[select id,name from Batch_Number__c];
        
        
        list<string> batchnumber=new list<string>{batchnumberid.id};
            list<integer> inputquantity=new list<integer>{1};
                test.startTest();
                PF_DeliveryAutomation.DeliveryAutomation(batchnumber,inputquantity,orderrecord.id);
        test.stopTest();
        
    }
    
    
}