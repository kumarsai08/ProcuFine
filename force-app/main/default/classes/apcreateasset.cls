public class apcreateasset {
    @AuraEnabled
    public static void createAsset(String prodId,List<Object> batchNumbers,string orderid,date deliverydate) {
       // date ocloseDate = date.newInstance(deliverydate);
        System.debug('Returmnmed cdata'+prodId+''+batchNumbers);
        OrderItem ordObj =[select id,Product2Id,Order.AccountId,Order.Id from OrderItem  where Product2Id=:prodId LIMIT 1];
        Batch_Number__c BNObj = new  Batch_Number__c();
        BNObj.Order__c = Id.valueOf(orderid);
        BNObj.Delivery_date__c = deliverydate;
        insert BNObj;
        List<Asset> assetObjList = new List<asset>();
        integer len = batchNumbers.size();
        //len= len-1;
        list<Product2> pd=[select id,name from Product2 where id=:prodId];
        for(integer i=0;i<len;i++){
            Asset astObj = new Asset();
            astObj.InstallDate = deliverydate;
            astObj.Product2Id = prodId;
            astObj.Name = pd[0].name +' '+ 'Asset Delivery'+' '+i;
            astObj.AccountId=ordObj.Order.AccountId;
            astObj.Quantity=1.00;
            astObj.Order_Id__c=Id.valueOf(orderid);
            astObj.Batch_Number__c = (String)batchNumbers[i];
            astObj.Batch_Number_lookup__c = BNObj.Id;

            assetObjList.add(astObj);
        }
        System.debug('list'+assetObjList);
        insert assetObjList;
        System.debug('inserted');
        
    }

}