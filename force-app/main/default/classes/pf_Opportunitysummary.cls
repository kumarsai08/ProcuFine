public with sharing class pf_Opportunitysummary {

    public static Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
    @AuraEnabled(cacheable=true)
    public static  Map<String,String>  GetSuppleirDetails(String Productid) {
        list<PF_Product_Supplier__c> PSList= [Select Supplier_Name__c,Supplier_Name__r.Name From PF_Product_Supplier__c Where Product__r.id=:Productid];
        Map<String,String> NamesList = new  Map<String,String> ();
        for (PF_Product_Supplier__c PS : PSList) {
            NamesList.put(PS.Supplier_Name__c,PS.Supplier_Name__r.Name);
        }
        return NamesList;

    }
    @AuraEnabled
    public static List < Order > fetchOrderProduct() {  
        return[select id,PF_Product__r.Name,PF_Product__c,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status,RecordType.Name FROM Order WHERE Order.Status!='Fully Received Under QA' order by OrderNumber ASC];
    }
    @AuraEnabled
    public static List < Opportunity > pf_OpportunityQuantity() {
            return [SELECT Id,name,CloseDate,PF_Opportunity_Quantity__c,StageName FROM Opportunity ];   
            //where StageName='closed won'
        }

        @AuraEnabled
    public static List < Opportunity > pf_OpportunityQuantitytab() {
            return [SELECT Id,name,CloseDate,PF_Opportunity_Quantity__c,StageName FROM Opportunity where StageName='closed won'];   
            
        }

        @AuraEnabled    
        public static List < Order > orderStatusFilter(String searchstatus) {
                if(searchstatus=='All'){
                    return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order];    
                }else{
                    return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where Status LIKE:searchstatus];    
                }
        }    

        @AuraEnabled   
        public static List < Order > orderStatusRecords(String searchstatus, String searchsname) {
            if(searchstatus=='All'){
                return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where PF_Product__r.Name LIKE:searchsname];        
            }

                else if (searchstatus=='All' && searchsname=='All') {
    
            return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order];
        }else if(searchsname=='All'){
            return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where Status LIKE:searchstatus ];    
    
        }else {
            return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where Status LIKE:searchstatus AND PF_Product__r.Name LIKE:searchsname];    
        }
        }

        @AuraEnabled
        public static list<Product2> GetSupplierrDetailsfornewtable(String pname){
            string apname=pname;
            system.debug('line 60'+pname);
           return [select Id,Name,PF_UOM__c,Quantity__c,PF_On_Order__c,PF_Orders_Received__c,PF_Under_QA__c,PF_Defective_Quantity__c FROM Product2 where Name =: pname];   
        }

        @AuraEnabled(cacheable=true)
    public static List < PF_Product_Supplier__c> supplierSection(String pnamee) {


        return[select Id,Name, Product__r.name,Supplier_Name__r.Name,Supplier_Name__r.grade__c,Quantity__c from PF_Product_Supplier__c WHERE Product__r.name=:pnamee ];
       
    }

    @AuraEnabled   
        public static List<Order> getOrderId(String searchKey) {
            String key = '%' + searchKey + '%'; 
            return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where OrderNumber LIKE :key];
        }

        @AuraEnabled   
        public static List<Order> getSupplierDetails(String searchSupplier) {
            String key = '%' + searchSupplier + '%'; 
            return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where Account.Name LIKE :key];
        }    

    @AuraEnabled
    public static List<String> supplierSearchFilter() {
        List<Account> SupplierNamesList = [SELECT Id,Name,RecordType.Name,grade__c FROM Account WHERE RecordType.Name = 'Supplier'];
        list<String> Snameslist = new list<String>();
        for (Account supplier : SupplierNamesList) {
            Snameslist.add(supplier.Name);
           
        }


        return Snameslist;
       
    }
    @AuraEnabled
    public static List <String> supplierNamesList(String pnamee) {


        list<PF_Product_Supplier__c> pslist2=[select Id,Name, Product__r.name,Supplier_Name__r.Name  from PF_Product_Supplier__c  WHERE Product__r.name=:pnamee ];
        List<string> supnameslist = new List<string>();
        for (PF_Product_Supplier__c ps : pslist2) {
            supnameslist.add(ps.Supplier_Name__r.Name);
        }
        return supnameslist;
       
    }

