public with sharing class Productandserialnumberdetails {
    @AuraEnabled(cacheable=true)
    public static List<OrderItem> fetchSerialnumber() {
        return[Select Id,Product2.Name,Order.Received_Quantity__c From OrderItem];
    }
}