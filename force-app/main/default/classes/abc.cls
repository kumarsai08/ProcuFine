public class abc {
                    public static Map<String, Id> getRecordTypeDeveloperNameIdMap(String strObjectName) {
                        try{
                    Schema.DescribeSObjectResult objDescribeSObjectResult = Schema.getGlobalDescribe().get(strObjectName).getDescribe();
                    Map<String, RecordTypeInfo> map_RecordTypeInfoByName = objDescribeSObjectResult.getRecordTypeInfosByDeveloperName();
                    Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
                    for (RecordTypeInfo objRecordTypeInfo : map_RecordTypeInfoByName.values()) {
                        map_RecordTypeIdByDeveloperName.put(objRecordTypeInfo.getDeveloperName(), objRecordTypeInfo.getRecordTypeId());
                    }}
                         catch(exception ex)
        {
            new CustomLogException().Log(ex);
               
                
        }
                    
                    return map_RecordTypeIdByDeveloperName;
                }
    public static Map<String, Id> map_RecordTypeIdByDeveloperName = new Map<String, Id>();
    @AuraEnabled(cacheable=true)
    public static  Map<String,String>  GetSuppleirDetails(String Productid) {
         Map<String,String> NamesList = new  Map<String,String> ();
        try{
        list<Product_Supplier__c> PSList= [Select Account__c,Account__r.Name From Product_Supplier__c Where Product__r.id=:Productid];
       
        for (Product_Supplier__c PS : PSList) {
            NamesList.put(PS.Account__c,PS.Account__r.Name);
        }
        }
         catch(exception ex)
        {
            new CustomLogException().Log(ex);
               
                
        }
        return NamesList;
        
    }
 public static list<Quote> SendAnEmail(list<String> supplierids,list<String> Orderquantity,list<string> supplierNamesList,String WarehouseName){
        system.debug('LINE 15' + supplierids);
        system.debug(supplierNamesList);
      List<QuoteLineItem> qlList = new List<QuoteLineItem>();
                         list<Quote> Qlist = new list<Quote>();    
     try{
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
        
        
            Integer num;
            String oppID;
            
            system.debug('LINE 15' + supplierids);
            
            
                    
                    list<Quote> Quoteslist= [SELECT Name,Id,OpportunityId,Opportunity.Name FROM Quote WHERE OpportunityId =: oppID];
                    integer listsize=Quoteslist.size();
                    if(Quoteslist.isEmpty()){
                        num=0;
                    } else {
                        
                        
                        num=listsize;
                        
                        
                    }
                    
                    
                    List<String> address = new List<String>(); 

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
      catch(exception ex)
        {
            new CustomLogException().Log(ex);
               
                
        }
                    

                    
                    return Qlist;    
                    
                    
                    
                }
}