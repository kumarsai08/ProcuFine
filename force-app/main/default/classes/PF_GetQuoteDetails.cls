/*******************************************************************************************************
* 
* @ Name            :   PF_GetQuoteDetails
* @ Purpose         :   It is used for attaching documents and fo replying in chats.
* @ Author          :   kumarsaiVadapalli
* @ Test Class Name :   Pf_TestClassFor_GetQuoteDetails
*
*   Date         |      Developer Name               |  Version      
* ======================================================================================================
* 17-02-2023     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/


 /**
    * @ description  : This is a global Apex class that implements the Messaging.InboundEmailHandler interface and handles incoming emails, extracts relevant information, updates associated records, and creates a new EmailMessage record based on the email content
    * @params         :email- This parameter represents the inbound email message that is being handled.
    * @params         :envelope-This parameter represents the envelope of the inbound email message. It contains metadata about the email, such as the sender's address, recipient's address, and email subject.
    **/
global class PF_GetQuoteDetails implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email,Messaging.InboundEnvelope envelope){
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        string strEmailSentFromName = email.fromname;
        String strEmailSentFromEmail = email.fromAddress;
        String strEmailSubject=email.subject;
        string strHtmlBOdy=email.htmlBody;
        strHtmlBOdy=strHtmlBOdy.stripHtmlTags();
        string reg='>';
        Boolean blnRepliedEmail=false;
        try{
            String strplaintext= '';
            strplaintext = email.plainTextBody;
            string strquoteidd= strHtmlBOdy.substringBetween('quoteid:','.');
            list<Quote> list_quote_records=[SELECT
                                            id,
                                            Name,
                                            QuoteNumber,
                                            Email
                                            FROM Quote 
                                            WHERE id=:strquoteidd limit 1];
            list<quote> list_quote_update_Records=new list<quote>();
            list<string> list_Supplier_email=new list<string>();    
            list<attachment> list_attachment=new list<attachment>();
            for(quote q:list_quote_records){
                if(q.id==strquoteidd){
                    list_Supplier_email.add(q.Email);
                    if(email.binaryAttachments!=null){
                        for (Messaging.Inboundemail.BinaryAttachment file : email.binaryAttachments)
                        {
                            ContentVersion objcontentversion = new ContentVersion();
                            objcontentversion.ContentLocation = 'S';
                            objcontentversion.PathOnClient = file.fileName;//File name with extension
                            objcontentversion.Title =file.fileName;//Name of the file
                            objcontentversion.VersionData = file.body;//File content
                            insert objcontentversion;
                            
                            ContentDocumentLink objcontentdocument = new ContentDocumentLink();
                            objcontentdocument.ContentDocumentId = [SELECT 
                            Id,
                            ContentDocumentId
                            FROM ContentVersion 
                            WHERE Id =: objcontentversion.Id].ContentDocumentId;
                            objcontentdocument.LinkedEntityId = q.Id;
                            objcontentdocument.Visibility = 'AllUsers';
                            objcontentdocument.ShareType = 'I';
                            insert objcontentdocument;
                        }
                    } 
                    else if (email.textAttachments!=null && email.textAttachments.size()>0) {
                        for(integer i=0;i<email.textAttachments.size();i++){
                            attachment objattachment=new attachment();
                            objattachment.ParentId=q.id;
                            objattachment.Name=email.textAttachments[i].filename;
                            objattachment.body=Blob.valueOf(email.textAttachments[i].body);
                            list_attachment.add(objattachment);
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