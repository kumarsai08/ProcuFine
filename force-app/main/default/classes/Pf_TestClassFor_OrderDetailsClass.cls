@istest
public class Pf_TestClassFor_OrderDetailsClass {
    @testsetup static void data_setup(){
        Id RecordTypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Purchase Orders').getRecordTypeId();
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account objAccount = new account();
        objAccount.name='test account';
        insert objAccount;       
        Opportunity objOpportunity = new Opportunity
            (Name = 'testopp',Type ='New Customer',AccountId=objAccount.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Prospecting'); 
        insert objOpportunity;
        Product2 objProduct2=new Product2();
        objProduct2.Name='teset product';
        objProduct2.IsActive=true;
        objProduct2.Rejected_Quantity__c=23;
        insert objProduct2;
        PricebookEntry objPricebookEntry = new PricebookEntry(UnitPrice=10.0, Product2Id=objProduct2.Id, Pricebook2Id=pricebook2idvalue, IsActive=true);
        
        insert objPricebookEntry;
        schema.Location objLocation = new schema.Location();
        objLocation.Name='Miyapur';
        objLocation.LocationType='WareHouse-1';
        objLocation.Maximum_Threshold__c=22;
        insert objLocation;
        Inventory__c objInventory =new Inventory__c();
        objInventory.Name='Check';
        objInventory.Threshold__c=10;
        objInventory.Quantity__c=5;
        objInventory.Exsisting_Stock_On_Hand__c=5;
        objInventory.On_Order__c=6;
        objInventory.defective_quantity__c=4;
        objInventory.Order__c=4;
        objInventory.Under_QA_Num__c=3;
        objInventory.Product__c=objProduct2.id;
        objInventory.Warehouse__c=objLocation.id;       
        insert objInventory;
        Order objOrder=new Order();
        objOrder.Name='test order';
        objOrder.status='Order Placed';
        objOrder.On_Hand_Recieved__c=2;
        objOrder.OpportunityId=objOpportunity.id;
        objOrder.AccountId =objAccount.Id;        
        objOrder.Approved_Quantity__c=4;
        objOrder.Pending_Quantityy1__c=8;
        objOrder.Reject_Quantity__c=9;
        objOrder.Under_QA__c=2;
        objOrder.EffectiveDate=system.today();
        objOrder.Pricebook2id =pricebook2idvalue;
        objOrder.RecordTypeId =RecordTypeIdOrder;
        objOrder.Warehouse__c=objLocation.id;
        objOrder.Product__c=objProduct2.Id;
        // orr.Quantity__c=10;
        insert objOrder;
        OrderItem objOrderItem = new OrderItem();
        objOrderItem.Product2Id=objProduct2.Id;
        objOrderItem.Quantity=1.0;
        objOrderItem.OrderId=objOrder.Id;
        objOrderItem.UnitPrice=10.0;
        objOrderItem.PricebookEntryId = objPricebookEntry.id;
        system.debug(objOrderItem);
        insert objOrderItem;
        contact objContact= new contact ();
        objContact.FirstName = 'test';
        objContact.LastName = 'record';
        objContact.AccountId = objAccount.id;
        insert objContact;
        Batch_Number__c objBatch_Number=new Batch_Number__c();
        objBatch_Number.Delivery_date__c=system.today();
        objBatch_Number.Child_Assets_Count__c=4;
        objBatch_Number.Defective_Batch__c=null;
        insert objBatch_Number;        
        asset objAsset=new asset();
        objAsset.Name='test asset';
        objAsset.Product2Id=objProduct2.Id;
        objAsset.Batch_Number_lookup__c=objBatch_Number.Id;
        objAsset.InstallDate=system.today();
        objAsset.AccountId=objAccount.Id;
        objAsset.ContactId=objContact.id;
        objAsset.Batch_Number_lookup__c=objBatch_Number.Id;
        objAsset.Batch_Number__c='1';
        objAsset.Order_Id__c=objOrder.Id;
        objAsset.Status='QA In Progress'; 
        objAsset.SKU_Id__c='1';
        insert objAsset;             
        
        
    }
    @istest static void test_fetchOrderProduct(){
        test.startTest();       
        orderdetails.fetchOrderProduct();
        test.stopTest();       
    }
    @istest static void test_updateOrder(){
        //list<order> orderid=[select id from order];
        id ID_orderid=[select id from order].id;
        string String_orderalue=(string)ID_orderid;
        integer Integer_valueRquantity=15;
        test.startTest();
        List<Order> updateOrderList= orderdetails.updateOrder(String_orderalue,Integer_valueRquantity);
        test.stopTest();
    }
    
    @istest static void test_createAsset(){
        id ID_prodid=[select id from Product2 ].id;
        string String_prodidvalue=(string)ID_prodid;
        list<object> List_batchNumbers=new list<object>{'1','2'};
            id ID_orderid=[select id from order].id;
        string String_orderalue=(string)ID_orderid;
        date Date_deliverydate=system.today();
        
        test.startTest();
        orderdetails.createAsset(String_prodidvalue,List_batchNumbers,String_orderalue,Date_deliverydate);
        test.stopTest();
        
    }
    @istest static void test_getproductnamerecords(){
        test.startTest();
        list<string> List_returnlist=orderdetails.getproductnamerecords();
        test.stopTest();
    }
    @istest static void test_retrieveProductRecords(){
        string String_searchsname=[select id,name from Product2 ].name;
        test.startTest();
        List < OrderItem > gettingretrieveProductRecords=orderdetails.retrieveProductRecords(String_searchsname);
        test.stopTest();
        
    }
    @istest static void test_retrieveProductNameRecords(){
        string String_searchsname=[select id,name from Product2 ].name;
        test.startTest();
        List < Inventory__c > List_gettingretrieveProductNameRecords=orderdetails.retrieveProductNameRecords(String_searchsname);
        test.stopTest();
        
    }
    @istest static void test_getSupplierDetails(){
        string String_searchsname=[select id,name from account].name;
        test.startTest();
        List < order > List_gettinggetSupplierDetails=orderdetails.getSupplierDetails(String_searchsname);
        test.stopTest();
        
    }
    @istest static void test_orderStatusFilter(){
        string String_searchstatus='All';
        test.startTest();
        list<order> gettingorderdetailsforAll=orderdetails.orderStatusFilter('All');
        list<order> gettingorderdetailswithoutAll=orderdetails.orderStatusFilter(Null);
        
        test.stopTest();
    }
    @istest static void test_orderStatusRecords(){
        string String_searchstatus='All';
        string String_searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.orderStatusRecords('All',Null);
        orderdetails.orderStatusRecords('Order Placed',Null);
        orderdetails.orderStatusRecords('Order Placed','teset product');
        test.stopTest();
        
    }
    @istest static void test_orderProductNameFilter(){
        
        string String_searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.orderProductNameFilter(String_searchsname);
        
        test.stopTest();
        
    }
    @istest static void test_statusRecords(){
        
        string String_searchsname=[select id,name from Product2 ].name;
        test.startTest();
        orderdetails.statusRecords('',String_searchsname);
        orderdetails.statusRecords('',Null);
        orderdetails.statusRecords('All','All');        
        test.stopTest();
        
    }
    @istest static void test_getOrderIds(){
        string String_ordernumbervalue=[select id,ordernumber from order ].ordernumber;
        test.startTest();
        orderdetails.getOrderId(String_ordernumbervalue);               
        test.stopTest();
        
    }
    @istest static void test_statusRecordsWithoutProduct(){
        string String_searchstatus='All';
        test.startTest();
        orderdetails.statusRecordsWithoutProduct(String_searchstatus);  
        orderdetails.statusRecordsWithoutProduct(null);  
        
        test.stopTest();
        
    }
    @istest static void test_getAssetRecords(){
        id ID_orderid=[select id from order].id;
        string String_orderidvalue=(string)ID_orderid;       
        test.startTest();
        orderdetails.getAssetRecords(String_orderidvalue);              
        test.stopTest();
        
    }
    @istest static void test_OrderRecordsDatatable(){
        
        test.startTest();
        orderdetails.OrderRecordsDatatable();              
        test.stopTest();
        
    }
    @istest static void test_getOrderIdQA(){
        order Record_order=[select id,name,status from order];
        Record_order.Status='Partial Quantity Under QA';
        update Record_order;
        string String_ordernumbervalue=[select id,ordernumber from order].ordernumber;
        test.startTest();
        orderdetails.getOrderIdQA(String_ordernumbervalue);              
        test.stopTest();
        
    }
    @istest static void test_fetchSearchResultsDeliveryInfo(){
        
        string String_ordernumbervalue=[select id,ordernumber from order].ordernumber;
        test.startTest();
        orderdetails.fetchSearchResultsDeliveryInfo(String_ordernumbervalue);              
        test.stopTest();
        
    }
    
    @istest static void test_Assetvalues(){
        asset Record_updateasset=[select id,Status from asset];
        Record_updateasset.Status='QA Pass';
        update Record_updateasset;
        
        id ID_batchname=[select id from Batch_Number__c].id;
        string String_batchnamevalue=(string)ID_batchname;
        test.startTest();
        orderdetails.Assetvalues(String_batchnamevalue);              
        test.stopTest();
        
    }
    
    
}