@AuraEnabled
    public static List < PF_Product_Supplier__c> retrieveRecords(String searchsname ,String pnamee ) {
        return[select Id,Name,Product__r.name,Supplier_Name__r.Name from PF_Product_Supplier__c WHERE Product__r.name=:pnamee  and Supplier_Name__r.Name LIKE :searchsname];
       
    }
    @AuraEnabled
    public static list<Quote> ReviseButton(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList){
        system.debug('LINE 15' + supplierids);
        list<PF_Product_Supplier__c> PSList1= [Select Id,Supplier_Name__c,Supplier_Name__r.PF_Email__c,Supplier_Name__r.Name,Product__r.Name,Product__c,Product__r.ProductCode From PF_Product_Supplier__c Where  Id in :supplierids ];
        String productname = PSList1[0].Product__r.Name;
        system.debug('line 17'+PSList1[0].Product__r.Name);
        string productcode= PSList1[0].Product__r.ProductCode;
        system.debug('line 17'+PSList1[0].Product__r.ProductCode);
        Map<String,String> MapsupllOrderQ = new Map<String,String>();
        //system.debug(WarehouseName);
        List<PricebookEntry> PBList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : PSList1[0].Product__c LIMIT 1];
        system.debug('orderq list '+Orderquantity);
        system.debug('snames list '+supplierNamesList);
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            system.debug('line 29 '+supplierNamesList[i]+Orderquantity[i]);
            MapsupllOrderQ.put(supplierNamesList[i],Orderquantity[i]);           
        }
        system.debug('line 34 '+ MapsupllOrderQ);      
        Integer num;
        String oppID;      
        system.debug('LINE 15' + supplierids);
        string s1= productname;
        list<Opportunity> opplist=[SELECT Name,Id FROM Opportunity WHERE Name = : s1];
        Opportunity opp=new Opportunity();
        if (opplist.isEmpty()) {        
            opp.Name=productname;
            opp.StageName='Prospecting';
            opp.Pricebook2Id= PBList[0].Pricebook2Id;
            opp.CloseDate=System.today() + 90;
            insert opp;
            oppID=opp.Id;           
        }else {
            oppID=opplist[0].Id;
        }
       
        list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
        integer listsize=Quoteslist.size();
        if(Quoteslist.isEmpty()){
             num=0;
        } else {
             num=listsize;          
        }
              
        List<String> address = new List<String>();
        list<Quote> Qlist = new list<Quote>();    
        for(PF_Product_Supplier__c p:PSList1){
            address.add(p.Supplier_Name__r.PF_Email__c);
            Quote q = new Quote();
            system.debug(productcode);
            q.Name= 'QT Revised'+'-'+'{ '+productcode+' }'+ '-'+string.valueof(num+=1);
            q.OpportunityId= Id.valueOf(oppID);
            system.debug(MapsupllOrderQ.get(p.Supplier_Name__r.Name));
            q.Pricebook2Id= PBList[0].Pricebook2Id;          
            q.PF_Order_Quantity__c=decimal.valueOf(MapsupllOrderQ.get(p.Supplier_Name__r.Name));
            q.PF_Supplier_Account__c = p.Supplier_Name__c;
            q.PF_Supplier__c=p.Supplier_Name__r.Name;
            q.Email= p.Supplier_Name__r.PF_Email__c;
            q.Revised_Record__c='Revised';
            q.PF_Inventory_Manager__c=userinfo.getuserId();
            //system.debug('line 91'+WarehouseName);
            //q.warehouse__c= WarehouseName;
            q.PF_Product__c=p.Product__c;
          //  q.Email_Service_Id__c='   quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
           
            Qlist.add(q);
                   
        }
        insert Qlist;
        System.debug('line33'+address);
        System.debug('line 34'+Qlist);
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : Qlist[0].PF_Product__c LIMIT 1];
        for(Quote q :Qlist){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.PF_Order_Quantity__c;
            qL.Product2Id = q.PF_Product__c;


            qL.PricebookEntryId =PriceBEntryList[0].Id;
           // qL.ListPrice=PriceBEntryList[0].UnitPrice;
            qlList.add(qL);
        }
        if(!qlList.isEmpty()){
            insert qlList;
        }
        system.debug('qlList'+qlList);
       
       
     
        return Qlist;    
       
       
       
    }

    @AuraEnabled
    public static list<Quote> SendAnEmail(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList,String WarehouseName){
        system.debug('LINE 15' + supplierids);
        list<PF_Product_Supplier__c> PSList1= [Select Id,Supplier_Name__c,Supplier_Name__r.PF_Email__c,Supplier_Name__r.Name,Product__r.Name,Product__c,Product__r.ProductCode From PF_Product_Supplier__c Where  Id in :supplierids ];
        String productname = PSList1[0].Product__r.Name;
        system.debug('line 17'+PSList1[0].Product__r.Name);
        string productcode= PSList1[0].Product__r.ProductCode;
        system.debug('line 17'+PSList1[0].Product__r.ProductCode);
        Map<String,String> MapsupllOrderQ = new Map<String,String>();
        system.debug(WarehouseName);
        List<PricebookEntry> PBList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : PSList1[0].Product__c LIMIT 1];
        system.debug('orderq list '+Orderquantity);
        system.debug('snames list '+supplierNamesList);
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            system.debug('line 29 '+supplierNamesList[i]+Orderquantity[i]);
            MapsupllOrderQ.put(supplierNamesList[i],Orderquantity[i]);           
        }
        system.debug('line 34 '+ MapsupllOrderQ);      
        Integer num;
        String oppID;      
        system.debug('LINE 15' + supplierids);
        string s1= productname;
        list<Opportunity> opplist=[SELECT Name,Id FROM Opportunity WHERE Name = : s1];
        Opportunity opp=new Opportunity();
        if (opplist.isEmpty()) {        
            opp.Name=productname;
            opp.StageName='Prospecting';
            opp.Pricebook2Id= PBList[0].Pricebook2Id;
            opp.CloseDate=System.today() + 90;
            insert opp;
            oppID=opp.Id;           
        }else {
            oppID=opplist[0].Id;
        }
       
        list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
        integer listsize=Quoteslist.size();
        if(Quoteslist.isEmpty()){
             num=0;
        } else {
             num=listsize;          
        }
              
        List<String> address = new List<String>();
        list<Quote> Qlist = new list<Quote>();    
        for(PF_Product_Supplier__c p:PSList1){
            address.add(p.Supplier_Name__r.PF_Email__c);
            Quote q = new Quote();
            system.debug(productcode);
            q.Name= 'QT'+'-'+'{ '+productcode+' }'+ '-'+string.valueof(num+=1);
            q.OpportunityId= Id.valueOf(oppID);
            system.debug(MapsupllOrderQ.get(p.Supplier_Name__r.Name));
            q.Pricebook2Id= PBList[0].Pricebook2Id;          
            q.PF_Order_Quantity__c=decimal.valueOf(MapsupllOrderQ.get(p.Supplier_Name__r.Name));
            q.PF_Supplier_Account__c = p.Supplier_Name__c;
            q.PF_Supplier__c=p.Supplier_Name__r.Name;
            q.Email= p.Supplier_Name__r.PF_Email__c;
            q.PF_Inventory_Manager__c=userinfo.getuserId();
            system.debug('line 91'+WarehouseName);
            //q.warehouse__c= WarehouseName;
            q.PF_Product__c=p.Product__c;
          //  q.Email_Service_Id__c='   quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
           
            Qlist.add(q);
                   
        }
        insert Qlist;
        System.debug('line33'+address);
        System.debug('line 34'+Qlist);
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : Qlist[0].PF_Product__c LIMIT 1];
        for(Quote q :Qlist){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.PF_Order_Quantity__c;
            qL.Product2Id = q.PF_Product__c;


            qL.PricebookEntryId =PriceBEntryList[0].Id;
           // qL.ListPrice=PriceBEntryList[0].UnitPrice;
            qlList.add(qL);
        }
        if(!qlList.isEmpty()){
            insert qlList;
        }
        system.debug('qlList'+qlList);
       
       
     
        return Qlist;  
    }  
       
       
       
    
        

        @AuraEnabled
        public static list<OpportunityLineItem> opprecords(string productname){
            //string p=productname;
            return [SELECT id, Opportunity.name,Opportunity.TotalOpportunityQuantity,Quantity,Product2.name ,OpportunityId,Opportunity.Account.Name,  Opportunity.CloseDate,Opportunity.StageName FROM OpportunityLineItem WHERE Product2.name=: productname and Opportunity.StageName='closed won'];
           // 
    
        }   

    @AuraEnabled
    public static List < Product2 > pf_ProductSummary() {
        return [SELECT Id,Name,Quantity__c,Approved_Quantity__c,Rejected_Quantity__c,PF_On_Order__c,PF_Orders_Received__c,PF_Under_QA__c,PF_Defective_Quantity__c FROM Product2];  
       // Opportunity.Id 
            }
     
    @AuraEnabled
    public static List<string> getproductnamerecords() {
         List<string> productlist=new List<string>();
         List<Product2> returnlist=[Select Id, Name, ISActive From Product2 WHERE ISActive=true];
        for (Product2 product : returnlist) {
            productlist.add(product.Name);  
        }
        return productlist;      
}

