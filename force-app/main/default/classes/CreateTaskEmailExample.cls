global class CreateTaskEmailExample implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        string strEmailSentFromName = email.fromname;
        String strEmailSentFromEmail = email.fromAddress; 
        String strEmailSubject=email.subject;
       // String strEmailBody = email.plainTextBody;
        string strHtmlBOdy=email.htmlBody;
        strHtmlBOdy=strHtmlBOdy.stripHtmlTags();
        system.debug('line 10'+strHtmlBOdy);
        
        string reg='>';
        Boolean blnRepliedEmail=false;
        //system.debug(stremailbody.replaceAll(reg, ''));
        //strEmailBody=stremailbody.replaceAll(reg, '');
        system.debug('13'+strEmailSubject);
        system.debug('14'+strHtmlBOdy);
        system.debug('15'+strEmailSentFromEmail);
       
        
        try{
            system.debug('line 7');
            
            String plaintext= '';
            // Add the email plain text into the local variable
            plaintext = email.plainTextBody;
            string quoteidd= strHtmlBOdy.substringBetween('quoteid:','.');
            system.debug('quote id:'+quoteidd);
            system.debug('plaintext:'+plaintext);
            list<Quote> quote_records=[select id,Name,QuoteNumber,Email from Quote where id=:quoteidd limit 1];
            system.debug(quote_records[0].id);
            list<quote> quote_update_Records=new list<quote>();
            list<string> Supplier_email=new list<string>();    
            list<attachment> atment=new list<attachment>();
            for(quote q:quote_records){
                if(q.id==quoteidd){
                    Supplier_email.add(q.Email);
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
            if(strEmailSubject.contains('Re:') && (quote_records[0].id== quoteidd) ){
                // For replied emails
                strHtmlBOdy=strHtmlBOdy.substringBefore('##'); 
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strHtmlBOdy;
                chatterEmailMessage.Incoming= true;
                chatterEmailMessage.TextBody = strHtmlBOdy;
                chatterEmailMessage.RelatedToId=quote_records[0].id;
                chatterEmailMessage.status = '3';    
            }
            else if((quote_records[0].id== quoteidd)){
                // for the first email
                
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strHtmlBOdy;
                chatterEmailMessage.Incoming= False;
                chatterEmailMessage.TextBody =strHtmlBOdy;
                chatterEmailMessage.RelatedToId=quote_records[0].id;
                chatterEmailMessage.status = '3';
            }
            else{
                system.debug('pass');
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