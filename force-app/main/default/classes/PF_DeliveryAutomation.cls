/**
* @description       : 
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             : 
* @last modified on  : 04-25-2023
* @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PF_DeliveryAutomation {
    @Auraenabled
    public static void DeliveryAutomation(list<string> list_batchnumber,list<integer> list_inputqunatity,string strorderid){
        
        try{
            list<asset> list_assetrecords=[SELECT
             id,
            name,
            Batch_Number_lookup__c,
            InstallDate,
            Sales_Order__c 
            FROM asset
            WHERE Batch_Number_lookup__c in: list_batchnumber
            ORDER BY InstallDate asc];
            map<string,integer> map_batchbyId=new map<string,integer>();
            for(integer i=0;i<list_batchnumber.size();i++){
                map_batchbyId.put(list_batchnumber.get(i),list_inputqunatity.get(i));
            }
            map<string,list<asset>>map_assetbyId=new map<string,list<asset>>();
            for(integer i=0;i<list_batchnumber.size();i++){
                map_assetbyId.put(list_batchnumber.get(i),new list<asset>());
            }

            for(asset objasset:list_assetrecords){
                system.debug('size'+map_assetbyId.get(objasset.Batch_Number_lookup__c).size());
                if(map_assetbyId.get(objasset.Batch_Number_lookup__c).size()< map_batchbyId.get(objasset.Batch_Number_lookup__c)){
                    map_assetbyId.get(objasset.Batch_Number_lookup__c).add(objasset);
                    system.debug('17'+map_assetbyId.get(objasset.Batch_Number_lookup__c));              
                }
            }
            list<asset> list_assetrecupdate=new list<asset>();
            for(string assetkey:map_assetbyId.keyset()){
                for(asset ast: map_assetbyId.get(assetkey)){
                    asset objasset=new asset();
                    objasset.Id=ast.id;
                    objasset.Batch_Number_lookup__c=null;
                    objasset.Product2Id=null;
                    objasset.Sales_Order__c= strorderid;
                    list_assetrecupdate.add(objasset);
                }
                
            }
            system.debug('20'+map_assetbyId);
            update list_assetrecupdate;   
            list<asset> assetrecordsupdate=new list<asset>(); 
        }
        catch(exception ex)
        {
            new CustomLogException().Log(ex);
            
        }
    }
}