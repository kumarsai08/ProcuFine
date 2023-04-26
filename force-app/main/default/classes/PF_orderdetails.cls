/*******************************************************************************************************
* 
* @ Name            :   PF_orderdetails
-* @ Purpose        :   It is used in the deliveryinformation component
* @ Author          :   Srikanth.Halavath
* @ Test Class Name :   Pf_TestClassFor_OrderDetailsClass
*
*   Date            |  Developer Name                   |  Version      
* ======================================================================================================
*  17-02-2023        |  himabindu.vanaparthi@absyz.com   |  1.0         
*                   |  manogna.koppula@absyz.com        |          
*                   |  kumarsaiVadapalli@absyz.com      |         
*                   |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/
public  class PF_orderdetails {
    @AuraEnabled
    public static List < OrderItem > fetchOrderProduct() {
        return[SELECT 
        id,
        Product2.Name,
        Product2Id,
        OrderId,
        Order.OrderNumber,
        Order.Under_QA__c,
        Order.On_Hand_Recieved__c,
        Order.Account.Name,
        Order.Quantity__c,
        Order.Received_Quantity__c,
        Order.Pending_Quantityy1__c,
        Order.Status,
        Product2.Rejected_Quantity__c,
        Order.RecordType.Name FROM OrderItem 
        WHERE  Order.RecordType.Name = 'Purchase Orders' 
        AND Order.status!='Fully Received Under QA' ORDER BY Order.OrderNumber ASC];    
    }
    @AuraEnabled
    public static List<Order> updateOrder(string strordervalue,integer intvalueRquantity ) {
        System.debug('ordervalue :: ' + strordervalue + 'valueee'+ intvalueRquantity );
        List<Order> list_ordlistquery = [SELECT 
        id,
        Quantity__c,
        Received_Quantity__c,
        Under_QA__c,
        On_Hand_Recieved__c,
        Pending_Quantityy1__c,
        Status,Product__c,
        Warehouse__c
        FROM Order WHERE id=:strordervalue];
        
        List<Inventory__c> list_invlist = [SELECT 
        Id,
        Product__c,
        On_Order__c,
        Order__c,
        Warehouse__c
        FROM Inventory__c
        WHERE Product__c = : list_ordlistquery[0].Product__c 
        AND Warehouse__c = : list_ordlistquery[0].Warehouse__c ];
        
        list<Inventory__c> list_newinvlist = new list<Inventory__c>();
        system.debug('ordlistquery :: ' + list_ordlistquery);
        for (Inventory__c objinv : list_invlist) {
            objinv.On_Order__c=objinv.On_Order__c-intvalueRquantity;
            objinv.Order__c=objinv.Order__c+intvalueRquantity;
            list_newinvlist.add(objinv);
        } 
        update list_newinvlist; 
        List<Order> list_updateOrderList = new List<Order>();
        for(Order objorder:list_ordlistquery){
            objorder.Under_QA__c= objorder.Under_QA__c   + intvalueRquantity;
            objorder.Received_Quantity__c = 0;
            objorder.On_Hand_Recieved__c=objorder.On_Hand_Recieved__c + intvalueRquantity;
            objorder.Pending_Quantityy1__c = objorder.Pending_Quantityy1__c - intvalueRquantity;
            list_updateOrderList.add(objorder);  
        } 
        system.debug('line 20');
        update  list_updateOrderList;
        system.debug('line 22');  
        return   list_updateOrderList;  
    }
    
    @AuraEnabled
    public static void createAsset(String strprodId,List<Object> objbatchNumbers,string strorderid,date deliverydate) {
        System.debug('Returmnmed cdata'+strprodId+''+objbatchNumbers);
        OrderItem ordObj =[SELECT 
        id,
        Product2Id,
        Order.AccountId,
        Order.Id,
        Order.Warehouse__c
        FROM OrderItem  
        WHERE Product2Id=:strprodId LIMIT 1];
        Batch_Number__c objBatchnumber = new  Batch_Number__c();
        objBatchnumber.Order__c = Id.valueOf(strorderid);
        objBatchnumber.Delivery_date__c = deliverydate;
        insert objBatchnumber;
        List<Asset> assetObjList = new List<asset>();
        integer len = objbatchNumbers.size();
        list<Product2> pd=[select id,name from Product2 where id=:strprodId];
        for(integer i=0;i<len;i++){
            Asset astObj = new Asset();
            astObj.InstallDate = deliverydate;
            astObj.LocationId = ordObj.Order.Warehouse__c;
            
            astObj.Product2Id = strprodId;
            astObj.Name = pd[0].name +' '+ 'Asset Delivery'+' '+i;
            astObj.AccountId=ordObj.Order.AccountId;
            astObj.Quantity=1.00;
            astObj.Order_Id__c=Id.valueOf(strorderid);
            astObj.SKU_Id__c = (String)objbatchNumbers[i];
            astObj.Batch_Number_lookup__c = objBatchnumber.Id;
            assetObjList.add(astObj);
        }
        insert assetObjList;   
    
    }
    @AuraEnabled
    public static List<string> getproductnamerecords() {
        List<string> list_productlist=new List<string>();
        List<Product2> list_product=[Select Id, Name, IsActive From Product2 WHERE IsActive=true];
        for (Product2 objproduct : list_product) {
            list_productlist.add(objproduct.Name);  
        }
        return list_productlist;      
    }
    @AuraEnabled
    public static List < OrderItem > retrieveProductRecords(String strsearchsname) {
        return[ SELECT 
        id,
        Product2.Name,
        Product2Id,
        OrderId,
        Order.OrderNumber,
        Order.Under_QA__c,
        Order.Quantity__c,
        Order.Received_Quantity__c,
        Order.Pending_Quantityy1__c,
        Order.Status
        FROM OrderItem
        WHERE Product2.Name LIKE:strsearchsname ];    
    }
    
    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String strsearchsproductname) {
        
        
        return [ SELECT 
        id,
        Warehouse__r.Name,
        Product__r.name,
        Quantity__c,
        Exsisting_Stock_On_Hand__c,
        On_Order__c,
        defective_quantity__c,
        Order__c,
        Under_QA_Num__c,
        Shortfall__c,
        Threshold__c
        FROM Inventory__c
        WHERE  Product__r.name != null 
        AND Warehouse__r.Name!=null
        AND Product__r.name LIKE:strsearchsproductname];
    }
    
    @AuraEnabled   
    public static List<Order> getSupplierDetails(String strsearchSupplier) {
        String strkey = '%' + strsearchSupplier + '%'; 
        return[SELECT 
        Id,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name,
        RecordType.Name 
        FROM Order 
        WHERE RecordType.Name = 'Purchase Orders'
        AND Account.Name!= null
        AND Warehouse__r.Name != null
        AND Product__r.Name != null
        AND Account.Name LIKE :strkey];
    }
    
    @AuraEnabled    
    public static List < Order > orderStatusFilter(String strsearchstatus) {
        if(strsearchstatus=='All'){
            return[SELECT 
            Name,
            Id,
            Type,
            EffectiveDate,
            Account.Name,
            Warehouse__r.Name,
            OrderNumber,
            Status,
            Product__c,
            Product__r.Name 
            FROM Order];    
        }else{
            return[SELECT
            Name,
            Id,
            Type,
            EffectiveDate,
            Account.Name,
            Warehouse__r.Name,
            OrderNumber,
            Status,
            Product__c,
            Product__r.Name
            FROM Order
            WHERE Status LIKE:strsearchstatus];    
        }
    }    
    @AuraEnabled   
    public static List < Order > orderStatusRecords(String strsearchstatus, String strsearchsname) {
        if(strsearchstatus=='All' || strsearchstatus== null ){
            return[SELECT 
            Id,
            EffectiveDate,
            Account.Name,
            Warehouse__r.Name,
            Order.On_Hand_Recieved__c,
            OrderNumber,
            Status,
            Product__c,
            Product__r.Name,
            RecordType.Name
            FROM Order
            WHERE RecordType.Name = 'Purchase Orders'
            AND Product__r.Name LIKE:strsearchsname];        
        }
        else if(strsearchsname=='All' ||  strsearchsname== null){
            System.debug('133');
            return[SELECT 
            Id,
            EffectiveDate,
            Account.Name,
            Warehouse__r.Name,
            Order.On_Hand_Recieved__c,
            OrderNumber,
            Status,
            Product__c,
            Product__r.Name,
            RecordType.Name
            FROM Order
            WHERE RecordType.Name = 'Purchase Orders'
            AND Account.Name!= null
            AND Warehouse__r.Name != null 
            AND Product__r.Name != null
            and Status LIKE:strsearchstatus ];    
            
        }else {
            return[SELECT 
            Id,
            EffectiveDate,
            Account.Name,
            Warehouse__r.Name,
            Order.On_Hand_Recieved__c,
            OrderNumber,
            Status,
            Product__c,
            Product__r.Name,
            RecordType.Name 
            FROM Order  
            WHERE RecordType.Name = 'Purchase Orders'
            AND Status LIKE:strsearchstatus 
            AND Product__r.Name LIKE:strsearchsname];    
        }
    }
    
    @AuraEnabled
    public static List < Order > orderProductNameFilter(String strsearchsname) {
        return [SELECT 
        Name,
        Id,
        Type,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name
        FROM Order where Product__r.Name LIKE:strsearchsname];
    }
    
    @AuraEnabled   
    public static List < OrderItem > statusRecords(String strsearchstatus, String strsearchsname) {
        system.debug(strsearchstatus);
        system.debug(strsearchsname);
        
        if(strsearchstatus=='All' || strsearchstatus == '' || strsearchstatus== null ){
            if(String.isNotBlank(strsearchsname) && !(strsearchsname.containsOnly('All')) ){
                
                return[SELECT 
                id,
                Product2.Name,
                Product2Id,
                OrderId,
                Order.RecordType.Name,
                Order.Account.Name,
                Order.On_Hand_Recieved__c,
                Order.OrderNumber,
                Order.Under_QA__c,
                Order.Quantity__c,
                Order.Received_Quantity__c,
                Order.Pending_Quantityy1__c,
                Order.Status
                FROM OrderItem 
                WHERE Product2.Name !=null
                AND Order.RecordType.Name = 'Purchase Orders'
                AND Order.Account.Name != null
                AND Order.status!='Fully Received Under QA'
                AND Product2.Name LIKE:strsearchsname
                ORDER BY order.orderNumber ];      
            }
            else{
                return [SELECT id,
                Product2.Name,
                Product2Id,
                OrderId,
                Order.Account.Name,
                Order.RecordType.Name,
                Order.On_Hand_Recieved__c,
                Order.OrderNumber,
                Order.Quantity__c,
                Order.Under_QA__c,
                Order.Received_Quantity__c,
                Order.Pending_Quantityy1__c,
                Order.Status 
                FROM OrderItem WHERE Order.Account.Name!=null 
                AND Order.status!='Fully Received Under QA'
                AND Order.RecordType.Name = 'Purchase Orders'
                ORDER BY order.orderNumber ] ;
                
            }
        }
        
        else if (strsearchstatus=='All' && strsearchsname=='All') {
            
            return[SELECT id,
            Product2.Name,
            Product2Id,
            OrderId,
            Order.Account.Name,
            Order.RecordType.Name, 
            Order.On_Hand_Recieved__c,
            Order.OrderNumber,
            Order.Quantity__c,
            Order.Under_QA__c,
            Order.Received_Quantity__c,
            Order.Pending_Quantityy1__c, 
            Order.Status 
            FROM OrderItem 
            WHERE Order.Account.Name!=null
            AND Order.status!='Fully Received Under QA'
            AND Order.RecordType.Name = 'Purchase Orders' 
            ORDER BY order.orderNumber ] ;
        }else if(strsearchsname=='All' || strsearchsname == '' || strsearchsname== null){
            if(String.isNotBlank(strsearchstatus) && !(strsearchstatus.containsOnly('All')) ){       
                return [SELECT
                id,
                Product2.Name,
                Product2Id,
                OrderId,
                Order.Account.Name,
                Order.RecordType.Name,
                Order.On_Hand_Recieved__c,
                Order.OrderNumber,
                Order.Under_QA__c,
                Order.Quantity__c,
                Order.Received_Quantity__c,
                Order.Pending_Quantityy1__c,
                Order.Status
                FROM OrderItem 
                WHERE Order.Status LIKE:strsearchstatus
                AND Order.Account.Name!=null 
                AND Order.RecordType.Name = 'Purchase Orders'
                AND Order.status!='Fully Received Under QA'
                ORDER BY order.orderNumber ];    
            }
            else{
                return [SELECT id,
                Product2.Name,
                Product2Id,
                OrderId,
                Order.Account.Name,
                Order.RecordType.Name,
                Order.On_Hand_Recieved__c,
                Order.OrderNumber,
                Order.Quantity__c,
                Order.Under_QA__c,
                Order.Received_Quantity__c,
                Order.Pending_Quantityy1__c,
                Order.Status 
                FROM OrderItem
                WHERE Order.Account.Name!=null 
                AND Order.status!='Fully Received Under QA' 
                AND Order.RecordType.Name = 'Purchase Orders' 
                ORDER BY order.orderNumber ] ;
                
            }
        }else {
            return [SELECT 
            id,
            Product2.Name,
            Product2Id,
            OrderId,
            Order.Account.Name,
            Order.RecordType.Name,
            Order.On_Hand_Recieved__c,
            Order.OrderNumber,
            Order.Under_QA__c,
            Order.Quantity__c,
            Order.Received_Quantity__c,
            Order.Pending_Quantityy1__c,
            Order.Status
            FROM OrderItem 
            WHERE Order.Status LIKE:strsearchstatus
            AND Product2.Name LIKE:strsearchsname 
            AND Order.status!='Fully Received Under QA'
            AND Order.RecordType.Name = 'Purchase Orders'
            AND Order.Account.Name!=null 
            ORDER BY order.orderNumber ];    
            
        }    
    }
    
    @AuraEnabled   
    public static List<Order> getOrderId(String strsearchKey) {
        String strkey = '%' + strsearchKey + '%'; 
        return [SELECT 
        Id,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name,
        RecordType.Name 
        FROM Order
        WHERE RecordType.Name = 'Purchase Orders'
        AND Account.Name!= null
        AND Warehouse__r.Name != null
        AND Product__r.Name != null
        AND OrderNumber LIKE :strkey];
    }
    
    @AuraEnabled    
    public static List < OrderItem > statusRecordsWithoutProduct(String strsearchstatus) {
        if(strsearchstatus=='All'){
            return [SELECT
            id,
            Product2.Name,
            Product2Id,
            OrderId,
            Order.OrderNumber,
            Order.Under_QA__c,
            Order.Quantity__c,
            Order.Received_Quantity__c,
            Order.Pending_Quantityy1__c,
            Order.Status
            FROM OrderItem ];    
            
            
        }else{
            return[SELECT 
            id,
            Product2.Name,
            Product2Id,
            OrderId, 
            Order.OrderNumber,
            Order.Under_QA__c,
            Order.Quantity__c,
            Order.Received_Quantity__c,
            Order.Pending_Quantityy1__c,
            Order.Status
            FROM OrderItem 
            WHERE Order.Status LIKE:strsearchstatus];    
            
        }
        
    }
    
    @AuraEnabled   
    public static integer getAssetRecords(String strassetRecs) {
        integer intAssetListSize=0;
        list<Asset> list_assetlist=[SELECT Id,
        Order_Id__c 
        FROM Asset 
        WHERE Order_Id__c =: strassetRecs];
        intAssetListSize=list_assetlist.size();
        return intAssetListSize;
        
    }
    
    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(){
        string strOrdertypename='';
        system.debug('Ordertypename'+strOrdertypename);
        return [SELECT
        Id,
        EffectiveDate,
        Account.Name,
        Warehouse__r.Name,
        OrderNumber,
        Status,
        Product__c,
        Product__r.Name,
        RecordType.Name
        FROM Order 
        WHERE EffectiveDate!=null 
        AND Account.Name!=null
        AND Warehouse__r.Name!=null
        AND OrderNumber!=null
        AND Status!=null 
        AND Product__c!=null
        AND Product__r.Name!=null
        AND RecordType.Name = 'Purchase Orders'
        ORDER BY OrderNumber ASC];
        
        
    }
    
    @AuraEnabled   
    public static List<OrderItem> getOrderIdQA(String strsearchKey) {
        String strkey = '%' + strsearchKey + '%'; 
        return [SELECT
        Order.Id,
        Order.OrderNumber,
        Product2.Id,
        Order.Status,
        Order.On_Hand_Recieved__c,
        Product2.Name,
        Order.Pending_Quantityy1__c,
        Order.Under_QA__c, 
        Order.Approved_Quantity__c,
        Order.Reject_Quantity__c
        FROM OrderItem 
        WHERE Order.OrderNumber like:strkey
        AND (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') 
        ORDER BY Order.OrderNumber ASC];
    }
    
    @AuraEnabled
    public static List < OrderItem > fetchSearchResultsDeliveryInfo(String strsearchKey) {
        String strsearchReturn = '%'+strsearchKey+'%';
        system.debug('line230'+strsearchReturn);
        
        return[SELECT 
        id,
        Product2.Name,
        Product2Id,
        OrderId, 
        Order.Account.Name,
        Order.OrderNumber,
        Order.Under_QA__c,
        Order.Quantity__c,
        Order.Received_Quantity__c,
        Order.On_Hand_Recieved__c,
        Order.Pending_Quantityy1__c, 
        Order.Status 
        FROM OrderItem 
        WHERE Product2.Name!=null 
        AND Order.Account.Name != null 
        AND  Order.Status !='Fully Received Under QA'
        AND Order.OrderNumber like:strsearchReturn ];    
    }
    
    @AuraEnabled
    public static List <Asset> Assetvalues(string strbatchname) {
        
        return[SELECT 
        name,
        Batch_Number_lookup__r.name,
        Product2.Name,
        SerialNumber,
        Batch_Number__c,
        SKU_Id__c,
        Status 
        FROM Asset WHERE Status='QA Pass' 
        AND Batch_Number_lookup__c =: strbatchname];    
    }  
}