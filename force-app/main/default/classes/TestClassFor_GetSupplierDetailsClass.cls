@istest
public class TestClassFor_GetSupplierDetailsClass {
    @testsetup static void data_setup(){
        Id RecordTypeIdOrder = Schema.SObjectType.order.getRecordTypeInfosByName().get('Purchase Orders').getRecordTypeId();
        Id RecordTypeIdaccount = Schema.SObjectType.account.getRecordTypeInfosByName().get('Supplier').getRecordTypeId();
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account acc = new account();
        acc.name='test account';
        acc.Email__c='test@gmail.com';
        acc.grade__c='A';
        acc.RecordTypeId=RecordTypeIdaccount;
        insert acc; 
        Product2 pr=new Product2();
        pr.Name='teset product';
        pr.IsActive=true;
        pr.Rejected_Quantity__c=23;
        pr.ProductCode='001';
        pr.UoM__c='20';
        insert pr;
        Opportunity opp = new Opportunity
            (Name = 'teset product Miyapur',Type ='New Customer',AccountId=acc.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Closed won',TotalOpportunityQuantity=10,OrderNumber__c='10',Delivery_Status__c='In progress'); 
        insert opp;
        
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
        orr.Type='Procured';
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
         // OpportunityLineItem    oli = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, PricebookEntryId = pbe.id, totalPrice = 200);
       //insert oli;

        Product_Supplier__c ps=new Product_Supplier__c();
        ps.Product__c=pr.id;
        ps.Name=acc.Name;
        ps.Quantity__c=10;
        ps.Account__c=acc.id;
        insert ps;
        quote qt=new quote();
        qt.OpportunityId=opp.id;
        qt.Product__c=pr.id;
        qt.Supplier_Account__c=acc.id;
        qt.Name='test quote';
        qt.supplier_Email__c=acc.Email__c;
        qt.Supplier__c=acc.Name;
        qt.warehouse__c=loc.name;
        qt.Order_Quantity__c=10;
        qt.Status='open';
        qt.PriceBook2Id = pricebook2idvalue;
        insert qt;
        QuoteLineItem ql=new QuoteLineItem();
        ql.Product2Id=pr.Id;
        ql.PriceBookentryId =pbe.Id;
        ql.QuoteId=qt.Id;
        ql.Quantity=20;
        ql.UnitPrice=20;
        insert ql;                
    }
    
    @istest static void test_productsuppliers(){
        id prid=[select id,name from Product2].id;
        string Productid=(string)prid;
        test.startTest();
        GetSuppleirDetails.productsuppliers(Productid);       
        test.stopTest();      
    }
    @istest static void test_GetSuppleirDetails(){
        id psid=[select id,name from Product_Supplier__c].id;
        list<string> productsupplierid=new list<string>();
        productsupplierid.add((string)psid);
        list<string> Orderquantity=new list<string>{'1'};
            string psname=[select id,name from Product_Supplier__c].name;
        list<string> supplierNamesList=new list<string>();
        supplierNamesList.add(psname);            
        test.startTest();
        GetSuppleirDetails.SendAnEmail(productsupplierid,Orderquantity,supplierNamesList,'Miyapur');       
        test.stopTest();      
    }
    @istest static void test_GetQuoteDetailsdummy(){
        
        test.startTest();
        GetSuppleirDetails.GetQuoteDetailsdummy();       
        test.stopTest();      
    }
    @istest static void test_OrderRecords(){    
        string suppname=[select id,name from account].name;
        string warname=[select id,name from Location].name;
        id quoteid=[select id from quote].id;
        string quoteidvalue=(string)quoteid;
        list<string> suppliername=new list<string>();
        suppliername.add(suppname);
        list<string> warehousename=new list<string>();
        warehousename.add(warname);
        test.startTest();
        GetSuppleirDetails.OrderRecords(suppliername,warehousename,quoteid);
        
        test.stopTest();
    }
    
    @istest static void test_OrderRecordsDatatable(){
        string procure='Procured';
        test.startTest();
        GetSuppleirDetails.OrderRecordsDatatable(procure);
        test.stopTest();
    }
    @istest static void test_sendemailtosuppliers(){
        string suppname=[select id,name from account].name;
        list<string> suppliername=new list<string>();
        suppliername.add(suppname);        
        test.startTest();
        GetSuppleirDetails.sendemailtosuppliers(suppliername);
        test.stopTest();
        
    }
    
    @istest static void test_searchOrders(){
        string suppname=[select id,name from account].name;
        string ordertypename='Procured';       
        test.startTest();
        GetSuppleirDetails.searchOrders(suppname,ordertypename);      
        test.stopTest();        
    }
    @istest static void test_opprecords(){
        string productname='teset product';
        test.startTest();
        GetSuppleirDetails.opprecords(productname);
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
         id quotelineitemid=[select id from QuoteLineItem].id;
         string quotelineitemvalue=(string)quotelineitemid;
         date datevalue=system.today();
        
        test.startTest();
        GetSuppleirDetails.CreateQuotelineitems(quotelineitemvalue,10,10,10.0,'hi',datevalue);
        test.stopTest();
    }
     @istest static void test_UpdateQuoteLineItemAndQuoteStatus(){
         id quoteid=[select id from quote].id;
         string quoteidvalue=(string)quoteid;
         list<quote> qt=[select id,status from quote];
         qt[0].Status='closed';
         update qt;         
         id opportunityid=[select id from opportunity].id;
         list<string> oppids=new list<string>();
         oppids.add(opportunityid);                
        test.startTest();
        GetSuppleirDetails.UpdateQuoteLineItemAndQuoteStatus(quoteidvalue,oppids);
        test.stopTest();
    }
    @istest static void test_getRelatedFilesByRecordId(){
        id quoteid=[select id from quote].id;
         string quoteidvalue=(string)quoteid;
        
        test.startTest();
        GetSuppleirDetails.getRelatedFilesByRecordId(quoteidvalue);
        test.stopTest();
    }
     @istest static void test_RejectedQuoteStatusUpdation(){
        list<QuoteLineItem> QuoteLineItemid=[select id,QuoteId from QuoteLineItem];        
        test.startTest();
        GetSuppleirDetails.RejectedQuoteStatusUpdation(QuoteLineItemid);
        test.stopTest();
    }
    @istest static void test_CreateQuoteAndQuoteLineItems(){
         id quoteid=[select id from quote].id;
         string quoteidvalue=(string)quoteid;       
        test.startTest();
        GetSuppleirDetails.CreateQuoteAndQuoteLineItems(quoteidvalue);
        test.stopTest();
    }
        @istest static void test_get(){
         id quoteid=[select id from quote].id;
         string quoteidvalue=(string)quoteid;       
        test.startTest();
        GetSuppleirDetails.get(quoteidvalue);
        test.stopTest();
        }
    @istest static void test_GetAssetRecordsFromProduct(){
         id productid=[select id from product2].id;
         string productidvalue=(string)productid;       
        test.startTest();
        GetSuppleirDetails.GetAssetRecordsFromProduct(productidvalue);
        test.stopTest();
        }
    
    @istest static void test_GetProductIdFromOppProductUsingOpportunity(){
         id oppid=[select id from opportunity].id;
         string oppidvalue=(string)oppid;       
        test.startTest();
        GetSuppleirDetails.GetProductIdFromOppProductUsingOpportunity(oppidvalue);
        test.stopTest();
        }

    
    
    
}