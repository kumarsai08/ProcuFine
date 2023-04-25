/*******************************************************************************************************
* 
* @ Name            :   PF_WorkflowListviewController
* @ Purpose         :   This class is used for displaying data in inventorySummary componenet. 
* @ Author          :   Shammel Ahmed 
* @ Usage           :   1) For displaying workflow list on the workflow page according to the user
*                       2) For creating a request from the workflow page onclick of execute
* @ Test Class Name :   PF_WorkflowListviewControllerTest
*
*   Date            |  Developer Name               |  Version      |  Changes
* ======================================================================================================
*   30-10-2018      |  shameel.ahmed@absyz.com      |  1.0          |  Initial Version
*   05-11-2018      |  deeksha.suvarna@absyz.com    |  1.1          |  Added Profile Categorization Logic.
*
*******************************************************************************************************/



public  class PF_InventorySummary {
    @AuraEnabled
    public static List < Inventory__c > fetchInventory() {
        return [SELECT
        id,
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
        FROM Inventory__c 
        WHERE Product__c!=null 
        AND  Warehouse__c != null];
        
    }
    
    @AuraEnabled
    public static List < Opportunity > fetchOpportunity() {
        return [SELECT
        name, 
        (select Product2Id FROM Opportunitylineitems) 
        FROM opportunity];   
    }
    
    @AuraEnabled
    public static List<string> getwarehousenamerecords() {
        List<string> list_warehouselist=new List<string>();
        List<Schema.Location> list_returnlist=[SELECT 
        Id,
        Name 
        FROM Location];
        for (Schema.Location objlocation : list_returnlist) {
            list_warehouselist.add(objlocation.Name);  
        }
        return list_warehouselist;     
        
    }
    
    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String strsearchsname) {
        return [ SELECT id, 
        Warehouse__r.Name,
        Product__r.name,
        Quantity__c,
        Exsisting_Stock_On_Hand__c,
        On_Order__c,
        defective_quantity__c,
        Order__c,
        Under_QA_Num__c, 
        Shortfall__c
        FROM Inventory__c
        where Product__r.name 
        LIKE:strsearchsname];
    }
    
    @AuraEnabled
    public static List < Inventory__c > retrieveWarehouseRecords(String strsearchsname) {
        
        return [ SELECT id,
        Warehouse__r.Name,
        Product__r.name,
        Quantity__c,
        Exsisting_Stock_On_Hand__c,
        On_Order__c,
        defective_quantity__c,
        Order__c,
        Under_QA_Num__c, 
        Shortfall__c 
        FROM Inventory__c
        WHERE Warehouse__r.Name 
        LIKE:strsearchsname];
    }
    
    
    @AuraEnabled   
    public static List <Inventory__c> productsRecords(String strsearchstatus, String strsearchsname) {
        if(strsearchstatus=='All' && strsearchsname == NULL){
            return [ SELECT id,
            Warehouse__r.Name,
            Product__r.name, 
            Quantity__c, 
            Exsisting_Stock_On_Hand__c,
            On_Order__c,
            defective_quantity__c,
            Order__c, 
            Under_QA_Num__c, 
            Shortfall__c 
            FROM Inventory__c
            where Product__r.name
            LIKE:strsearchsname];       
        }
        else if(strsearchstatus=='All' && strsearchsname=='All') {
            
            return [ SELECT id,
            Warehouse__r.Name,
            Product__r.name, 
            Quantity__c,
            Exsisting_Stock_On_Hand__c, 
            On_Order__c,
            defective_quantity__c,
            Order__c, 
            Under_QA_Num__c,
            Shortfall__c
            FROM Inventory__c];
            
        }
        else if(strsearchsname=='All' && strsearchstatus==NULL){
            return [ SELECT id,
            Warehouse__r.Name,
            Product__r.name,
            Quantity__c,
            Exsisting_Stock_On_Hand__c,
            On_Order__c,
            defective_quantity__c,
            Order__c, 
            Under_QA_Num__c,
            Shortfall__c
            FROM Inventory__c 
            WHERE Warehouse__r.Name 
            LIKE:strsearchstatus];    
            
        }
        else {
            return [ SELECT id,
            Warehouse__r.Name,
            Product__r.name, 
            Quantity__c,
            Exsisting_Stock_On_Hand__c, 
            On_Order__c,
            defective_quantity__c,
            Order__c, 
            Under_QA_Num__c,
            Shortfall__c 
            FROM Inventory__c 
            WHERE Warehouse__r.Name 
            LIKE:strsearchstatus 
            AND Product__r.name
            LIKE:strsearchsname];    
            
        }
    }

    
    @AuraEnabled
    public static List <Inventory__c> getProductNames(String strwareHouseName) {
        
        return [ SELECT id,
        Warehouse__r.Name,
        Name,
        Product__r.Name
        FROM Inventory__c
        WHERE Warehouse__r.Name
        LIKE:strwareHouseName];
        
    }
    
    @AuraEnabled
    public static List < Product_Supplier__c > getSupplierNames(String strproductName,string strWarehouseName,string strQuoteStatusValue ) {
        system.debug('prod'+strproductName);
        system.debug('ware'+strWarehouseName);
        list<Quote> list_OpenQuoteSupplierList = new list<Quote>();
        if(strQuoteStatusValue=='Open'){
            list_OpenQuoteSupplierList = [SELECT 
            Id,
            Name,
            AccountId,
            QuoteNumber,
            Supplier_Account__c,
            Product__r.Name,
            warehouse__c,
            Status
            FROM Quote 
            WHERE Product__r.Name =:strproductName
            AND warehouse__c=:strWarehouseName
            AND Status = :strQuoteStatusValue];
        }else if(strQuoteStatusValue=='Closed'){
            list_OpenQuoteSupplierList = [SELECT 
            Id,
            Name,
            AccountId,
            QuoteNumber,
            Supplier_Account__c,
            Product__r.Name,
            warehouse__c,
            Status,
            Opportunity.StageName
            FROM Quote
            WHERE Product__r.Name =:strproductName 
            AND warehouse__c=:strWarehouseName 
            AND Status = :strQuoteStatusValue 
            AND Opportunity.StageName='Closed Won'];
            
        }else {
            list_OpenQuoteSupplierList = [SELECT 
            Id,
            Name,
            AccountId,
            QuoteNumber,
            Supplier_Account__c,
            Product__r.Name,
            warehouse__c,
            Status,
            Opportunity.StageName
            FROM Quote 
            WHERE Product__r.Name =:strproductName
            AND warehouse__c=:strWarehouseName
            AND Status = :strQuoteStatusValue
            AND Opportunity.StageName='Closed Lost'];
            
        }
        system.debug('line 67'+list_OpenQuoteSupplierList);
        list<string> list_SupplierIdsList = new list<string>();
        for (Quote objquote : list_OpenQuoteSupplierList) {
            system.debug('line 70'+objquote.Supplier_Account__c);
            list_SupplierIdsList.add(objquote.Supplier_Account__c);
            
        }
        system.debug('line 74'+list_SupplierIdsList);
        list<Product_Supplier__c> list_Supplier =[ SELECT id,
        Name,
        Account__r.Name,
        Account__c,
        Product__r.Name
        FROM Product_Supplier__c
        WHERE Product__r.Name 
        LIKE:strproductName
        AND Account__c IN : list_SupplierIdsList];
        return [ SELECT
        id,
        Name,
        Account__r.Name,
        Account__c,
        Product__r.Name
        FROM Product_Supplier__c
        WHERE Product__r.Name
        LIKE:strproductName
        AND Account__c IN : list_SupplierIdsList];
        
    }
}