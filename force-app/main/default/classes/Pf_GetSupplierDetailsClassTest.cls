@istest
public class Pf_GetSupplierDetailsClassTest {
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
        id ID_prid=[select id,
                    name 
                    from Product2].id;
        string StrProductid=(string)ID_prid;
        test.startTest();
        PF_GetSuppleirDetails.productsuppliers(StrProductid);       
        test.stopTest();      
    }
    @istest static void test_GetSuppleirDetails(){
        id ID_psid=[select id,
                    name 
                    from Product_Supplier__c].id;
        list<string> List_productsupplierid=new list<string>();
        List_productsupplierid.add((string)ID_psid);
        list<string> List_Orderquantity=new list<string>{'1'};
            string Strpsname=[select id,name from Product_Supplier__c].name;
        list<string> List_supplierNamesList=new list<string>();
        List_supplierNamesList.add(Strpsname);            
        test.startTest();
        PF_GetSuppleirDetails.SendAnEmail(List_productsupplierid,List_Orderquantity,List_supplierNamesList,'Miyapur');       
        test.stopTest();      
    }
    @istest static void test_GetQuoteDetailsdummy(){
        
        test.startTest();
        PF_GetSuppleirDetails.GetQuoteDetailsdummy();       
        test.stopTest();      
    }
    @istest static void test_OrderRecords(){    
        string Strsuppname=[select id,
                                name from account].name;
        string Strwarname=[select id,
                               name from Location].name;
        id ID_quoteid=[select id from quote].id;
        string Strquoteidvalue=(string)ID_quoteid;
        list<string> List_suppliername=new list<string>();
        List_suppliername.add(Strsuppname);
        list<string> List_warehousename=new list<string>();
        List_warehousename.add(Strwarname);
        test.startTest();
        PF_GetSuppleirDetails.OrderRecords(List_suppliername,List_warehousename,Strquoteidvalue);
        
        test.stopTest();
    }
    
    @istest static void test_OrderRecordsDatatable(){
        string Strprocure='Procured';
        test.startTest();
        PF_GetSuppleirDetails.OrderRecordsDatatable(Strprocure);
        test.stopTest();
    }
    @istest static void test_sendemailtosuppliers(){
        string Strsuppname=[select id,name from account].name;
        list<string> List_suppliername=new list<string>();
        List_suppliername.add(Strsuppname);        
        test.startTest();
        PF_GetSuppleirDetails.sendemailtosuppliers(List_suppliername);
        test.stopTest();
        
    }
    
    @istest static void test_searchOrders(){
        string Strsuppname=[select id,name from account].name;
        string Strordertypename='Procured';       
        test.startTest();
        PF_GetSuppleirDetails.searchOrders(Strsuppname,Strordertypename);      
        test.stopTest();        
    }
    @istest static void test_opprecords(){
        string Strproductname='teset product';
        test.startTest();
        PF_GetSuppleirDetails.opprecords(Strproductname);
        test.stopTest();
    }
    @istest static void test_GetSupplierrDetailsfornewtable(){
        
        test.startTest();
        PF_GetSuppleirDetails.GetSupplierrDetailsfornewtable('teset product','miyapur');
        test.stopTest();
    }
        @istest static void test_supplierSection(){
        
        test.startTest();
        PF_GetSuppleirDetails.supplierSection('teset product');
        test.stopTest();
    }
    @istest static void test_retrieveRecords(){
        
        test.startTest();
        PF_GetSuppleirDetails.retrieveRecords('test account','teset product');
        test.stopTest();
    }
     @istest static void test_supplierSearchFilter(){
        
        test.startTest();
        PF_GetSuppleirDetails.supplierSearchFilter();
        test.stopTest();
    }
    @istest static void test_supplierNamesList(){
        
        test.startTest();
        PF_GetSuppleirDetails.supplierNamesList('test account');
        test.stopTest();
    }
     @istest static void test_PFGetQuoteLineItems(){
        
        test.startTest();
        PF_GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur','open');

        PF_GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur','closed');
          PF_GetSuppleirDetails.PFGetQuoteLineItems('teset product','test account','miyapur',null);
        test.stopTest();
    }
     @istest static void test_CreateQuotelineitems(){
         id ID_quotelineitemid=[select id from QuoteLineItem].id;
         string Strquotelineitemvalue=(string)ID_quotelineitemid;
         date Date_datevalue=system.today();
        
        test.startTest();
        PF_GetSuppleirDetails.CreateQuotelineitems(Strquotelineitemvalue,10,10,10.0,'hi',Date_datevalue);
        test.stopTest();
    }
     @istest static void test_UpdateQuoteLineItemAndQuoteStatus(){
         id ID_quoteid=[select id from quote].id;
         string Strquoteidvalue=(string)ID_quoteid;
         list<quote> List_quote=[select id,
                                 status
                                 from quote];
         List_quote[0].Status='closed';
         update List_quote;         
         id ID_opportunityid=[select id 
                              from opportunity].id;
         list<string> List_oppids=new list<string>();
         List_oppids.add(ID_opportunityid);                
        test.startTest();
        PF_GetSuppleirDetails.UpdateQuoteLineItemAndQuoteStatus(Strquoteidvalue,List_oppids);
        test.stopTest();
    }
    @istest static void test_getRelatedFilesByRecordId(){
        id ID_quoteid=[select id
                       from quote].id;
         string Strquoteidvalue=(string)ID_quoteid;
        
        test.startTest();
        PF_GetSuppleirDetails.getRelatedFilesByRecordId(Strquoteidvalue);
        test.stopTest();
    }
     @istest static void test_RejectedQuoteStatusUpdation(){
        list<QuoteLineItem> List_QuoteLineItemid=[select id,
                                                  QuoteId 
                                                  from QuoteLineItem];        
        test.startTest();
        PF_GetSuppleirDetails.RejectedQuoteStatusUpdation(List_QuoteLineItemid);
        test.stopTest();
    }
    @istest static void test_CreateQuoteAndQuoteLineItems(){
         id ID_quoteid=[select id from quote].id;
         string Strquoteidvalue=(string)ID_quoteid;       
        test.startTest();
        PF_GetSuppleirDetails.CreateQuoteAndQuoteLineItems(Strquoteidvalue);
        test.stopTest();
    }
        @istest static void test_get(){
         id ID_quoteid=[select id
                        from quote].id;
         string Strquoteidvalue=(string)ID_quoteid;       
        test.startTest();
        PF_GetSuppleirDetails.get(Strquoteidvalue);
        test.stopTest();
        }
    @istest static void test_GetAssetRecordsFromProduct(){
         id ID_productid=[select id 
                          from product2].id;
         string Strproductidvalue=(string)ID_productid;       
        test.startTest();
        PF_GetSuppleirDetails.GetAssetRecordsFromProduct(Strproductidvalue);
        test.stopTest();
        }
    
    @istest static void test_GetProductIdFromOppProductUsingOpportunity(){
         id ID_oppid=[select id 
                      from opportunity].id;
         string Stroppidvalue=(string)ID_oppid;       
        test.startTest();
        PF_GetSuppleirDetails.GetProductIdFromOppProductUsingOpportunity(Stroppidvalue);
        test.stopTest();
        }

    
    
    
}