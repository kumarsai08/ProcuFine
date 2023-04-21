public with sharing class SupplierrDetails {
    @AuraEnabled(cacheable=true)

    public static List < Inventory__c > GetSupplierrDetails() {

        return[select Id, Product__r.name, Stock_On_Hand__c, Threshold__c, Quantity__c, Warehouse__r.Name from Inventory__c];
       
    }
}