@AuraEnabled
    public static List < Order > orderProductNameFilter(String searchsname) {
        return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where PF_Product__r.Name LIKE:searchsname];    
    }

    @AuraEnabled
    public static List < Product2 > ProductNameFilterInOpp(String searchsname) {
        return [SELECT Id,Name,Quantity__c,PF_On_Order__c,PF_Orders_Received__c,PF_Under_QA__c,PF_Defective_Quantity__c FROM Product2 where Name=:searchsname];  
    }       

    @AuraEnabled
    public static List < PF_Product_Supplier__c > getSupplierNames(String productName,string QuoteStatusValue ) {
        system.debug('prod'+productName);
        list<Quote> OpenQuoteSupplierList = new list<Quote>();
        if(QuoteStatusValue=='Open'){
        OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,PF_Supplier_Account__c,PF_Product__r.Name,Status FROM Quote WHERE PF_Product__r.Name =:productName AND Status = :QuoteStatusValue]; //PF_Supplier_Account__r.Name,Account.name,
        }else if(QuoteStatusValue== 'Closed'){
            OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,PF_Supplier_Account__c,PF_Product__r.Name,Status,Opportunity.StageName FROM Quote WHERE PF_Product__r.Name =:productName AND Status = :QuoteStatusValue AND Opportunity.StageName='Closed Won'];
        }else{
            OpenQuoteSupplierList = [SELECT Id,Name,AccountId,QuoteNumber,PF_Supplier_Account__c,PF_Product__r.Name,Status,Opportunity.StageName FROM Quote WHERE PF_Product__r.Name =:productName AND Status = :QuoteStatusValue AND Opportunity.StageName='Closed Lost'];
        }
        system.debug('line 67'+OpenQuoteSupplierList);
        list<string> SupplierIdsList = new list<string>();
        for (Quote q : OpenQuoteSupplierList) {
            system.debug('line 70'+q.PF_Supplier_Account__c);
            SupplierIdsList.add(q.PF_Supplier_Account__c);
           
        }
        system.debug('line 74'+SupplierIdsList);
        list<PF_Product_Supplier__c> pslist=[ select id,Name, Supplier_Name__r.Name,Supplier_Name__c,Product__r.Name from PF_Product_Supplier__c WHERE Product__r.Name LIKE:productName AND Supplier_Name__c IN : SupplierIdsList  ];
         system.debug('line 75'+ pslist);
        return [ select id,Name, Supplier_Name__r.Name,Supplier_Name__c,Product__r.Name from PF_Product_Supplier__c WHERE Product__r.Name LIKE:productName AND Supplier_Name__c IN : SupplierIdsList  ];
       
    }

    @AuraEnabled
    public static list<QuoteLineItem> PFGetQuoteLineItems(string productname, string suppliername,string QuoteStatusValue){
        if(QuoteStatusValue=='Open'){
            List<String> QuoteIdsList = new List<String>();
            list<QuoteLineItem> QLinelist =[select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber,Quote.Opportunity.StageName from QuoteLineItem where Quote.PF_Product__r.name=:productname and Quote.PF_Supplier_Account__r.name=:suppliername and Quote.Status =: QuoteStatusValue  ];
            for (QuoteLineItem QLI : QLinelist) {
                QuoteIdsList.add(QLI.QuoteId);
                
            }
            return [select id,Quantity,LineNumber,Quote.PF_Estimated_Delivery_Date__c,Quote.PF_Product__c,UnitPrice,Description,ListPrice,Discount,TotalPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  IN : QuoteIdsList order by Quote.QuoteNumber asc ];        }
            else if(QuoteStatusValue=='Closed'){
                List<String> QuoteIdsList = new List<String>();
                 list<QuoteLineItem> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId, Quote.Opportunity.StageName,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where Quote.PF_Product__r.name=:productname and Quote.PF_Supplier_Account__r.name=:suppliername and Quote.Opportunity.StageName='Closed Won'order by Quote.QuoteNumber  ];
                 for (QuoteLineItem QLI : QLinelist) {
                    QuoteIdsList.add(QLI.QuoteId);
                    
                }
                return [select id,Quantity,LineNumber,UnitPrice,Quote.PF_Estimated_Delivery_Date__c,Quote.PF_Product__c,ListPrice,TotalPrice,Description,Discount,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  in : QuoteIdsList order by LineNumber asc];
            }
            else{
                List<String> QuoteIdsList = new List<String>();
         list<QuoteLineItem> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.Opportunity.StageName,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where Quote.PF_Product__r.name=:productname and Quote.PF_Supplier_Account__r.name=:suppliername and Quote.Opportunity.StageName='Closed Lost' order by Quote.QuoteNumber];
         for (QuoteLineItem QLI : QLinelist) {
            QuoteIdsList.add(QLI.QuoteId);
            
        }
            return [select id,Quantity,LineNumber,UnitPrice,Quote.PF_Estimated_Delivery_Date__c,Quote.PF_Product__c,ListPrice,TotalPrice,Description,Discount,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId in : QuoteIdsList order by LineNumber asc];
        }
    }
    
    

