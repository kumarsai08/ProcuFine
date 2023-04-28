/*******************************************************************************************************
* 
* @ Name            :   PF_AssetRecords
* @ Purpose         :    This class is used for displaying data in PFQAManager component. 
* @ Author          :   Hima Bindu Vanaparthi Santhoshi.
* @ Test Class Name :   PF_TestClassFor_AssetRecords
*
*   Date            |  Developer Name               |  Version      
* ======================================================================================================
* 26-12-2022     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/

public with sharing class PF_AssetRecords {
    /**
    * @ description  : This method returns Order Item records with specific order statuses and sorts them by order number.
    **/
    @AuraEnabled
    public static List < OrderItem > QAManagerOrderPro() {
        return [SELECT 
                Order.Id,
                Order.OrderNumber,
                Product2.Id,
                Order.Status,
                Order.On_Hand_Recieved__c,
                Product2.Name,
                Order.Pending_Quantityy1__c,
                Order.Under_QA__c,
                Order.Approved_Quantity__c, 
                Order.Reject_Quantity__c
                FROM OrderItem
                WHERE  Order.Status='Partial Quantity Under QA'
                OR Order.Status='Fully Received Under QA' 
                ORDER BY Order.OrderNumber ASC];    
    }

    /** 
    * @ description  :  This method returns Asset records with a specific Order Id and status, and sorted by the delivery date of the associated Batch Number record
    *  @params        :   proId -  It is used to search for a product
    **/
    @AuraEnabled
    public static List<Asset> producttoassestrecords(string proId ){
        return[SELECT 
                SKU_Id__c, 
                Order_Id__c,
                Batch_Number_lookup__r.Name,
                Batch_Number_lookup__c,
                Batch_Number_lookup__r.Delivery_date__c, 
                Product2.Id,
                Status,
                Product2.Name 
                FROM Asset 
                WHERE Status='QA In Progress'
                AND Order_Id__c =:proId
                AND Batch_Number_lookup__r.Name !=null
                ORDER BY Batch_Number_lookup__r.Delivery_date__c ];
    } 
    
    /** 
    * @ description  :  This method updates Asset and Order records based on a list of Asset record IDs and corresponding status values
    *  @params        :   assetRecordIds - To search for particular id and match status 
    *  @params        :   statusValues - To match status values 
    **/
    @AuraEnabled
    public static List<Asset> CreateAssetRecords(list<string> assetRecordIds,list<string> statusValues ){
        list<Asset> list_GetAssetRecords = [SELECT 
                                            Id,
                                            Batch_Number__c,
                                            Order_Id__c,
                                            Product2.Id,
                                            Status
                                            FROM Asset 
                                            WHERE Status='QA In Progress'
                                            AND Id in : assetRecordIds];
        Map<String,String>Map_MapAssetValue = new Map<String,String>();
        List<Asset>list_UpdateAssetList = new List<Asset>();
        List<Order> list_UpdateOrderList = new List<Order>();
        for (Integer i = 0; i<assetRecordIds.size(); i++) {
            Map_MapAssetValue.put(assetRecordIds[i],statusValues[i]);   
        }
        for (Asset objAssetRecord : list_GetAssetRecords) {
            Order objorder = [SELECT
                                Id,
                                Under_QA__c,
                                Approved_Quantity__c,
                                Reject_Quantity__c
                                FROM Order 
                                WHERE id=:objAssetRecord.Order_Id__c];
            objorder.Under_QA__c= objorder.Under_QA__c-1;
            if(Map_MapAssetValue.get(objAssetRecord.Id)=='QA Pass'){
                if(objorder.Approved_Quantity__c!=null ) objorder.Approved_Quantity__c=objorder.Approved_Quantity__c+1;
                else objorder.Approved_Quantity__c=1;
            }else if(Map_MapAssetValue.get(objAssetRecord.Id)=='QA Fail'){
                if(objorder.Reject_Quantity__c!=null)objorder.Reject_Quantity__c=objorder.Reject_Quantity__c+1;
                else objorder.Reject_Quantity__c=1;
            }
            update objorder;
            objAssetRecord.Status=Map_MapAssetValue.get(objAssetRecord.Id);
            system.debug(Map_MapAssetValue.get(objAssetRecord.Id));
            list_UpdateAssetList.add(objAssetRecord);
        }
        update list_UpdateAssetList;
        return list_UpdateAssetList;   
    }

    /** 
    * @ description  :  This method retrieves a list of Order Item records that have a Product Name containing the specified string and are in either the "Partial Quantity Under QA" or "Fully Received Under QA" statuses, sorted by Order Number in ascending order.
    *  @params       : proIdInQA-It is used to search for order id 
    **/
    @AuraEnabled
    public static List<OrderItem> retrieveProductNameRecordsInQA(string proIdInQA ){
        return [SELECT 
                Order.Id, 
                Order.OrderNumber,
                Product2.Id,
                Order.Status,
                Order.On_Hand_Recieved__c, 
                Product2.Name,
                Order.Pending_Quantityy1__c,
                Order.Under_QA__c,
                Order.Approved_Quantity__c,
                Order.Reject_Quantity__c 
                FROM OrderItem 
                WHERE(Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') 
                AND Product2.Name LIKE:proIdInQA ORDER BY Order.OrderNumber ASC];      
    }
    /** 
    * @ description  : This Apex method updates failed asset records by creating new batch numbers, updating asset and batch number records, and returning the updated asset record
    *  @params       : FailedAssetIds-It is used to search for failed order.
    **/
    @AuraEnabled
    public static List<Asset> UpdateFailedAssetRecords(list<string> FailedAssetIds ){
        list<Asset> list_GetAssetRecords = [SELECT 
                                            Id, 
                                            Batch_Number__c,
                                            Batch_Number_lookup__c,
                                            Order_Id__c, 
                                            Product2.Id,
                                            Status 
                                            FROM Asset
                                            WHERE  Id in : FailedAssetIds];
        List<String> list_BatchNumberIds = new List<String>();
        for (Asset objAsset : list_GetAssetRecords) {
            list_BatchNumberIds.add(objAsset.Batch_Number_lookup__c);
        }
        list<Batch_Number__c> list_GetBatchNumberRecords = [SELECT 
                                                                Id,
                                                                Defective_Batch__c ,
                                                                Order__c,
                                                                Delivery_date__c
                                                                FROM Batch_Number__c 
                                                                WHERE Id IN : list_BatchNumberIds];
        List<Asset> list_UpdateAssetList = new List<Asset>();
        List<Batch_Number__c> list_CreateBatchesList = new List<Batch_Number__c>();
        List<Batch_Number__c> list_UpdateBatchNumberList = new List<Batch_Number__c>();
        Map<String,String> map_MapParentBatchIdtoChild = new  Map<String,String>();
        for (Batch_Number__c objbatchNumber : list_GetBatchNumberRecords) {
            if(objbatchNumber.Defective_Batch__c ==null){
                Batch_Number__c objnewbatch = new Batch_Number__c();
                objnewbatch.Order__c = objbatchNumber.Order__c;
                objnewbatch.Delivery_date__c = objbatchNumber.Delivery_date__c;
                list_CreateBatchesList.add(objnewbatch);      
            }   
        } 
        insert list_CreateBatchesList;
        integer inti = 0;
        for (Batch_Number__c objbatchnum : list_GetBatchNumberRecords) {
            if(objbatchnum.Defective_Batch__c ==null){
                map_MapParentBatchIdtoChild.put(objbatchnum.Id,list_CreateBatchesList[inti].Id);
                inti=inti+1; 
            }else{
                map_MapParentBatchIdtoChild.put(objbatchnum.Id,objbatchnum.Defective_Batch__c);   
            }  
        }
        for (Asset objAssetRecord : list_GetAssetRecords) {
            objAssetRecord.Batch_Number_lookup__c = map_MapParentBatchIdtoChild.get(objAssetRecord.Batch_Number_lookup__c);
            list_UpdateAssetList.add(objAssetRecord);   
        }
        for (Batch_Number__c objbatch : list_GetBatchNumberRecords) {
            if(objbatch.Defective_Batch__c==null){
                objbatch.Defective_Batch__c = map_MapParentBatchIdtoChild.get(objbatch.Id);
            }
            list_UpdateBatchNumberList.add(objbatch); 
        }
        update list_UpdateAssetList;
        update list_UpdateBatchNumberList;
        return list_UpdateAssetList;     
    } 
}