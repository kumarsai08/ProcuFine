public class Helloworld {
    @Auraenabled
 public static void DeliveryAutomation(list<string> batchnumber,list<integer> inputqunatity,string orderid){
     list<asset> assetrecords=[select id,name,Batch_Number_lookup__c,InstallDate,Sales_Order__c from asset where  Status='QA Pass' AND Batch_Number_lookup__c in: batchnumber order by InstallDate asc];
     map<string,integer> mapofbatchandQuant=new map<string,integer>();
     for(integer i=0;i<batchnumber.size();i++){
         mapofbatchandQuant.put(batchnumber.get(i),inputqunatity.get(i));
     }
     map<string,list<asset>> mpg=new map<string,list<asset>>();
     for(integer i=0;i<batchnumber.size();i++){
         mpg.put(batchnumber.get(i),new list<asset>());
     }
     system.debug(mpg);
     
     
     for(asset assetrec:assetrecords){
         system.debug('size'+mpg.get(assetrec.Batch_Number_lookup__c).size());
       if(mpg.get(assetrec.Batch_Number_lookup__c).size()< mapofbatchandQuant.get(assetrec.Batch_Number_lookup__c)){
             mpg.get(assetrec.Batch_Number_lookup__c).add(assetrec);
             system.debug('17'+mpg.get(assetrec.Batch_Number_lookup__c));              
         }
     }
     list<asset> assetrecupdate=new list<asset>();
     for(string assetkey:mpg.keyset()){
        // list<asset> assrec=mpg.get(assetkey);
         for(asset ast: mpg.get(assetkey)){
             asset at=new asset();
             at.Id=ast.id;
             at.Batch_Number_lookup__c=null;
             at.Product2Id=null;
             at.Sales_Order__c= orderid;
            
             assetrecupdate.add(at);
         }
         
     }
     system.debug('20'+mpg);
     update assetrecupdate;   
     
     list<asset> assetrecordsupdate=new list<asset>();
     
 }
 
}