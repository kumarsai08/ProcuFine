/*******************************************************************************************************
* 
* @ Name            :   PF_InventorySummary
* @ Purpose         :   This class is used for displaying data in inventory Summary componenet. 
* @ Author          :   Manogna.Koppula 
* @ Test Class Name :   Pf_TestClassFor_Pf_Inventory_Summary
*   Date            |  Developer Name               |  Version      
* ======================================================================================================
* 26-12-2022     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/



public  class PF_InventorySummary {
    /**
    * @ description  : This method is used in the inventorysummary componenet returns a list of "Inventory__c" records which executes a SOQL query to retrieve specific fields of the "Inventory__c" object where the "Product__c" and "Warehouse__c" fields are not null.
    **/
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
    /**
    * @ description   :  This method is used to show data in the inventory summary componenet and returns a list of "Opportunity" records without any filtering criteria.
    **/
    @AuraEnabled
    public static List < Opportunity > fetchOpportunity() {
        return [SELECT
        name, 
        (select Product2Id FROM Opportunitylineitems) 
        FROM opportunity];   
    }
    /**
    * @ description  :   This method is used to show data in the inventory summary component and  returns the list of warehouse names.
    **/
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
    /**
    * @ description  :  This method is used to setup data for so and so purpose.
    *  @params        :   strsearchsname - To search for supplier Name. 
    **/
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
    /**
    * @ description  :  This method is used to show data in the inventory summary component and returns  a list of "Inventory__c" records based on the provided search string.
    *  @params       :   strsearchsname - Its used To search for warehouse Name in inventory summary component. 
    **/
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
    
    /**
    * @ description  :  This method is used to show data in the inventory summary component and retrieves a list of Inventory__c records based on optional search parameters for warehouse name and product name.
    *  @params        :   strsearchstatus - Its used To search for Product Name in inventory summary component.
    *  @params        :   strsearchsname - Its used To search for warehouse Name in inventory summary component. 
    **/
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
    
    /**
    * @ description  :  This method is used to show data in the Supplier Datatable component and returns a list of Inventory__c records whose associated Warehouse__c record has a name that contains the input string strwareHouseName
    *  @params        :   strwareHouseName - To search for warehouse Name. 
    **/
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
    /**
    * @ description  :  This method is used to setup data for so and so purpose.
    *  @params        :   strsearchsname - To search for supplier Name. 
    **/
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