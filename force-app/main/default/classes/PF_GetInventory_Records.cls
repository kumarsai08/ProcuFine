public with sharing class PF_GetInventory_Records {
    @AuraEnabled(cacheable=true)
    public static List<Inventory__c> PF_GetInventory_Records() {
        System.debug('User:'+userinfo.getuserId());
        return [SELECT Id, Name, Quantity__c, Threshold__c,
        Warehouse__c,Warehouse__r.Name,Product__c, Product__r.Name ,Restockk__c
            FROM Inventory__c WHERE Restockk__c=TRUE ];
           // and Inventory_Manager__c=:userinfo.getuserId()

    }
}