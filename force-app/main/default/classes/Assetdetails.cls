public with sharing class Assetdetails {
    @AuraEnabled(cacheable=true)
    public static List<Asset> getassetrecords() {
        return[select Product2.Name,Batch_Number__c from Asset];

    }
}