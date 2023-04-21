global class email_to_suppliers implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        string strEmailSentFromName = email.fromname;
        String strEmailSentFromEmail = email.fromAddress; 
        String strEmailSubject=email.subject;
        String strEmailBody = email.plainTextBody;
        Boolean blnRepliedEmail=false;
        
        try{
            system.debug('line 7');
            
            String plaintext= '';
            // Add the email plain text into the local variable
            plaintext = email.plainTextBody;
            string quoteidd=plaintext.substringBetween('quoteid:','\n');
            system.debug('quote id:'+quoteidd);
            system.debug('plaintext:'+plaintext);
            list<Quote> quote_records=[select id,Name,QuoteNumber,supplier_Email__c from Quote where id=:quoteidd limit 1];
            list<quote> quote_update_Records=new list<quote>();
            list<string> Supplier_email=new list<string>();    
            list<attachment> atment=new list<attachment>();
            for(quote q:quote_records){
                if(q.id==quoteidd){
                    Supplier_email.add(q.supplier_Email__c);
                    if(email.binaryAttachments != null && email.binaryAttachments.size()>0){
                        for(integer i=0;i<email.binaryAttachments.size();i++){
                            attachment atc=new attachment();
                            atc.ParentId=q.id;
                            atc.Name=email.binaryAttachments[i].filename;
                            atc.Body=email.binaryAttachments[i].body;
                            atment.add(atc);
                        }
                    }
                }
            }
            insert atment;
            EmailMessage chatterEmailMessage = new EmailMessage();
            if(strEmailSubject.contains('Re:')){
                // For replied emails
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strEmailBody;
                chatterEmailMessage.Incoming= true;
                chatterEmailMessage.TextBody = strEmailBody;
                chatterEmailMessage.RelatedToId=quote_records[0].id;
                chatterEmailMessage.status = '3';    
            }
            else{
                // for the first email
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strEmailBody;
                chatterEmailMessage.Incoming= False;
                chatterEmailMessage.TextBody =strEmailBody;
                chatterEmailMessage.RelatedToId=quote_records[0].id;
                chatterEmailMessage.status = '3';
            }
            insert chatterEmailMessage;
            
            result.success=true;
        }
        catch(exception e){
            result.success=false;
        }
        return result;
    }
}