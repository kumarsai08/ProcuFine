public class SupplierDetails {
    @AuraEnabled(cacheable=true)
    public static List < Inventory__c > InventoryRecords() {

        return [ select Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c];
       
    }
}