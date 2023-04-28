/*******************************************************************************************************
* 
* @ Name            :   PF_DeliveryAutomation
* @ Purpose         :   It is used in the asset delivery tab where upon clicking deliver button update in inventory summary table  Component.
* @ author          :    Srikanth.Halavath
*   Date            |  Developer Name               |  Version      
* ======================================================================================================
* 22-04-2023     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/

public class PF_triggeronassetrecords {
     /** 
    * @ description  :  This method takes a list of asset records, compares their status with the corresponding records in a map of asset records, and updates the "Under_QA_Num__c" field in an Inventory__c record based on the number of assets with "QA In Progress" status, filtered by product name and warehouse.
    *  @params        :asrecords- It conatins list of asset records
    *  @params        :getasrecords-It contains id of assets.
    **/
    public static void getassetrecords(list<asset> asrecords,map<id,asset> getasrecords){
        set<id> set_productname=new set<id>();
        set<id> set_warehouse=new set<id>();
        for(asset objasset:asrecords){
            if(objasset.Status=='QA Pass'|| objasset.Status=='QA Fail'){
                if(objasset.Status!=getasrecords.get(objasset.id).status ){
                    set_productname.add(objasset.Product2Id);
                    set_warehouse.add(objasset.LocationId);                   
                }
            }
        }
        list<asset> list_assetrecords=[SELECT
                                        id,
                                        status
                                        FROM asset
                                        WHERE Product2Id in :set_productname 
                                        AND LocationId in : set_warehouse
                                        AND status='QA In Progress' ];
                                        integer intassetsize=list_assetrecords.size();
        list<Inventory__c> list_inventory=[SELECT 
                                            id,
                                            Under_QA_Num__c
                                            FROM Inventory__c 
                                            WHERE Product__c in :set_productname
                                            AND Warehouse__c in : set_warehouse LIMIT 1 ];
        for(Inventory__c objinventory:list_inventory){
            objinventory.Under_QA_Num__c=intassetsize;
        }
        update list_inventory;
        
    }
    
}