public class day201merch {
    public static void methods(){
        list<asset> asse=[select id,name,Batch_Number_lookup__c from asset where Batch_Number_lookup__c = 'a085g000008QYesAAG'];
        list<id> assetids=new list<id>();
        for(asset asids:asse){
            assetids.add(asids.id);
        }
        system.debug(asse);
    }
}