@istest
public class Pf_OrderDetailsClassTest {
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
        objOrder.Pending_Quantityy1__c=100;
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
        PF_orderdetails.fetchOrderProduct();
        test.stopTest();       
    }
    @istest static void test_updateOrder(){
        //list<order> orderid=[select id from order];
        id ID_orderid=[select id
                       from order].id;
        string Strordervalue=(string)ID_orderid;
        integer IntvalueRquantity=1;
        test.startTest();
        List<Order> updateOrderList= PF_orderdetails.updateOrder(Strordervalue,IntvalueRquantity);
        test.stopTest();
    }
    
    @istest static void test_createAsset(){
        id ID_prodid=[select id
                      from Product2 ].id;
        string Strprodidvalue=(string)ID_prodid;
        list<object> List_batchNumbers=new list<object>{'1','2'};
            id ID_orderid=[select id
                           from order].id;
        string Strordervalue=(string)ID_orderid;
        date Date_deliverydate=system.today();
        
        test.startTest();
        PF_orderdetails.createAsset(Strprodidvalue,List_batchNumbers,Strordervalue,Date_deliverydate);
        test.stopTest();
        
    }
    @istest static void test_getproductnamerecords(){
        test.startTest();
        list<string> List_returnlist=PF_orderdetails.getproductnamerecords();
        test.stopTest();
    }
    @istest static void test_retrieveProductRecords(){
        string Strsearchsname=[select id,
                                   name 
                                   from Product2 ].name;
        test.startTest();
        List < OrderItem > gettingretrieveProductRecords=PF_orderdetails.retrieveProductRecords(Strsearchsname);
        test.stopTest();
        
    }
    @istest static void test_retrieveProductNameRecords(){
        string Strsearchsname=[select id,
                                   name
                                   from Product2 ].name;
        test.startTest();
        List < Inventory__c > List_gettingretrieveProductNameRecords=PF_orderdetails.retrieveProductNameRecords(Strsearchsname);
        test.stopTest();
        
    }
    @istest static void test_getSupplierDetails(){
        string Strsearchsname=[select id,name from account].name;
        test.startTest();
        List < order > List_gettinggetSupplierDetails=PF_orderdetails.getSupplierDetails(Strsearchsname);
        test.stopTest();
        
    }
    @istest static void test_orderStatusFilter(){
        string Strsearchstatus='All';
        test.startTest();
        list<order> gettingorderdetailsforAll=PF_orderdetails.orderStatusFilter('All');
        list<order> gettingorderdetailswithoutAll=PF_orderdetails.orderStatusFilter(Null);
        
        test.stopTest();
    }
    @istest static void test_orderStatusRecords(){
        string Strsearchstatus='All';
        string Strsearchsname=[select id,
                                   name 
                                   from Product2 ].name;
        test.startTest();
        PF_orderdetails.orderStatusRecords('All',Null);
        PF_orderdetails.orderStatusRecords('Order Placed',Null);
        PF_orderdetails.orderStatusRecords('Order Placed','teset product');
        test.stopTest();
        
    }
    @istest static void test_orderProductNameFilter(){
        
        string String_searchsname=[select id,
                                   name
                                   from Product2 ].name;
        test.startTest();
        PF_orderdetails.orderProductNameFilter(String_searchsname);
        
        test.stopTest();
        
    }
    @istest static void test_statusRecords(){
        
        string Strsearchsname=[select id,
                                   name 
                                   from Product2 ].name;
        test.startTest();
        PF_orderdetails.statusRecords('',Strsearchsname);
        PF_orderdetails.statusRecords('',Null);
        PF_orderdetails.statusRecords('All','All');        
        test.stopTest();
        
    }
    @istest static void test_getOrderIds(){
        string Strordernumbervalue=[select id,
                                        ordernumber
                                        from order ].ordernumber;
        test.startTest();
        PF_orderdetails.getOrderId(Strordernumbervalue);               
        test.stopTest();
        
    }
    @istest static void test_statusRecordsWithoutProduct(){
        string Strsearchstatus='All';
        test.startTest();
        PF_orderdetails.statusRecordsWithoutProduct(Strsearchstatus);  
        PF_orderdetails.statusRecordsWithoutProduct(null);  
        
        test.stopTest();
        
    }
    @istest static void test_getAssetRecords(){
        id ID_orderid=[select id 
                       from order].id;
        string Strorderidvalue=(string)ID_orderid;       
        test.startTest();
        PF_orderdetails.getAssetRecords(Strorderidvalue);              
        test.stopTest();
        
    }
    @istest static void test_OrderRecordsDatatable(){
        
        test.startTest();
        PF_orderdetails.OrderRecordsDatatable();              
        test.stopTest();
        
    }
    @istest static void test_getOrderIdQA(){
        order Record_order=[select id,
                            name,
                            status
                            from order];
        Record_order.Status='Partial Quantity Under QA';
        update Record_order;
        string Strordernumbervalue=[select id,
                                        ordernumber 
                                        from order].ordernumber;
        test.startTest();
        PF_orderdetails.getOrderIdQA(Strordernumbervalue);              
        test.stopTest();
        
    }
    @istest static void test_fetchSearchResultsDeliveryInfo(){
        
        string Strordernumbervalue=[select id,
                                        ordernumber
                                        from order].ordernumber;
        test.startTest();
        PF_orderdetails.fetchSearchResultsDeliveryInfo(Strordernumbervalue);              
        test.stopTest();
        
    }
    
    @istest static void test_Assetvalues(){
        asset Record_updateasset=[select id,
                                  Status 
                                  from asset];
        Record_updateasset.Status='QA Pass';
        update Record_updateasset;
        
        id ID_batchname=[select id from Batch_Number__c].id;
        string Strbatchnamevalue=(string)ID_batchname;
        test.startTest();
        PF_orderdetails.Assetvalues(Strbatchnamevalue);              
        test.stopTest();
        
    }
    
    
}