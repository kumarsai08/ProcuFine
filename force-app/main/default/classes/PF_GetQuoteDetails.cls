/*******************************************************************************************************
* 
* @ Name            :   PF_GetQuoteDetails
* @ Purpose         :   It is used for attaching documents and fo replying in chats.
* @ Author          :   kumarsaiVadapalli
* @ Test Class Name :   Pf_TestClassFor_GetQuoteDetails
*
*   Date            |  Developer Name               |  Version      
* ======================================================================================================
* 17-02-2023    |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/


global class PF_GetQuoteDetails implements Messaging.InboundEmailHandler {
    
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
        system.debug('13'+strEmailSubject);
        system.debug('14'+strHtmlBOdy);
        system.debug('15'+strEmailSentFromEmail);
        try{
            system.debug('line 7');
            String strplaintext= '';
            strplaintext = email.plainTextBody;
            string strquoteidd= strHtmlBOdy.substringBetween('quoteid:','.');
            system.debug('quote id:'+strquoteidd);
            system.debug('plaintext:'+strplaintext);
            list<Quote> list_quote_records=[SELECT
            id,
            Name,
            QuoteNumber,
            Email
            FROM Quote 
            WHERE id=:strquoteidd limit 1];
            system.debug(list_quote_records[0].id);
            list<quote> list_quote_update_Records=new list<quote>();
            list<string> list_Supplier_email=new list<string>();    
            list<attachment> list_attachment=new list<attachment>();
            for(quote q:list_quote_records){
                if(q.id==strquoteidd){
                    list_Supplier_email.add(q.Email);
                    if(email.binaryAttachments!=null){
                        for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments)
                        {
                            ContentVersion cVersion = new ContentVersion();
                            cVersion.ContentLocation = 'S';
                            cVersion.PathOnClient = file.fileName;//File name with extension
                            cVersion.Title =file.fileName;//Name of the file
                            cVersion.VersionData = file.body;//File content
                            insert cVersion;
                            
                            ContentDocumentLink objcdl = new ContentDocumentLink();
                            objcdl.ContentDocumentId = [SELECT 
                            Id,
                            ContentDocumentId
                            FROM ContentVersion 
                            WHERE Id =: cVersion.Id].ContentDocumentId;
                            objcdl.LinkedEntityId = q.Id;
                            objcdl.Visibility = 'AllUsers';
                            objcdl.ShareType = 'I';
                            insert objcdl;
                        }
                    } 
                    else if (email.textAttachments!=null && email.textAttachments.size()>0) {
                        for(integer i=0;i<email.textAttachments.size();i++){
                            attachment atc=new attachment();
                            atc.ParentId=q.id;
                            atc.Name=email.textAttachments[i].filename;
                            atc.body=Blob.valueOf(email.textAttachments[i].body);
                            list_attachment.add(atc);
                        }
                        
                    }
                }
            }
            insert list_attachment;
            EmailMessage chatterEmailMessage = new EmailMessage();
            if(strEmailSubject.contains('Re:') && (list_quote_records[0].id== strquoteidd) ){
                // For replied emails
                strHtmlBOdy=strHtmlBOdy.substringBefore('##');
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =list_Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strHtmlBOdy;
                chatterEmailMessage.Incoming= true;
                chatterEmailMessage.TextBody = strHtmlBOdy;
                chatterEmailMessage.RelatedToId=list_quote_records[0].id;
                chatterEmailMessage.status = '3';    
            }
            else if((list_quote_records[0].id== strquoteidd)){
                // for the first email
                
                chatterEmailMessage.fromAddress= strEmailSentFromEmail;
                chatterEmailMessage.ToAddress =list_Supplier_email[0];
                chatterEmailMessage.FromName = strEmailSentFromName;
                chatterEmailMessage.Subject = strEmailSubject;
                chatterEmailMessage.HtmlBody = strHtmlBOdy;
                chatterEmailMessage.Incoming= False;
                chatterEmailMessage.TextBody =strHtmlBOdy;
                chatterEmailMessage.RelatedToId=list_quote_records[0].id;
                chatterEmailMessage.status = '3';
            }
            else{
                system.debug('pass');
            }
            insert chatterEmailMessage;
            
            result.success=true;
        }
        catch(exception ex)
        {
            new CustomLogException().Log(ex);
            
            
        }
        return result;
    }
}