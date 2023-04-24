@istest
public class TestClassFor_OrderDetailsClass {
    @testsetup static void data_setup(){
        Id RecordTypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Purchase Orders').getRecordTypeId();
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account acc = new account();
        acc.name='test account';
        insert acc;       
        Opportunity opp = new Opportunity
            (Name = 'testopp',Type ='New Customer',AccountId=acc.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Prospecting'); 
        insert opp;
        Product2 pr=new Product2();
        pr.Name='teset product';
        pr.IsActive=true;
        pr.Rejected_Quantity__c=23;
        insert pr;
        PricebookEntry pbe = new PricebookEntry(UnitPrice=10.0, Product2Id=pr.Id, Pricebook2Id=pricebook2idvalue, IsActive=true);

insert pbe;
        schema.Location loc = new schema.Location();
        loc.Name='Miyapur';
        loc.LocationType='WareHouse-1';
        loc.Maximum_Threshold__c=22;
        insert loc;
        Inventory__c inv =new Inventory__c();
        inv.Name='Check';
        inv.Threshold__c=10;
        inv.Quantity__c=5;
        inv.Exsisting_Stock_On_Hand__c=5;
        inv.On_Order__c=6;
        inv.defective_quantity__c=4;
        inv.Order__c=4;
        inv.Under_QA_Num__c=3;
        inv.Product__c=pr.id;
        inv.Warehouse__c=loc.id;       
        insert inv;
        Order orr=new Order();
        orr.Name='test order';
        orr.status='Order Placed';
        orr.On_Hand_Recieved__c=2;
        orr.OpportunityId=opp.id;
        orr.AccountId =acc.Id;        
        orr.Approved_Quantity__c=4;
        orr.Pending_Quantityy1__c=8;
        orr.Reject_Quantity__c=9;
        orr.Under_QA__c=2;
        orr.EffectiveDate=system.today();
        orr.Pricebook2id =pricebook2idvalue;
        orr.RecordTypeId =RecordTypeIdOrder;
        orr.Warehouse__c=loc.id;
        orr.Product__c=pr.Id;
       // orr.Quantity__c=10;
        insert orr;
        OrderItem oi = new OrderItem();
    oi.Product2Id=pr.Id;
    oi.Quantity=1.0;
    oi.OrderId=orr.Id;
    oi.UnitPrice=10.0;
    oi.PricebookEntryId = pbe.id;
system.debug(oi);
insert oi;
        contact con= new contact ();
        con.FirstName = 'test';
        con.LastName = 'record';
        con.AccountId = acc.id;
        insert con;
        Batch_Number__c bn=new Batch_Number__c();
        bn.Delivery_date__c=system.today();
        bn.Child_Assets_Count__c=4;
        bn.Defective_Batch__c=null;
        insert bn;        
         asset assetrecord=new asset();
        assetrecord.Name='test asset';
        assetrecord.Product2Id=pr.Id;
        assetrecord.Batch_Number_lookup__c=bn.Id;
        assetrecord.InstallDate=system.today();
        assetrecord.AccountId=acc.Id;
        assetrecord.ContactId=con.id;
        assetrecord.Batch_Number_lookup__c=bn.Id;
        assetrecord.Batch_Number__c='1';
        assetrecord.Order_Id__c=orr.Id;
        assetrecord.Status='QA In Progress'; 
        assetrecord.SKU_Id__c='1';
        insert assetrecord;             

        
    }
    @istest static void test_fetchOrderProduct(){
        test.startTest();       
            orderdetails.fetchOrderProduct();
            test.stopTest();       
    }
    @istest static void test_updateOrder(){
        //list<order> orderid=[select id from order];
        id orderid=[select id from order].id;
        string orderalue=(string)orderid;
        integer valueRquantity=15;
        test.startTest();
        List<Order> updateOrderList= orderdetails.updateOrder(orderalue,valueRquantity);
        test.stopTest();
    }
    @istest static void test_createAsset(){
        id prodid=[select id from Product2 ].id;
        string prodidvalue=(string)prodid;
        list<object> batchNumbers=new list<object>{'1','2'};
                    id orderid=[select id from order].id;
        string orderalue=(string)orderid;
        date deliverydate=system.today();
        
        test.startTest();
        orderdetails.createAsset(prodidvalue,batchNumbers,orderalue,deliverydate);
        test.stopTest();
            
    }
    @istest static void test_getproductnamerecords(){
        test.startTest();
        list<string> returnlist=orderdetails.getproductnamerecords();
        test.stopTest();
    }
    @istest static void test_retrieveProductRecords(){
        string searchsname=[select id,name from Product2 ].name;
        test.startTest();
         List < OrderItem > gettingretrieveProductRecords=orderdetails.retrieveProductRecords(searchsname);
        test.stopTest();
        
    }
    @istest static void test_retrieveProductNameRecords(){
        string searchsname=[select id,name from Product2 ].name;
        test.startTest();
         List < Inventory__c > gettingretrieveProductNameRecords=orderdetails.retrieveProductNameRecords(searchsname);
        test.stopTest();
        
    }
    @istest static void test_getSupplierDetails(){
        string searchsname=[select id,name from account].name;
                test.startTest();
         List < order > gettinggetSupplierDetails=orderdetails.getSupplierDetails(searchsname);
        test.stopTest();
        
    }
    @istest static void test_orderStatusFilter(){
        string searchstatus='All';
        test.startTest();
        list<order> gettingorderdetailsforAll=orderdetails.orderStatusFilter('All');
        list<order> gettingorderdetailswithoutAll=orderdetails.orderStatusFilter(Null);
        
        test.stopTest();
    }
    @istest static void test_orderStatusRecords(){
        string searchstatus='All';
        string searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.orderStatusRecords('All',Null);
         orderdetails.orderStatusRecords('Order Placed',Null);
         orderdetails.orderStatusRecords('Order Placed','teset product');
        test.stopTest();
        
    }
     @istest static void test_orderProductNameFilter(){

        string searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.orderProductNameFilter(searchsname);

        test.stopTest();
        
    }
    @istest static void test_statusRecords(){

        string searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.statusRecords('',searchsname);
        orderdetails.statusRecords('',Null);
        orderdetails.statusRecords('All','All');        
        test.stopTest();
        
    }
    @istest static void test_getOrderIds(){
        string ordernumbervalue=[select id,ordernumber from order ].ordernumber;
        test.startTest();
        orderdetails.getOrderId(ordernumbervalue);               
        test.stopTest();
        
    }
        @istest static void test_statusRecordsWithoutProduct(){
        string searchstatus='All';
        test.startTest();
        orderdetails.statusRecordsWithoutProduct(searchstatus);  
        orderdetails.statusRecordsWithoutProduct(null);  
            
        test.stopTest();
        
    }
    @istest static void test_getAssetRecords(){
        id orderid=[select id from order].id;
        string orderidvalue=(string)orderid;       
        test.startTest();
        orderdetails.getAssetRecords(orderidvalue);              
        test.stopTest();
        
    }
     @istest static void test_OrderRecordsDatatable(){

        test.startTest();
        orderdetails.OrderRecordsDatatable();              
        test.stopTest();
        
    }
         @istest static void test_getOrderIdQA(){
             order od=[select id,name,status from order];
             od.Status='Partial Quantity Under QA';
             update od;
             string ordernumbervalue=[select id,ordernumber from order].ordernumber;
        test.startTest();
        orderdetails.getOrderIdQA(ordernumbervalue);              
        test.stopTest();
        
    }
    @istest static void test_fetchSearchResultsDeliveryInfo(){
             
             string ordernumbervalue=[select id,ordernumber from order].ordernumber;
        test.startTest();
        orderdetails.fetchSearchResultsDeliveryInfo(ordernumbervalue);              
        test.stopTest();
        
    }

         @istest static void test_Assetvalues(){
             asset updateasset=[select id,Status from asset];
             updateasset.Status='QA Pass';
             update updateasset;
             
             id batchname=[select id from Batch_Number__c].id;
             string batchnamevalue=(string)batchname;
        test.startTest();
        orderdetails.Assetvalues(batchnamevalue);              
        test.stopTest();
        
    }


}