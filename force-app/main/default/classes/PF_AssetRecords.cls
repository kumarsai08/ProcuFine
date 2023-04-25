/*******************************************************************************************************
* 
* @ Name            :   PF_WorkflowListviewController
* @ Purpose         :   Controller for Workflow Listview
* @ Author          :   Deeksha Suvarna
* @ Usage           :   1) For displaying workflow list on the workflow page according to the user
*                       2) For creating a request from the workflow page onclick of execute
* @ Test Class Name :   PF_TestClassFor_AssetRecords
*
*   Date            |  Developer Name               |  Version      |  Changes
* ======================================================================================================
*   30-10-2018      |  shameel.ahmed@absyz.com      |  1.0          |  Initial Version
*   05-11-2018      |  deeksha.suvarna@absyz.com    |  1.1          |  Added Profile Categorization Logic.
*
*******************************************************************************************************/

public with sharing class PF_AssetRecords {
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
    
    
    @AuraEnabled
    public static List<Asset> producttoassestrecords(string strproId ){
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
        AND Order_Id__c =: strproId
        AND Batch_Number_lookup__r.Name !=null
        ORDER BY Batch_Number_lookup__r.Delivery_date__c ];
    } 
    
    @AuraEnabled
    public static List<Asset> CreateAssetRecords(list<string> list_assetRecordIds,list<string> list_statusValues ){
        system.debug('77:'+list_assetRecordIds);
        system.debug('78:'+list_assetRecordIds);
        list<Asset> list_GetAssetRecords = [SELECT 
        Id,
        Batch_Number__c,
        Order_Id__c,
        Product2.Id,
        Status
        FROM Asset 
        WHERE Status='QA In Progress'
        AND Id in : list_assetRecordIds];
        system.debug(list_GetAssetRecords);
        Map<String,String>Map_MapAssetValue = new Map<String,String>();
        List<Asset>list_UpdateAssetList = new List<Asset>();
        List<Order> list_UpdateOrderList = new List<Order>();
        for (Integer i = 0; i < list_assetRecordIds.size(); i++) {
            Map_MapAssetValue.put(list_assetRecordIds[i],list_statusValues[i]);   
            
        }
        system.debug(Map_MapAssetValue);
        for (Asset AssetRecord : list_GetAssetRecords) {
            system.debug(AssetRecord.Id);
            Order objorder = [SELECT
            Id,
            Under_QA__c,
            Approved_Quantity__c,
            Reject_Quantity__c
            FROM Order 
            WHERE id=:AssetRecord.Order_Id__c];
            objorder.Under_QA__c= objorder.Under_QA__c-1;
            system.debug('line 33'+objorder);
            system.debug('line 34'+ objorder.Approved_Quantity__c);
            if(Map_MapAssetValue.get(AssetRecord.Id)=='QA Pass'){
                if(objorder.Approved_Quantity__c!=null ) objorder.Approved_Quantity__c=objorder.Approved_Quantity__c+1;
                else objorder.Approved_Quantity__c=1;
            }else if(Map_MapAssetValue.get(AssetRecord.Id)=='QA Fail'){
                if(objorder.Reject_Quantity__c!=null)objorder.Reject_Quantity__c=objorder.Reject_Quantity__c+1;
                else objorder.Reject_Quantity__c=1;
            }
            update objorder;
            AssetRecord.Status=Map_MapAssetValue.get(AssetRecord.Id);
            system.debug(Map_MapAssetValue.get(AssetRecord.Id));
            list_UpdateAssetList.add(AssetRecord);
        }
        update list_UpdateAssetList;
        return list_UpdateAssetList; 
        
    }
    @AuraEnabled
    public static List<OrderItem> retrieveProductNameRecordsInQA(string strproIdInQA ){
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
        WHERE  (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') 
        AND Product2.Name LIKE:strproIdInQA ORDER BY Order.OrderNumber ASC];    
        
    }
    
    @AuraEnabled
    public static List<Asset> UpdateFailedAssetRecords(list<string> strFailedAssetIds ){
        system.debug(strFailedAssetIds);
        list<Asset> list_GetAssetRecords = [SELECT 
                                            Id, 
                                            Batch_Number__c,
                                            Batch_Number_lookup__c,
                                            Order_Id__c, 
                                            Product2.Id,
                                            Status 
                                            FROM Asset
                                            WHERE  Id in : strFailedAssetIds];
        system.debug(list_GetAssetRecords);
        List<String> list_BatchNumberIds = new List<String>();
        for (Asset objAsset : list_GetAssetRecords) {
            list_BatchNumberIds.add(objAsset.Batch_Number_lookup__c);
        }
        list<Batch_Number__c> list_GetBatchNumberRecords = [SELECT Id,
                                                              Defective_Batch__c ,
                                                              Order__c,
                                                              Delivery_date__c
                                                               FROM Batch_Number__c 
                                                               WHERE Id IN : list_BatchNumberIds];
        system.debug(list_GetBatchNumberRecords);
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
            system.debug(objbatchnum.Id);
            if(objbatchnum.Defective_Batch__c ==null){
                system.debug('101');
                map_MapParentBatchIdtoChild.put(objbatchnum.Id,list_CreateBatchesList[inti].Id);
                inti=inti+1; 
            }else{
                system.debug('108');
                map_MapParentBatchIdtoChild.put(objbatchnum.Id,objbatchnum.Defective_Batch__c);
                
            }
            
        }
        system.debug('112 '+map_MapParentBatchIdtoChild);
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