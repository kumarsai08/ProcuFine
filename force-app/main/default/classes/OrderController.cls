public class OrderController {
 
    @AuraEnabled( cacheable = true )
    public static List< Order > FetchOrders() {
     
        return [
            select id,Account.name,Warehouse__r.name,Status,EffectiveDate from Order
        ];
         
    }
     
}