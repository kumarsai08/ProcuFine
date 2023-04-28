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
    * @ description  : This method is used in the inventorysummary componenet which returns a list of "Inventory__c" records which executes a SOQL query to retrieve specific fields of the "Inventory__c" object where the "Product__c" and "Warehouse__c" fields are not null.
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
        List<Schema.Location> list_returnlist= [SELECT 
                                                Id,
                                                Name 
                                                FROM Location];
        for (Schema.Location objlocation : list_returnlist) {
            list_warehouselist.add(objlocation.Name);  
        }
        return list_warehouselist;         
    }

    /** 
    * @ description  :  This method   retrieves Inventory records with specific product name matching a search string
    *  @params        :   searchsname -  It is used to search for a supplier
    **/
    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String searchsname) {
        return [ SELECT 
                id, 
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
                LIKE:searchsname];
    }

    /**
    * @ description  :  This method is used to show data in the inventory summary component and returns  a list of "Inventory__c" records based on the provided search string.
    *  @params       :   searchsname - Its used To search for warehouse Name in inventory summary component. 
    **/
    @AuraEnabled
    public static List < Inventory__c > retrieveWarehouseRecords(String searchsname) {
        
        return [ SELECT 
                id,
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
                LIKE:searchsname];
    }
    
    /**
    * @ description  :  This method is used to show data in the inventory summary component and retrieves a list of Inventory__c records based on optional search parameters for warehouse name and product name.
    *  @params        :   searchstatus - Its used To search for Product Name in inventory summary component.
    *  @params        :   searchsname - Its used To search for warehouse Name in inventory summary component. 
    **/
    @AuraEnabled   
    public static List <Inventory__c> productsRecords(String searchstatus, String searchsname) {
        if(searchstatus=='All' && searchsname == NULL){
            return [ SELECT 
                        id,
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
                        LIKE:searchsname];       
        }
        else if(searchstatus=='All' && searchsname=='All') {
            
            return [ SELECT
                        id,
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
        else if(searchsname=='All' && searchstatus==NULL){
            return [ SELECT 
                        id,
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
                        LIKE:searchstatus];    
            
        }
        else {
            return [ SELECT 
                        id,
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
                        LIKE:searchstatus 
                        AND Product__r.name
                        LIKE:searchsname];      
        }
    }
    
    /**
    * @ description  :  This method is used to show data in the Supplier Datatable component and returns a list of Inventory__c records whose associated Warehouse__c record has a name that contains the input string strwareHouseName
    *  @params        :   wareHouseName - To search for warehouse Name. 
    **/
    @AuraEnabled
    public static List <Inventory__c> getProductNames(String wareHouseName) {
        return [ SELECT 
                    id,
                    Warehouse__r.Name,
                    Name,
                    Product__r.Name
                    FROM Inventory__c
                    WHERE Warehouse__r.Name
                    LIKE:wareHouseName];   
    }

    /**
    * @ description   :  This method is used to setup data for so and so purpose.
    *  @params        :    productName-To search for product
    *  @params        :    WarehouseName-To search for warehouse based on product
    *  @params        :   QuoteStatusValue-To search for quotes based upon product and warehouse
    **/
    @AuraEnabled
    public static List < Product_Supplier__c > getSupplierNames(String productName,string WarehouseName,string QuoteStatusValue ) {
        list<Quote> list_OpenQuoteSupplierList = new list<Quote>();
        if(QuoteStatusValue=='Open'){
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
                                            WHERE Product__r.Name =:productName
                                            AND warehouse__c=:WarehouseName
                                            AND Status = :QuoteStatusValue];
        }else if(QuoteStatusValue=='Closed'){
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
                                            WHERE Product__r.Name =:productName 
                                            AND warehouse__c=:WarehouseName 
                                            AND Status = :QuoteStatusValue 
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
                                            WHERE Product__r.Name =:productName
                                            AND warehouse__c=:WarehouseName
                                            AND Status = :QuoteStatusValue
                                            AND Opportunity.StageName='Closed Lost'];
        }
        list<string> list_SupplierIdsList = new list<string>();
        for (Quote objquote : list_OpenQuoteSupplierList) {
            list_SupplierIdsList.add(objquote.Supplier_Account__c);   
        }
        list<Product_Supplier__c> list_Supplier =[ SELECT 
                                                    id,
                                                    Name,
                                                    Account__r.Name,
                                                    Account__c,
                                                    Product__r.Name
                                                    FROM Product_Supplier__c
                                                    WHERE Product__r.Name 
                                                    LIKE:productName
                                                    AND Account__c IN : list_SupplierIdsList];
        return [ SELECT
                    id,
                    Name,
                    Account__r.Name,
                    Account__c,
                    Product__r.Name
                    FROM Product_Supplier__c
                    WHERE Product__r.Name
                    LIKE:productName
                    AND Account__c IN : list_SupplierIdsList];
    }
}