@AuraEnabled
    public static void CreateQuotelineitems(string quoteLineId,integer Quantity,integer salesPrice,Decimal discount,String lineIemDescription,date estimateddeliverydate){
        System.debug('Insoide CreateQuotelineitems'+ quoteLineId);  
        //System.debug('Details'+productname+'__:'+suppliername+'__:'+warehouse+'__:');
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<Quote> quotelist = new List<Quote>();
        list<QuoteLineItem> oldqlList = [SELECT Id,QuoteId, UnitPrice,Quantity,Discount,Description FROM QuoteLineItem WHERE Id = : quoteLineId  ];
        list<Quote> oldQuoteList = [SELECT Id,PF_Order_Quantity__c,PF_Estimated_Delivery_Date__c FROM Quote WHERE Id = : oldqlList[0].QuoteId];
        for (Quote q : oldQuoteList) {
            q.PF_Order_Quantity__c=Quantity;
            q.PF_Estimated_Delivery_Date__c = estimateddeliverydate;
            quotelist.add(q);
        }
        for (QuoteLineItem qL : oldqlList) {
            qL.UnitPrice =salesPrice;
            qL.Quantity =Quantity;
            qL.Discount = discount;
            qL.Description = lineIemDescription;
            qlList.add(qL);
        }
            update qlList;
            update quotelist;

        system.debug('Insertred'+qlList);
        system.debug('qlist'+quotelist);
    }

    @AuraEnabled
    public static void UpdateQuoteLineItemAndQuoteStatus(string QId,List<String> Qlist){
        System.debug(Qlist);

        /*list<QuoteLineItem> GetQLIList = [select id,Quantity,Finalised__c,PricebookEntryId,Quote.Status,Quote.Id from QuoteLineItem where id=: QLIid ];
        list<QuoteLineItem> UpdateQLIList = new list<QuoteLineItem>();


        GetQLIList[0].Finalised__c=true;
        UpdateQLIList.add(GetQLIList[0]);
        update UpdateQLIList;*/
        list<Quote> GetQuoteList = [SELECT Id,Status ,OpportunityId FROM Quote WHERE Id =: QId];
        List<Opportunity> GetOppList = [SELECT Id,StageName   FROM Opportunity WHERE Id =: GetQuoteList[0].OpportunityId];
        List<Opportunity> updateOppList = new List<Opportunity>();
        for (Opportunity opp : GetOppList) {
            opp.StageName = 'Closed Won';
            updateOppList.add(opp);
            
        }
        update updateOppList;

        list<Quote> UpdateQuoteList = new list<Quote>();
        GetQuoteList[0].Status='Closed';
        UpdateQuoteList.add(GetQuoteList[0]);
        list<Quote> GetOtherQuotesList = [SELECT Id,Status FROM Quote WHERE Id in : Qlist];
        for (Quote q : GetOtherQuotesList) {
            if(q.Id!=QId){
                q.Status='Rejected';
                UpdateQuoteList.add(q);
            }
            
            
        } 

        update UpdateQuoteList;

    }

    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(){
        string Ordertypename='';
        system.debug('Ordertypename'+Ordertypename);
        // return [SELECT Name,Id,Type,EffectiveDate,Account.Name,OrderNumber,Status,PF_Product__c,PF_Product__r.Name FROM Order WHERE Type= 'Procured' ];
        return[select id,Type,PF_Product__c,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order WHERE Type= 'Procured'];

    }

    @AuraEnabled
      public static List < Product2 > getProductNames(String productname) {


            return [ select id,name from Product2 WHERE Name LIKE:productname];
       
    }

    public static Map<String, Id> getRecordTypeDeveloperNameIdMap(String strObjectName) {
        Schema.DescribeSObjectResult objDescribeSObjectResult = Schema.getGlobalDescribe().get(strObjectName).getDescribe();
        Map<String, RecordTypeInfo> map_RecordTypeInfoByName = objDescribeSObjectResult.getRecordTypeInfosByDeveloperName();
        Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
        for (RecordTypeInfo objRecordTypeInfo : map_RecordTypeInfoByName.values()) {
            map_RecordTypeIdByDeveloperName.put(objRecordTypeInfo.getDeveloperName(), objRecordTypeInfo.getRecordTypeId());
        }
        
        return map_RecordTypeIdByDeveloperName;
    }
 @AuraEnabled
    public static list<Order> OrderRecords(list<string> supplierNamesList,String quoteId){
        system.debug('line 112');
        system.debug('supplier'+supplierNamesList[0]);
        List<Order> ordlist= new list<Order>();
        list<string> productIdsList = new list<string>();
        Map<Id,Decimal> MapPidOrderQuantity = new Map<Id,Decimal>();
        list<account> lstacc = [select id,name,PF_Email__c from account where name in : supplierNamesList];
        map<string ,id> mapsupp = new map<string,id>();
        map<Id, String> mapEmail = new map<Id, String>();
        map<string,id> maploc = new map<string,id>();
        List<Quote> SelectedQuoteRows =[select id,Name, PF_Product__c,QuoteNumber,PF_Supplier__c, PF_Order_Quantity__c, PF_Supplier_Email__c from Quote  where Id=:quoteId];
        //Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
        map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Order');
        //System.debug('Quote Number'+quoteId);
        //List<Quote> SelectedQuoteRows =[select id,Name, PF_Product__c,QuoteNumber,PF_Supplier__c,PF_Order_Quantity__c, PF_Supplier_Email__c from Quote  where Id=:quoteId];
        String RecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Order');
        for(account acc : lstacc){
           mapsupp.put(acc.name,acc.id);
           mapEmail.put(acc.id,acc.PF_Email__c);
        }
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id= : SelectedQuoteRows[0].PF_Product__c];
        for (Quote q : SelectedQuoteRows) {
            order orr = new order();
            orr.AccountId = mapsupp.get(q.PF_Supplier__c);
            orr.Status='Order Placed';
            orr.Type='Procured';
            orr.PF_Product__c=q.PF_Product__c;
            orr.PF_Pending_Quantity__c=q.PF_Order_Quantity__c;
            orr.EffectiveDate= System.today();
            orr.PF_Order_Quantity__c=q.PF_Order_Quantity__c;
            orr.PF_Account_Email__c = q.PF_Supplier_Email__c;
            orr.Pricebook2Id=PriceBEntryList[0].Pricebook2Id;
            orr.RecordTypeId=recordTypeId;
            if(productIdsList.contains(q.PF_Product__c)){
                //continue;
            }else {
                productIdsList.add(q.PF_Product__c);
            }
           
            if(MapPidOrderQuantity.containsKey(q.PF_Product__c)){
                Decimal OrderQUpdation = MapPidOrderQuantity.get(q.PF_Product__c);
                OrderQUpdation = OrderQUpdation + q.PF_Order_Quantity__c;
                MapPidOrderQuantity.put(q.PF_Product__c, OrderQUpdation);
            }else{
                MapPidOrderQuantity.put(q.PF_Product__c, q.PF_Order_Quantity__c);
            }
            //orr.TotalAmount=q.Order_Quantity__c;
           
            ordlist.add(orr);
           
        }
        insert ordlist;
        list<Product2> GetProductInventoryList = [SELECT Id, Name, PF_On_Order__c FROM Product2 WHERE id IN : productIdsList];
        list<Product2> UpdateProductInventoryList = new list<Product2>();
        list<attachment>  atment=new list<attachment>();
        list<OrderItem>  OrdProductList =new list<OrderItem>();
       
        list<String> Orderidslist = new List<String>();
        for (Order ordd : ordlist) {
            Orderidslist.add(ordd.Id);
            OrderItem ordproduct = new OrderItem();
            ordproduct.OrderId=ordd.Id;
            ordproduct.Product2Id=ordd.PF_Product__c;
            ordproduct.Quantity=ordd.PF_Order_Quantity__c;

            String entryId=[SELECT Id FROM PricebookEntry Where Product2Id=:ordd.PF_Product__c LIMIT 1].Id;
             System.debug('Pricebook:'+entryId);
            ordproduct.PricebookEntryId=entryId;
           
            ordproduct.UnitPrice=[SELECT UnitPrice FROM PricebookEntry Where Product2Id=:ordd.PF_Product__c LIMIT 1].UnitPrice;
            OrdProductList.add(ordproduct);
        }
        insert OrdProductList;
        List<Order> Orderslist2 = [SELECT Name,Id,EffectiveDate,OrderNumber,PF_Product__c,supplier_Email__c,PF_Order_Quantity__c,Account.Name,PF_Product__r.Name FROM Order WHERE Id in : Orderidslist];
       
        for (Order o : Orderslist2) {
            System.debug('Order:'+o.AccountId);
            string body='<p> Hello  ' + o.Account.Name +'</p>'
            +'<p>Greetings!</p>'
          +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc, We  are pleased with your quote details and have deicded to accept your offer '


          +'Details of our Order requirements are as follows:!</p>' +


          '<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+o.PF_Product__r.Name  +'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+o.PF_Order_Quantity__c+'</td> </tr>  </table>'+


          '<p>Could you please share current availability, best prices and delivery details (lead time, delivery schedule etc.) so that we can take this conversation forward?</p>'+




          '<p>Looking forward to your reply.</p>'+
          '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
          'P.S. Please Reply All on this email with the details and do not change the subject';
            // atc.Name=o.OrderNumber + o.Account.Name + '.pdf';
            // atc.Body=EncodingUtil.base64Decode(body);
            // atment.add(atc);
            Blob b=blob.toPDF(body);
            string Name = ''+o.OrderNumber+'-' + o.Account.Name+ '.pdf';
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
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
           
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = o.Id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
           cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            system.debug('cDocLink' + cDocLink);






        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
     
        list<string> emailsaddress=new list<String>();
        // for(account acc:lstacc){
        //     emailsaddress.add(acc.PF_Email__c);                
        // }
        string BodyHtml;
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Products Required, Sent Quote details accepted');
        mail.setToAddresses(new List<String>{mapEmail.get(o.AccountId)});
        System.debug('Email :'+mapEmail.get(o.AccountId));
        //for(string str:supplierNamesList){
            BodyHtml= '<p> Hello  ' + o.Account.Name +'</p>'
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
        return ordlist;
    }
       

    


