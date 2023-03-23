public  class PFbatchClass  implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC) {
        string query='SELECT ID, Name, Quantity__c,Threshold__c,Restockk__c From Inventory__c where Restockk__c = true';
        system.debug(query);
        return Database.getQueryLocator(query);
        
    }
    public void execute(Database.BatchableContext BC, list<Inventory__c> invlist){
        String head = '';
        String htmlBody = '';
        
        htmlBody += '<table border="1" style="border-collapse: collapse"><caption>Inventory data as of today</caption><tr><th>Inventory Name</th><th>Quantity</th><th>Threshold Limit</th></tr>';
        for(Inventory__c inv: invlist){
            //system.debug(inv);
            String InventoryName = inv.Name; 
            Decimal Quantity = inv.Quantity__c; 
            Decimal ThresholdLimit = inv.Threshold__c; 
             
           htmlBody += '<tr><td>' + InventoryName + '</td><td>' + Quantity + '</td><td>' + ThresholdLimit + '</td></tr>';
        }
        //close table...
        htmlBody += '</table>';
        
        system.debug('Email Body: ' + htmlBody); 
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<String> address = new List<String>{'himabindu.vanaparthi@absyz.com'};
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Inventory Updates');
        mail.sethtmlbody(htmlBody);
        mail.setToAddresses(address);
        emailList.add(mail);
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
        
        
    }
    
    public void finish(Database.BatchableContext BC){
        
        
    }
}