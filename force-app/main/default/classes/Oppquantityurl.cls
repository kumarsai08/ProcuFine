public with sharing class Oppquantityurl {
    @AuraEnabled
    public static list<Opportunity> Oppquantityurl() {
        //System.debug('User:'+userinfo.getuserId());
        return [select id, name,TotalOpportunityQuantity,CloseDate,OrderNumber__c,StageName,Delivery_Status__c From Opportunity ];
           // and Inventory_Manager__c=:userinfo.getuserId()
    }
}