// QA Manager Methods
@AuraEnabled
    public static List < Order > QAManagerTable() {
        
        return [SELECT Id,OrderNumber,PF_Product__c,PF_Product__r.Name,Status,PF_Product__r.PF_Orders_Received__c,PF_Pending_Quantity__c,PF_Under_QA__c, PF_Approved_Quantity__c, PF_Reject_Quantity__c from Order WHERE Status='Partial Quantity Under QA' OR Status='Fully Received Under QA'];    
    }


    @AuraEnabled
    public static List<Asset> producttoassestrecords(string proId ){
        return[Select PF_Batch_Name__c,PF_OrderId__c,Product2.Id, Status,Product2.Name from Asset Where Status='QA In Progress' AND PF_OrderId__c =: proId];
       
    }

    @AuraEnabled
    public static List<Asset> CreateAssetRecords(list<string> assetRecordIds,list<string> statusValues ){


        list<Asset> GetAssetRecords = [Select Id,PF_Batch_Name__c, PF_OrderId__c, Product2.Id, Status from Asset Where Status='QA In Progress' AND Id in : assetRecordIds];
        system.debug(GetAssetRecords);
        Map<String,String> MapAssetValue = new Map<String,String>();
        List<Asset> UpdateAssetList = new List<Asset>();
        List<Order> UpdateOrderList = new List<Order>();
        for (Integer i = 0; i < assetRecordIds.size(); i++) {
            MapAssetValue.put(assetRecordIds[i],statusValues[i]);  
           
        }
        system.debug(MapAssetValue);
        for (Asset AssetRecord : GetAssetRecords) {
            system.debug(AssetRecord.Id);
            Order ord = [Select Id,PF_Under_QA__c,PF_Approved_Quantity__c,PF_Reject_Quantity__c From Order Where id=:AssetRecord.PF_OrderId__c];
            ord.PF_Under_QA__c= ord.PF_Under_QA__c-1;
            if(MapAssetValue.get(AssetRecord.Id)=='QA Pass'){
                if(ord.PF_Approved_Quantity__c!=null ) ord.PF_Approved_Quantity__c=ord.PF_Approved_Quantity__c+1;
                else ord.PF_Approved_Quantity__c=1;
            }else if(MapAssetValue.get(AssetRecord.Id)=='QA Fail'){
                if(ord.PF_Reject_Quantity__c!=null)ord.PF_Reject_Quantity__c=ord.PF_Reject_Quantity__c+1;
                else ord.PF_Reject_Quantity__c=1;
            }
            update ord;
            AssetRecord.Status=MapAssetValue.get(AssetRecord.Id);
            system.debug(MapAssetValue.get(AssetRecord.Id));
            UpdateAssetList.add(AssetRecord);
        }
        update UpdateAssetList;
        //Update UpdateOrderList;
        return UpdateAssetList;
}

