public class helloworld{
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
}