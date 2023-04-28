@istest
public class PF_AssetRecordsTest {
    @testsetup static void Data_setup(){
        Id pricebook2idvalue = Test.getStandardPricebookId();
        account objAccount = new account();
        objAccount.name='test account';
        insert objAccount;       
        Opportunity objOpportunity = new Opportunity
            (Name = 'testopp',Type ='New Customer',AccountId=objAccount.id,CloseDate=Date.valueOf('2008-04-28'),StageName='Prospecting'); 
        insert objOpportunity;
        Product2 objProduct2=new Product2();
        objProduct2.Name='teset product';
        objProduct2.IsActive=true;
        insert objProduct2;
        Batch_Number__c objBatch_Number=new Batch_Number__c();
        objBatch_Number.Delivery_date__c=system.today();
        objBatch_Number.Child_Assets_Count__c=4;
        objBatch_Number.Defective_Batch__c=null;
        insert objBatch_Number;        
        contact objcontact= new contact ();
        objcontact.FirstName = 'test';
        objcontact.LastName = 'record';
        objcontact.AccountId = objAccount.id;
        insert objcontact;
        PricebookEntry objPricebookEntry = new PricebookEntry(UnitPrice=10.0, Product2Id=objProduct2.Id, Pricebook2Id=pricebook2idvalue, IsActive=true);
        
        insert objPricebookEntry;
        Order objOrder=new Order();
        objOrder.Name='test order';
        objOrder.status='Order Placed';
        objOrder.On_Hand_Recieved__c=2;
        objOrder.OpportunityId=objOpportunity.id;
        objOrder.AccountId =objAccount.Id;        
        objOrder.Approved_Quantity__c=4;
        objOrder.Pending_Quantityy1__c=8;
        objOrder.Reject_Quantity__c=9;
        objOrder.Under_QA__c=2;
        objOrder.EffectiveDate=system.today();
        objOrder.Pricebook2id =pricebook2idvalue;
        insert objOrder;
        OrderItem objOrderItem = new OrderItem();
        objOrderItem.Product2Id=objProduct2.Id;
        objOrderItem.Quantity=1.0;
        objOrderItem.OrderId=objOrder.Id;
        objOrderItem.UnitPrice=10.0;
        objOrderItem.PricebookEntryId = objPricebookEntry.id;
        system.debug(objOrderItem);
        insert objOrderItem;
        
        
        asset objAsset=new asset();
        objAsset.Name='test asset';
        objAsset.Product2Id=objProduct2.Id;
        objAsset.Batch_Number_lookup__c=objBatch_Number.Id;
        objAsset.InstallDate=system.today();
        objAsset.AccountId=objAccount.Id;
        objAsset.ContactId=objcontact.id;
        objAsset.Batch_Number_lookup__c=objBatch_Number.Id;
        objAsset.Batch_Number__c='1';
        objAsset.Order_Id__c=objOrder.Id;
        objAsset.Status='QA In Progress';       
        insert objAsset;             
    }
    @istest static void tesetasrecords(){
        Product2 Record_prodid=[select 
                         id,
                         name 
                         from Product2];       
        list<orderitem> List_oritem=new list<orderitem>();       
        test.startTest();        
        list<asset> List_assetreturnrecords= PF_AssetRecords.producttoassestrecords(Record_prodid.Id);        
        test.stopTest();
    }
    @istest static void createassetrecords_test(){
        list<Asset> List_createassetreturnrecords=new list<Asset>();        
        list<Asset>  List_assetrecordss=[select 
                                         id,
                                         name
                                         from asset ];
        list<string> List_assetids=new list<string>();
        order List_orderupdate=[select id,
                                Approved_Quantity__c 
                                from order];               
        for(Asset Record_assetrecord : List_assetrecordss){
            List_assetids.add(Record_assetrecord.id);            
        }        
        list<string> List_statusValues=new list<string>{'QA Pass'}; 
            system.debug('statusValues'+List_statusValues);       
        test.startTest();       
        PF_AssetRecords.CreateAssetRecords(List_assetids, List_statusValues);        
        test.stopTest();       
    }   
    @istest static void createassetrecords_test1(){
        list<Asset> List_createassetreturnrecords=new list<Asset>();     
        list<Asset>  List_assetrecordss=[select id,
                                         name 
                                         from asset ];
        list<string> List_assetids=new list<string>();
        order Record_orderupdate=[select id,
                                  Approved_Quantity__c
                                  from order];       
        for(Asset Record_asse : List_assetrecordss){
            List_assetids.add(Record_asse.id);          
        }        
        list<string> List_statusValues=new list<string>{'QA Pass'}; 
            system.debug('statusValues'+List_statusValues);       
        test.startTest();        
        Record_orderupdate.Approved_Quantity__c=null;
        update Record_orderupdate;
        PF_AssetRecords.CreateAssetRecords(List_assetids, List_statusValues);       
        test.stopTest();                
    }  
    @istest static void createassetrecords_test2(){
        list<Asset> List_createassetreturnrecords=new list<Asset>();        
        list<Asset>  List_assetrecordss=[select id,
                                         name 
                                         from asset ];
        list<string> List_assetids=new list<string>();
        order Record_orderupdate=[select id,
                           Approved_Quantity__c 
                           from order];      
        for(Asset Record_asse : List_assetrecordss){
            List_assetids.add(Record_asse.id);            
        }        
        list<string> List_statusValues=new list<string>{'QA Fail'}; 
            system.debug('statusValues'+List_statusValues);        
        test.startTest();       
        PF_AssetRecords.CreateAssetRecords(List_assetids, List_statusValues);       
        test.stopTest();                
    }
    @istest static void createassetrecords_test3(){
        list<Asset> List_createassetreturnrecords=new list<Asset>();       
        list<Asset>  List_assetrecordss=[select id,name from asset ];
        list<string> List_assetids=new list<string>();
        order Record_orderupdate=[select id,
                                  Approved_Quantity__c,
                                  Reject_Quantity__c 
                                  from order];        
        for(Asset Record_asse : list_assetrecordss){
            List_assetids.add(Record_asse.id);          
        }        
        list<string> List_statusValues=new list<string>{'QA Fail'}; 
            system.debug('statusValues'+List_statusValues);        
        test.startTest();
        Record_orderupdate.Approved_Quantity__c=9;       
        Record_orderupdate.Reject_Quantity__c=null;
        update Record_orderupdate;        
        PF_AssetRecords.CreateAssetRecords(List_assetids, List_statusValues);       
        test.stopTest();        
        
    }
    @istest static void test_UpdateFailedAssetRecords(){
        list<asset>  list_updateassetfailed=[select id,
                                             name 
                                             from asset ];
        list<string> list_updateassetstringids=new list<string>();
        for(asset Record_ups:list_updateassetfailed){
            list_updateassetstringids.add(Record_ups.id);
        }
        
        
        test.startTest();
        PF_AssetRecords.UpdateFailedAssetRecords(list_updateassetstringids);
        test.stopTest();}
    
    @istest static void testQAManagerOrderPro(){
        
        order Record_order=[select id,
                            name,
                            status
                            from order
                            where name='test order'];
        Record_order.Status='Fully Received Under QA';
        update Record_order;
        
        
        test.startTest();
        PF_AssetRecords.QAManagerOrderPro();
        
        test.stopTest();}
    @istest static void test_retrieveProductNameRecordsInQA(){
        
        //test.startTest();
        string String_proIdInQA=[select id,
                                 name 
                                 from Product2 ].name;
        test.startTest();
        PF_AssetRecords.retrieveProductNameRecordsInQA(String_proIdInQA);
        
        test.stopTest();
        
    }
    
    
}