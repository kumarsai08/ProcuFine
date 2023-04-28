/*******************************************************************************************************
* 
* @ Name            :   PF_orderdetails
-* @ Purpose        :   It is used in the deliveryinformation component
* @ Author          :   Hima Bindu Vanaparthi
* @ Test Class Name :   Pf_TestClassFor_OrderDetailsClass
*
*   Date            |  Developer Name                |  Version      
* ======================================================================================================
* 16-03-2023     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/
public with sharing class PF_GetSuppleirDetails {
    public static Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
    @AuraEnabled(cacheable=true)
    public static  Map<String,String>  productsuppliers(String Productid) {
        list<Product_Supplier__c> list_productsuppliers= [SELECT 
        Account__c,
        Account__r.Name
        FROM Product_Supplier__c
        WHERE Product__r.id=:Productid];
        Map<String,String> map_NamesList = new  Map<String,String> ();
        for (Product_Supplier__c objproductsupplier : list_productsuppliers) {
            map_NamesList.put(objproductsupplier.Account__c,objproductsupplier.Account__r.Name);
        }
        return map_NamesList; 
    }

    /** 
    * @ description  :  This methodsends an email containing a list of quotes to different suppliers based on their IDs and order quantities.
    *  @params        :   supplierids -  It is used to store list of suppliers Ids
    *  @params        :   Orderquantity -  It is used to store for order input quantity
    *  @params        :   supplierNamesList -  It is used to store list of suppliernames
     *  @params        :   WarehouseName -  It is used to store warehouse name
    **/
    @AuraEnabled
    public static list<Quote> SendAnEmail(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList,String WarehouseName){
        list<Product_Supplier__c> list_Productsupplier= [SELECT 
        Id,
        Account__c,
        Account__r.Email__c,
        Account__r.Name,
        Product__r.Name,
        Product__c,
        Product__r.ProductCode
        FROM Product_Supplier__c
        WHERE  Id in :supplierids ];
        String strproductname = list_Productsupplier[0].Product__r.Name;
        string productcode= list_Productsupplier[0].Product__r.ProductCode;
        Map<String,String> map_MapsupllOrderQ = new Map<String,String>();
        List<PricebookEntry> list_pricebook = [SELECT 
        Id,
        Product2Id,
        Pricebook2Id,
        UnitPrice
        FROM PricebookEntry
        WHERE Product2Id= : list_Productsupplier[0].Product__c LIMIT 1];
        Map<String,Id> map_MapSupplierIdOppId = new Map<String,Id>();        
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            map_MapsupllOrderQ.put(supplierNamesList[i],Orderquantity[i]); 
        }
        integer OppListSize=0;
        string strs1= strproductname+' '+WarehouseName;
        list<Opportunity> list_opportunity=[SELECT 
        Name,
        Id 
        FROM Opportunity
        WHERE Name = : strs1];
        if(list_opportunity.size()==0){
            OppListSize = 1;
        }
        else {
            OppListSize = list_opportunity.size();
        }
        List<Opportunity> list_Opportunities = new List<Opportunity>();
        for (String str : supplierNamesList) {
            Opportunity objopportunity=new Opportunity();
            map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Opportunity');
            String strOppRecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Opportunity');
            objopportunity.RecordTypeId = strOppRecordTypeId;
            OppListSize= OppListSize + 1;
            objopportunity.Name=strproductname+' '+WarehouseName+' '+String.valueOf(OppListSize);
            objopportunity.StageName='Prospecting';
            objopportunity.Pricebook2Id= list_pricebook[0].Pricebook2Id;
            objopportunity.CloseDate=System.today() + 90;
            list_Opportunities.add(objopportunity);
            
        }
        insert list_Opportunities;
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            map_MapSupplierIdOppId.put(supplierNamesList[i], list_Opportunities[i].Id);   
        }
        Integer intnum;
        String oppID;        
        list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
        integer listsize=Quoteslist.size();
        if(Quoteslist.isEmpty()){
            intnum=0;
        } else {
            intnum=listsize;
        }
        List<String> straddress = new List<String>(); 
        list<Quote> list_quote = new list<Quote>();    
        for(Product_supplier__c objproductsupplier:list_Productsupplier){
            straddress.add(objproductsupplier.account__r.Email__c);
            Quote objquote = new Quote();
            objquote.Name= 'QT'+'-'+'{ '+productcode+' }'+ '-'+string.valueof(intnum+=1);
            objquote.OpportunityId= map_MapSupplierIdOppId.get(objproductsupplier.Account__r.Name) ;              
            objquote.Pricebook2Id= list_pricebook[0].Pricebook2Id;
            objquote.Order_Quantity__c=decimal.valueOf(map_MapsupllOrderQ.get(objproductsupplier.account__r.Name));
            objquote.Supplier_Account__c = objproductsupplier.Account__c;
            objquote.Supplier__c=objproductsupplier.account__r.Name;
            objquote.supplier_Email__c= objproductsupplier.account__r.Email__c;
            objquote.Inventory_Manager__c=userinfo.getuserId();
            objquote.warehouse__c= WarehouseName;
            objquote.Product__c=objproductsupplier.Product__c;
            list_quote.add(objquote);
        }
        insert list_quote;
        List<QuoteLineItem> list_quotelineitem = new List<QuoteLineItem>();
        List<PricebookEntry> list_PriceBEntry = [SELECT 
        Id,
        Product2Id,
        Pricebook2Id,
        UnitPrice
        FROM PricebookEntry 
        WHERE Product2Id= : list_quote[0].Product__c LIMIT 1];
        for(Quote q :list_quote){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.Order_Quantity__c;
            qL.Product2Id = q.Product__c;
            qL.PricebookEntryId =list_PriceBEntry[0].Id;
            list_quotelineitem.add(qL);
        }
        if(!list_quotelineitem.isEmpty()){
            insert list_quotelineitem;
        }        
        return list_quote;         
    }

  
    @AuraEnabled
    public static list<Quote> GetQuoteDetails(){
        return [SELECT 
        Id,
        Name,
        supplier__c,
        warehouse__c,
        Product__c,
        Order_Quantity__c,
        Inventory_Manager__c
        FROM Quote 
        WHERE Inventory_Manager__c =: userinfo.getuserId()];
    }


    @AuraEnabled
    public static list<Quote> GetQuoteDetailsdummy(){
        return [SELECT 
        Id,
        Name,
        supplier__c,
        warehouse__c 
        FROM Quote   ];
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
    
    /** 
    * @ description  :  This method consists of email and order record is being created and document is attched to that order
    *  @params        :   supplierNamesList -  It is used to store list of suppliers.
     *  @params        :   WarehouseNamesList -  It is used to store list of warehousenames
     *  *  @params        :   quoteId -  It is used to store quoteId.
    **/
    @AuraEnabled
    public static list<Order> OrderRecords(list<string> supplierNamesList, List<String> WarehouseNamesList,String quoteId ){
        List<Order> list_order= new list<Order>();
        list<string> list_productIdsList = new list<string>();
        Map<Id,Decimal> map_MapPidOrderQuantity = new Map<Id,Decimal>();
        list<account> list_account = [SELECT 
        id,
        name,
        Email__c
        FROM account
        WHERE name in : supplierNamesList];
        list<Schema.Location> list_location = [SELECT 
        id,
        name
        FROM Location 
        WHERE name in : WarehouseNamesList];
        map<string ,id> map_supplier = new map<string,id>();
        map<Id, String> map_Email = new map<Id, String>();
        map<string,id> map_location = new map<string,id>();
        List<Quote> list_SelectedQuoteRows =[SELECT 
        id,
        Name,
        Product__c,
        QuoteNumber,
        Supplier__c,
        Supplier_Account__c,
        Order_Quantity__c,
        supplier_Email__c,
        warehouse__c
        FROM Quote  
        WHERE Id=:quoteId];
        map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Order');
        String RecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Orderr');
        for(account objAccount : list_account){
            map_supplier.put(objAccount.name,objAccount.id); 
            map_Email.put(objAccount.id,objAccount.Email__c);
        }
        for(Schema.Location objlocation : list_location){
            map_location.put(objlocation.name,objlocation.id);
        }
        List<PricebookEntry> list_PriceBEntryList = [SELECT 
        Id,
        Product2Id,
        Pricebook2Id
        FROM PricebookEntry 
        WHERE Product2Id= : list_SelectedQuoteRows[0].Product__c];
        for (Quote objquote : list_SelectedQuoteRows) {
            order objorder = new order();
            objorder.AccountId = objquote.Supplier_Account__c;
            objorder.Status='Order Placed';
            objorder.Type='Procured';
            objorder.Product__c=objquote.Product__c;
            objorder.QuoteId = quoteId;
            objorder.EffectiveDate= System.today();
            objorder.Warehouse__c= map_location.get(objquote.warehouse__c);
            objorder.Order_Quantity__c=objquote.Order_Quantity__c;
            objorder.Account_Email__c = objquote.supplier_Email__c;
            objorder.Pricebook2Id=list_PriceBEntryList[0].Pricebook2Id;
            objorder.RecordTypeId=recordTypeId;
            if(list_productIdsList.contains(objquote.Product__c)){   
            }else {
                list_productIdsList.add(objquote.Product__c);
            }
            if(map_MapPidOrderQuantity.containsKey(objquote.Product__c)){
                Decimal OrderQUpdation = map_MapPidOrderQuantity.get(objquote.Product__c);
                OrderQUpdation = OrderQUpdation + objquote.Order_Quantity__c;
                map_MapPidOrderQuantity.put(objquote.Product__c, OrderQUpdation);
            }else{
                map_MapPidOrderQuantity.put(objquote.Product__c, objquote.Order_Quantity__c);//mapsupp
            }        
            list_order.add(objorder);  
        }
        insert list_order;
        list<Inventory__c> list_GetProductInventoryList = [SELECT 
        Id,
        Name,
        On_Order__c,
        Product__c
        FROM Inventory__c 
        WHERE Product__c IN : list_productIdsList];
        list<Inventory__c> list_UpdateProductInventoryList = new list<Inventory__c>();
        list<attachment>  list_attachment=new list<attachment>();
        list<OrderItem>  list_OrdProductList =new list<OrderItem>();
        list<String> list_Orderidslist = new List<String>();
        for (Order objorder : list_order) {
            list_Orderidslist.add(objorder.Id);
            OrderItem objordproduct = new OrderItem();
            objordproduct.OrderId=objorder.Id;
            objordproduct.Product2Id=objorder.Product__c;
            objordproduct.Quantity=objorder.Order_Quantity__c;
            String entryId=[SELECT
            Id
            FROM PricebookEntry 
            Where Product2Id=:objorder.Product__c LIMIT 1].Id;
            objordproduct.PricebookEntryId=entryId;
            
            objordproduct.UnitPrice=[SELECT 
            UnitPrice
             FROM PricebookEntry
            WHERE Product2Id=:objorder.Product__c LIMIT 1].UnitPrice;
            list_OrdProductList.add(objordproduct);
        }
        insert list_OrdProductList;
        List<Order> list_Ord = [SELECT 
        Name,
        Id,
        EffectiveDate,
        OrderNumber,
        Product__c,
        Account_Email__c,
        Order_Quantity__c,
        Warehouse__c,
        Account.Name,
        Product__r.Name,
        Warehouse__r.Name 
        FROM Order
         WHERE Id in : list_Orderidslist];
        
        for (Order objOrder : list_Ord) {
            System.debug('Order:'+objOrder.AccountId);
            string body='<p> Hello  ' + objOrder.Account.Name +'</p>'
            +'<p>Greetings!</p>'
            +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc, We  are pleased with your quote details and have deicded to accept your offer '
            
            +'Details of our Order requirements are as follows:!</p>' +
            
            '<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <th style="border: 1px solid #dddddd;padding: 5px;">Location</th></tr> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+objOrder.Product__r.Name  +'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+objOrder.Order_Quantity__c+'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+objOrder.Warehouse__r.Name    +'</td> </tr>  </table>'+
            
            '<p>Could you please share current availability, best prices and delivery details (lead time, delivery schedule etc.) so that we can take this conversation forward?</p>'+
            
            
            '<p>Looking forward to your reply.</p>'+ 
            '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
            'P.S. Please Reply All on this email with the details and do not change the subject';
            Blob bln=blob.toPDF(body); 
            string strName = ''+objOrder.OrderNumber+'-' + objOrder.Account.Name+ '.pdf';
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = strName; 
            cVersion.Title = strName;//Name of the file
            cVersion.VersionData =bln ;//File content
            Insert cVersion;
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = objOrder.Id;//Add attachment parentId
            cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
            cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
            Insert cDocLink;
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            list<string> emailsaddress=new list<String>();
            string BodyHtml;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Products Required, Sent Quote details accepted');
            mail.setToAddresses(new List<String>{map_Email.get(objOrder.AccountId)});
            System.debug('Email :'+map_Email.get(objOrder.AccountId));
            BodyHtml= '<p> Hello  ' + objOrder.Account.Name +'</p>'
            +'<p>Greetings!</p>'
            +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc,My team and I reviewed the documents you sent and were very happy with what we read. We are excited at the prospect of using your product .'
            +'More details of our requirements are as follows:!</p>' +
            '<p>We want the said quantity of Products and hope it will be delivered soon </p>'+
            '<p>Looking forward to your reply.</p>'+ 
            '<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
            '<p>P.S. Please Reply All on this email with the details and do not change the subject.</p>';
            mail.sethtmlbody(BodyHtml);
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(strName);
            efa.setBody(bln);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
             //Messaging.SingleEmailMessage[] mails =  new List<Messaging.SingleEmailMessage> {mail};
            //Messaging.SendEmailResult[] result= Messaging.sendEmail(mails);                
        }
        return list_order;
    }

    /** 
    * @ description  :  This method is used in order datattable and retrieves a list of Order records based on a specific order type name.
    *  @params        :   Ordertypename -  It is used to 
    **/
    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(string Ordertypename){
        return [SELECT 
        Name,
        Id,
        Type,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name
        FROM Order
        WHERE Type=:Ordertypename ]; 
    }
    @AuraEnabled
    public static void sendemailtosuppliers(list<string> suppliernames){  
    }
    
    @AuraEnabled(Cacheable = true)
    public static list<Order> searchOrders(String SupplierName,string Ordertypename) {
        SupplierName = '%' + SupplierName + '%';
        list<Order> list_Orderslist = [SELECT 
        Name,
        Id,
        Type,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name 
        FROM Order
        WHERE (Account.Name LIKE :SupplierName ) 
        AND Type=:Ordertypename ];
        
        if(list_Orderslist.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return list_Orderslist; 
    }
    

    @AuraEnabled
    public static list<OpportunityLineItem> opprecords(string productname){
        return [SELECT 
        id,
        Opportunity.name,
        Opportunity.TotalOpportunityQuantity,
        Quantity,
        Product2.name,
        OpportunityId,
        Opportunity.Account.Name,
        Opportunity.CloseDate,
        Opportunity.OrderNumber__c,
        Opportunity.StageName,
        Opportunity.Delivery_Status__c
        FROM OpportunityLineItem 
        WHERE Product2.name=: productname 
        AND Opportunity.StageName='Closed Won' ];                    
    }
    
    /** 
    * @ description  :  This method retrieves a list of Inventory__c records based on a specific product name and warehouse name, while excluding any records where either the product name or warehouse name is null.
    *  @params        :   pname -  It is used to store product name
    *  @params        :   wname -  It is used to store Warehouse name
    **/
    @AuraEnabled
    public static List <Inventory__c> GetSupplierrDetailsfornewtable(String pname,string wname) {
        return[SELECT 
        Id,
        Product__r.name,
        Exsisting_Stock_On_Hand__c,
        On_Order__c,
        Order__c,
        Threshold__c,
        Shortfall__c,
        Quantity__c,
        Warehouse__r.Name,
        Product__r.UoM__c
        from Inventory__c 
        WHERE Product__r.name=:pname
        AND Warehouse__r.Name = :wname 
        AND Product__r.name!=null
        AND Warehouse__r.Name!=null ];     
    } 
    
    /** 
    * @ description  :  This method   retrieves a list of Product_Supplier__c records based on a specific product name and orders them by the grade of the account associated with each record.
    *  @params        :   pnamee -  It is used to store productname
    **/
    @AuraEnabled(cacheable=true)
    public static List < Product_Supplier__c> supplierSection(String pnamee) {
        return[SELECT Id,
        Name,
        Product__r.name,
        Account__r.Name,
        Quantity__c,
        Account__r.grade__c
        FROM Product_Supplier__c 
        WHERE Product__r.name=:pnamee
        ORDER BY Account__r.grade__c
        ];
    }

    /** 
    * @ description  :  This method retrieves a list of Product_Supplier__c records based on a search for a specific product name and a partial match of the account name.
    *  @params        :   searchsname -  It is used to store product name
     *  @params        :   pnamee -  It is used to store changed product
    **/
    @AuraEnabled(cacheable=true)
    public static List < Product_Supplier__c> retrieveRecords(String searchsname ,String pnamee ) {
        return[SELECT Id,
        Name,
        Product__r.name,
        Account__r.Name,
        Account__r.grade__c
        FROM Product_Supplier__c 
        WHERE Product__r.name=:pnamee
        AND Account__r.Name LIKE :searchsname];   
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> supplierSearchFilter() {
        List<Account> list_SupplierNamesList = [SELECT 
        Id,
        Name,
        RecordType.Name
        FROM Account
        WHERE RecordType.Name = 'Supplier'];
        list<String> list_Snameslist = new list<String>();
        for (Account objsupplier : list_SupplierNamesList) {
            list_Snameslist.add(objsupplier.Name);   
        }
        return list_Snameslist;
    }
    
    /** 
    * @ description  :  This method  takes one input parameter "pnamee" and returns a list of supplier names as strings for the specified product name "pnamee".
    *  @params        :   pnamee -  It is used to store product anme
    **/
    @AuraEnabled(cacheable=true)
    public static List <String> supplierNamesList(String pnamee) {
        list<Product_Supplier__c> list_productsupplier = [SELECT 
        Id,
        Name,
        Product__r.name,
        Account__r.Name
        from Product_Supplier__c
        WHERE Product__r.name=:pnamee ];
        List<string> supnameslist = new List<string>();
        for (Product_Supplier__c objproductsupplier : list_productsupplier) {
            supnameslist.add(objproductsupplier.Account__r.Name);
        }
        return supnameslist; 
    }

    /** 
    * @ description  :  This method that takes four input parameters and returns a list of QuoteLineItem objects based on the specified filter criteria.
    *  @params        :   productname -  It is used to store productname
    *  @params        :   suppliername -  It is used to store suppliername
    *   @params        :   warehouse -  It is used to store warehouse name
    *   @params        :   QuoteStatusValue -  It is used to store quotestatus
    **/
    @AuraEnabled
    public static list<QuoteLineItem> PFGetQuoteLineItems(string productname, string suppliername,string warehouse,string QuoteStatusValue){
        if(QuoteStatusValue=='Open'){
            List<String> list_QuoteIdsList = new List<String>();
            list<QuoteLineItem> list_QLinelist = [SELECT 
            id,
            Quantity,
            LineNumber,
            UnitPrice,
            ListPrice,
            Quote.Product__r.name,
            QuoteId,
            Finalised__c,
            PricebookEntryId,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber,
            Quote.Opportunity.StageName
            FROM QuoteLineItem 
            WHERE Quote.Product__r.name=:productname
            AND Quote.Supplier_Account__r.name=:suppliername 
            AND Quote.warehouse__c =:warehouse 
            AND Quote.Status =: QuoteStatusValue   ];
            for (QuoteLineItem objquotelineitem : list_QLinelist) {
                list_QuoteIdsList.add(objquotelineitem.QuoteId);
                
            }
            return [SELECT id,
            Quantity,
            LineNumber,
            Quote.Expected_delivery_date__c,
            Quote.Product__c,
            UnitPrice,
            Description,
            ListPrice,
            Discount,
            TotalPrice,
            Quote.Product__r.name,
            QuoteId,
            Finalised__c,
            PricebookEntryId,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber
            FROM QuoteLineItem 
            WHERE QuoteId  IN : list_QuoteIdsList
            ORDER BY Quote.QuoteNumber ASC ]; 
        }
        else if(QuoteStatusValue=='Closed'){
            List<String> list_QuoteIdsList = new List<String>();
            list<QuoteLineItem> list_QLinelist =[SELECT 
            id,
            Quantity,
            LineNumber,
            UnitPrice,
            ListPrice,
            Quote.Product__r.name,
            QuoteId,
            Finalised__c,
            PricebookEntryId,
            Quote.Opportunity.StageName,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber
            FROM QuoteLineItem 
            WHERE Quote.Product__r.name=:productname
            AND Quote.Supplier_Account__r.name=:suppliername 
            AND Quote.warehouse__c =:warehouse
            AND Quote.Opportunity.StageName='Closed Won'
            ORDER BY Quote.QuoteNumber  ];
            for (QuoteLineItem objquotelineitem : list_QLinelist) {
                list_QuoteIdsList.add(objquotelineitem.QuoteId);
            }
            return [SELECT 
            id,
            Quantity,
            LineNumber,
            UnitPrice,
            Quote.Expected_delivery_date__c,
            Quote.Product__c,
            ListPrice,
            TotalPrice,
            Description,
            Discount,
            Quote.Product__r.name,
            QuoteId,
            Finalised__c,
            PricebookEntryId,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber
            FROM QuoteLineItem 
            WHERE QuoteId  in : list_QuoteIdsList 
            ORDER BY LineNumber ASC];
        }else{
            List<String> list_QuoteIdsList = new List<String>();
            list<QuoteLineItem> list_QLinelist = [SELECT 
            id,
            Quantity,
            LineNumber,
            UnitPrice,
            ListPrice,
            Quote.Product__r.name,
            QuoteId,
            Finalised__c,
            PricebookEntryId,
            Quote.Opportunity.StageName,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber 
            FROM QuoteLineItem 
            WHERE Quote.Product__r.name=:productname
            AND Quote.Supplier_Account__r.name=:suppliername 
            AND Quote.warehouse__c =:warehouse   
            AND Quote.Opportunity.StageName='Closed Lost'
            ORDER BY Quote.QuoteNumber  ];
            for (QuoteLineItem objquotelineitem : list_QLinelist) {
                list_QuoteIdsList.add(objquotelineitem.QuoteId);
                
            }
            return [SELECT 
            id,
            Quantity,
            LineNumber,
            UnitPrice,
            Quote.Expected_delivery_date__c,
            Quote.Product__c,
            ListPrice,
            TotalPrice,
            Description,
            Discount,
            Quote.Product__r.name,
            QuoteId,Finalised__c,
            PricebookEntryId,
            Quote.Supplier_Account__r.name,
            Quote.warehouse__c,
            Quote.Status,
            Quote.QuoteNumber
            FROM QuoteLineItem 
            WHERE QuoteId in : list_QuoteIdsList 
            ORDER BY LineNumber ASC];
            
        }
    }

    /** 
    * @ description  :  This method updates the Quantity, sales price, discount, description, expected delivery date, and order quantity fields of a given Quote Line Item record and its associated Quote record.  
    *  @params        :   quoteLineId -  It is used to store quotelineId 
    *  @params        :   Quantity -  It is used to store inputquantity 
    *  @params        :   salesPrice -  It is used to store listprice
    *  @params        :   discount -  It is used to store discount
    *  @params        :   lineIemDescription -  It is used to store description
    *  @params        :   estimateddeliverydate -  It is used to store date
    **/
    @AuraEnabled
    public static void CreateQuotelineitems(string quoteLineId,integer Quantity,integer salesPrice,Decimal discount,String lineIemDescription , date estimateddeliverydate){
        List<QuoteLineItem> list_quotelineitem = new List<QuoteLineItem>();
        List<Quote> quotelist = new List<Quote>();
        list<QuoteLineItem> list_oldqlList = [SELECT 
        Id,
        QuoteId,
        UnitPrice,
        Quantity,
        Discount,
        Description
        FROM QuoteLineItem
        WHERE Id = : quoteLineId ];
        list<Quote> list_oldQuoteList = [SELECT 
        Id,
        Order_Quantity__c,
        Expected_delivery_date__c
        FROM Quote 
        WHERE Id = : list_oldqlList[0].QuoteId];
        for (Quote objquote : list_oldQuoteList) {
            objquote.Order_Quantity__c=Quantity;
            objquote.Expected_delivery_date__c = estimateddeliverydate;
            quotelist.add(objquote);
        }
        for (QuoteLineItem objquotelineitem : list_oldqlList) {
            objquotelineitem.UnitPrice =salesPrice;
            objquotelineitem.Quantity =Quantity;
            objquotelineitem.Discount = discount;
            objquotelineitem.Description = lineIemDescription;
            list_quotelineitem.add(objquotelineitem);
        }
        update list_quotelineitem;
        update quotelist; 
    }
    
    /** 
    * @ description  :  This method updates the status of a given Quote record to "Closed" and updates the status of all other Quote records in a given list to "Rejected", while also updating the StageName of the Opportunity associated with the given Quote record to "Closed Won".
    *  @params        :   QId -  It is used to store place orderId
     *  @params        :   Qlist -  It is used to store list of quotes
    **/
    @AuraEnabled
    public static void UpdateQuoteLineItemAndQuoteStatus(string QId,List<String> Qlist){
        System.debug(Qlist);                
        list<Quote> list_GetQuoteList = [SELECT 
        Id,
        Status,
        OpportunityId
        FROM Quote
        WHERE Id =: QId];
        List<Opportunity> list_GetOppList = [SELECT 
        Id,
        StageName
        FROM Opportunity
        WHERE Id =: list_GetQuoteList[0].OpportunityId];
        List<Opportunity> list_updateOppList = new List<Opportunity>();
        for (Opportunity objopportunity : list_GetOppList) {
            objopportunity.StageName = 'Closed Won';
            list_updateOppList.add(objopportunity);    
        }
        update list_updateOppList;                    
        list<Quote> list_UpdateQuoteList = new list<Quote>();
        list_GetQuoteList[0].Status='Closed';
        list_UpdateQuoteList.add(list_GetQuoteList[0]);
        list<Quote> list_GetOtherQuotesList = [SELECT 
        Id,
        Status 
        FROM Quote
        WHERE Id in : Qlist];
        for (Quote objquote : list_GetOtherQuotesList) {
            if(objquote.Id!=QId){
                objquote.Status='Rejected';
                list_UpdateQuoteList.add(objquote);
            } 
        }
        update list_UpdateQuoteList;  
    }
    
    /** 
    * @ description  :  This method  retrieves the names and IDs of all attachments and content files related to a given Quote record ID and returns them as a Map of ID to title
    *  @params        :   QuoteId -  It is used to store quote id
    **/
    @AuraEnabled
    public static Map<ID, String> getRelatedFilesByRecordId(String QuoteId) {        
        List<Attachment> list_attachment = [SELECT 
        Id,
        Name
        FROM Attachment
        WHERE ParentId = :QuoteId];
        Map<ID, String> list_mapIdTitle = new Map<ID, String>();
        for (Attachment docLink : list_attachment) {
            list_mapIdTitle.put(docLink.Id, docLink.Name);
        }
        
        List<ContentDocumentLink> list_Contentfiles = [SELECT 
        ContentDocumentId
        FROM ContentDocumentLink
        WHERE LinkedEntityId = :QuoteId];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink doc : list_Contentfiles) {
            fileIDs.add(doc.ContentDocumentId);
        }
        List<ContentVersion> list_contentversion = [SELECT 
        ContentDocumentId,
        FileExtension,
        Title 
        FROM ContentVersion
        WHERE ContentDocumentId IN : fileIDs];
        for (ContentVersion docLinkCV : list_contentversion) {
            list_mapIdTitle.put(docLinkCV.ContentDocumentId, docLinkCV.Title);
        }
        return list_mapIdTitle;
    }

    /** 
    * @ description  :  This method updates the status of rejected quotes and the stage name of their associated opportunity to "Closed Lost".
    *  @params        :   QuoteLineItemsList -  It is used to store list of quotelineitems
    **/
    @AuraEnabled
    public static void RejectedQuoteStatusUpdation(List<QuoteLineItem> QuoteLineItemsList){
        List<String> list_QuoteIdsList = new List<String>();
        for (QuoteLineItem quoteLineItem : QuoteLineItemsList) {
            list_QuoteIdsList.add(quoteLineItem.QuoteId);     
        }
        list<Quote> list_GetQuoteList = [SELECT 
        Id,
        Status,
        OpportunityId 
        FROM Quote
        WHERE Id IN: list_QuoteIdsList];
        List<Opportunity> list_GetOppList = [SELECT
        Id,
        StageName
        FROM Opportunity 
        WHERE Id =: list_GetQuoteList[0].OpportunityId];
        List<Opportunity> list_updateOppList = new List<Opportunity>();
        for (Opportunity objopportunity : list_GetOppList) {
            objopportunity.StageName = 'Closed Lost';
            list_updateOppList.add(objopportunity); 
        }
        update list_updateOppList;
        list<Quote> list_UpdateQuoteList = new list<Quote>();
        for (Quote objquote : list_GetQuoteList) {
            objquote.Status='Rejected';
            list_UpdateQuoteList.add(objquote);
        }
        update list_UpdateQuoteList;
    }
    
    /** 
    * @ description  :  This method is used in supplierDatatable and creates a new Quote record and its related QuoteLineItem records from an existing Quote record identified by the given QuoteId.   
    *  @params        :   QuoteId -  It is used to store quoteid 
    **/
    @AuraEnabled
    public static void CreateQuoteAndQuoteLineItems(string QuoteId){
        list<Quote> list_oldQuoteList = [SELECT 
        Id,
        Name,
        OpportunityId,
        Pricebook2Id,
        Product__r.ProductCode,
        Order_Quantity__c,
        Supplier_Account__c,
        Supplier__c,
        supplier_Email__c,
        Inventory_Manager__c,
        warehouse__c,
        Product__c 
        FROM Quote
        WHERE Id = : QuoteId];
        integer num = [SELECT 
        Id,
        OpportunityId
        FROM Quote
        WHERE OpportunityId = : list_oldQuoteList[0].OpportunityId].size();
        list<Quote> list_Qlist = new list<Quote>();
        for(Quote objquote : list_oldQuoteList){
            Quote objquo = new Quote();
            objquo.Name= 'QT'+'-'+'{ '+ objquote.Product__r.ProductCode+' }'+ '-'+string.valueof(num+=1);
            objquo.OpportunityId= objquote.OpportunityId;
            objquo.Pricebook2Id= objquote.Pricebook2Id;
            objquo.Revised__c = true;    
            objquo.Order_Quantity__c= objquote.Order_Quantity__c;
            objquo.Supplier_Account__c = objquote.Supplier_Account__c;
            objquo.Supplier__c=objquote.Supplier__c;
            objquo.supplier_Email__c= objquote.supplier_Email__c;
            objquo.Inventory_Manager__c=objquote.Inventory_Manager__c;
            objquo.warehouse__c= objquote.warehouse__c;
            objquo.Product__c=objquote.Product__c;
            //  q.Email_Service_Id__c='	quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
            list_Qlist.add(objquo);
        }
        insert list_Qlist;
        List<QuoteLineItem> list_qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT 
        Id,
        Product2Id,
        Pricebook2Id,
        UnitPrice
        FROM PricebookEntry 
        WHERE Product2Id= : list_Qlist[0].Product__c LIMIT 1];
        for(Quote objquote :list_Qlist){
            QuoteLineItem objquotelineitem = new QuoteLineItem();
            objquotelineitem.UnitPrice =0;
            objquotelineitem.QuoteId = objquote.Id;
            objquotelineitem.Quantity = objquote.Order_Quantity__c;
            objquotelineitem.Product2Id = objquote.Product__c;
            objquotelineitem.PricebookEntryId =PriceBEntryList[0].Id;
            list_qlList.add(objquotelineitem);
        }
        if(!list_qlList.isEmpty()){
            insert list_qlList;
        } 
    }
    
    /** 
    * @ description  :  This method retrieves a map of Attachment records' IDs and names related to a given QuoteId.
    *  @params       :   QuoteId -  It is used to store quoteid
    **/
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> get(String QuoteId) {
        system.debug('line 551'+QuoteId);       
        List<Attachment> list_files = [SELECT 
        Id,
        Name
        FROM Attachment
        WHERE ParentId = :QuoteId];
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (Attachment docLink : list_files) {
            mapIdTitle.put(docLink.Id, docLink.Name);
        }
        return mapIdTitle;
    }

    /** 
    * @ description  :  This method  returns a list of Asset records where the given Product2Id matches, the status is 'QA Pass', and the Batch Number lookup is not null, sorted by the InstallDate field
    *  @params        :   productid -  It is used to store the product
    **/
    @AuraEnabled(cacheable=true)
    public static list<Asset> GetAssetRecordsFromProduct(String productid) {     
        List<Asset> list_AssetRecords = [SELECT 
        Id,
        Name,
        Batch_Number_lookup__c,
        Batch_Number_lookup__r.Name,
        Status,
        Batch_Number_lookup__r.Child_Assets_Count__c,
        InstallDate,
        Product2Id 
        FROM Asset
        WHERE Product2Id = :productid
        AND Status='QA Pass' 
        AND Batch_Number_lookup__c!= null ORDER BY InstallDate];
        return list_AssetRecords;  
    }

   
    @AuraEnabled(cacheable=true)
    public static list<OpportunityLineItem> GetProductIdFromOppProductUsingOpportunity(String OppId) {       
        List<OpportunityLineItem> list_OppProductList = [SELECT 
        Id,
        OpportunityId,
        Product2Id 
        FROM OpportunityLineItem
        WHERE OpportunityId = :OppId];
        return list_OppProductList;
    }
    
}