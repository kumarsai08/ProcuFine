public class PF_triggeronassetrecords {
    public static void getassetrecords(list<asset> asrecords,map<id,asset> getasrecords){
        set<id> productname=new set<id>();
        set<id> warehouse=new set<id>();
        for(asset ast:asrecords){
            if(ast.Status=='QA Pass'|| ast.Status=='QA Fail'){
                if(ast.Status!=getasrecords.get(ast.id).status ){
                    productname.add(ast.Product2Id);
                    warehouse.add(ast.LocationId);                   
                }
            }
        }
        list<asset> assetrecords=[select id,status from asset where Product2Id in :productname and LocationId in : warehouse and status='QA In Progress' ];
        integer assetsize=assetrecords.size();
        list<Inventory__c> inv=[select id,Under_QA_Num__c from Inventory__c where Product__c in :productname and Warehouse__c in : warehouse limit 1 ];
        for(Inventory__c invent:inv){
            invent.Under_QA_Num__c=assetsize;
            
        }
        update inv;
        
        
    }

}