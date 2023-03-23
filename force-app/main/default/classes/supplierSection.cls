public with sharing class supplierSection {
    @AuraEnabled(cacheable=true)

    public static List < Product_Supplier__c> supplierSection() {

        return[select Id,Name, Product__r.name from Product_Supplier__c];
       
    }
}