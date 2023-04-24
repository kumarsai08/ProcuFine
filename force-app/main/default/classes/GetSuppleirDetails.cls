public with sharing class GetSuppleirDetails {
    public static Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
    @AuraEnabled(cacheable=true)
    public static  Map<String,String>  productsuppliers(String Productid) {
        list<Product_Supplier__c> PSList= [Select Account__c,Account__r.Name From Product_Supplier__c Where Product__r.id=:Productid];
        Map<String,String> NamesList = new  Map<String,String> ();
        for (Product_Supplier__c PS : PSList) {
            NamesList.put(PS.Account__c,PS.Account__r.Name);
        }
        return NamesList;
        
    }
    @AuraEnabled
    public static list<Quote> SendAnEmail(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList,String WarehouseName){
        system.debug('LINE 15' + supplierids);
        system.debug(supplierNamesList);
        list<Product_Supplier__c> PSList1= [Select Id,Account__c,Account__r.Email__c,Account__r.Name,Product__r.Name,Product__c,Product__r.ProductCode From Product_Supplier__c Where  Id in :supplierids ];
        String productname = PSList1[0].Product__r.Name;
        system.debug('line 17'+PSList1[0].Product__r.Name);
        string productcode= PSList1[0].Product__r.ProductCode;
        system.debug('line 17'+PSList1[0].Product__r.ProductCode);
        Map<String,String> MapsupllOrderQ = new Map<String,String>();
        system.debug(WarehouseName);
        List<PricebookEntry> PBList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : PSList1[0].Product__c LIMIT 1];
        Map<String,Id> MapSupplierIdOppId = new Map<String,Id>();
        
        
        system.debug('orderq list '+Orderquantity);
        system.debug('snames list '+supplierNamesList);
        
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            system.debug('line 29 '+supplierNamesList[i]+Orderquantity[i]);
            
            MapsupllOrderQ.put(supplierNamesList[i],Orderquantity[i]);
            
        }
        integer OppListSize=0;
        string s1= productname+' '+WarehouseName;
        list<Opportunity> opplist=[SELECT Name,Id FROM Opportunity WHERE Name = : s1];
        if(opplist.size()==0){
            OppListSize = 1;
        }
        else {
            OppListSize = opplist.size();
        }
        List<Opportunity> OppMapList = new List<Opportunity>();
        system.debug('line 34 '+ MapsupllOrderQ);
        for (String str : supplierNamesList) {
            Opportunity opp=new Opportunity();
            map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Opportunity');
            String OppRecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Opportunity');
            opp.RecordTypeId = OppRecordTypeId;
            OppListSize= OppListSize + 1;
            opp.Name=productname+' '+WarehouseName+' '+String.valueOf(OppListSize);
            opp.StageName='Prospecting';
            opp.Pricebook2Id= PBList[0].Pricebook2Id;
            opp.CloseDate=System.today() + 90;
            OppMapList.add(opp);
            
        }
        insert OppMapList;
        for (Integer i = 0; i < supplierNamesList.size(); i++) {
            system.debug(OppMapList[i]);
            MapSupplierIdOppId.put(supplierNamesList[i], OppMapList[i].Id);
            system.debug(MapSupplierIdOppId);
            
            
            
        }
        
        //for (Product_Supplier__c ps2 : PSList1) {
        
        // }
        
        
        
        
        //string q1='QT'+'-'+'{ '+productname+' }'+ '-'+p.account__r.Name+'-%';
        //List<Quote> Quoteslist=[ SELECT Name,Id FROM QUOTE WHERE Name Like q1];
        //EmailTemplate tempID = [SELECT Id,HTMLValue,Name FROM EmailTemplate WHERE Id =: System.Label.TEMPLATEID];
        //String emailBody = tempID.HTMLValue;
        /*if (Quoteslist.isEmpty()) {
Integer num=0;
} else {
Integer num = Integer.ValueOf(Quoteslist[0].Name.substringAfter('-'));
}*/
        Integer num;
        String oppID;
        
        system.debug('LINE 15' + supplierids);
        
        
        // Opportunity opp=new Opportunity();
        // if (opplist.isEmpty()) {
        
        //     opp.Name=productname+' '+WarehouseName;
        //     opp.StageName='Prospecting';
        //     opp.Pricebook2Id= PBList[0].Pricebook2Id;
        //     opp.CloseDate=System.today() + 90;
        //     insert opp;
        //     oppID=opp.Id;
        
        
        // }else {
        //     oppID=opplist[0].Id;
        // }
        
        list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
        integer listsize=Quoteslist.size();
        if(Quoteslist.isEmpty()){
            num=0;
        } else {
            
            
            num=listsize;
            
            
        }
        
        
        List<String> address = new List<String>(); 
        list<Quote> Qlist = new list<Quote>();    
        for(Product_supplier__c p:PSList1){
            address.add(p.account__r.Email__c);
            Quote q = new Quote();
            system.debug(productcode);
            q.Name= 'QT'+'-'+'{ '+productcode+' }'+ '-'+string.valueof(num+=1);
            system.debug(p.Account__c);
            
            system.debug( MapSupplierIdOppId.get(p.Account__r.Name));
            q.OpportunityId= MapSupplierIdOppId.get(p.Account__r.Name) ;              //Id.valueOf(oppID);
            system.debug(MapsupllOrderQ.get(p.account__r.Name));
            q.Pricebook2Id= PBList[0].Pricebook2Id;
            //q.AccountId= p.Account__c;
            
            
            q.Order_Quantity__c=decimal.valueOf(MapsupllOrderQ.get(p.account__r.Name));
            q.Supplier_Account__c = p.Account__c;
            q.Supplier__c=p.account__r.Name;
            q.supplier_Email__c= p.account__r.Email__c;
            q.Inventory_Manager__c=userinfo.getuserId();
            system.debug('line 91'+WarehouseName);
            q.warehouse__c= WarehouseName;
            q.Product__c=p.Product__c;
            //  q.Email_Service_Id__c='	quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
            
            Qlist.add(q);
            
        }
        insert Qlist;
        System.debug('line33'+address);
        System.debug('line 34'+Qlist);
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : Qlist[0].Product__c LIMIT 1];
        for(Quote q :Qlist){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.Order_Quantity__c;
            qL.Product2Id = q.Product__c;
            
            qL.PricebookEntryId =PriceBEntryList[0].Id;
            // qL.ListPrice=PriceBEntryList[0].UnitPrice;
            qlList.add(qL);
        }
        if(!qlList.isEmpty()){
            insert qlList;
        }
        system.debug('qlList'+qlList);
        
        //String messageBody = '<html><body>Hi, welcome to &nbsp;&nbsp;&nbsp;Our World</body>  </html>';
        
        
        
        /* List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setSubject('Requirement for Products');

//mail.setToAddresses(address);



for(Quote q:Qlist){
String BodyHtml='';
// system.debug('line 34'+q.Id);
// system.debug('line 94 '+q.supplier_Email__c+MapsupllOrderQ.get(q.Supplier__c));

//address.add(q.Supplier_Account__r.Email__c);
mail.setplaintextbody('PLease check for the availability of '+productname +' of the quantity '+ MapsupllOrderQ.get(q.Supplier__c));


mail.setToAddresses(new List<String>{q.supplier_Email__c});

BodyHtml+='<p> Hello  ' + q.Supplier__c +'</p>'
+'<p>Greetings!</p>'
+'<p>I am the inventory manager from Procufine, a procurement management company based in hyderabad..Our company is interested in procuring some of the products that you have to offer.'
+'More details of our requirements are as follows:!</p>' +
'<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <th style="border: 1px solid #dddddd;padding: 5px;">Location</th></tr> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+productname+'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+MapsupllOrderQ.get(q.Supplier__c)+'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+WarehouseName+'</td> </tr>  </table>'+
'<p>Could you please share current availability, best prices and delivery details (lead time, delivery schedule etc.) so that we can take this conversation forward?</p>'+
'<p>Looking forward to your reply.</p>'+ 
'<p>Thanks,<br>Procufine DevOrg<br>Inventory Manager <br> Pro.Inc., Hyderabad <br> (+91)-1234567890!</p>'+
'P.S. Please Reply All on this email with the details and do not change the subject.'+
'<p style="display:none"> quoteid:'+ q.id +'</p>'

;
system.debug(BodyHtml);
mail.setReplyTo('quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com');
mail.setHtmlBody(BodyHtml);

// Messaging.SingleEmailMessage[] mails =  new List<Messaging.SingleEmailMessage> {mail};
// Messaging.SendEmailResult[] result= Messaging.sendEmail(mails);

}


system.debug('line 26');
//Messaging.SendEmailResult[] result= new Messaging.SendEmailResult();
if(!emailList.isEmpty()){
// Messaging.SendEmailResult[] result= Messaging.sendEmail(emailList);
//  System.debug('result:'+ result);
}*/
        
        return Qlist;    
        
        
        
    }
    @AuraEnabled
    public static list<Quote> GetQuoteDetails(){
        system.debug('line 89'+[select Id,Name,supplier__c,warehouse__c,Inventory_Manager__c FROM Quote WHERE Inventory_Manager__c =: userinfo.getuserId()  ]);
        return [select Id,Name,supplier__c,warehouse__c,Product__c,Order_Quantity__c,Inventory_Manager__c FROM Quote WHERE Inventory_Manager__c =: userinfo.getuserId()  ];
    }
    @AuraEnabled
    public static list<Quote> GetQuoteDetailsdummy(){
        return [select Id,Name,supplier__c,warehouse__c FROM Quote   ];
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
    public static list<Order> OrderRecords(list<string> supplierNamesList, List<String> WarehouseNamesList,String quoteId ){
        system.debug('line 112');
        List<Order> ordlist= new list<Order>();
        list<string> productIdsList = new list<string>();
        Map<Id,Decimal> MapPidOrderQuantity = new Map<Id,Decimal>();
        list<account> lstacc = [select id,name,Email__c from account where name in : supplierNamesList];
        list<Schema.Location> lstloc = [select id,name from Location where name in : WarehouseNamesList];
        map<string ,id> mapsupp = new map<string,id>();
        map<Id, String> mapEmail = new map<Id, String>();
        map<string,id> maploc = new map<string,id>();
        List<Quote> SelectedQuoteRows =[select id,Name, Product__c,QuoteNumber,Supplier__c,Supplier_Account__c, Order_Quantity__c, supplier_Email__c,warehouse__c from Quote  where Id=:quoteId];
        map_RecordTypeIdByDeveloperName = getRecordTypeDeveloperNameIdMap('Order');
        String RecordTypeId = map_RecordTypeIdByDeveloperName.get('Purchase_Orderr');
        system.debug('267 '+RecordTypeId);
        for(account acc : lstacc){
            mapsupp.put(acc.name,acc.id); 
            mapEmail.put(acc.id,acc.Email__c);
        }
        for(Schema.Location loc : lstloc){
            maploc.put(loc.name,loc.id);
        }
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id FROM PricebookEntry WHERE Product2Id= : SelectedQuoteRows[0].Product__c];
        
        
        
        for (Quote q : SelectedQuoteRows) {
            order orr = new order();
            //orr.RecordType=
            // mapsupp.get(q.supplier__c)
            orr.AccountId = q.Supplier_Account__c;
            orr.Status='Order Placed';
            orr.Type='Procured';
            orr.Product__c=q.Product__c;
            orr.QuoteId = quoteId;
            orr.EffectiveDate= System.today();
            orr.Warehouse__c= maploc.get(q.warehouse__c);
            orr.Order_Quantity__c=q.Order_Quantity__c;
            orr.Account_Email__c = q.supplier_Email__c;
            orr.Pricebook2Id=PriceBEntryList[0].Pricebook2Id;
            orr.RecordTypeId=recordTypeId;
            if(productIdsList.contains(q.Product__c)){
                
            }else {
                productIdsList.add(q.Product__c);
            }
            
            if(MapPidOrderQuantity.containsKey(q.Product__c)){
                Decimal OrderQUpdation = MapPidOrderQuantity.get(q.Product__c);
                OrderQUpdation = OrderQUpdation + q.Order_Quantity__c;
                MapPidOrderQuantity.put(q.Product__c, OrderQUpdation);
            }else{
                MapPidOrderQuantity.put(q.Product__c, q.Order_Quantity__c);
            }
            //orr.TotalAmount=q.Order_Quantity__c;
            
            ordlist.add(orr);
            
        }
        insert ordlist;
        list<Inventory__c> GetProductInventoryList = [SELECT Id, Name, On_Order__c,Product__c FROM Inventory__c WHERE Product__c IN : productIdsList];
        list<Inventory__c> UpdateProductInventoryList = new list<Inventory__c>();
        list<attachment>  atment=new list<attachment>();
        list<OrderItem>  OrdProductList =new list<OrderItem>();
        
        list<String> Orderidslist = new List<String>();
        for (Order ordd : ordlist) {
            Orderidslist.add(ordd.Id);
            OrderItem ordproduct = new OrderItem();
            ordproduct.OrderId=ordd.Id;
            ordproduct.Product2Id=ordd.Product__c;
            ordproduct.Quantity=ordd.Order_Quantity__c;
            //GetProductInventory.On_Order__c=GetProductInventory.On_Order__c + ordd.Order_Quantity__c;Eee
            
            
            
            String entryId=[SELECT Id FROM PricebookEntry Where Product2Id=:ordd.Product__c LIMIT 1].Id;
            System.debug('Pricebook:'+entryId);
            ordproduct.PricebookEntryId=entryId;
            
            ordproduct.UnitPrice=[SELECT UnitPrice FROM PricebookEntry Where Product2Id=:ordd.Product__c LIMIT 1].UnitPrice;
            OrdProductList.add(ordproduct);
            //  UpdateProductInventoryList.add(GetProductInventory);
            //ordproduct.
        }
        insert OrdProductList;
        // for (Inventory__c inv : GetProductInventoryList) {
        //     inv.On_Order__c=inv.On_Order__c + MapPidOrderQuantity.get(inv.Product__c);
        //     UpdateProductInventoryList.add(inv);
        // }
        
        // Update UpdateProductInventoryList;
        List<Order> Orderslist2 = [SELECT Name,Id,EffectiveDate,OrderNumber,Product__c,Account_Email__c,Order_Quantity__c,Warehouse__c,Account.Name,Product__r.Name,Warehouse__r.Name FROM Order WHERE Id in : Orderidslist];
        
        for (Order o : Orderslist2) {
            // attachment atc=new attachment();
            // atc.ParentId=o.id;
            System.debug('Order:'+o.AccountId);
            string body='<p> Hello  ' + o.Account.Name +'</p>'
                +'<p>Greetings!</p>'
                +'<p>I am from Procufine DevOrg and I am an inventory manager with Pro.Inc, We  are pleased with your quote details and have deicded to accept your offer '
                
                +'Details of our Order requirements are as follows:!</p>' +
                
                '<table style="width:100%;border-collapse:collapse;text-align:left;"> <tr> <th style="border: 1px solid #dddddd;padding: 5px;">Product Name</th> <th style="border: 1px solid #dddddd;padding: 5px;">Order Quantity</th> <th style="border: 1px solid #dddddd;padding: 5px;">Location</th></tr> <tr> <td style="border: 1px solid #dddddd;padding: 5px;">'+o.Product__r.Name  +'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+o.Order_Quantity__c+'</td> <td style="border: 1px solid #dddddd;padding: 5px;">'+o.Warehouse__r.Name    +'</td> </tr>  </table>'+
                
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
            //for(account acc:ac){
            // emailsaddress.add(acc.Email__c);                
            //  }
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
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            // Messaging.SingleEmailMessage[] mails =  new List<Messaging.SingleEmailMessage> {mail};
            //Messaging.SendEmailResult[] result= Messaging.sendEmail(mails);
            
            // emailList.add(mail);
            //}
            //mail.sethtmlbody(BodyHtml);
            
            
            //  if(!emailList.isEmpty()){
            //   Messaging.sendEmail(emailList);
            // }        
            
            
        }
        
        return ordlist;
        
    }
    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(string Ordertypename){
        system.debug('Ordertypename'+Ordertypename);
        return [SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order WHERE Type=:Ordertypename ];
        
        
    }
    @AuraEnabled
    public static void sendemailtosuppliers(list<string> suppliernames){
        
    }
    
    @AuraEnabled(Cacheable = true)
    public static list<Order> searchOrders(String strSupplierName,string Ordertypename) {
        strSupplierName = '%' + strSupplierName + '%';
        list<Order> Orderslist2 = [SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order WHERE (Account.Name LIKE :strSupplierName ) and Type=:Ordertypename ];
        
        if(Orderslist2.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return Orderslist2; 
    }
    
    @AuraEnabled
    public static list<OpportunityLineItem> opprecords(string productname){
        //string p=productname;
        return [SELECT id, Opportunity.name,Opportunity.TotalOpportunityQuantity,Quantity,Product2.name ,OpportunityId,Opportunity.Account.Name,  Opportunity.CloseDate,Opportunity.OrderNumber__c,Opportunity.StageName,Opportunity.Delivery_Status__c FROM OpportunityLineItem WHERE Product2.name=: productname AND Opportunity.StageName='Closed Won' ];
        // 
        
    }
    
    
    @AuraEnabled
    public static List <Inventory__c> GetSupplierrDetailsfornewtable(String pname,string wname) {
        
        return[select Id, Product__r.name, Exsisting_Stock_On_Hand__c,On_Order__c,Order__c, Threshold__c,Shortfall__c, Quantity__c, Warehouse__r.Name,Product__r.UoM__c
               
               from Inventory__c WHERE Product__r.name=:pname AND Warehouse__r.Name = :wname AND Product__r.name!=null AND Warehouse__r.Name!=null ];
        
    }
    
    
    @AuraEnabled(cacheable=true)
    
    public static List < Product_Supplier__c> supplierSection(String pnamee) {
        
        return[select Id,Name, Product__r.name,Account__r.Name,Quantity__c,Account__r.grade__c
               
               from Product_Supplier__c WHERE Product__r.name=:pnamee order by Account__r.grade__c
              ];
        
    }
    
    
    
    
    @AuraEnabled(cacheable=true)
    
    public static List < Product_Supplier__c> retrieveRecords(String searchsname ,String pnamee ) {
        
        
        return[select Id,Name, Product__r.name,Account__r.Name,Account__r.grade__c from Product_Supplier__c WHERE Product__r.name=:pnamee  and Account__r.Name LIKE :searchsname];
        
    }
    
    @AuraEnabled(cacheable=true)
    
    public static List<String> supplierSearchFilter() {
        List<Account> SupplierNamesList = [SELECT Id,Name, RecordType.Name FROM Account WHERE RecordType.Name = 'Supplier'];
        list<String> Snameslist = new list<String>();
        for (Account supplier : SupplierNamesList) {
            Snameslist.add(supplier.Name);
            
        }
        
        return Snameslist;
        
    }
    
    @AuraEnabled(cacheable=true)
    
    public static List <String> supplierNamesList(String pnamee) {
        
        list<Product_Supplier__c>   pslist2=[select Id,Name, Product__r.name,Account__r.Name  from Product_Supplier__c WHERE Product__r.name=:pnamee ];
        List<string> supnameslist = new List<string>();
        for (Product_Supplier__c ps : pslist2) {
            supnameslist.add(ps.Account__r.Name);
        }
        return supnameslist;
        
    }
    @AuraEnabled
    public static list<QuoteLineItem> PFGetQuoteLineItems(string productname, string suppliername,string warehouse,string QuoteStatusValue){
        if(QuoteStatusValue=='Open'){
            List<String> QuoteIdsList = new List<String>();
            
            list<QuoteLineItem> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber, Quote.Opportunity.StageName from QuoteLineItem where Quote.Product__r.name=:productname and Quote.Supplier_Account__r.name=:suppliername and Quote.warehouse__c =:warehouse and Quote.Status =: QuoteStatusValue   ];
            for (QuoteLineItem QLI : QLinelist) {
                QuoteIdsList.add(QLI.QuoteId);
                
            }
            
            return [select id,Quantity,LineNumber,Quote.Expected_delivery_date__c,Quote.Product__c,UnitPrice,Description,ListPrice,Discount,TotalPrice,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  IN : QuoteIdsList order by Quote.QuoteNumber asc ];        }
        else if(QuoteStatusValue=='Closed'){
            List<String> QuoteIdsList = new List<String>();
            list<QuoteLineItem> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId, Quote.Opportunity.StageName,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber from QuoteLineItem where Quote.Product__r.name=:productname and Quote.Supplier_Account__r.name=:suppliername and Quote.warehouse__c =:warehouse   and Quote.Opportunity.StageName='Closed Won'order by Quote.QuoteNumber  ];
            for (QuoteLineItem QLI : QLinelist) {
                QuoteIdsList.add(QLI.QuoteId);
                
            }
            
            return [select id,Quantity,LineNumber,UnitPrice,Quote.Expected_delivery_date__c,Quote.Product__c,ListPrice,TotalPrice,Description,Discount,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  in : QuoteIdsList order by LineNumber asc];
        }else{
            List<String> QuoteIdsList = new List<String>();
            list<QuoteLineItem> QLinelist =    [select id,Quantity,LineNumber,UnitPrice,ListPrice,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId, Quote.Opportunity.StageName,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber from QuoteLineItem where Quote.Product__r.name=:productname and Quote.Supplier_Account__r.name=:suppliername and Quote.warehouse__c =:warehouse   and Quote.Opportunity.StageName='Closed Lost'order by Quote.QuoteNumber  ];
            for (QuoteLineItem QLI : QLinelist) {
                QuoteIdsList.add(QLI.QuoteId);
                
            }
            
            return [select id,Quantity,LineNumber,UnitPrice,Quote.Expected_delivery_date__c,Quote.Product__c,ListPrice,TotalPrice,Description,Discount,Quote.Product__r.name ,QuoteId,Finalised__c,PricebookEntryId,Quote.Supplier_Account__r.name,Quote.warehouse__c,Quote.Status,Quote.QuoteNumber from QuoteLineItem where QuoteId  in : QuoteIdsList order by LineNumber asc];
            
        }
    }
    @AuraEnabled
    public static void CreateQuotelineitems(string quoteLineId,integer Quantity,integer salesPrice,Decimal discount,String lineIemDescription , date estimateddeliverydate){
        System.debug('Insoide CreateQuotelineitems'+ quoteLineId);
        //System.debug('Details'+productname+'__:'+suppliername+'__:'+warehouse+'__:');
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<Quote> quotelist = new List<Quote>();
        
        list<QuoteLineItem> oldqlList = [SELECT Id,QuoteId, UnitPrice,Quantity,Discount,Description FROM QuoteLineItem WHERE Id = : quoteLineId ];
        list<Quote> oldQuoteList = [SELECT Id,Order_Quantity__c,Expected_delivery_date__c FROM Quote WHERE Id = : oldqlList[0].QuoteId];
        for (Quote q : oldQuoteList) {
            q.Order_Quantity__c=Quantity;
            q.Expected_delivery_date__c = estimateddeliverydate;
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
        
        // Qlist.remove();
        
        
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
    public static Map<ID, String> getRelatedFilesByRecordId(String QuoteId) {
        system.debug('line 551'+QuoteId);
        // Get record file IDs        
        List<Attachment> files = [SELECT Id,Name FROM Attachment WHERE ParentId = :QuoteId];
        System.debug('files:'+files);
        /* List<ID> fileIDs = new List<ID>();
for (ContentDocumentLink docLink : files) {
fileIDs.add(docLink.ContentDocumentId);
}

List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];*/
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (Attachment docLink : files) {
            mapIdTitle.put(docLink.Id, docLink.Name);
        }
        
        List<ContentDocumentLink> Contentfiles = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :QuoteId];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink doc : Contentfiles) {
            fileIDs.add(doc.ContentDocumentId);
        }
        
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        // Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion docLinkCV : docs) {
            mapIdTitle.put(docLinkCV.ContentDocumentId, docLinkCV.Title);
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
        
        list<Quote> GetQuoteList = [SELECT Id,Status ,OpportunityId FROM Quote WHERE Id IN: QuoteIdsList];
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
    public static void CreateQuoteAndQuoteLineItems(string QuoteId){
        
        /*list<QuoteLineItem> GetQLIList = [select id,Quantity,Finalised__c,PricebookEntryId,Quote.Status,Quote.Id from QuoteLineItem where id=: QLIid ];
list<QuoteLineItem> UpdateQLIList = new list<QuoteLineItem>();

GetQLIList[0].Finalised__c=true;
UpdateQLIList.add(GetQLIList[0]);
update UpdateQLIList;*/
        list<Quote> oldQuoteList = [SELECT Id,Name,OpportunityId,Pricebook2Id,Product__r.ProductCode,Order_Quantity__c,Supplier_Account__c,Supplier__c,supplier_Email__c,Inventory_Manager__c,warehouse__c,Product__c FROM Quote WHERE Id = : QuoteId];
        integer num = [SELECT Id,OpportunityId FROM Quote WHERE OpportunityId = : oldQuoteList[0].OpportunityId].size();
        list<Quote> Qlist = new list<Quote>();
        
        for(Quote qt : oldQuoteList){
            
            Quote q = new Quote();
            
            q.Name= 'QT'+'-'+'{ '+ qt.Product__r.ProductCode+' }'+ '-'+string.valueof(num+=1);
            q.OpportunityId= qt.OpportunityId;
            
            q.Pricebook2Id= qt.Pricebook2Id;
            q.Revised__c = true;
            //q.AccountId= p.Account__c;
            
            
            q.Order_Quantity__c= qt.Order_Quantity__c;
            q.Supplier_Account__c = qt.Supplier_Account__c;
            q.Supplier__c=qt.Supplier__c;
            q.supplier_Email__c= qt.supplier_Email__c;
            q.Inventory_Manager__c=qt.Inventory_Manager__c;
            
            q.warehouse__c= qt.warehouse__c;
            q.Product__c=qt.Product__c;
            
            //  q.Email_Service_Id__c='	quote_automation@k-cqjr5k147upssfvf9zommipivpinhx2wjv2prh9oj5jqyqnk.5g-i1ljoea3.ap24.apex.salesforce.com';
            
            Qlist.add(q);
            
        }
        insert Qlist;
        
        System.debug('line 34'+Qlist);
        List<QuoteLineItem> qlList = new List<QuoteLineItem>();
        List<PricebookEntry> PriceBEntryList = [SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Product2Id= : Qlist[0].Product__c LIMIT 1];
        for(Quote q :Qlist){
            QuoteLineItem qL = new QuoteLineItem();
            qL.UnitPrice =0;
            qL.QuoteId = q.Id;
            qL.Quantity = q.Order_Quantity__c;
            qL.Product2Id = q.Product__c;
            
            qL.PricebookEntryId =PriceBEntryList[0].Id;
            // qL.ListPrice=PriceBEntryList[0].UnitPrice;
            qlList.add(qL);
        }
        if(!qlList.isEmpty()){
            insert qlList;
        }
        system.debug('qlList'+qlList);
        
        
        
    }
    
    
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> get(String QuoteId) {
        system.debug('line 551'+QuoteId);
        // Get record file IDs        
        List<Attachment> files = [SELECT Id,Name FROM Attachment WHERE ParentId = :QuoteId];
        System.debug('files:'+files);
        /* List<ID> fileIDs = new List<ID>();
for (ContentDocumentLink docLink : files) {
fileIDs.add(docLink.ContentDocumentId);
}

List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];*/
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (Attachment docLink : files) {
            mapIdTitle.put(docLink.Id, docLink.Name);
        }
        return mapIdTitle;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static list<Asset> GetAssetRecordsFromProduct(String productid) {
        system.debug('line 551 :'+productid);
        // Get record file IDs        
        List<Asset> AssetRecords = [SELECT Id,Name,Batch_Number_lookup__c,Batch_Number_lookup__r.Name,Status,Batch_Number_lookup__r.Child_Assets_Count__c,InstallDate,Product2Id FROM Asset WHERE Product2Id = :productid  AND Status='QA Pass' and Batch_Number_lookup__c!= null order by InstallDate];
        System.debug('files:'+AssetRecords);
        
        return AssetRecords;
        
    }
    @AuraEnabled(cacheable=true)
    public static list<OpportunityLineItem> GetProductIdFromOppProductUsingOpportunity(String OppId) {
        system.debug('line 551 :'+OppId);
        // Get record file IDs        
        List<OpportunityLineItem> OppProductList = [SELECT Id,OpportunityId,Product2Id FROM OpportunityLineItem WHERE OpportunityId = :OppId  ];
        
        return OppProductList;
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}