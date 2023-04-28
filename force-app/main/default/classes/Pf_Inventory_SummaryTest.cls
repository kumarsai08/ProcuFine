@isTest
public class Pf_Inventory_SummaryTest {
    @testsetup static void TestfetchInventory(){
        account objAccount = new account();
        objAccount.name = 'test account';
        insert objAccount;
        
        opportunity objopportunity = new opportunity();
        objopportunity.name = 'test opp';
        objopportunity.CloseDate = system.today();
        objopportunity.StageName = 'closed won';
        objopportunity.AccountId = objAccount.id;
        insert objopportunity;
        
        Product2 objProduct2 =new Product2();
        objProduct2.Name='Pencil';
        insert objProduct2;
        
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
        
        Product_Supplier__c obj_Product_Supplier = new Product_Supplier__c();
        obj_Product_Supplier.Name='Srikanth';
        obj_Product_Supplier.Account__c = objAccount.Id;
        obj_Product_Supplier.Product__c = objProduct2.id;
        
        insert obj_Product_Supplier;
        
        Quote objquote =New Quote();
        objquote.Name='quote1';
        objquote.OpportunityId=objopportunity.Id;
        objquote.Supplier_Account__c=objAccount.Id;
        objquote.warehouse__c=objLocation.Id;
        objquote.Status='Open';
        insert objquote;
        
    }
    @isTest
    static void testapp(){
        List < Inventory__c > list_inv = [select id,
                                          Threshold__c,
                                          Warehouse__r.Name, 
                                          Product__r.name,
                                          Product__c,
                                          Warehouse__c, 
                                          Quantity__c,
                                          Exsisting_Stock_On_Hand__c, 
                                          On_Order__c,
                                          defective_quantity__c,
                                          Order__c, 
                                          Under_QA_Num__c, 
                                          Shortfall__c
                                          from Inventory__c];
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