@AuraEnabled
    public static List<OrderItem> retrieveProductNameRecordsInQA(string proIdInQA ){
        return [SELECT Order.Id,Order.OrderNumber,Product2.Id,Order.Status,Order.PF_On_Hand_Received__c, Product2.Name,Order.PF_Pending_Quantity__c,Order.PF_Under_QA__c, Order.PF_Approved_Quantity__c, Order.PF_Reject_Quantity__c from OrderItem WHERE  (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') AND Product2.Name LIKE:proIdInQA order by Order.OrderNumber ASC];    
       
    }

  

    @AuraEnabled
    public static List < OrderItem > fetchSearchResultsDeliveryInfo(String searchKey) {
        String searchReturn = '%'+searchKey+'%';
        system.debug('line230'+searchReturn);

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.PF_Under_QA__c, Order.PF_Order_Quantity__c,Order.Received_Quantity__c,Order.PF_Pending_Quantity__c, Order.Status from OrderItem where Order.OrderNumber like:searchReturn];    
    }

@AuraEnabled
public static void createAsset(String prodId,List<object> batchNumbers,string orderid,date deliverydate) {
        System.debug('Returmnmed cdata'+prodId+''+batchNumbers);
        OrderItem ordObj =[select id,Product2Id,Order.AccountId,Order.Id from OrderItem  where Product2Id=:prodId LIMIT 1];
        PF_Batch_Number__c BNObj = new PF_Batch_Number__c();
        BNObj.PF_Order__c = Id.valueOf(orderid);
        BNObj.Delivery_Date__c = deliverydate;
        insert BNObj;
        List<Asset> assetObjList = new List<asset>();
        integer len = batchNumbers.size();
        //len=len-1;
        list<Product2> pd=[select id,name from Product2 where id=:prodId];
        for(integer i=0;i<len;i++){
            Asset astObj = new Asset();
            astObj.InstallDate = deliverydate;
            astObj.Product2Id = prodId;
            astObj.Name = pd[0].name +' '+ 'Asset Delivery'+' '+i;
            astObj.AccountId=ordObj.Order.AccountId;
            astObj.Quantity=1.00;
            astObj.PF_OrderId__c=Id.valueOf(orderid);
            astObj.PF_SKU_Id__c = (string)batchNumbers[i];
            astObj.PF_Batch_Number__c = BNObj.Id;
            assetObjList.add(astObj);
        }
        System.debug('list'+assetObjList);
        insert assetObjList;
        System.debug('inserted');
        
    
    }

   @AuraEnabled
    public static List<Order> updateOrder(string ordervalue,integer valueRquantity) {
        System.debug('ordervalue :: ' + ordervalue + 'valueee'+ valueRquantity );
        List<Order> ordlistquery = [Select id,Quantity__c,Received_Quantity__c,PF_Under_QA__c,PF_Pending_Quantity__c,Status,PF_Product__c from Order where id=:ordervalue];
        List<Product2> invlist = [SELECT Id,PF_Defective_Quantity__c,PF_Orders_Received__c FROM Product2 WHERE Id = : ordlistquery[0].PF_Product__c ];
        system.debug(invlist);
         list<Product2> newinvlist = new list<Product2>();
         system.debug('ordlistquery :: ' + ordlistquery);
         for (Product2 inv : invlist) {
             inv.PF_Defective_Quantity__c=inv.PF_Defective_Quantity__c-valueRquantity;
             inv.PF_Orders_Received__c=inv.PF_Orders_Received__c+valueRquantity;
            newinvlist.add(inv);
         } 
         update newinvlist; 
        List<Order> updateOrderList = new List<Order>();
        for(Order ord:ordlistquery){
            ord.PF_Under_QA__c= ord.PF_Under_QA__c   + valueRquantity;
            ord.Received_Quantity__c = 0;
            ord.PF_Pending_Quantity__c = ord.PF_Pending_Quantity__c - valueRquantity;
            updateOrderList.add(ord);
            System.debug('line 648'+ord.PF_Pending_Quantity__c);
 

        } 
        system.debug('line 20');
        update  updateOrderList;
        system.debug(updateOrderList);
        system.debug('line 22');  
        return   updateOrderList;  
    }  
    
    @AuraEnabled

    public static Map<ID, String> getRelatedFilesByRecordId(String QuoteId) {
        system.debug('line 551'+QuoteId);
        List<Attachment> files = [SELECT Id,Name FROM Attachment WHERE ParentId = :QuoteId];
        System.debug('files:'+files);
       
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (Attachment docLink : files) {
                mapIdTitle.put(docLink.Id, docLink.Name);
            }
            return mapIdTitle;
}
@AuraEnabled
public static void RejectedQuoteStatusUpdation(List<QuoteLineItem> QuoteLineItemsList){

    /*list<QuoteLineItem> GetQLIList = [select id,Quantity,Finalised__c,PricebookEntryId,Quote.Status,Quote.Id from QuoteLineItem where id=: QLIid ];
    list<QuoteLineItem> UpdateQLIList = new list<QuoteLineItem>();

    GetQLIList[0].Finalised__c=true;
    UpdateQLIList.add(GetQLIList[0]);
    update UpdateQLIList;*/
    List<String> QuoteIdsList = new List<String>();
    for (QuoteLineItem quoteLineItem : QuoteLineItemsList) {
        QuoteIdsList.add(quoteLineItem.QuoteId);
    }
    list<Quote> GetQuoteList = [SELECT Id,Status,OpportunityId FROM Quote WHERE Id IN: QuoteIdsList];
    List<Opportunity> GetOppList = [SELECT Id,StageName   FROM Opportunity WHERE Id =: GetQuoteList[0].OpportunityId];
        List<Opportunity> updateOppList = new List<Opportunity>();
        for (Opportunity opp : GetOppList) {
            opp.StageName = 'Closed Lost';
            updateOppList.add(opp);
            
        }
        update updateOppList;
    list<Quote> UpdateQuoteList = new list<Quote>();
    for (Quote Q : GetQuoteList) {
        Q.Status='Rejected';
        UpdateQuoteList.add(Q);
    }
    update UpdateQuoteList;
}

    @AuraEnabled
    public static List<string> getSupplierNameRecords(){
        List<string> supplierList=new List<string>();
        List<Account> returnlist=[SELECT Id, Name,RecordType.Name FROM Account WHERE RecordType.Name = 'Supplier'];
          for(Account pslist : returnlist)  {
            supplierList.add(pslist.Name);
          }
          return supplierList;
}

@AuraEnabled
    public static void CreateQuoteAndQuoteLineItems(string QuoteId){

        /*list<QuoteLineItem> GetQLIList = [select id,Quantity,Finalised__c,PricebookEntryId,Quote.Status,Quote.Id from QuoteLineItem where id=: QLIid ];
        list<QuoteLineItem> UpdateQLIList = new list<QuoteLineItem>();

        GetQLIList[0].Finalised__c=true;
        UpdateQLIList.add(GetQLIList[0]);
        update UpdateQLIList;*/
        list<Quote> oldQuoteList = [SELECT Id,Name,OpportunityId,Pricebook2Id,PF_Product__r.ProductCode,PF_Order_Quantity__c,PF_Supplier_Account__c,PF_Supplier__c,PF_Supplier_Email__c,PF_Inventory_Manager__c,PF_Product__c FROM Quote WHERE Id = : QuoteId];
        integer num = [SELECT Id,OpportunityId FROM Quote WHERE OpportunityId = : oldQuoteList[0].OpportunityId].size();
        list<Quote> Qlist = new list<Quote>();

        for(Quote qt : oldQuoteList){
            
            Quote q = new Quote();
            
            q.Name= 'QT'+'-'+'{ '+ qt.PF_Product__r.ProductCode+' }'+ '-'+string.valueof(num+=1);
            q.OpportunityId= qt.OpportunityId;
            q.Pricebook2Id= qt.Pricebook2Id;
            q.PF_Revised__c=true;
            //q.AccountId= p.Account__c;
            q.PF_Order_Quantity__c= qt.PF_Order_Quantity__c;
            q.PF_Supplier_Account__c = qt.PF_Supplier_Account__c;
            q.PF_Supplier__c=qt.PF_Supplier__c;
            q.PF_Supplier_Email__c= qt.PF_Supplier_Email__c;
            q.PF_Inventory_Manager__c=qt.PF_Inventory_Manager__c;
            q.PF_Product__c=qt.PF_Product__c;
            //q.Revised_Record__c='Revised';
          //  q.Email_Service_Id__c='	quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
            
            Qlist.add(q);
                   
        }
        insert Qlist;
       
        System.debug('line 34'+Qlist);
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : Qlist[0].PF_Product__c LIMIT 1];
        for(Quote q :Qlist){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.PF_Order_Quantity__c;
            qL.Product2Id = q.PF_Product__c;
            qL.PricebookEntryId =PriceBEntryList[0].Id;

           // qL.ListPrice=PriceBEntryList[0].UnitPrice;
            qlList.add(qL);
        }
        if(!qlList.isEmpty()){
            insert qlList;
        }
        system.debug('qlList'+qlList);



    }
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Order.Status.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;
     }
// @AuraEnabled
//     public static list<Quote> getQuoteLineItems(string productname, string suppliername,string QuoteStatusValue){
//         if(QuoteStatusValue=='Open'){

//             list<Quote> QLinelist =    [select id,Name,QuoteNumber,PF_Order_Quantity__c,Status,PF_Product__r.name,PF_Supplier_Account__r.name from Quote where PF_Product__r.name=:productname and PF_Supplier_Account__r.name=:suppliername and Status =: QuoteStatusValue];

//             return [select id,Name,QuoteNumber,PF_Order_Quantity__c,Status,PF_Product__r.name,PF_Supplier_Account__r.name from Quote];        }
//         else{
//          list<Quote> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where Quote.PF_Product__r.name=:productname and Quote.PF_Supplier_Account__r.name=:suppliername and Quote.Status =: QuoteStatusValue order by Quote.QuoteNumber DESC limit 1 ];


//             return [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.PF_Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.PF_Supplier_Account__r.name,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  = : QLinelist[0].QuoteId];
//         }
//     }

}