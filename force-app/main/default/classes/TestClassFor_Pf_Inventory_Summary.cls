@isTest
public class TestClassFor_Pf_Inventory_Summary {
    @testsetup static void TestfetchInventory(){
        account acc = new account();
        acc.name = 'test account';
        insert acc;
        
        opportunity opp = new opportunity();
        opp.name = 'test opp';
        opp.CloseDate = system.today();
        opp.StageName = 'closed won';
        opp.AccountId = acc.id;
        insert opp;
        
        Product2 pro =new Product2();
        pro.Name='Pencil';
        insert pro;
        
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
        inv.Product__c=pro.id;
        inv.Warehouse__c=loc.id;
        insert inv;
        
        Product_Supplier__c prod = new Product_Supplier__c();
        prod.Name='Srikanth';
        prod.Account__c = acc.Id;
        prod.Product__c = pro.id;
        
        insert prod;
        
        Quote quo =New Quote();
        quo.Name='quote1';
        quo.OpportunityId=opp.Id;
        quo.Supplier_Account__c=acc.Id;
        quo.warehouse__c=loc.Id;
        quo.Status='Open';
        insert quo;
        
    }
    @isTest
    static void testapp(){
        List < Inventory__c > listinv = [select id,Threshold__c, Warehouse__r.Name, Product__r.name,Product__c,Warehouse__c, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c,defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c];
        test.startTest();
        Pf_Inventory_Summary.fetchInventory();
        test.stopTest();
    }
    @istest static void fetchOpportunity_test(){
        test.startTest();
        Pf_Inventory_Summary.fetchOpportunity();
        test.stopTest();
    }
    @istest static void getwarehousenamerecords_test(){
        test.startTest();
        Pf_Inventory_Summary.getwarehousenamerecords();
        test.stopTest();
        
    }
    @istest static void retrieveWarehouseRecords_test(){
        test.startTest();
        Pf_Inventory_Summary.retrieveWarehouseRecords('Pencil');
        test.stopTest();
        
    }
    
    @istest static void retrieveProductNameRecords_test(){
        test.startTest();
        Pf_Inventory_Summary.retrieveProductNameRecords('Pencil');
        test.stopTest();
        
    }
    
    @istest static void getProductNames_test(){
        test.startTest();
        Pf_Inventory_Summary.getProductNames('Pencil');
        test.stopTest();
        
    }
    
    @istest static void productsRecords_test(){
        test.startTest();
        Pf_Inventory_Summary.productsRecords('All',NULL);
        Pf_Inventory_Summary.productsRecords(NULL,'All');
        Pf_Inventory_Summary.productsRecords(NULL,NULL);
        Pf_Inventory_Summary.productsRecords('All','All');
        test.stopTest();
        
    }
    @istest static void getSupplierNames_test(){
        test.startTest();
        Pf_Inventory_Summary.getSupplierNames('Pencil','Miyapur','open');
        Pf_Inventory_Summary.getSupplierNames('Pencil','Miyapur','closed');
        Pf_Inventory_Summary.getSupplierNames('Pencil','Miyapur','Rejected');
        test.stopTest();
        
    }
}