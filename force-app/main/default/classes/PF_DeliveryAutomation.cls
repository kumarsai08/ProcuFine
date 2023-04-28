/*******************************************************************************************************
* 
* @ Name            :   PF_DeliveryAutomation
* @ Purpose         :   It is used in the pFAssetDeliverySR Component.
* @ Test Class Name :   Pf_TestClassForPF_DeliveryAutomation
* @ Author          :   kumarsaiVadapalli
*   Date            |  Developer Name               |  Version      
* ======================================================================================================
* 16-02-2023     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/

public class PF_DeliveryAutomation {
     /**
    * @ description  : This method that automates delivery by updating asset records based on batch number and input quantity, with an associated sales order ID, and logs any exceptions with a custom exception logger
    * @params        : batchnumber-Its used to get batchnumber id 
    * @params        : inputqunatity- Its used to get quantity of that particular batch
    * @params        : orderid-Its used to get order id of that particular batch
    **/
    @Auraenabled
    public static void DeliveryAutomation(list<string> batchnumber,list<integer> inputqunatity,string orderid){
        
        try{
            list<asset> list_assetrecords=[SELECT
             id,
            name,
            Batch_Number_lookup__c,
            InstallDate,
            Sales_Order__c 
            FROM asset
            WHERE Batch_Number_lookup__c in:batchnumber
            ORDER BY InstallDate asc];
            map<string,integer> map_batchbyId=new map<string,integer>();
            for(integer i=0;i<batchnumber.size();i++){
                map_batchbyId.put(batchnumber.get(i),inputqunatity.get(i));
            }
            map<string,list<asset>>map_assetbyId=new map<string,list<asset>>();
            for(integer i=0;i<batchnumber.size();i++){
                map_assetbyId.put(batchnumber.get(i),new list<asset>());
            }

            for(asset objasset:list_assetrecords){
                if(map_assetbyId.get(objasset.Batch_Number_lookup__c).size()< map_batchbyId.get(objasset.Batch_Number_lookup__c)){
                    map_assetbyId.get(objasset.Batch_Number_lookup__c).add(objasset);
                }
            }
            list<asset> list_assetrecupdate=new list<asset>();
            for(string assetkey:map_assetbyId.keyset()){
                for(asset ast: map_assetbyId.get(assetkey)){
                    asset objasset=new asset();
                    objasset.Id=ast.id;
                    objasset.Batch_Number_lookup__c=null;
                    objasset.Product2Id=null;
                    objasset.Sales_Order__c= orderid;
                    list_assetrecupdate.add(objasset);
                }  
            }
            update list_assetrecupdate;   
            list<asset> assetrecordsupdate=new list<asset>(); 
        }
        catch(exception ex)
        {
            new CustomLogException().Log(ex);
            
        }
    }
}