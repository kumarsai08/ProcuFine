@istest
public class TestClassFor_GetQuoteDetails {
    @isTest
    static void OutboundEmailHandler(){
        opportunity opp = new opportunity();
        opp.name = 'test opp';
        opp.CloseDate = system.today();
        opp.StageName = 'closed won';
        insert opp;
        
     Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromname = 'John Doe';
        email.fromAddress = 'john.doe@test.com';
        email.subject = 'Test email';
        email.htmlBody = 'This is a test email. quoteid: 123456.';
        
        // Create a test quote record
        Quote quote = new Quote();
        quote.Name = 'Test Quote';
        quote.Email = 'supplier@test.com';
        quote.OpportunityId=opp.Id;
        insert quote;
        
        email.plainTextBody = 'Test plain text email body';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new GetQuoteDetails().handleInboundEmail(email, envelope);
        
        
        // Test handling of binary attachments
        Messaging.Inboundemail.BinaryAttachment attachment = new Messaging.Inboundemail.BinaryAttachment();
        attachment.fileName = 'test.pdf';
        attachment.body = Blob.valueOf('test');
        email.binaryAttachments = new List<Messaging.Inboundemail.BinaryAttachment>{ attachment };
        result = new GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails with Re
        email.subject = 'Re: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + quote.Id + '.## Replied email body</body></html>';
        result = new GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails
        email.subject = 'Regy: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + quote.Id + '.## Replied email body</body></html>';
        result = new GetQuoteDetails().handleInboundEmail(email, envelope);
    }
    @isTest
    static void OutboundEmailHandler1(){
        opportunity opp = new opportunity();
        opp.name = 'test opp';
        opp.CloseDate = system.today();
        opp.StageName = 'closed won';
        insert opp;
        
     Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromname = 'John Doe';
        email.fromAddress = 'john.doe@test.com';
        email.subject = 'Test email';
        email.htmlBody = 'This is a test email. quoteid: 123456.';
        
        // Create a test quote record
        Quote quote = new Quote();
        quote.Name = 'Test Quote';
        quote.Email = 'supplier@test.com';
        quote.OpportunityId=opp.Id;
        insert quote;
        
        email.plainTextBody = 'Test plain text email body';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmailResult result = new GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of text attachments
        Messaging.Inboundemail.TextAttachment textAttachment = new Messaging.Inboundemail.TextAttachment();
        textAttachment.filename = 'test.txt';
        textAttachment.body = 'test';
        email.textAttachments = new List<Messaging.Inboundemail.TextAttachment>{ textAttachment };
        result = new GetQuoteDetails().handleInboundEmail(email, envelope);
        
        // Test handling of replied emails with Re
        email.subject = 'Re: Test Email';
        email.htmlBody = '<html><body>Test email body<br/>quoteid:' + quote.Id + '.## Replied email body</body></html>';
        result = new GetQuoteDetails().handleInboundEmail(email, envelope);
    }
    

}