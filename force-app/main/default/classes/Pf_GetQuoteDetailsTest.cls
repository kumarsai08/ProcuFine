@istest
public class Pf_GetQuoteDetailsTest {
    @isTest
    static void OutboundEmailHandler(){
        opportunity objopportunity = new opportunity();
        objopportunity.name = 'test opp';
        objopportunity.CloseDate = system.today();
        objopportunity.StageName = 'closed won';
        insert objopportunity;
        
     Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromname = 'John Doe';
        email.fromAddress = 'john.doe@test.com';
        email.subject = 'Test email';
        email.htmlBody = 'This is a test email. quoteid: 123456.';
        
        // Create a test quote record
        Quote objquote = new Quote();
        objquote.Name = 'Test Quote';
        objquote.Email = 'supplier@test.com';
        objquote.OpportunityId=objopportunity.Id;
        insert objquote;
        
        email.plainTextBody = 'Test plain text email body';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
        
        
        // Test handling of binary attachments
        Messaging.Inboundemail.BinaryAttachment attachment = new Messaging.Inboundemail.BinaryAttachment();
        attachment.fileName = 'test.pdf';
        attachment.body = Blob.valueOf('test');
        email.binaryAttachments = new List<Messaging.Inboundemail.BinaryAttachment>{ attachment };
        result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails with Re
        email.subject = 'Re: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + objquote.Id + '.## Replied email body</body></html>';
        result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails
        email.subject = 'Regy: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + objquote.Id + '.## Replied email body</body></html>';
        result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
    }
    @isTest
    static void OutboundEmailHandler1(){
        opportunity objopportunity = new opportunity();
        objopportunity.name = 'test opp';
        objopportunity.CloseDate = system.today();
        objopportunity.StageName = 'closed won';
        insert objopportunity;
        
     Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromname = 'John Doe';
        email.fromAddress = 'john.doe@test.com';
        email.subject = 'Test email';
        email.htmlBody = 'This is a test email. quoteid: 123456.';
        
        // Create a test quote record
        Quote objquote = new Quote();
        objquote.Name = 'Test Quote';
        objquote.Email = 'supplier@test.com';
        objquote.OpportunityId=objopportunity.Id;
        insert objquote;
        
        email.plainTextBody = 'Test plain text email body';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of text attachments
        Messaging.Inboundemail.TextAttachment textAttachment = new Messaging.Inboundemail.TextAttachment();
        textAttachment.filename = 'test.txt';
        textAttachment.body = 'test';
        email.textAttachments = new List<Messaging.Inboundemail.TextAttachment>{ textAttachment };
        result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails with Re
        email.subject = 'Re: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + objquote.Id + '.## Replied email body</body></html>';
        result = new PF_GetQuoteDetails().handleInboundEmail(email, envelope);
    }
    

}