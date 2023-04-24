@istest
public class TestClassFor_AssetRecords {
    @testsetup static void testmethods(){
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account acc = new account();
        acc.name='test account';
        insert acc;       
        Opportunity opp = new Opportunity
            (Name = 'testopp',Type ='New Customer',AccountId=acc.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Prospecting'); 
        insert opp;
        Product2 pr=new Product2();
        pr.Name='teset product';
        pr.IsActive=true;
        insert pr;
        Batch_Number__c bn=new Batch_Number__c();
        bn.Delivery_date__c=system.today();
        bn.Child_Assets_Count__c=4;
        bn.Defective_Batch__c=null;
        insert bn;        
        contact con= new contact ();
        con.FirstName = 'test';
        con.LastName = 'record';
        con.AccountId = acc.id;
        insert con;
        PricebookEntry pbe = new PricebookEntry(UnitPrice=10.0, Product2Id=pr.Id, Pricebook2Id=pricebook2idvalue, IsActive=true);

insert pbe;
        Order orr=new Order();
        orr.Name='test order';
        orr.status='Order Placed';
        orr.On_Hand_Recieved__c=2;
        orr.OpportunityId=opp.id;
        orr.AccountId =acc.Id;        
        orr.Approved_Quantity__c=4;
        orr.Pending_Quantityy1__c=8;
        orr.Reject_Quantity__c=9;
        orr.Under_QA__c=2;
        orr.EffectiveDate=system.today();
        orr.Pricebook2id =pricebook2idvalue;
        insert orr;
        OrderItem oi = new OrderItem();
    oi.Product2Id=pr.Id;
    oi.Quantity=1.0;
    oi.OrderId=orr.Id;
    oi.UnitPrice=10.0;
    oi.PricebookEntryId = pbe.id;
system.debug(oi);
insert oi;

        
        asset assetrecord=new asset();
        assetrecord.Name='test asset';
        assetrecord.Product2Id=pr.Id;
        assetrecord.Batch_Number_lookup__c=bn.Id;
        assetrecord.InstallDate=system.today();
        assetrecord.AccountId=acc.Id;
        assetrecord.ContactId=con.id;
        assetrecord.Batch_Number_lookup__c=bn.Id;
        assetrecord.Batch_Number__c='1';
        assetrecord.Order_Id__c=orr.Id;
        assetrecord.Status='QA In Progress';       
        insert assetrecord;             
    }
    @istest static void tesetasrecords(){
        Product2 prodid=[select id,name from Product2];       
        list<orderitem> oritem=new list<orderitem>();       
        test.startTest();
             
        list<asset> assetreturnrecords= PF_AssetRecords.producttoassestrecords(prodid.Id);        
        test.stopTest();
    }
    @istest static void createassetrecords_test(){
        list<Asset> createassetreturnrecords=new list<Asset>();        
        list<Asset>  assetrecordss=[select id,name from asset ];
        list<string> assetids=new list<string>();
        order orderupdate=[select id,Approved_Quantity__c from order];               
        for(Asset asse : assetrecordss){
            assetids.add(asse.id);            
        }        
        list<string> statusValues=new list<string>{'QA Pass'}; 
            system.debug('statusValues'+statusValues);       
        test.startTest();       
        PF_AssetRecords.CreateAssetRecords(assetids, statusValues);        
        test.stopTest();       
    }   
    @istest static void createassetrecords_test1(){
        list<Asset> createassetreturnrecords=new list<Asset>();     
        list<Asset>  assetrecordss=[select id,name from asset ];
        list<string> assetids=new list<string>();
        order orderupdate=[select id,Approved_Quantity__c from order];       
        for(Asset asse : assetrecordss){
            assetids.add(asse.id);          
        }        
        list<string> statusValues=new list<string>{'QA Pass'}; 
            system.debug('statusValues'+statusValues);       
        test.startTest();        
        orderupdate.Approved_Quantity__c=null;
        update orderupdate;
        PF_AssetRecords.CreateAssetRecords(assetids, statusValues);       
        test.stopTest();                
    }  
    @istest static void createassetrecords_test2(){
        list<Asset> createassetreturnrecords=new list<Asset>();        
        list<Asset>  assetrecordss=[select id,name from asset ];
        list<string> assetids=new list<string>();
        order orderupdate=[select id,Approved_Quantity__c from order];      
        for(Asset asse : assetrecordss){
            assetids.add(asse.id);            
        }        
        list<string> statusValues=new list<string>{'QA Fail'}; 
            system.debug('statusValues'+statusValues);        
        test.startTest();       
        PF_AssetRecords.CreateAssetRecords(assetids, statusValues);       
        test.stopTest();                
    }
    @istest static void createassetrecords_test3(){
        list<Asset> createassetreturnrecords=new list<Asset>();       
        list<Asset>  assetrecordss=[select id,name from asset ];
        list<string> assetids=new list<string>();
        order orderupdate=[select id,Approved_Quantity__c,Reject_Quantity__c from order];        
        for(Asset asse : assetrecordss){
            assetids.add(asse.id);          
        }        
        list<string> statusValues=new list<string>{'QA Fail'}; 
            system.debug('statusValues'+statusValues);        
        test.startTest();
        orderupdate.Approved_Quantity__c=9;       
        orderupdate.Reject_Quantity__c=null;
        update orderupdate;        
        PF_AssetRecords.CreateAssetRecords(assetids, statusValues);       
        test.stopTest();        
        
    }
        @istest static void test_UpdateFailedAssetRecords(){
            list<asset>  updateassetfailed=[select id,name from asset ];
            list<string> updateassetstringids=new list<string>();
            for(asset ups:updateassetfailed){
                updateassetstringids.add(ups.id);
            }
             
            
            test.startTest();
            PF_AssetRecords.UpdateFailedAssetRecords(updateassetstringids);
            test.stopTest();}
    
    @istest static void testQAManagerOrderPro(){
           
             order od=[select id,name,status from order where name='test order'];
od.Status='Fully Received Under QA';
update od;
      
            
            test.startTest();
        PF_AssetRecords.QAManagerOrderPro();
           
            test.stopTest();}
    @istest static void test_retrieveProductNameRecordsInQA(){
        
          //test.startTest();
        string proIdInQA=[select id,name from Product2 ].name;
        test.startTest();
        PF_AssetRecords.retrieveProductNameRecordsInQA(proIdInQA);
           
            test.stopTest();
        
    }

            
}