public  class PF_InventorySummary {
    @AuraEnabled
    public static List < Inventory__c > fetchInventory() {

            return [  select id,Threshold__c, Warehouse__r.Name, Product__r.name,Product__c,Warehouse__c, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c,defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c WHERE Product__c!=null AND  Warehouse__c != null ];
       
    }
    
    @AuraEnabled
    public static List<Opportunity> fetchOpportunity() {
        return [select name, (select Product2Id from Opportunitylineitems) from opportunity];   
    }

    @AuraEnabled
    public static List<string> getwarehousenamerecords() {
         List<string> warehouselist=new List<string>();
         List<Schema.Location> returnlist=[Select Id,Name From Location];
        for (Schema.Location loc : returnlist) {
            warehouselist.add(loc.Name);  
        }
        return warehouselist;     

    }

    @AuraEnabled
     public static List < Inventory__c > retrieveProductNameRecords(String searchsname) {
    return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c,defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c where Product__r.name LIKE:searchsname];
    }
    
    @AuraEnabled
    public static List < Inventory__c > retrieveWarehouseRecords(String searchsname) {
     
    return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c where Warehouse__r.Name LIKE:searchsname];
    }
    

    @AuraEnabled   
    public static List < Inventory__c > productsRecords(String searchstatus, String searchsname) {
        if(searchstatus=='All'){
            return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c where Product__r.name LIKE:searchsname];       
        }
 
            else if (searchstatus=='All' && searchsname=='All') {

                return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c];

            }
            else if(searchsname=='All'){
                return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c where Warehouse__r.Name LIKE:searchstatus ];    

    }else {
        return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c from Inventory__c where Warehouse__r.Name LIKE:searchstatus AND Product__r.name LIKE:searchsname];    

    }
}

@AuraEnabled
    public static List < Inventory__c > getProductNames(String wareHouseName) {

            return [ select id,Warehouse__r.Name,Name, Product__r.Name from Inventory__c WHERE Warehouse__r.Name LIKE:wareHouseName];
       
    }

    @AuraEnabled
    public static List < Product_Supplier__c > getSupplierNames(String productName,string WarehouseName,string QuoteStatusValue ) {
        system.debug('prod'+productName);
        system.debug('ware'+WarehouseName);
        list<Quote> OpenQuoteSupplierList = new list<Quote>();
        if(QuoteStatusValue=='Open'){
        OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,Supplier_Account__c,Product__r.Name,warehouse__c,Status FROM Quote WHERE Product__r.Name =:productName AND warehouse__c=:WarehouseName AND Status = :QuoteStatusValue];
        }else if(QuoteStatusValue=='Closed'){
            //OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,Supplier_Account__c,Product__r.Name,warehouse__c,Status FROM Quote WHERE Product__r.Name =:productName AND warehouse__c=:WarehouseName AND Status = :QuoteStatusValue ];
            OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,Supplier_Account__c,Product__r.Name,warehouse__c,Status,Opportunity.StageName FROM Quote WHERE Product__r.Name =:productName AND warehouse__c=:WarehouseName AND Status = :QuoteStatusValue AND Opportunity.StageName='Closed Won'];

        }else {
    
            OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,Supplier_Account__c,Product__r.Name,warehouse__c,Status,Opportunity.StageName FROM Quote WHERE Product__r.Name =:productName AND warehouse__c=:WarehouseName AND Status = :QuoteStatusValue AND Opportunity.StageName='Closed Lost'];

        }
        system.debug('line 67'+OpenQuoteSupplierList);
        list<string> SupplierIdsList = new list<string>();
        for (Quote q : OpenQuoteSupplierList) {
            system.debug('line 70'+q.Supplier_Account__c);
            SupplierIdsList.add(q.Supplier_Account__c);
            
        }
        system.debug('line 74'+SupplierIdsList);
        list<Product_Supplier__c> pslist=[ select id,Name, Account__r.Name,Account__c,Product__r.Name from Product_Supplier__c WHERE Product__r.Name LIKE:productName AND Account__c IN : SupplierIdsList  ];

         system.debug('line 75'+ pslist);
        return [ select id,Name, Account__r.Name,Account__c,Product__r.Name from Product_Supplier__c WHERE Product__r.Name LIKE:productName AND Account__c IN : SupplierIdsList  ];
       
    }
}