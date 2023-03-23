public class EmailToSuppliers {
    public static void sendemailtosuppliers(list<string> suppliernames){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        list<account> ac=[select id,name,Email__c from account where name in:suppliernames];
        list<string> emailsaddress=new list<String>();
        for(account acc:ac){
            emailsaddress.add(acc.Email__c);                
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Products Required ');
        mail.sethtmlbody('productss');
        mail.setToAddresses(emailsaddress);
        emailList.add(mail);
         if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }        
    }
    
    public static void ordercreation(list<string> Supp , list<string> warh){
        list<account> lstacc = [select id,name from account where name in : supp];
        list<Schema.Location> lstloc = [select id,name from Location where name in : warh];
        map<string ,id> mapsupp = new map<string,id>();
        map<string,id> maploc = new map<string,id>();
        for(account acc : lstacc){
           mapsupp.put(acc.name,acc.id); 
        }
        for(Schema.Location loc : lstloc){
            maploc.put(loc.name,loc.id);
        }
        list<order> ord=new list<order>();
        for(string  acc1 : mapsupp.keyset()){
        order orr = new order();
        orr.AccountId = mapsupp.get(acc1);
        orr.EffectiveDate=date.today();
        orr.Status='Draft';     
        ord.add(orr);    
        system.debug(orr); 
        }
        insert ord;
        
    }

}