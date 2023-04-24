public with sharing class PF_AssetRecords {
    @AuraEnabled
    public static List < OrderItem > QAManagerOrderPro() {
        
        return [SELECT Order.Id,Order.OrderNumber,Product2.Id,Order.Status,Order.On_Hand_Recieved__c, Product2.Name,Order.Pending_Quantityy1__c,Order.Under_QA__c, Order.Approved_Quantity__c, Order.Reject_Quantity__c from OrderItem WHERE  Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA' order by Order.OrderNumber ASC];    
    }
    
    
    @AuraEnabled
    public static List<Asset> producttoassestrecords(string proId ){
        return[Select SKU_Id__c, Order_Id__c,Batch_Number_lookup__r.Name,Batch_Number_lookup__c,Batch_Number_lookup__r.Delivery_date__c, Product2.Id, Status,Product2.Name from Asset Where Status='QA In Progress' AND Order_Id__c =: proId AND Batch_Number_lookup__r.Name !=null Order by Batch_Number_lookup__r.Delivery_date__c ];
        
    } 
    
    @AuraEnabled
    public static List<Asset> CreateAssetRecords(list<string> assetRecordIds,list<string> statusValues ){
		system.debug('77:'+assetRecordIds);
        system.debug('78:'+assetRecordIds);
        list<Asset> GetAssetRecords = [Select Id,Batch_Number__c, Order_Id__c, Product2.Id, Status from Asset Where Status='QA In Progress' AND Id in : assetRecordIds];
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
            Order ord = [Select Id,Under_QA__c,Approved_Quantity__c,Reject_Quantity__c From Order Where id=:AssetRecord.Order_Id__c];
            ord.Under_QA__c= ord.Under_QA__c-1;
            system.debug('line 33'+ord);
            system.debug('line 34'+ ord.Approved_Quantity__c);
            if(MapAssetValue.get(AssetRecord.Id)=='QA Pass'){
                if(ord.Approved_Quantity__c!=null ) ord.Approved_Quantity__c=ord.Approved_Quantity__c+1;
                else ord.Approved_Quantity__c=1;
            }else if(MapAssetValue.get(AssetRecord.Id)=='QA Fail'){
                if(ord.Reject_Quantity__c!=null)ord.Reject_Quantity__c=ord.Reject_Quantity__c+1;
                else ord.Reject_Quantity__c=1;
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
        return [SELECT Order.Id,Order.OrderNumber,Product2.Id,Order.Status,Order.On_Hand_Recieved__c, Product2.Name,Order.Pending_Quantityy1__c,Order.Under_QA__c, Order.Approved_Quantity__c, Order.Reject_Quantity__c from OrderItem WHERE  (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') AND Product2.Name LIKE:proIdInQA order by Order.OrderNumber ASC];    
        
    }




    @AuraEnabled
    public static List<Asset> UpdateFailedAssetRecords(list<string> FailedAssetIds ){
        system.debug(FailedAssetIds);
        //Status='QA Fail' AND

        list<Asset> GetAssetRecords = [Select Id,Batch_Number__c, Batch_Number_lookup__c,Order_Id__c, Product2.Id, Status from Asset Where  Id in : FailedAssetIds];
        system.debug(GetAssetRecords);
        List<String> BatchNumberIds = new List<String>();
        for (Asset ast : GetAssetRecords) {
            BatchNumberIds.add(ast.Batch_Number_lookup__c);
            
        }
        list<Batch_Number__c> GetBatchNumberRecords = [Select Id,Defective_Batch__c ,Order__c,Delivery_date__c FROM Batch_Number__c WHERE Id IN : BatchNumberIds];
        system.debug(GetBatchNumberRecords);
        List<Asset> UpdateAssetList = new List<Asset>();
        List<Batch_Number__c> CreateBatchesList = new List<Batch_Number__c>();

        List<Batch_Number__c> UpdateBatchNumberList = new List<Batch_Number__c>();
    
        Map<String,String> MapParentBatchIdtoChild = new  Map<String,String>();
        for (Batch_Number__c batch : GetBatchNumberRecords) {
           // MapParentBatchIdtoChild.put(arg0, arg1)
           if(batch.Defective_Batch__c ==null){
            Batch_Number__c newbatch = new Batch_Number__c();
            //newbatch.
            newbatch.Order__c = batch.Order__c;
            newbatch.Delivery_date__c = batch.Delivery_date__c;

            CreateBatchesList.add(newbatch);
            


           }



            
        }

        insert CreateBatchesList;
        integer i =0;
        for (Batch_Number__c batchnum : GetBatchNumberRecords) {
            system.debug(batchnum.Id);
            if(batchnum.Defective_Batch__c ==null){
                system.debug('101');
                MapParentBatchIdtoChild.put(batchnum.Id,CreateBatchesList[i].Id);
                i=i+1;
                
    
    
               }else{
                system.debug('108');


                MapParentBatchIdtoChild.put(batchnum.Id,batchnum.Defective_Batch__c);

               }
            
        }
        system.debug('112 '+MapParentBatchIdtoChild);
        



        // if(GetBatchNumberRecords[0].Defective_Batch__c==null){

                
        //         insert newbatch;
        // }
        for (Asset AssetRecord : GetAssetRecords) {
            //if(GetBatchNumberRecords[0].Defective_Batch__c==null){
                AssetRecord.Batch_Number_lookup__c = MapParentBatchIdtoChild.get(AssetRecord.Batch_Number_lookup__c);
                
        //}else{
           // AssetRecord.Batch_Number_lookup__c = MapParentBatchIdtoChild.get(AssetRecord.Batch_Number_lookup__c);
       // }
        UpdateAssetList.add(AssetRecord);

            
        }
        for (Batch_Number__c bn : GetBatchNumberRecords) {
            if(bn.Defective_Batch__c==null){
            bn.Defective_Batch__c = MapParentBatchIdtoChild.get(bn.Id);
            }
            UpdateBatchNumberList.add(bn);
            
        }
        update UpdateAssetList;
        update UpdateBatchNumberList;
        //Update UpdateOrderList;
        return UpdateAssetList;



        
    }



    


   
    
   
}