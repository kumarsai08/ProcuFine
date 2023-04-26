@istest
public class Pf_TestClassFor_GetSupplierDetailsClass {
    @testsetup static void data_setup(){
        Id RecordTypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Purchase Orders').getRecordTypeId();
        Id RecordTypeIdaccount = Schema.SObjectType.account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account objAccount = new account();
        objAccount.name='test account';
        objAccount.Email__c='test@gmail.com';
        objAccount.grade__c='A';
        objAccount.RecordTypeId=RecordTypeIdaccount;
        insert objAccount; 
        Product2 objProduct2=new Product2();
        objProduct2.Name='teset product';
        objProduct2.IsActive=true;
        objProduct2.Rejected_Quantity__c=23;
        objProduct2.ProductCode='001';
        objProduct2.UoM__c='20';
        insert objProduct2;
        Opportunity objOpportunity = new Opportunity
            (Name = 'teset product Miyapur',Type ='New Customer',AccountId=objAccount.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Closed won',TotalOpportunityQuantity=10,OrderNumber__c='10',Delivery_Status__c='In progress'); 
        insert objOpportunity;
        
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
        Order objorder=new Order();
        objorder.Name='test order';
        objorder.status='Order Placed';
        objorder.On_Hand_Recieved__c=2;
        objorder.OpportunityId=objOpportunity.id;
        objorder.AccountId =objAccount.Id;        
        objorder.Approved_Quantity__c=4;
        objorder.Pending_Quantityy1__c=8;
        objorder.Reject_Quantity__c=9;
        objorder.Under_QA__c=2;
        objorder.EffectiveDate=system.today();
        objorder.Pricebook2id =pricebook2idvalue;
        objorder.RecordTypeId =RecordTypeIdOrder;
        objorder.Warehouse__c=objLocation.id;
        objorder.Product__c=objProduct2.Id;
        objorder.Type='Procured';
        // orr.Quantity__c=10;
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
        objAsset.Order_Id__c=objorder.Id;
        objAsset.Status='QA In Progress'; 
        objAsset.SKU_Id__c='1';
        insert objAsset;

        Product_Supplier__c objProduct_Supplier=new Product_Supplier__c();
        objProduct_Supplier.Product__c=objProduct2.id;
        objProduct_Supplier.Name=objAccount.Name;
        objProduct_Supplier.Quantity__c=10;
        objProduct_Supplier.Account__c=objAccount.id;
        insert objProduct_Supplier;
        quote objquote=new quote();
        objquote.OpportunityId=objOpportunity.id;
        objquote.Product__c=objProduct2.id;
        objquote.Supplier_Account__c=objAccount.id;
        objquote.Name='test quote';
        objquote.supplier_Email__c=objAccount.Email__c;
        objquote.Supplier__c=objAccount.Name;
        objquote.warehouse__c=objLocation.name;
        objquote.Order_Quantity__c=10;
        objquote.Status='open';
        objquote.PriceBook2Id = pricebook2idvalue;
        insert objquote;
        QuoteLineItem objQuoteLineItem=new QuoteLineItem();
        objQuoteLineItem.Product2Id=objProduct2.Id;
        objQuoteLineItem.PriceBookentryId =objPricebookEntry.Id;
        objQuoteLineItem.QuoteId=objquote.Id;
        objQuoteLineItem.Quantity=20;
        objQuoteLineItem.UnitPrice=20;
        insert objQuoteLineItem;                
    }
    
    @istest static void test_productsuppliers(){
        id ID_prid=[select id,name from Product2].id;
        string String_Productid=(string)ID_prid;
        test.startTest();
        GetSuppleirDetails.productsuppliers(String_Productid);       
        test.stopTest();      
    }
    @istest static void test_GetSuppleirDetails(){
        id ID_psid=[select id,name from Product_Supplier__c].id;
        list<string> List_productsupplierid=new list<string>();
        List_productsupplierid.add((string)ID_psid);
        list<string> List_Orderquantity=new list<string>{'1'};
            string String_psname=[select id,name from Product_Supplier__c].name;
        list<string> List_supplierNamesList=new list<string>();
        List_supplierNamesList.add(String_psname);            
        test.startTest();
        GetSuppleirDetails.SendAnEmail(List_productsupplierid,List_Orderquantity,List_supplierNamesList,'Miyapur');       
        test.stopTest();      
    }
    @istest static void test_GetQuoteDetailsdummy(){
        
        test.startTest();
        GetSuppleirDetails.GetQuoteDetailsdummy();       
        test.stopTest();      
    }
    @istest static void test_OrderRecords(){    
        string String_suppname=[select id,name from account].name;
        string String_warname=[select id,name from Location].name;
        id ID_quoteid=[select id from quote].id;
        string String_quoteidvalue=(string)ID_quoteid;
        list<string> List_suppliername=new list<string>();
        List_suppliername.add(String_suppname);
        list<string> List_warehousename=new list<string>();
        List_warehousename.add(String_warname);
        test.startTest();
        GetSuppleirDetails.OrderRecords(List_suppliername,List_warehousename,String_quoteidvalue);
        
        test.stopTest();
    }
    
    @istest static void test_OrderRecordsDatatable(){
        string String_procure='Procured';
        test.startTest();
        GetSuppleirDetails.OrderRecordsDatatable(String_procure);
        test.stopTest();
    }
    @istest static void test_sendemailtosuppliers(){
        string String_suppname=[select id,name from account].name;
        list<string> List_suppliername=new list<string>();
        List_suppliername.add(String_suppname);        
        test.startTest();
        GetSuppleirDetails.sendemailtosuppliers(List_suppliername);
        test.stopTest();
        
    }
    
    @istest static void test_searchOrders(){
        string String_suppname=[select id,name from account].name;
        string String_ordertypename='Procured';       
        test.startTest();
        GetSuppleirDetails.searchOrders(String_suppname,String_ordertypename);      
        test.stopTest();        
    }
    @istest static void test_opprecords(){
        string String_productname='teset product';
        test.startTest();
        GetSuppleirDetails.opprecords(String_productname);
        test.stopTest();
    }
    @istest static void test_GetSupplierrDetailsfornewtable(){
        
        test.startTest();
        GetSuppleirDetails.GetSupplierrDetailsfornewtable('teset product','miyapur');
        test.stopTest();
    }
        @istest static void test_supplierSection(){
        
        test.startTest();
        GetSuppleirDetails.supplierSection('teset product');
        test.stopTest();
    }
    @istest static void test_retrieveRecords(){
        
        test.startTest();
        GetSuppleirDetails.retrieveRecords('test account','teset product');
        test.stopTest();
    }
     @istest static void test_supplierSearchFilter(){
        
        test.startTest();
        GetSuppleirDetails.supplierSearchFilter();
        test.stopTest();
    }
    @istest static void test_supplierNamesList(){
        
        test.startTest();
        GetSuppleirDetails.supplierNamesList('test account');
        test.stopTest();
    }
     @istest static void test_PFGetQuoteLineItems(){
        
        test.startTest();
        GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur','open');

        GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur','closed');
          GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur',null);
        test.stopTest();
    }
     @istest static void test_CreateQuotelineitems(){
         id ID_quotelineitemid=[select id from QuoteLineItem].id;
         string String_quotelineitemvalue=(string)ID_quotelineitemid;
         date Date_datevalue=system.today();
        
        test.startTest();
        GetSuppleirDetails.CreateQuotelineitems(String_quotelineitemvalue,10,10,10.0,'hi',Date_datevalue);
        test.stopTest();
    }
     @istest static void test_UpdateQuoteLineItemAndQuoteStatus(){
         id ID_quoteid=[select id from quote].id;
         string String_quoteidvalue=(string)ID_quoteid;
         list<quote> List_quote=[select id,status from quote];
         List_quote[0].Status='closed';
         update List_quote;         
         id ID_opportunityid=[select id from opportunity].id;
         list<string> List_oppids=new list<string>();
         List_oppids.add(ID_opportunityid);                
        test.startTest();
        GetSuppleirDetails.UpdateQuoteLineItemAndQuoteStatus(String_quoteidvalue,List_oppids);
        test.stopTest();
    }
    @istest static void test_getRelatedFilesByRecordId(){
        id ID_quoteid=[select id from quote].id;
         string String_quoteidvalue=(string)ID_quoteid;
        
        test.startTest();
        GetSuppleirDetails.getRelatedFilesByRecordId(String_quoteidvalue);
        test.stopTest();
    }
     @istest static void test_RejectedQuoteStatusUpdation(){
        list<QuoteLineItem> List_QuoteLineItemid=[select id,QuoteId from QuoteLineItem];        
        test.startTest();
        GetSuppleirDetails.RejectedQuoteStatusUpdation(List_QuoteLineItemid);
        test.stopTest();
    }
    @istest static void test_CreateQuoteAndQuoteLineItems(){
         id ID_quoteid=[select id from quote].id;
         string String_quoteidvalue=(string)ID_quoteid;       
        test.startTest();
        GetSuppleirDetails.CreateQuoteAndQuoteLineItems(String_quoteidvalue);
        test.stopTest();
    }
        @istest static void test_get(){
         id ID_quoteid=[select id from quote].id;
         string String_quoteidvalue=(string)ID_quoteid;       
        test.startTest();
        GetSuppleirDetails.get(String_quoteidvalue);
        test.stopTest();
        }
    @istest static void test_GetAssetRecordsFromProduct(){
         id ID_productid=[select id from product2].id;
         string String_productidvalue=(string)ID_productid;       
        test.startTest();
        GetSuppleirDetails.GetAssetRecordsFromProduct(String_productidvalue);
        test.stopTest();
        }
    
    @istest static void test_GetProductIdFromOppProductUsingOpportunity(){
         id ID_oppid=[select id from opportunity].id;
         string Stringoppidvalue=(string)ID_oppid;       
        test.startTest();
        GetSuppleirDetails.GetProductIdFromOppProductUsingOpportunity(Stringoppidvalue);
        test.stopTest();
        }

    
    
    
}