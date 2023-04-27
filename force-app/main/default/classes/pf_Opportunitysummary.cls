/*******************************************************************************************************
* 
* @ Name            :   pf_Opportunitysummary
* @ Purpose         :   Controller for Workflow Listview
* @ Author          :   Kumar Sai and Manogna Koppula
* @ Usage           :   1) 
*                       2) 
* @ Test Class Name :   
*
*   Date            |  Developer Name               |  Version      |  Changes
* ======================================================================================================
*                   |  manogna.koppula@absyz.com    |  1.0          |  Initial Version
*                   |  kumarsai.vadapalli@absyz.com |
*******************************************************************************************************/
public with sharing class pf_Opportunitysummary {

    public static Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
    /**
    * @ description  :  This method retrieves the supplier details associated with a product and returns them as a map of supplier IDs to supplier names.
    *  @params       :  Productid - The parameter is used to filter the list of PF_Product_Supplier__c records to only include those that are related to a specific Product record identified by its Id.
    **/
        @AuraEnabled
        public static Map<String,String>  GetSuppleirDetails(String Productid) {
            list<PF_Product_Supplier__c> list_ProductSupplier= [SELECT 
                                                                Supplier_Name__c,
                                                                Supplier_Name__r.Name 
                                                                FROM PF_Product_Supplier__c 
                                                                WHERE Product__r.id=:Productid];
            Map<String,String> map_NamesList = new  Map<String,String> ();
            for (PF_Product_Supplier__c objProductSupplier : list_ProductSupplier) {
                map_NamesList.put(objProductSupplier.Supplier_Name__c,objProductSupplier.Supplier_Name__r.Name);
            }
            return map_NamesList;
        }

    /**
    * @ description  :  This method returns a list of Order records with specific fields and conditions to display in a Lightning component.
    **/
        @AuraEnabled
        public static List < Order > fetchOrderProduct() { 
            // Query all orders that do not have a status of "Fully Received Under QA" 
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   PF_Product__c,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status,
                   RecordType.Name 
                   FROM Order 
                   WHERE Order.Status!='Fully Received Under QA' 
                   ORDER BY OrderNumber ASC];
        }

    /**
    * @ description  :  This method returns a list of Opportunity records with specific fields queried, which can be used in other parts of the application.
    **/
        @AuraEnabled
        public static List < Opportunity > pf_OpportunityQuantity() {
                return [SELECT 
                        Id,
                        name,
                        CloseDate,
                        PF_Opportunity_Quantity__c,
                        StageName 
                        FROM Opportunity ];   
        }

    /**
    * @ description  :  This method retrieves a list of closed won Opportunities with their relevant details, which can be used to display data in a tabular format.
    **/
        @AuraEnabled
        public static List < Opportunity > pf_OpportunityQuantitytab() {
                return [SELECT 
                        Id,
                        name,
                        CloseDate,
                        PF_Opportunity_Quantity__c,
                        StageName 
                        FROM Opportunity 
                        WHERE StageName='closed won'];   
        }

    /**
    * @ description  :  This method is used to filter and return a list of Order records based on the input search status, where the search status could be "All" or a specific status.
    *  @params       :  searchstatus - The parameter in the code is used to filter the search results based on the order status.
    **/
        @AuraEnabled    
        public static List < Order > orderStatusFilter(String searchstatus) {
            if(searchstatus=='All'){
                return[SELECT 
                       Id,
                       PF_Product__r.Name,
                       OrderNumber,
                       Account.Name,
                       EffectiveDate,
                       Quantity__c,
                       Received_Quantity__c,
                       PF_Pending_Quantity__c,
                       PF_Under_QA__c,
                       Status 
                       FROM Order];    
            }
            else{
                return[SELECT 
                       Id,
                       PF_Product__r.Name,
                       OrderNumber,
                       Account.Name,
                       EffectiveDate,
                       Quantity__c,
                       Received_Quantity__c,
                       PF_Pending_Quantity__c,
                       PF_Under_QA__c,
                       Status 
                       FROM Order 
                       WHERE Status 
                       LIKE:searchstatus];    
            }
        }    

    /**
    * @ description  :  This method is used to filter Order records based on the values of two search parameters - searchstatus and searchsname.
    *  @params       :  The parameters searchstatus and searchsname are used to filter the records based on the user's search criteria for the order status and product name respectively.
    **/
        @AuraEnabled   
        public static List < Order > orderStatusRecords(String searchstatus, String searchsname) {
            if(searchstatus=='All'){
                return[SELECT 
                       ID,
                       PF_Product__r.Name,
                       OrderNumber,
                       Account.Name,
                       EffectiveDate,
                       Quantity__c,
                       Received_Quantity__c,
                       PF_Pending_Quantity__c,
                       PF_Under_QA__c,
                       Status 
                       FROM Order 
                       WHERE PF_Product__r.Name 
                       LIKE:searchsname];        
            }

            else if(searchstatus=='All' && searchsname=='All') {
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order];
            }
            else if(searchsname=='All'){
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE Status 
                   LIKE:searchstatus ];    
    
            }
            else {
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE Status 
                   LIKE:searchstatus 
                   AND PF_Product__r.Name 
                   LIKE:searchsname];    
            }
        }

    /**
    * @ description  :  This code returns the details of a product based on the product name provided as a parameter.
    *  @params       :  The parameter is used as a input to filter the query results and retrieve the details of a specific product with the matching Name.
    **/        
        @AuraEnabled
        public static list<Product2> GetSupplierrDetailsfornewtable(String pname){
            string apname=pname;
            return [SELECT 
                    Id,
                    Name,
                    PF_UOM__c,
                    Quantity__c,
                    PF_On_Order__c,
                    PF_Orders_Received__c,
                    PF_Under_QA__c,
                    PF_Defective_Quantity__c 
                    FROM Product2 
                    WHERE Name =: pname];   
        }

    /**
    * @ description  :  This method is used to fetch a list of records of PF_Product_Supplier__c that have a specific product name (pnamee) as a reference field value.
    *  @params       :  The parameter is used to filter the records based on the related Product__r.name field. Only records with a matching Product__r.name value will be returned.
    **/
        @AuraEnabled(cacheable=true)
        public static List < PF_Product_Supplier__c> supplierSection(String pnamee) {
            return[SELECT 
                   Id,
                   Name,
                   Product__r.name,
                   Supplier_Name__r.Name,
                   Supplier_Name__r.grade__c,
                   Quantity__c 
                   FROM PF_Product_Supplier__c 
                   WHERE Product__r.name=:pnamee ];
        }

    /**
    * @ description  :  This method is used to retrieve a list of Order records that match a search key in the OrderNumber field.
    *  @params       :  The parameter is used to pass a search keyword that is used to filter the records based on the OrderNumber field. The records returned will only include Order records whose OrderNumber field contains the searchKey as a substring.
    **/
        @AuraEnabled   
        public static List<Order> getOrderId(String searchKey) {
            String key = '%' + searchKey + '%'; 
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE OrderNumber 
                   LIKE :key];
        }

    /**
    * @ description  :  This method is used to retrieve a list of Order records based on a search for the name of a specific Account in the Account.Name field.
    *  @params       :  The parameter is used to search for orders based on the name of the supplier.
    **/
        @AuraEnabled   
        public static List<Order> getSupplierDetails(String searchSupplier) {
            String key = '%' + searchSupplier + '%'; 
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE Account.Name 
                   LIKE :key];
        }    

    /**
    * @ description  :  This method is used to retrieve and return a list of all supplier names from the "Account" object where the record type is "Supplier".
    **/
        @AuraEnabled
        public static List<String> supplierSearchFilter(){
            List<Account> list_SupplierNamesList = [SELECT Id,
                                                           Name,
                                                           RecordType.Name,
                                                           grade__c 
                                                           FROM Account 
                                                           WHERE RecordType.Name = 'Supplier'];
            list<String> list_Supplierslist = new list<String>();
                for (Account objSupplier : list_SupplierNamesList){
                    list_Supplierslist.add(objSupplier.Name);
                }
        return list_Supplierslist;
        }
    
    /**
    * @ description  :  This method is used to get the list of supplier names for a given product name by querying the PF_Product_Supplier__c object.
    *  @params       :  The parameter is used to filter the query results based on the name of a product.
    **/
        @AuraEnabled
        public static List <String> supplierNamesList(String pnamee) {
        list<PF_Product_Supplier__c> list_ProductSuppliers=[SELECT 
                                                            Id,
                                                            Name, 
                                                            Product__r.name,
                                                            Supplier_Name__r.Name  
                                                            FROM PF_Product_Supplier__c  
                                                            WHERE Product__r.name=:pnamee ];
        List<string> list_SupplierNames = new List<string>();
            for (PF_Product_Supplier__c objProductSupplier : list_ProductSuppliers) {
                list_SupplierNames.add(objProductSupplier.Supplier_Name__r.Name);
            }
        return list_SupplierNames;
        }

    /**
    * @ description  :  This method is used to retrieve records from the PF_Product_Supplier__c object based on the specified product name and supplier name search criteria.
    *  @params       :  The parameter 'searchsname' is used to filter the PF_Product_Supplier__c records by the supplier name matching the search criteria, while the parameter 'pnamee' is used to filter the records by the product name.
    **/
        @AuraEnabled
        public static List < PF_Product_Supplier__c> retrieveRecords(String searchsname ,String pnamee ) {
            return[SELECT 
                   Id,
                   Name,
                   Product__r.name,
                   Supplier_Name__r.Name 
                   FROM PF_Product_Supplier__c 
                   WHERE Product__r.name=:pnamee  
                   AND Supplier_Name__r.Name 
                   LIKE :searchsname];
        }

    /**
    * @ description  :  The method is used to create and revise quotes for a product with multiple suppliers based on the quantity requested from each supplier.
    *  @params       :  This is used to provide a list of supplier IDs, order quantities, and supplier names to create and revise quotes and quote line items.
    **/
        @AuraEnabled
        public static list<Quote> ReviseButton(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList){
            system.debug('LINE 15' + supplierids);
            list<PF_Product_Supplier__c> list_ProductSuppliers=[SELECT 
                                                                Id,
                                                                Supplier_Name__c,
                                                                Supplier_Name__r.PF_Email__c,
                                                                Supplier_Name__r.Name,
                                                                Product__r.Name,
                                                                Product__c,
                                                                Product__r.ProductCode 
                                                                FROM PF_Product_Supplier__c 
                                                                WHERE Id in :supplierids ];
            String productname = list_ProductSuppliers[0].Product__r.Name;
            system.debug('line 17'+list_ProductSuppliers[0].Product__r.Name);
            string productcode= list_ProductSuppliers[0].Product__r.ProductCode;
            system.debug('line 17'+list_ProductSuppliers[0].Product__r.ProductCode);
            Map<String,String> map_SupllOrderQ = new Map<String,String>();
            List<PricebookEntry> list_PriceBookList =  [SELECT 
                                                        Id,
                                                        Product2Id,
                                                        Pricebook2Id,
                                                        UnitPrice 
                                                        FROM PricebookEntry 
                                                        WHERE Product2Id= : list_ProductSuppliers[0].Product__c LIMIT 1];
            system.debug('orderq list '+Orderquantity);
            system.debug('snames list '+supplierNamesList);
                for (Integer i = 0; i < supplierNamesList.size(); i++) {
                    system.debug('line 29 '+supplierNamesList[i]+Orderquantity[i]);
                    map_SupllOrderQ.put(supplierNamesList[i],Orderquantity[i]);           
                }
            system.debug('line 34 '+ map_SupllOrderQ);      
            Integer intNum;
            String strOppID;      
            system.debug('LINE 15' + supplierids);
            string strSupplier1= productname;
            list<Opportunity> list_Opportunitylist=[SELECT 
                                                    Id,
                                                    Name
                                                    FROM Opportunity 
                                                    WHERE Name = : strSupplier1];
            Opportunity objOpportunity = new Opportunity();
                if (list_Opportunitylist.isEmpty()) {        
                    objOpportunity.Name=productname;
                    objOpportunity.StageName='Prospecting';
                    objOpportunity.Pricebook2Id= list_PriceBookList[0].Pricebook2Id;
                    objOpportunity.CloseDate=System.today() + 90;
                    insert objOpportunity;
                    strOppID=objOpportunity.Id;           
                }else {
                    strOppID=list_Opportunitylist[0].Id;
                }
            list<Quote> list_Quoteslist= [SELECT 
                                          Id,
                                          Name,
                                          OpportunityId,
                                          Opportunity.Name 
                                          FROM Quote 
                                          WHERE OpportunityId =: strOppID];
            integer list_Size=list_Quoteslist.size();
            if(list_Quoteslist.isEmpty()){
                intNum=0;
            } 
            else {
                intNum=list_Size;          
            }
            List<String> list_Address = new List<String>();
            list<Quote> list_Quotelist = new list<Quote>();    
                for(PF_Product_Supplier__c objProSupplier :list_ProductSuppliers){
                    list_Address.add(objProSupplier.Supplier_Name__r.PF_Email__c);
                    Quote objQuote = new Quote();
                    system.debug(productcode);
                    objQuote.Name= 'QT Revised'+'-'+'{ '+productcode+' }'+ '-'+string.valueof(intNum+=1);
                    objQuote.OpportunityId= Id.valueOf(strOppID);
                    system.debug(map_SupllOrderQ.get(objProSupplier.Supplier_Name__r.Name));
                    objQuote.Pricebook2Id= list_PriceBookList[0].Pricebook2Id;          
                    objQuote.PF_Order_Quantity__c=decimal.valueOf(map_SupllOrderQ.get(objProSupplier.Supplier_Name__r.Name));
                    objQuote.PF_Supplier_Account__c = objProSupplier.Supplier_Name__c;
                    objQuote.PF_Supplier__c=objProSupplier.Supplier_Name__r.Name;
                    objQuote.Email= objProSupplier.Supplier_Name__r.PF_Email__c;
                    objQuote.Revised_Record__c='Revised';
                    objQuote.PF_Inventory_Manager__c=userinfo.getuserId();
                    objQuote.PF_Product__c=objProSupplier.Product__c;
                //  objQuote.Email_Service_Id__c='   quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
                list_Quotelist.add(objQuote);                        
                }
                insert list_Quotelist;
            System.debug('line33'+list_Address);
            System.debug('line 34'+list_Quotelist);
            List<QuoteLineItem> list_QuoteLineItem = new List<QuoteLineItem>();
            List<PricebookEntry> PriceBEntryList = [SELECT 
                                                    Id,
                                                    Product2Id,
                                                    Pricebook2Id,
                                                    UnitPrice 
                                                    FROM PricebookEntry 
                                                    WHERE Product2Id= : list_Quotelist[0].PF_Product__c LIMIT 1];
                for(Quote objQuotes :list_Quotelist){
                    QuoteLineItem objQuoteLineItems = new QuoteLineItem();
                    objQuoteLineItems.UnitPrice =0;
                    objQuoteLineItems.QuoteId = objQuotes.Id;
                    objQuoteLineItems.Quantity = objQuotes.PF_Order_Quantity__c;
                    objQuoteLineItems.Product2Id = objQuotes.PF_Product__c;
                    objQuoteLineItems.PricebookEntryId =PriceBEntryList[0].Id;
                    //objQuoteLineItems.ListPrice=PriceBEntryList[0].UnitPrice;
                list_QuoteLineItem.add(objQuoteLineItems);
                }
                if(!list_QuoteLineItem.isEmpty()){
                    insert list_QuoteLineItem;
                }
            system.debug('list_QuoteLineItem'+list_QuoteLineItem);
            return list_Quotelist;    
        }

    /**
    * @ description  :  This method takes in a list of supplier IDs, order quantities, supplier names, and a warehouse name, and returns a list of Quote records that are created based on the inputs provided.
    *  @params       :  The parameters are used to pass information into the method from the calling supplier IDs, order quantities, supplier names, and warehouse name.
    **/
        @AuraEnabled
        public static list<Quote> SendAnEmail(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList,String WarehouseName){
            system.debug('LINE 15' + supplierids);
            list<PF_Product_Supplier__c> list_ProductSupplr= [SELECT 
                                                              Id,
                                                              Supplier_Name__c,
                                                              Supplier_Name__r.PF_Email__c,
                                                              Supplier_Name__r.Name,
                                                              Product__r.Name,
                                                              Product__c,
                                                              Product__r.ProductCode 
                                                              FROM PF_Product_Supplier__c 
                                                              WHERE  Id in :supplierids ];
            String strProductName = list_ProductSupplr[0].Product__r.Name;
            system.debug('line 17'+list_ProductSupplr[0].Product__r.Name);
            string strProductCode= list_ProductSupplr[0].Product__r.ProductCode;
            system.debug('line 17'+list_ProductSupplr[0].Product__r.ProductCode);
            Map<String,String> Map_SupllOrder = new Map<String,String>();
            system.debug(WarehouseName);
            List<PricebookEntry> list_PriceBookEntry = [SELECT 
                                                        Id,
                                                        Product2Id,
                                                        Pricebook2Id,
                                                        UnitPrice 
                                                        FROM PricebookEntry 
                                                        WHERE Product2Id= : list_ProductSupplr[0].Product__c LIMIT 1];
            system.debug('orderq list '+Orderquantity);
            system.debug('snames list '+supplierNamesList);
                for (Integer i = 0; i < supplierNamesList.size(); i++) {
                    system.debug('line 29 '+supplierNamesList[i]+Orderquantity[i]);
                    Map_SupllOrder.put(supplierNamesList[i],Orderquantity[i]);           
                }
            system.debug('line 34 '+ Map_SupllOrder);      
            Integer intNumber;
            String strOpportunityID;      
            system.debug('LINE 15' + supplierids);
            string strSupplr= strProductName;
            list<Opportunity> list_Opportunity=[SELECT 
                                                Id,
                                                Name
                                                FROM Opportunity 
                                                WHERE Name = : strSupplr];
            Opportunity list_Opportunnity=new Opportunity();
                if (list_Opportunity.isEmpty()){        
                    list_Opportunnity.Name=strProductName;
                    list_Opportunnity.StageName='Prospecting';
                    list_Opportunnity.Pricebook2Id= list_PriceBookEntry[0].Pricebook2Id;
                    list_Opportunnity.CloseDate=System.today() + 90;
                    insert list_Opportunnity;
                    strOpportunityID=list_Opportunnity.Id;           
                }
                else {
                    strOpportunityID=list_Opportunity[0].Id;
                }
            list<Quote> list_AllQuotes = [SELECT 
                                          Id,
                                          Name,
                                          OpportunityId,
                                          Opportunity.Name 
                                          FROM Quote 
                                          WHERE OpportunityId =: strOpportunityID];
            integer list_Sizes=list_AllQuotes.size();
                if(list_AllQuotes.isEmpty()){
                    intNumber=0;
                } 
                else {
                    intNumber=list_Sizes;          
                }
            List<String> list_AllAddress = new List<String>();
            list<Quote> list_Quotes = new list<Quote>();    
                    for(PF_Product_Supplier__c objPrductSupplier:list_ProductSupplr){
                        list_AllAddress.add(objPrductSupplier.Supplier_Name__r.PF_Email__c);
                        Quote objQuotee = new Quote();
                        system.debug(strProductCode);
                        objQuotee.Name= 'QT'+'-'+'{ '+strProductCode+' }'+ '-'+string.valueof(intNumber+=1);
                        objQuotee.OpportunityId= Id.valueOf(strOpportunityID);
                        system.debug(Map_SupllOrder.get(objPrductSupplier.Supplier_Name__r.Name));
                        objQuotee.Pricebook2Id= list_PriceBookEntry[0].Pricebook2Id;          
                        objQuotee.PF_Order_Quantity__c=decimal.valueOf(Map_SupllOrder.get(objPrductSupplier.Supplier_Name__r.Name));
                        objQuotee.PF_Supplier_Account__c = objPrductSupplier.Supplier_Name__c;
                        objQuotee.PF_Supplier__c=objPrductSupplier.Supplier_Name__r.Name;
                        objQuotee.Email= objPrductSupplier.Supplier_Name__r.PF_Email__c;
                        objQuotee.PF_Inventory_Manager__c=userinfo.getuserId();
                        system.debug('line 91'+WarehouseName);
                        objQuotee.PF_Product__c=objPrductSupplier.Product__c;
                        //objQuotee.Email_Service_Id__c='   quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
                        list_Quotes.add(objQuotee);   
                    }
            insert list_Quotes;
            System.debug('line33'+list_AllAddress);
            System.debug('line 34'+list_Quotes);
            List<QuoteLineItem> list_Quoteelist = new List<QuoteLineItem>();
            List<PricebookEntry> list_PriceBKEntry = [SELECT 
                                                      Id,
                                                      Product2Id,
                                                      Pricebook2Id,
                                                      UnitPrice 
                                                      FROM PricebookEntry 
                                                      WHERE Product2Id= : list_Quotes[0].PF_Product__c 
                                                      LIMIT 1];
                for(Quote objQuoote :list_Quotes){
                    QuoteLineItem objQuooteLineItem = new QuoteLineItem();
                    objQuooteLineItem.UnitPrice =0;
                    objQuooteLineItem.QuoteId = objQuoote.Id;
                    objQuooteLineItem.Quantity = objQuoote.PF_Order_Quantity__c;
                    objQuooteLineItem.Product2Id = objQuoote.PF_Product__c;
                    objQuooteLineItem.PricebookEntryId =list_PriceBKEntry[0].Id;
                    //objQuooteLineItem.ListPrice=list_PriceBKEntry[0].UnitPrice;
                    list_Quoteelist.add(objQuooteLineItem);
                }
                if(!list_Quoteelist.isEmpty()){
                    insert list_Quoteelist;
                }
            system.debug('list_Quoteelist'+list_Quoteelist);
            return list_Quotes;  
        }  
       
    /**
    * @ description  :  This method is used to retrieve a list of closed-won opportunity line items that match a given product name.
    *  @params       :  The parameter is used to filter the OpportunityLineItem records based on the Product2 name.
    **/  
        @AuraEnabled
        public static list<OpportunityLineItem> opprecords(string productname){
            return[SELECT 
                   Id, 
                   Opportunity.name,
                   Opportunity.TotalOpportunityQuantity,
                   Quantity,
                   Product2.name,
                   OpportunityId,
                   Opportunity.Account.Name,  
                   Opportunity.CloseDate,
                   Opportunity.StageName 
                   FROM OpportunityLineItem 
                   WHERE Product2.name=: productname 
                   AND Opportunity.StageName='closed won'];    
        }   
    /**
    * @ description  :  This method retrieves a summary of product data including various quantity fields from the Product2 object. 
    **/
        @AuraEnabled
        public static List < Product2 > pf_ProductSummary() {
            return [SELECT 
                    Id,
                    Name,
                    Quantity__c,
                    Approved_Quantity__c,
                    Rejected_Quantity__c,
                    PF_On_Order__c,
                    PF_Orders_Received__c,
                    PF_Under_QA__c,
                    PF_Defective_Quantity__c 
                    FROM Product2];  
        }
     
    /**
    * @ description  :  This method is used to retrieve the names of all active products and return them as a list of strings.
    **/        
        @AuraEnabled
        public static List<string> getproductnamerecords() {
            List<string> list_Product=new List<string>();
            List<Product2> list_ReturnProducts=[SELECT 
                                                Id, 
                                                Name, 
                                                ISActive 
                                                FROM Product2 
                                                WHERE ISActive=true];
                for (Product2 objProduct : list_ReturnProducts) {
                    list_Product.add(objProduct.Name);  
                }
            return list_Product;      
        }

    /**
    * @ description  :  This method is used to retrieve a list of Orders filtered by a search term matching the name of a related Product.
    *  @params       :  The parameter is used to filter the results of the SOQL query to return only the Orders that have a related PF_Product__r record with a name containing the value passed in searchsname.
    **/    
        @AuraEnabled
        public static List < Order > orderProductNameFilter(String searchsname) {
            return[SELECT 
                   Id,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE PF_Product__r.Name 
                   LIKE:searchsname];    
        }
    /**
    * @ description  :  This method retrieves a list of products that match a given search term in their name.
    *  @params       :  The parameter is used to filter the Product2 records based on the exact match of the Name field.
    **/
        @AuraEnabled
        public static List < Product2 > ProductNameFilterInOpp(String searchsname) {
            return [SELECT 
                    Id,
                    Name,
                    Quantity__c,
                    PF_On_Order__c,
                    PF_Orders_Received__c,
                    PF_Under_QA__c,
                    PF_Defective_Quantity__c 
                    FROM Product2 
                    WHERE Name=:searchsname];  
        }

    /**
    * @ description  :  This method is used to retrieve the list of PF_Product_Supplier__c records that match the given product name and quote status value, along with their corresponding supplier names. 
    *  @params       :  The "productName" parameter is used to filter the results based on the name of the product and the "QuoteStatusValue" parameter is used to filter the results based on the status of the quote associated with the product.
    **/
        @AuraEnabled
        public static List < PF_Product_Supplier__c > getSupplierNames(String productName,string QuoteStatusValue ) {
            system.debug('prod'+productName);
            list<Quote> list_OpenQuoteSupplier = new list<Quote>();
                if(QuoteStatusValue=='Open'){
                    list_OpenQuoteSupplier = [SELECT 
                                              Id,
                                              Name,
                                              AccountId,
                                              QuoteNumber,
                                              PF_Supplier_Account__c,
                                              PF_Product__r.Name,
                                              Status 
                                              FROM Quote 
                                              WHERE PF_Product__r.Name =:productName 
                                              AND Status = :QuoteStatusValue];
                }
                else if(QuoteStatusValue== 'Closed'){
                    list_OpenQuoteSupplier = [SELECT 
                                              Id,
                                              Name,
                                              AccountId,
                                              QuoteNumber,
                                              PF_Supplier_Account__c,
                                              PF_Product__r.Name,
                                              Status,
                                              Opportunity.StageName 
                                              FROM Quote 
                                              WHERE PF_Product__r.Name =:productName 
                                              AND Status = :QuoteStatusValue 
                                              AND Opportunity.StageName='Closed Won'];
                }
                else{
                    list_OpenQuoteSupplier = [SELECT 
                                              Id,
                                              Name,
                                              AccountId,
                                              QuoteNumber,
                                              PF_Supplier_Account__c,
                                              PF_Product__r.Name,
                                              Status,
                                              Opportunity.StageName 
                                              FROM Quote 
                                              WHERE PF_Product__r.Name =:productName 
                                              AND Status = :QuoteStatusValue 
                                              AND Opportunity.StageName='Closed Lost'];
                }
            system.debug('line 67'+list_OpenQuoteSupplier);
            list<string> list_SupplierIds = new list<string>();
                for (Quote objQuotte : list_OpenQuoteSupplier) {
                    system.debug('line 70'+objQuotte.PF_Supplier_Account__c);
                    list_SupplierIds.add(objQuotte.PF_Supplier_Account__c);
                }
            system.debug('line 74'+list_SupplierIds);
            list<PF_Product_Supplier__c> list_ProductSupplierPS=[SELECT 
                                                                 Id,
                                                                 Name, 
                                                                 Supplier_Name__r.Name,
                                                                 Supplier_Name__c,
                                                                 Product__r.Name 
                                                                 FROM PF_Product_Supplier__c 
                                                                 WHERE Product__r.Name 
                                                                 LIKE:productName 
                                                                 AND Supplier_Name__c IN : list_SupplierIds  ];
            system.debug('line 75'+ list_ProductSupplierPS);
            return[SELECT 
                   Id,
                   Name, 
                   Supplier_Name__r.Name,
                   Supplier_Name__c,
                   Product__r.Name 
                   FROM PF_Product_Supplier__c 
                   WHERE Product__r.Name 
                   LIKE:productName 
                   AND Supplier_Name__c IN : list_SupplierIds  ];
        }

    /**
    * @ description  :  The method is used to retrieve a list of Quote Line Items based on certain criteria such as product name, supplier name, and quote status.
    *  @params       :  The parameters are used to filter the query results based on the values provided for the product name, supplier name, and quote status.
    **/
        @AuraEnabled
        public static list<QuoteLineItem> PFGetQuoteLineItems(string productname, string suppliername,string QuoteStatusValue){
            if(QuoteStatusValue=='Open'){
                List<String> list_QuoteIDs = new List<String>();
                list<QuoteLineItem> QLinelist =[SELECT 
                                                Id,
                                                Quantity,
                                                LineNumber,
                                                UnitPrice,
                                                ListPrice,
                                                Quote.PF_Product__r.name,
                                                QuoteId,
                                                Finalised__c,
                                                PricebookEntryId,
                                                Quote.PF_Supplier_Account__r.name,
                                                Quote.Status,
                                                Quote.QuoteNumber,
                                                Quote.Opportunity.StageName 
                                                FROM QuoteLineItem 
                                                WHERE Quote.PF_Product__r.name=:productname 
                                                AND Quote.PF_Supplier_Account__r.name=:suppliername 
                                                AND Quote.Status =: QuoteStatusValue  ];
                    for (QuoteLineItem QLI : QLinelist) {
                        list_QuoteIDs.add(QLI.QuoteId); 
                    }
                return [SELECT 
                        Id,
                        Quantity,
                        LineNumber,
                        Quote.PF_Estimated_Delivery_Date__c,
                        Quote.PF_Product__c,
                        UnitPrice,
                        Description,
                        ListPrice,
                        Discount,
                        TotalPrice,
                        Quote.PF_Product__r.name,
                        QuoteId,
                        Finalised__c,
                        PricebookEntryId,
                        Quote.PF_Supplier_Account__r.name,
                        Quote.Status,
                        Quote.QuoteNumber 
                        FROM QuoteLineItem 
                        WHERE QuoteId  IN : list_QuoteIDs 
                        ORDER BY Quote.QuoteNumber asc ];        
            }
                else if(QuoteStatusValue=='Closed'){
                    List<String> list_QuoteIDs = new List<String>();
                    list<QuoteLineItem> list_QuoteLineItm =[SELECT 
                                                            Id,
                                                            Quantity,
                                                            LineNumber,
                                                            UnitPrice,
                                                            ListPrice,
                                                            Quote.PF_Product__r.name,
                                                            QuoteId,
                                                            Finalised__c,
                                                            PricebookEntryId,
                                                            Quote.Opportunity.StageName,
                                                            Quote.PF_Supplier_Account__r.name,
                                                            Quote.Status,
                                                            Quote.QuoteNumber 
                                                            FROM QuoteLineItem 
                                                            WHERE Quote.PF_Product__r.name=:productname 
                                                            AND Quote.PF_Supplier_Account__r.name=:suppliername 
                                                            AND Quote.Opportunity.StageName='Closed Won'
                                                            ORDER BY Quote.QuoteNumber];
                    for (QuoteLineItem objQLI : list_QuoteLineItm) {
                        list_QuoteIDs.add(objQLI.QuoteId);
                    }
                    return[SELECT 
                           Id,
                           Quantity,
                           LineNumber,
                           UnitPrice,
                           Quote.PF_Estimated_Delivery_Date__c,
                           Quote.PF_Product__c,
                           ListPrice,
                           TotalPrice,
                           Description,
                           Discount,
                           Quote.PF_Product__r.name,
                           QuoteId,
                           Finalised__c,
                           PricebookEntryId,
                           Quote.PF_Supplier_Account__r.name,
                           Quote.Status,
                           Quote.QuoteNumber 
                           FROM QuoteLineItem 
                           WHERE QuoteId  in : list_QuoteIDs 
                           ORDER BY LineNumber asc];
                }
                else{
                    List<String> list_QuoteIDs = new List<String>();
                    list<QuoteLineItem> list_QuoteLineItm = [SELECT 
                                                             Id,
                                                             Quantity,
                                                             LineNumber,
                                                             UnitPrice,
                                                             ListPrice,
                                                             Quote.PF_Product__r.name ,
                                                             QuoteId,Finalised__c,
                                                             PricebookEntryId,
                                                             Quote.Opportunity.StageName,
                                                             Quote.PF_Supplier_Account__r.name,
                                                             Quote.Status,
                                                             Quote.QuoteNumber 
                                                             FROM QuoteLineItem 
                                                             WHERE Quote.PF_Product__r.name=:productname 
                                                             AND Quote.PF_Supplier_Account__r.name=:suppliername 
                                                             AND Quote.Opportunity.StageName='Closed Lost' 
                                                             ORDER BY Quote.QuoteNumber];
                        for (QuoteLineItem objQLI : list_QuoteLineItm) {
                            list_QuoteIDs.add(objQLI.QuoteId);
                        }
                    return [SELECT 
                            Id,
                            Quantity,
                            LineNumber,
                            UnitPrice,
                            Quote.PF_Estimated_Delivery_Date__c,
                            Quote.PF_Product__c,
                            ListPrice,
                            TotalPrice,
                            Description,
                            Discount,
                            Quote.PF_Product__r.name,
                            QuoteId,
                            Finalised__c,
                            PricebookEntryId,
                            Quote.PF_Supplier_Account__r.name,
                            Quote.Status,
                            Quote.QuoteNumber 
                            FROM QuoteLineItem 
                            WHERE QuoteId in : list_QuoteIDs 
                            ORDER BY LineNumber asc];
                }
        }
    
    /**
    * @ description  :  This method is used to update the information of a QuoteLineItem and Quote object in Salesforce.
    *  @params       :  The parameters passed in the method are used to update the fields of a QuoteLineItem and Quote record with new values such as quantity, sales price, discount, description, and estimated delivery date based on the input quoteLineId.
    **/
        @AuraEnabled
        public static void CreateQuotelineitems(string quoteLineId,integer Quantity,integer salesPrice,Decimal discount,String lineIemDescription,date estimateddeliverydate){
            System.debug('Insoide CreateQuotelineitems'+ quoteLineId);  
            List<QuoteLineItem> list_QuotelineItemm = new List<QuoteLineItem>();
            List<Quote> list_Quotelst = new List<Quote>();
            list<QuoteLineItem> list_OldQuoteList = [SELECT 
                                                     Id,
                                                     QuoteId, 
                                                     UnitPrice,
                                                     Quantity,
                                                     Discount,
                                                     Description 
                                                     FROM QuoteLineItem 
                                                     WHERE Id = : quoteLineId  ];
            list<Quote> list_OldQuotee = [SELECT 
                                          Id,
                                          PF_Order_Quantity__c,
                                          PF_Estimated_Delivery_Date__c 
                                          FROM Quote 
                                          WHERE Id = : list_OldQuoteList[0].QuoteId];
                for (Quote objQuotte : list_OldQuotee) {
                    objQuotte.PF_Order_Quantity__c=Quantity;
                    objQuotte.PF_Estimated_Delivery_Date__c = estimateddeliverydate;
                    list_Quotelst.add(objQuotte);
                }
                for (QuoteLineItem objQuoteItems : list_OldQuoteList) {
                    objQuoteItems.UnitPrice =salesPrice;
                    objQuoteItems.Quantity =Quantity;
                    objQuoteItems.Discount = discount;
                    objQuoteItems.Description = lineIemDescription;
                    list_QuotelineItemm.add(objQuoteItems);
                }
                update list_QuotelineItemm;
                update list_Quotelst;
            system.debug('Insertred'+list_QuotelineItemm);
            system.debug('qlist'+list_Quotelst);
        }

    /**
    * @ description  :  This method updates the status of a quote and its associated opportunity to "Closed Won" and updates the status of other quotes to "Rejected".
    *  @params       :  The parameters used in this method are used to pass the Quote Id and a list of Quote Ids to update the status of those quotes.
    **/
        @AuraEnabled
        public static void UpdateQuoteLineItemAndQuoteStatus(string QId,List<String> Qlist){
            System.debug(Qlist);
            list<Quote> list_GetQuote =[SELECT 
                                        Id,
                                        Status,
                                        OpportunityId 
                                        FROM Quote 
                                        WHERE Id =: QId];
            List<Opportunity> list_GetOpportunities = [SELECT 
                                                       Id,
                                                       StageName   
                                                       FROM Opportunity 
                                                       WHERE Id =: list_GetQuote[0].OpportunityId];
            List<Opportunity> list_UpdateOppotunities = new List<Opportunity>();
                for (Opportunity objOpportunities : list_GetOpportunities) {
                    objOpportunities.StageName = 'Closed Won';
                    list_UpdateOppotunities.add(objOpportunities);
                }
            update list_UpdateOppotunities;
            list<Quote> list_UpdateQuotee = new list<Quote>();
            list_GetQuote[0].Status='Closed';
            list_UpdateQuotee.add(list_GetQuote[0]);
            list<Quote> list_GetOtherQuotes = [SELECT 
                                               Id,
                                               Status 
                                               FROM Quote 
                                               WHERE Id in : Qlist];
                for (Quote objQuotes : list_GetOtherQuotes) {
                    if(objQuotes.Id!=QId){
                        objQuotes.Status='Rejected';
                        list_UpdateQuotee.add(objQuotes);
                    }  
                } 
            update list_UpdateQuotee;
        }

    /**
    * @ description  :  This method returns a list of Order records filtered by the Type field equal to 'Procured'.
    **/
        @AuraEnabled
        public static list<Order> OrderRecordsDatatable(){
            string strOrdertypename='';
            system.debug('strOrdertypename'+strOrdertypename);
            return[SELECT 
                   id,
                   Type,
                   PF_Product__c,
                   PF_Product__r.Name,
                   OrderNumber,
                   Account.Name,
                   EffectiveDate,
                   Quantity__c,
                   Received_Quantity__c,
                   PF_Pending_Quantity__c,
                   PF_Under_QA__c,
                   Status 
                   FROM Order 
                   WHERE Type= 'Procured'];
        }
    
    /**
    * @ description  : This method is used to retrieve a list of Product2 records whose name matches a given search string. 
    *  @params       : The parameter productname is used to search for Products in the Product2 object whose name matches the provided productname using the LIKE operator.
    **/
        @AuraEnabled
        public static List < Product2 > getProductNames(String productname) {
            return [SELECT 
                    Id,
                    name 
                    FROM Product2 
                    WHERE Name 
                    LIKE:productname];
        }

    /**
    * @ description  :  This method retrieves a map of record type developer names and their corresponding IDs for a given object.
    *  @params       :  The parameter is used to get the record type information. It is used to retrieve the RecordTypeInfo objects for the given object using the getRecordTypeInfosByDeveloperName() method.
    **/
        public static Map<String, Id> getRecordTypeDeveloperNameIdMap(String strObjectName) {
            Schema.DescribeSObjectResult objDescribeSObjectResult = Schema.getGlobalDescribe().get(strObjectName).getDescribe();
            Map<String, RecordTypeInfo> map_RecordTypeInfoByName = objDescribeSObjectResult.getRecordTypeInfosByDeveloperName();
            Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
            for (RecordTypeInfo objRecordTypeInfo : map_RecordTypeInfoByName.values()) {
                map_RecordTypeIdByDeveloperName.put(objRecordTypeInfo.getDeveloperName(), objRecordTypeInfo.getRecordTypeId());
            }
            return map_RecordTypeIdByDeveloperName;
        }

    /**
    * @ description  : The code appears to be for creating an order from a list of suppliers based on a quote ID. 
                       The code retrieves a list of accounts that match the supplier names list and then creates an order for each quote in the selected quote rows. 
                       The code then inserts the orders and creates order items for each order. Finally, the code sends an email to the supplier with the details of the order.
    *  @params       : 
    **/
        @AuraEnabled
        public static list<Order> OrderRecords(list<string> supplierNamesList,String quoteId){
            system.debug('line 112');
            system.debug('supplier'+supplierNamesList[0]);
            List<Order> list_Order= new list<Order>();
            list<string> list_ProductIds = new list<string>();
            Map<Id,Decimal> Map_IdOrderQuantity = new Map<Id,Decimal>();
            list<account> list_Account = [SELECT 
                                          Id,
                                          name,
                                          PF_Email__c 
                                          FROM account 
                                          WHERE name in : supplierNamesList];
            map<string ,id> map_Suplier = new map<string,id>();
            map<Id, String> map_Email = new map<Id, String>();
            map<string,id> map_Loc = new map<string,id>();
            List<Quote> list_SelectedQuoteRows =[SELECT 
                                                 Id,
                                                 Name, 
                                                 PF_Product__c,
                                                 QuoteNumber,
                                                 PF_Supplier__c, 
                                                 PF_Order_Quantity__c, 
                                                 PF_Supplier_Email__c 
                                                 FROM Quote  
                                                 WHERE Id=:quoteId];
            map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Order');
            String RecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Order');
                for(account objAccounts : list_Account){
                    map_Suplier.put(objAccounts.name,objAccounts.id);
                    map_Email.put(objAccounts.id,objAccounts.PF_Email__c);
                }
            List<PricebookEntry> list_PriceBookENtry =[SELECT 
                                                       Id,
                                                       Product2Id,
                                                       Pricebook2Id 
                                                       FROM PricebookEntry 
                                                       WHERE Product2Id= : list_SelectedQuoteRows[0].PF_Product__c];
                for (Quote objQuoteq : list_SelectedQuoteRows) {
                    order objOrrder = new order();
                    objOrrder.AccountId = map_Suplier.get(objQuoteq.PF_Supplier__c);
                    objOrrder.Status='Order Placed';
                    objOrrder.Type='Procured';
                    objOrrder.PF_Product__c=objQuoteq.PF_Product__c;
                    objOrrder.PF_Pending_Quantity__c=objQuoteq.PF_Order_Quantity__c;
                    objOrrder.EffectiveDate= System.today();
                    objOrrder.PF_Order_Quantity__c=objQuoteq.PF_Order_Quantity__c;
                    objOrrder.PF_Account_Email__c = objQuoteq.PF_Supplier_Email__c;
                    objOrrder.Pricebook2Id=list_PriceBookENtry[0].Pricebook2Id;
                    objOrrder.RecordTypeId=recordTypeId;
                    if(list_ProductIds.contains(objQuoteq.PF_Product__c)){
                    }else {
                        list_ProductIds.add(objQuoteq.PF_Product__c);
                    }
                    if(Map_IdOrderQuantity.containsKey(objQuoteq.PF_Product__c)){
                        Decimal intOrderQUpdation = Map_IdOrderQuantity.get(objQuoteq.PF_Product__c);
                        intOrderQUpdation = intOrderQUpdation + objQuoteq.PF_Order_Quantity__c;
                        Map_IdOrderQuantity.put(objQuoteq.PF_Product__c, intOrderQUpdation);
                    }else{
                        Map_IdOrderQuantity.put(objQuoteq.PF_Product__c, objQuoteq.PF_Order_Quantity__c);
                    }            
                    list_Order.add(objOrrder);
                }
            insert list_Order;
            list<Product2> list_GetProductInventory =[SELECT 
                                                      Id, 
                                                      Name, 
                                                      PF_On_Order__c 
                                                      FROM Product2 
                                                      WHERE id IN : list_ProductIds];
            list<Product2> list_UpdateProductInventory = new list<Product2>();
            list<attachment>  list_Attachment=new list<attachment>();
            list<OrderItem>  list_OrdProduct =new list<OrderItem>();
            list<String> list_Orderids = new List<String>();
                for (Order objOrdder : list_Order) {
                    list_Orderids.add(objOrdder.Id);
                    OrderItem objOrdproduct = new OrderItem();
                    objOrdproduct.OrderId=objOrdder.Id;
                    objOrdproduct.Product2Id=objOrdder.PF_Product__c;
                    objOrdproduct.Quantity=objOrdder.PF_Order_Quantity__c;
                    String entryId=[SELECT 
                                    Id 
                                    FROM PricebookEntry 
                                    WHERE Product2Id=:objOrdder.PF_Product__c LIMIT 1].Id;
                    System.debug('Pricebook:'+entryId);
                    objOrdproduct.PricebookEntryId=entryId;                
                    objOrdproduct.UnitPrice=[SELECT 
                                             UnitPrice 
                                             FROM PricebookEntry 
                                             WHERE Product2Id=:objOrdder.PF_Product__c LIMIT 1].UnitPrice;
                    list_OrdProduct.add(objOrdproduct);
                }
            insert list_OrdProduct;
            List<Order> list_Orderrs =[SELECT 
                                       ID,
                                       Name,
                                       EffectiveDate,
                                       OrderNumber,
                                       PF_Product__c,
                                       supplier_Email__c,
                                       PF_Order_Quantity__c,
                                       Account.Name,
                                       PF_Product__r.Name 
                                       FROM Order 
                                       WHERE Id in : list_Orderids];
                for (Order objOrderr : list_Orderrs) {
                    System.debug('Order:'+objOrderr.AccountId);
                    string body='<p> Hello  ' + objOrderr.Account.Name +'</p>'
                    +'<p>Greetings!</p>'
                    +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc, We  are pleased with your quote details and have deicded to accept your offer '
                    +'Details of our Order requirements are as follows:!</p>' +
                    '<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+objOrderr.PF_Product__r.Name  +'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+objOrderr.PF_Order_Quantity__c+'</td> </tr>  </table>'+
                    '<p>Could you please share current availability, best prices and delivery details (lead time, delivery schedule etc.) so that we can take this conversation forward?</p>'+
                    '<p>Looking forward to your reply.</p>'+
                    '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
                    'P.S. Please Reply All on this email with the details and do not change the subject';
                    // atc.Name=objOrderr.OrderNumber + objOrderr.Account.Name + '.pdf';
                    // atc.Body=EncodingUtil.base64Decode(body);
                    // list_Attachment.add(atc);
                    Blob b=blob.toPDF(body);
                    string Name = ''+objOrderr.OrderNumber+'-' + objOrderr.Account.Name+ '.pdf';
                    //EncodingUtil.base64Decode(body);
                    System.debug('Blob:'+b);
                    ContentVersion cVersion = new ContentVersion();
                    cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                    cVersion.PathOnClient = Name; //File name with extention
                    //cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                    //cVersion.OwnerId = o.OwnerId;//Owner of the file
                    cVersion.Title = Name;//Name of the file
                    cVersion.VersionData =b ;//File content
                    Insert cVersion;
                    system.debug('cVersion'+ cVersion);
                    //After saved the Content Verison, get the ContentDocumentId
                    Id conDocument = [SELECT 
                                      ContentDocumentId 
                                      FROM ContentVersion 
                                      WHERE Id =:cVersion.Id].ContentDocumentId;
                    //Insert ContentDocumentLink
                    ContentDocumentLink cDocLink = new ContentDocumentLink();
                    cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
                    cDocLink.LinkedEntityId = objOrderr.Id;//Add attachment parentId
                    cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                    cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                    Insert cDocLink;
                    system.debug('cDocLink' + cDocLink);
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                list<string> emailsaddress=new list<String>();
                // for(account objAccounts:list_Account){
                //     emailsaddress.add(objAccounts.PF_Email__c);                
                // }
                string BodyHtml;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject('Products Required, Sent Quote details accepted');
                mail.setToAddresses(new List<String>{map_Email.get(objOrderr.AccountId)});
                System.debug('Email :'+map_Email.get(objOrderr.AccountId));
                //for(string str:supplierNamesList){
                    BodyHtml= '<p> Hello  ' + objOrderr.Account.Name +'</p>'
                    +'<p>Greetings!</p>'
                    +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc,My team and I reviewed the documents you sent and were very happy with what we read. We are excited at the prospect of using your product .'
                    +'More details of our requirements are as follows:!</p>' +
                    '<p>We want the said quantity of Products and hope it will be delivered soon </p>'+
                    '<p>Looking forward to your reply.</p>'+
                    '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
                    '<p>P.S. Please Reply All on this email with the details and do not change the subject.</p>';
                    mail.sethtmlbody(BodyHtml);
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(Name);
                    efa.setBody(b);
                // mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                //Messaging.SingleEmailMessage[] mails =  new List<Messaging.SingleEmailMessage> {mail};
                // Messaging.SendEmailResult[] result= Messaging.sendEmail(mails);
                //    emailList.add(mail);
                // }
                //mail.sethtmlbody(BodyHtml);
                //if(!emailList.isEmpty()){
                //Messaging.sendEmail(emailList);
                // }   
                    
                }
            return list_Order;
        }

    /**
    * @ description  :  This method is used to retrieve a list of orders with specific fields and conditions for a QA Manager table.
    **/
        @AuraEnabled
        public static List < Order > QAManagerTable() {
            return [SELECT 
                    Id,
                    OrderNumber,
                    PF_Product__c,
                    PF_Product__r.Name,
                    Status,
                    PF_Product__r.PF_Orders_Received__c,
                    PF_Pending_Quantity__c,
                    PF_Under_QA__c, 
                    PF_Approved_Quantity__c, 
                    PF_Reject_Quantity__c 
                    FROM Order 
                    WHERE OrderNumber!=null 
                    AND PF_Product__r.Name!=null 
                    AND PF_Product__r.PF_Orders_Received__c!=null 
                    AND PF_Under_QA__c!=null 
                    AND PF_Approved_Quantity__c!=null 
                    AND PF_Reject_Quantity__c!=null 
                    AND (Status='Partial Quantity Under QA' OR Status='Fully Received Under QA')];    
        }

    /**
    * @ description  :  This method retrieves a list of Asset records related to a specific Product2 Id and with a Status of "QA In Progress."
    * @params        :  The parameter proId is used to filter the Asset records based on the value of the PF_OrderId__c field to only retrieve assets that are associated with a specific order.
    **/
        @AuraEnabled
        public static List<Asset> producttoassestrecords(string proId ){
            return[SELECT
                ID, 
                PF_Batch_Name__c,
                PF_OrderId__c,
                Product2.Id, 
                Status,
                Product2.Name 
                FROM Asset 
                WHERE Status='QA In Progress' 
                AND PF_OrderId__c =: proId];
        }

    /**
    * @ description  :  This method is used to update the status of Asset records based on the QA results and update the corresponding Order records with the approved and rejected quantity.
    *  @params       :  The two parameters, assetRecordIds and statusValues, are used to pass in lists of asset record ids and their corresponding status values that need to be updated.
    **/
        @AuraEnabled
        public static List<Asset> CreateAssetRecords(list<string> assetRecordIds,list<string> statusValues ){
            list<Asset> list_GetAssetRecords = [SELECT 
                                                Id,
                                                PF_Batch_Name__c, 
                                                PF_OrderId__c, 
                                                Product2.Id, 
                                                Status
                                                FROM Asset 
                                                WHERE Status='QA In Progress' 
                                                AND Id in : assetRecordIds];
            system.debug(list_GetAssetRecords);
            Map<String,String> Map_AssetValue = new Map<String,String>();
            List<Asset> list_UpdateAsset = new List<Asset>();
            List<Order> list_UpdateOrder = new List<Order>();
                for (Integer i = 0; i < assetRecordIds.size(); i++) {
                    Map_AssetValue.put(assetRecordIds[i],statusValues[i]);      
                }
            system.debug(Map_AssetValue);
                for (Asset objAssetRecord : list_GetAssetRecords) {
                    system.debug(objAssetRecord.Id);
                    Order list_Orderlist = [SELECT 
                                            Id,
                                            PF_Under_QA__c,
                                            PF_Approved_Quantity__c,
                                            PF_Reject_Quantity__c 
                                            FROM Order 
                                            WHERE Id=:objAssetRecord.PF_OrderId__c];
                                            list_Orderlist.PF_Under_QA__c= list_Orderlist.PF_Under_QA__c-1;
                        if(Map_AssetValue.get(objAssetRecord.Id)=='QA Pass'){
                            if(list_Orderlist.PF_Approved_Quantity__c!=null ) list_Orderlist.PF_Approved_Quantity__c=list_Orderlist.PF_Approved_Quantity__c+1;
                            else list_Orderlist.PF_Approved_Quantity__c=1;
                        }else if(Map_AssetValue.get(objAssetRecord.Id)=='QA Fail'){
                            if(list_Orderlist.PF_Reject_Quantity__c!=null)list_Orderlist.PF_Reject_Quantity__c=list_Orderlist.PF_Reject_Quantity__c+1;
                            else list_Orderlist.PF_Reject_Quantity__c=1;
                        }
                update list_Orderlist;
                objAssetRecord.Status=Map_AssetValue.get(objAssetRecord.Id);
                system.debug(Map_AssetValue.get(objAssetRecord.Id));
                list_UpdateAsset.add(objAssetRecord);
                }
            update list_UpdateAsset;
            return list_UpdateAsset;
        }
    /**
    * @ description  :  This method retrieves OrderItem records for a specific product in QA status, including related Order and Product information.
    *  @params       :  The proIdInQA parameter is used to filter and retrieve OrderItem records where the associated Product2 name contains the value of the proIdInQA parameter, and the Order status is either 'Partial Quantity Under QA' or 'Fully Received Under QA'.
    **/
        @AuraEnabled
        public static List<OrderItem> retrieveProductNameRecordsInQA(string proIdInQA ){
            return [SELECT 
                    ID,
                    Order.Id,
                    Order.OrderNumber,
                    Product2.Id,
                    Order.Status,
                    Order.PF_On_Hand_Received__c, 
                    Product2.Name,
                    Order.PF_Pending_Quantity__c,
                    Order.PF_Under_QA__c, 
                    Order.PF_Approved_Quantity__c, 
                    Order.PF_Reject_Quantity__c 
                    FROM OrderItem 
                    WHERE (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') 
                    AND Product2.Name 
                    LIKE:proIdInQA 
                    ORDER BY Order.OrderNumber ASC];    
        }
    /**
    * @ description  :  This method is used to fetch search results of Order Items based on a search key entered by the user, and display information for those order items.
    *  @params       :  The parameter searchKey is used to search for a specific string within the Order OrderNumber field in the SOQL query.
    **/
        @AuraEnabled
        public static List < OrderItem > fetchSearchResultsDeliveryInfo(String searchKey) {
            String strSearchReturn = '%'+searchKey+'%';
            system.debug('line230'+strSearchReturn);
            return[SELECT Id,
                   Product2.Name,
                   Product2Id,
                   OrderId, 
                   Order.OrderNumber,
                   Order.PF_Under_QA__c, 
                   Order.PF_Order_Quantity__c,
                   Order.Received_Quantity__c,
                   Order.PF_Pending_Quantity__c, 
                   Order.Status 
                   FROM OrderItem 
                   WHERE Order.OrderNumber 
                   LIKE:strSearchReturn];    
        }

    /**
    * @ description  :  The method is used to create Asset records associated with a specific order item and batch numbers, with delivery date and other related details.
    *  @params       :  The parameter String prodId is used to identify the Product2 record,batchNumbers is used to create multiple Asset records for the same Product2, orderid is used to relate the Order record with the Asset record, and date deliverydate is used to set the InstallDate field of the Asset record.
    **/
        @AuraEnabled
        public static void createAsset(String prodId,List<object> batchNumbers,string orderid,date deliverydate) {
            System.debug('Returmnmed cdata'+prodId+''+batchNumbers);
            OrderItem objOrderO =[SELECT 
                                  Id,
                                  Product2Id,
                                  Order.AccountId,
                                  Order.Id 
                                  FROM OrderItem  
                                  WHERE Product2Id=:prodId LIMIT 1];
            PF_Batch_Number__c objBatchNumber = new PF_Batch_Number__c();
            objBatchNumber.PF_Order__c = Id.valueOf(orderid);
            objBatchNumber.Delivery_Date__c = deliverydate;
            insert objBatchNumber;
            List<Asset> list_AssetObj = new List<asset>();
            integer intLength = batchNumbers.size();
            list<Product2> list_Producct=[SELECT 
                                          Id,
                                          name 
                                          FROM Product2 
                                          WHERE id=:prodId];
                for(integer i=0;i<intLength;i++){
                    Asset objAssets = new Asset();
                    objAssets.InstallDate = deliverydate;
                    objAssets.Product2Id = prodId;
                    objAssets.Name = list_Producct[0].name +' '+ 'Asset Delivery'+' '+i;
                    objAssets.AccountId=objOrderO.Order.AccountId;
                    objAssets.Quantity=1.00;
                    objAssets.PF_OrderId__c=Id.valueOf(orderid);
                    objAssets.PF_SKU_Id__c = (string)batchNumbers[i];
                    objAssets.PF_Batch_Number__c = objBatchNumber.Id;
                    list_AssetObj.add(objAssets);
                }
            System.debug('list'+list_AssetObj);
            insert list_AssetObj;
            System.debug('inserted');
        }

    /**
    * @ description  :  This method is used to update the order and inventory records by subtracting the received quantity and adding to the under QA quantity for a given product, and updating the pending quantity for the order.
    *  @params       :  The parameter ordervalue is used to identify the order to be updated, and the parameter valueRquantity is used to indicate the quantity of products received in the order that needs to be updated.
    **/
        @AuraEnabled
        public static List<Order> updateOrder(string ordervalue,integer valueRquantity) {
            System.debug('ordervalue :: ' + ordervalue + 'valueee'+ valueRquantity );
            List<Order> list_OrderListQuery = [SELECT 
                                               Id,
                                               Quantity__c,
                                               Received_Quantity__c,
                                               PF_Under_QA__c,
                                               PF_Pending_Quantity__c,
                                               Status,
                                               PF_Product__c 
                                               FROM Order 
                                               WHERE id=:ordervalue];
            List<Product2> list_Productlist = [SELECT 
                                               Id,
                                               PF_Defective_Quantity__c,
                                               PF_Orders_Received__c 
                                               FROM Product2 
                                               WHERE Id = : list_OrderListQuery[0].PF_Product__c ];
            system.debug(list_Productlist);
            list<Product2> list_NewProductList = new list<Product2>();
            system.debug('list_OrderListQuery :: ' + list_OrderListQuery);
                for (Product2 objProdct : list_Productlist) {
                    objProdct.PF_Defective_Quantity__c=objProdct.PF_Defective_Quantity__c-valueRquantity;
                    objProdct.PF_Orders_Received__c=objProdct.PF_Orders_Received__c+valueRquantity;
                    list_NewProductList.add(objProdct);
                } 
            update list_NewProductList; 
            List<Order> list_UpdateOrders = new List<Order>();
                for(Order objOrderObject:list_OrderListQuery){
                    objOrderObject.PF_Under_QA__c= objOrderObject.PF_Under_QA__c   + valueRquantity;
                    objOrderObject.Received_Quantity__c = 0;
                    objOrderObject.PF_Pending_Quantity__c = objOrderObject.PF_Pending_Quantity__c - valueRquantity;
                    list_UpdateOrders.add(objOrderObject);
                    System.debug('line 648'+objOrderObject.PF_Pending_Quantity__c);
                } 
            system.debug('line 20');
            update  list_UpdateOrders;
            system.debug(list_UpdateOrders);
            system.debug('line 22');  
            return   list_UpdateOrders;  
        }  
    
    /**
    * @ description  :  The method is used to retrieve the related files for a given record ID (QuoteId).
    *  @params       :  The parameter "QuoteId" is used to retrieve a list of Attachment files related to a specific Quote record with the matching QuoteId.
    **/
        @AuraEnabled
        public static Map<ID, String> getRelatedFilesByRecordId(String QuoteId) {
            system.debug('line 551'+QuoteId);
            List<Attachment> list_Files = [SELECT 
                                           Id,
                                           Name 
                                           FROM Attachment 
                                           WHERE ParentId = :QuoteId];
            System.debug('list_Files:'+list_Files);
                Map<ID, String> map_IdTitle = new Map<ID, String>();
                    for (Attachment objDocLink : list_Files) {
                        map_IdTitle.put(objDocLink.Id, objDocLink.Name);
                    }
                return map_IdTitle;
        }

    /**
    * @ description  :  This method is used to update the status of a rejected quote and set the stage name of the corresponding opportunity to "Closed Lost".
    *  @params       :  The parameter QuoteLineItemsList is used to fetch a list of Quote records based on the QuoteId associated with each QuoteLineItem.
    **/
        @AuraEnabled
        public static void RejectedQuoteStatusUpdation(List<QuoteLineItem> QuoteLineItemsList){
            List<String> list_QuoteIdss = new List<String>();
                for (QuoteLineItem objQuoteLineItem : QuoteLineItemsList) {
                    list_QuoteIdss.add(objQuoteLineItem.QuoteId);
                }
            list<Quote> list_GetQuote = [SELECT 
                                         Id,
                                         Status,
                                         OpportunityId 
                                         FROM Quote 
                                         WHERE Id IN: list_QuoteIdss];
            List<Opportunity> list_GetOpportunity=[SELECT 
                                                   Id,
                                                   StageName   
                                                   FROM Opportunity 
                                                   WHERE Id =: list_GetQuote[0].OpportunityId];
            List<Opportunity> list_UpdateOpportunity = new List<Opportunity>();
                for (Opportunity objOpprtunity : list_GetOpportunity) {
                    objOpprtunity.StageName = 'Closed Lost';
                    list_UpdateOpportunity.add(objOpprtunity);
                }
                update list_UpdateOpportunity;
            list<Quote> list_UpdateQuoteRecrds = new list<Quote>();
                for (Quote objQuoteRecs : list_GetQuote) {
                    objQuoteRecs.Status='Rejected';
                    list_UpdateQuoteRecrds.add(objQuoteRecs);
                }
            update list_UpdateQuoteRecrds;
        }

    /**
    * @ description  :  This method is used to retrieve the name of all supplier records in the Account object with a specific record type.
    **/
        @AuraEnabled
        public static List<string> getSupplierNameRecords(){
            List<string> list_Suppliier=new List<string>();
            List<Account> list_AccountReturnList=[SELECT 
                                                  Id, 
                                                  Name,
                                                  RecordType.Name 
                                                  FROM Account 
                                                  WHERE RecordType.Name = 'Supplier'];
            for(Account objSupplierNames : list_AccountReturnList)  {
                list_Suppliier.add(objSupplierNames.Name);
            }
            return list_Suppliier;
        }

    /**
    * @ description  :  This method is used to create a new Quote and its related Quote Line Items based on an existing Quote record.
    *  @params       :  The parameter string QuoteId is used to fetch the details of an existing Quote record based on the given Quote ID.
    **/
        @AuraEnabled
        public static void CreateQuoteAndQuoteLineItems(string QuoteId){
            list<Quote> list_OldQuote =[SELECT 
                                        Id,
                                        Name,
                                        OpportunityId,
                                        Pricebook2Id,
                                        PF_Product__r.ProductCode,
                                        PF_Order_Quantity__c,
                                        PF_Supplier_Account__c,
                                        PF_Supplier__c,
                                        PF_Supplier_Email__c,
                                        PF_Inventory_Manager__c,
                                        PF_Product__c 
                                        FROM Quote 
                                        WHERE Id = : QuoteId];
            integer intNumberr = [SELECT 
                                  Id,
                                  OpportunityId 
                                  FROM Quote 
                                  WHERE OpportunityId = : list_OldQuote[0].OpportunityId].size();
            list<Quote> list_QuoteRecords = new list<Quote>();
                for(Quote objQuoteRec : list_OldQuote){
                    Quote objQuottee = new Quote();                    
                    objQuottee.Name= 'QT'+'-'+'{ '+ objQuoteRec.PF_Product__r.ProductCode+' }'+ '-'+string.valueof(intNumberr+=1);
                    objQuottee.OpportunityId= objQuoteRec.OpportunityId;
                    objQuottee.Pricebook2Id= objQuoteRec.Pricebook2Id;
                    objQuottee.PF_Revised__c=true;
                    objQuottee.PF_Order_Quantity__c= objQuoteRec.PF_Order_Quantity__c;
                    objQuottee.PF_Supplier_Account__c = objQuoteRec.PF_Supplier_Account__c;
                    objQuottee.PF_Supplier__c=objQuoteRec.PF_Supplier__c;
                    objQuottee.PF_Supplier_Email__c= objQuoteRec.PF_Supplier_Email__c;
                    objQuottee.PF_Inventory_Manager__c=objQuoteRec.PF_Inventory_Manager__c;
                    objQuottee.PF_Product__c=objQuoteRec.PF_Product__c;
                    //objQuottee.Revised_Record__c='Revised';
                    //objQuottee.Email_Service_Id__c='	quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';                   
                    list_QuoteRecords.add(objQuottee);
                }
            insert list_QuoteRecords;
            System.debug('line 34'+list_QuoteRecords);
            List<QuoteLineItem> list_QuoteLineItemss = new List<QuoteLineItem>();
            List<PricebookEntry> list_PriceBookEntryList = [SELECT
                                                            Id,
                                                            Product2Id,
                                                            Pricebook2Id,
                                                            UnitPrice 
                                                            FROM PricebookEntry 
                                                            WHERE Product2Id= : list_QuoteRecords[0].PF_Product__c LIMIT 1];
                for(Quote objQuoteList :list_QuoteRecords){
                    QuoteLineItem objQuoteLines = new QuoteLineItem();
                    objQuoteLines.UnitPrice =0;
                    objQuoteLines.QuoteId = objQuoteList.Id;
                    objQuoteLines.Quantity = objQuoteList.PF_Order_Quantity__c;
                    objQuoteLines.Product2Id = objQuoteList.PF_Product__c;
                    objQuoteLines.PricebookEntryId =list_PriceBookEntryList[0].Id;
                    //objQuoteLines.ListPrice=list_PriceBookEntryList[0].UnitPrice;
                list_QuoteLineItemss.add(objQuoteLines);
                }
                if(!list_QuoteLineItemss.isEmpty()){
                    insert list_QuoteLineItemss;
                }
                system.debug('list_QuoteLineItemss'+list_QuoteLineItemss);
        }

    /**
    * @ description  :  This methods is used to retrieve the picklist values of the 'Status' field on the 'Order' object.
    **/
        @AuraEnabled
        public static List<String> getPickListValuesIntoList(){
            List<String> list_PickListValues= new List<String>();
            Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
            List<Schema.PicklistEntry> list_PickListEntry = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry objPickListValues : list_PickListEntry){
                list_PickListValues.add(objPickListValues.getLabel());
            }     
            return list_PickListValues;
        }
}