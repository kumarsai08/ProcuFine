public with sharing class assetRecords {
    @AuraEnabled
    public static List < OrderItem > QAManagerOrderPro() {
        
        return [SELECT Order.Id,Order.OrderNumber,Product2.Id,Order.Status,Order.On_Hand_Recieved__c, Product2.Name,Order.Pending_Quantityy1__c,Order.Under_QA__c, Order.Approved_Quantity__c, Order.Reject_Quantity__c from OrderItem WHERE  Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA' order by Order.OrderNumber ASC];    
    }
    
    
    @AuraEnabled
    public static List<Asset> producttoassestrecords(string proId ){
        return[Select Batch_Number__c, Order_Id__c,Batch_Number_lookup__r.Name, Product2.Id, Status,Product2.Name from Asset Where Status='QA In Progress' AND Order_Id__c =: proId AND Batch_Number_lookup__r.Name !=null];
        
    }

    @AuraEnabled
    public static List<Asset> CreateAssetRecords(list<string> assetRecordIds,list<string> statusValues ){

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



    


   
    
   
}