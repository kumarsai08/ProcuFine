@istest
class PF_OpportunitySummaryTest {
    @testsetup static void data_setup(){
        Id RecordTypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
        Id pricebook2idvalue = Test.getStandardPricebookId();
        Id RecordTypeIdaccount = Schema.SObjectType.account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        account objAccount = new account();
        objAccount.name='test account';
        objAccount.PF_Email__c='kumarsai0802@gmail.com';
        objAccount.Grade__c='A'; 
        objAccount.RecordTypeId=RecordTypeIdaccount;
        insert objAccount;
        Opportunity objOpportunity = new Opportunity
            (Name = 'test products',Type ='New Customer',AccountId=objAccount.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Closed Won',TotalOpportunityQuantity=10,PF_Opportunity_Quantity__c=10); 
        insert objOpportunity;
        
        Product2 objProduct2=new Product2();
        objProduct2.Name='test product';
        objProduct2.IsActive=true;
        objProduct2.Rejected_Quantity__c=23;
        objProduct2.PF_UOM__c='23';
        objProduct2.Quantity__c=10;
        objProduct2.PF_On_Order__c=10;
        objProduct2.PF_Orders_Received__c=20;
        objProduct2.PF_Defective_Quantity__c=20;
        objProduct2.ProductCode='001';
        insert objProduct2;
        PricebookEntry objPricebookEntry = new PricebookEntry(UnitPrice=10.0, Product2Id=objProduct2.Id, Pricebook2Id=pricebook2idvalue, IsActive=true);
        
        insert objPricebookEntry;
        PF_Product_Supplier__c objProduct_Supplier=new PF_Product_Supplier__c();
        objProduct_Supplier.Product__c=objProduct2.id;
        objProduct_Supplier.Name=objAccount.Name;
        objProduct_Supplier.Quantity__c=10;
        objProduct_Supplier.Supplier_Name__c=objAccount.id;
        insert objProduct_Supplier;  
        Order objorder=new Order();
        objorder.Name='test order';
        objorder.status='Order Placed';
        objorder.PF_On_Hand_Received__c=2;
        objorder.OpportunityId=objOpportunity.id;
        objorder.Received_Quantity__c=50;
        objorder.AccountId =objAccount.Id;        
        objorder.PF_Approved_Quantity__c=4;
        objorder.PF_Pending_Quantity__c=8;
        objorder.PF_Reject_Quantity__c=9;
        objorder.PF_Under_QA__c=2;
        objorder.EffectiveDate=system.today();
        objorder.Pricebook2id =pricebook2idvalue;
        objorder.RecordTypeId =RecordTypeIdOrder;
        objorder.PF_Product__c=objProduct2.Id;
        objorder.Type='Procured';
        insert objorder;
        OrderItem objOrderItem = new OrderItem();
        objOrderItem.Product2Id=objProduct2.Id;
        objOrderItem.Quantity=1.0;
        objOrderItem.OrderId=objorder.Id;
        objOrderItem.UnitPrice=10.0;
        objOrderItem.PricebookEntryId = objPricebookEntry.id;
        system.debug(objOrderItem);
        insert objOrderItem;
        contact objContact= new contact ();
        objContact.FirstName = 'test';
        objContact.LastName = 'record';
        objContact.AccountId = objAccount.id;
        insert objContact;
        quote objquote=new quote();
        objquote.OpportunityId=objOpportunity.id;
        objquote.PF_Product__c=objProduct2.id;
        objquote.PF_Supplier_Account__c=objAccount.id;
        objquote.Name='test quote';
        objquote.PF_Supplier_Email__c=objAccount.PF_Email__c;
        objquote.PF_Supplier__c=objAccount.Name;
        objquote.PF_Order_Quantity__c=10;
        objquote.Status='open';
        objquote.PF_Inventory_Manager__c=UserInfo.getUserId();
        objquote.PriceBook2Id = pricebook2idvalue;
        insert objquote;
        QuoteLineItem objQuoteLineItem=new QuoteLineItem();
        objQuoteLineItem.Product2Id=objProduct2.Id;
        objQuoteLineItem.PriceBookentryId =objPricebookEntry.Id;
        objQuoteLineItem.QuoteId=objquote.Id;
        objQuoteLineItem.Quantity=20;
        objQuoteLineItem.UnitPrice=20;
        insert objQuoteLineItem; 
        OpportunityLineItem ObjOpportunityLineItem = new OpportunityLineItem();
        ObjOpportunityLineItem.OpportunityId=objOpportunity.Id; 
        ObjOpportunityLineItem.PricebookEntryId=objPricebookEntry.Id ;
        ObjOpportunityLineItem.quantity=10;
        ObjOpportunityLineItem.Product2Id=objProduct2.id;
        ObjOpportunityLineItem.TotalPrice=20;
        insert ObjOpportunityLineItem;
        PF_Batch_Number__c objBatch_Number=new PF_Batch_Number__c();
        objBatch_Number.Delivery_Date__c=system.today();
        objBatch_Number.Child_Assets_Count__c=4;
        //objBatch_Number.Defective_Batch__c=null;
        insert objBatch_Number;        
        asset objAsset=new asset();
        objAsset.Name='test asset';
        objAsset.Product2Id=objProduct2.Id;
        objAsset.PF_Batch_Number__c=objBatch_Number.Id;
        objAsset.InstallDate=system.today();
        objAsset.AccountId=objAccount.Id;
        objAsset.ContactId=objContact.id;
        objAsset.PF_Batch_Number__c=objBatch_Number.Id;
        objAsset.PF_Batch_Name__c='1';
        objAsset.PF_OrderId__c=objorder.Id;
        objAsset.Status='QA In Progress'; 
        objAsset.PF_SKU_Id__c='1';
        insert objAsset;
        
    }
    @istest static void test_GetSuppleirDetails(){
        id ID_productid=[select id from product2].id;
        test.startTest();
        pf_Opportunitysummary.GetSuppleirDetails((string)ID_productid);
        test.stopTest();
        
    }
    @istest static void test_fetchOrderProduct(){       
        test.startTest();
        pf_Opportunitysummary.fetchOrderProduct();
        test.stopTest();        
    }
    @istest static void test_pf_OpportunityQuantity(){       
        test.startTest();
        pf_Opportunitysummary.pf_OpportunityQuantity();
        test.stopTest();        
    }
    @istest static void test_pf_OpportunityQuantitytab(){       
        test.startTest();
        pf_Opportunitysummary.pf_OpportunityQuantitytab();
        test.stopTest();        
    }
    @istest static void test_orderStatusFilter(){       
        test.startTest();
        pf_Opportunitysummary.orderStatusFilter('ALL');
        pf_Opportunitysummary.orderStatusFilter(NULL);
        test.stopTest();        
    }
    @istest static void test_orderStatusRecords(){       
        test.startTest();
        pf_Opportunitysummary.orderStatusRecords('ALL',NULL);
        pf_Opportunitysummary.orderStatusRecords(NULL,'ALL');
        pf_Opportunitysummary.orderStatusRecords('ALL','ALL');
        pf_Opportunitysummary.orderStatusRecords(NULL,NULL);
        test.stopTest();        
    }
    @istest static void test_GetSupplierrDetailsfornewtable(){
        test.startTest();
        pf_Opportunitysummary.GetSupplierrDetailsfornewtable('test product');
        test.stopTest();
        
    }
    @istest static void test_supplierSection(){
        test.startTest();
        pf_Opportunitysummary.supplierSection('test product');
        test.stopTest();
        
    }
    @istest static void test_getOrderId(){
        string Strordernumber=[select id,ordernumber from order].ordernumber;
        test.startTest();
        pf_Opportunitysummary.getOrderId(Strordernumber);
        test.stopTest();        
    }
    @istest static void test_getSupplierDetails(){       
        test.startTest();
        pf_Opportunitysummary.getSupplierDetails('test account');
        test.stopTest();        
    }
    @istest static void test_supplierSearchFilter(){       
        test.startTest();
        pf_Opportunitysummary.supplierSearchFilter();
        test.stopTest();        
    }
    @istest static void test_supplierNamesList(){       
        test.startTest();
        pf_Opportunitysummary.supplierNamesList('test product');
        test.stopTest();        
    }
    @istest static void test_retrieveRecords(){       
        test.startTest();
        pf_Opportunitysummary.retrieveRecords('test account','test product');
        test.stopTest();        
    }
    @istest static void test_ReviseButton(){ 
        list<PF_Product_Supplier__c> list_productsupplier=[select id,name from PF_Product_Supplier__c];
        list<string> List_supplierids=new list<string>();
        for(PF_Product_Supplier__c Record_ps:list_productsupplier){
            List_supplierids.add(Record_ps.id);
        }
        list<string> List_orderQuantity=new list<string>{'20'};
            list<string> List_SupplierNamesList=new list<string>{'test account'};
                
                
                test.startTest();
        pf_Opportunitysummary.ReviseButton(List_supplierids,List_orderQuantity,List_SupplierNamesList);
        test.stopTest();        
    }
    @istest static void test_SendAnEmail(){ 
        list<PF_Product_Supplier__c> list_productsupplier=[select id,name from PF_Product_Supplier__c];
        list<string> List_supplierids=new list<string>();
        for(PF_Product_Supplier__c Record_ps:list_productsupplier){
            List_supplierids.add(Record_ps.id);
        }
        list<string> List_orderQuantity=new list<string>{'20'};
            list<string> List_SupplierNamesList=new list<string>{'test account'};
                
                
                test.startTest();
        pf_Opportunitysummary.SendAnEmail(List_supplierids,List_orderQuantity,List_SupplierNamesList,'NO WareHouse');
        test.stopTest();        
    }
    @istest static void test_opprecords(){       
        test.startTest();
        pf_Opportunitysummary.opprecords('test product');
        test.stopTest();        
    }
    @istest static void test_pf_ProductSummary(){       
        test.startTest();
        pf_Opportunitysummary.pf_ProductSummary();
        test.stopTest();        
    }
    @istest static void test_getproductnamerecords(){       
        test.startTest();
        pf_Opportunitysummary.getproductnamerecords();
        test.stopTest();        
    }
    @istest static void test_orderProductNameFilter(){       
        test.startTest();
        pf_Opportunitysummary.orderProductNameFilter('test product');
        test.stopTest();        
    }
    @istest static void test_ProductNameFilterInOpp(){       
        test.startTest();
        pf_Opportunitysummary.ProductNameFilterInOpp('test product');
        test.stopTest();        
    }
    @istest static void test_getSupplierNames(){       
        test.startTest();
        pf_Opportunitysummary.getSupplierNames('test product','open');
        pf_Opportunitysummary.getSupplierNames('test product','closed');
        pf_Opportunitysummary.getSupplierNames('test product','Rejected');
        
        test.stopTest();        
    }
    @istest static void test_PFGetQuoteLineItems(){       
        test.startTest();
        pf_Opportunitysummary.PFGetQuoteLineItems('test product','test account','open');
        pf_Opportunitysummary.PFGetQuoteLineItems('test product','test account','closed');
        pf_Opportunitysummary.PFGetQuoteLineItems('test product','test account',NULL);
        
        
        test.stopTest();        
    }
    @istest static void test_CreateQuotelineitems(){ 
        id ID_quotelinitemid=[select id from QuoteLineItem].id;
        test.startTest();
        pf_Opportunitysummary.CreateQuotelineitems((string)ID_quotelinitemid,10,10,10.2,'nothing',system.today());
        test.stopTest();        
    }
    @istest static void test_UpdateQuoteLineItemAndQuoteStatus(){  
        list<quote> List_Quoteids=[select id from quote];
        list<string> List_Stringquoteids=new list<string>();
        for(quote ObjQuote:List_Quoteids){
            List_Stringquoteids.add(objquote.Id);
        }
        
        test.startTest();
        pf_Opportunitysummary.UpdateQuoteLineItemAndQuoteStatus((string)List_Quoteids[0].id,List_Stringquoteids);
        //pf_Opportunitysummary.UpdateQuoteLineItemAndQuoteStatus('',String_quoteids);
        test.stopTest();        
    }
    @istest static void test_OrderRecordsDatatable(){ 
        
        test.startTest();
        pf_Opportunitysummary.OrderRecordsDatatable();
        test.stopTest();        
    }
    @istest static void test_getProductNames(){           
        test.startTest();
        pf_Opportunitysummary.getProductNames('test product');
        test.stopTest();        
    }
    @istest static void test_OrderRecords(){ 
        list<quote> List_Quoteids=[select id,name from quote];
        list<string> list_suppliernamelist=new list<string>{'test account'};
            
            test.startTest();
        pf_Opportunitysummary.OrderRecords(list_suppliernamelist,List_Quoteids[0].id);
        test.stopTest();        
    }
    @istest static void test_QAManagerTable(){ 
        order Record_order=[select id,name ,status from order];
        Record_order.status='Fully Received Under QA';
        update record_order;               
        test.startTest();
        pf_Opportunitysummary.QAManagerTable();
        test.stopTest();        
    }
    @istest static void test_producttoassestrecords(){ 
        id String_Productid=[select id,name from product2].id;
        test.startTest();
        pf_Opportunitysummary.producttoassestrecords((string)String_Productid);
        test.stopTest();        
    }
    @istest static void test_CreateAssetRecords(){ 
        list<asset> Objassetids=[select id,name from asset];
        list<string> LIST_StringAssetids=new list<string>{(string)Objassetids[0].id};
            list<string> String_statuspass=new list<string>{'qa pass'};             
                test.startTest();
        pf_Opportunitysummary.CreateAssetRecords(LIST_StringAssetids,String_statuspass);
        test.stopTest();        
    }
    @istest static void test_CreateAssetRecords1(){ 
        order objorder=[select id,PF_Approved_Quantity__c from order];
        objorder.PF_Approved_Quantity__c=null;
        update objorder;
        list<asset> Objassetids=[select id,name from asset];
        list<string> LIST_StringAssetids=new list<string>{(string)Objassetids[0].id};
            list<string> String_statuspass=new list<string>{'qa pass'};                                                   
                test.startTest();
        pf_Opportunitysummary.CreateAssetRecords(LIST_StringAssetids,String_statuspass);            
        test.stopTest();        
    }
    @istest static void test_CreateAssetRecords2(){ 
        order objorder=[select id,PF_Approved_Quantity__c,PF_Reject_Quantity__c from order];
        objorder.PF_Reject_Quantity__c=null;
        update objorder;
        list<asset> Objassetids=[select id,name from asset];
        
        list<string> LIST_StringAssetids=new list<string>{(string)Objassetids[0].id};
            list<string> String_statuspass=new list<string>{'qa fail'};                                                   
                test.startTest();
        pf_Opportunitysummary.CreateAssetRecords(LIST_StringAssetids,String_statuspass);            
        test.stopTest();        
    }
    @istest static void test_retrieveProductNameRecordsInQA(){ 
        id String_Productid=[select id,name from product2].id;                                                       
        test.startTest();
        pf_Opportunitysummary.retrieveProductNameRecordsInQA(String_Productid);            
        test.stopTest();        
    }
    @istest static void test_fetchSearchResultsDeliveryInfo(){
        order objorder=[select id,PF_Approved_Quantity__c,PF_Reject_Quantity__c from order];
        objorder.PF_Reject_Quantity__c=20;
        objorder.PF_Approved_Quantity__c=88;
        update objorder;
        string String_ordernumber=[select id,ordernumber from order].ordernumber;
        test.startTest();
        pf_Opportunitysummary.fetchSearchResultsDeliveryInfo(String_ordernumber);
        test.stopTest();        
    }
    @istest static void test_createAsset(){
        id String_Productid=[select id,name from product2].id;  
        id String_orderid=[select id,name from order].id;  
        list<object> List_batchnumbers=new list<object>{'1'};           
            test.startTest();
        pf_Opportunitysummary.createAsset(String_Productid,List_batchnumbers,String_orderid,system.today());
        test.stopTest();        
    }
    @istest static void test_updateOrder(){
        id String_orderid=[select id,ordernumber from order].id;
        test.startTest();
        pf_Opportunitysummary.updateOrder((string)String_orderid,20);
        test.stopTest();        
    }
    @istest static void test_getRelatedFilesByRecordId(){
        id String_Quoteid=[select id from quote].id;
        test.startTest();
        pf_Opportunitysummary.getRelatedFilesByRecordId((string)String_Quoteid);
        test.stopTest();        
    }
    @istest static void test_RejectedQuoteStatusUpdation(){
        list<QuoteLineItem> list_quotelienitemlist=[select QuoteId from QuoteLineItem];
        test.startTest();
        pf_Opportunitysummary.RejectedQuoteStatusUpdation(list_quotelienitemlist);
        test.stopTest();        
    }
    @istest static void test_getSupplierNameRecords(){                   
        test.startTest();
        pf_Opportunitysummary.getSupplierNameRecords();
        test.stopTest();        
    }
     @istest static void test_CreateQuoteAndQuoteLineItems(){ 
        id String_Quoteid=[select id from quote].id;
        test.startTest();
        pf_Opportunitysummary.CreateQuoteAndQuoteLineItems(String_Quoteid);
        test.stopTest();        
    }
    @istest static void test_getPickListValuesIntoList(){         
        test.startTest();
        pf_Opportunitysummary.getPickListValuesIntoList();
        test.stopTest();        
    }
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}