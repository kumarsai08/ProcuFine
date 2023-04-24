public  class AssetWrapperClass {
    public static list<AssetReturnObject> ReturnAssetList = new list<AssetReturnObject>();
    
    @AuraEnabled
    public static void AssetValuesQA() { 
        
        try{//list<AssetReturnObject>
        Set<Id> orderidList=(new Map<Id,SObject>([SELECT Order.Id from OrderItem WHERE Order.Status='Partial Quantity Under QA' or Order.Status='Fully Received Under QA' ])).keySet();
        system.debug('orderidList :: ' + orderidList);
        AssetReturnObject assetReturn= new AssetReturnObject();
        Map<id,integer> underQAQty = new Map<id,integer> ();
        for(Id ord:orderidList){
             underQAQty.put(ord,Database.countQuery('select count() from Asset Where Order_Id__c =: ord and Status=\'QA Pass\''));
          //  assetReturn.QAPassQuantity.put(ord,Database.countQuery('select count() from Asset Where Order_Id__c =: ord and Status=\'QA Pass\''));
           // assetReturn.QAFailQuantity.put(ord,Database.countQuery('select count() from Asset Where Order_Id__c =: ord and Status=\'QA Fail\''));
        }
       assetReturn.orderItemList=[SELECT Order.OrderNumber, Product2.Name,Order.Pending_Quantityy1__c,Order.Id,Order.Under_QA__c, Product2.Approved_Quantity__c, Product2.Rejected_Quantity__c from OrderItem where Order.Status='Partial Quantity Under QA' or Order.Status='Fully Received Under QA' ];
        System.debug('Progress:'+underQAQty);
        //System.debug('Pass:'+assetReturn.QAPassQuantity);
        // System.debug('Fail:'+assetReturn.QAFailQuantity);
		//ReturnAssetList.add(assetReturn);
        //list<Asset> AssetList=[SELECT Count(Id),Order_Id__c from Asset Where Order_Id__c IN : orderidList AND status = 'QA In Progress' GROUP BY Order_Id__c];    
        //return ReturnAssetList;
    }
    catch(exception ex)
    {
        new CustomLogException().Log(ex);
           
            
    }
    }
 
    public class AssetReturnObject {
         @AuraEnabled
        public List < OrderItem > orderItemList;
         @AuraEnabled
        public Map<id,integer> underQAQuantity;
         @AuraEnabled
        public Map<id,integer> QAPassQuantity;
         @AuraEnabled
        public Map<id,integer> QAFailQuantity;

   }
}