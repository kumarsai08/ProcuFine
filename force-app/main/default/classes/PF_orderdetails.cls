/*******************************************************************************************************
* 
* @ Name            :   PF_orderdetails
-* @ Purpose        :   It is used in the deliveryinformation component,orderdatatablecomponent.
* @ Author          :   Hima Bindu vanaparthi
* @ Test Class Name :   Pf_TestClassFor_OrderDetailsClass
*
*   Date            |  Developer Name                |  Version      
* ======================================================================================================
* 24-02-2023     |  himabindu.vanaparthi@absyz.com   |  1.0         
*                |  manogna.koppula@absyz.com        |          
*                |  kumarsaiVadapalli@absyz.com      |         
*                |  srikanth.halavath@absyz.com      |         
*******************************************************************************************************/
public  class PF_orderdetails {
     /**
    * @ description  : This method returns a list of order items with their associated product information, order information, and related account information, filtered by record type and order status, and sorted by order number in ascending order. 
    **/
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

    /** 
    * @ description  :  This method updates the Order and Inventory records based on the provided order ID and received quantity, and returns the updated Order records
    *  @params       :   ordervalue- Its used to store product records
    *  @params       :   valueRquantity- Its used to store quantity value
    **/
    @AuraEnabled
    public static List<Order> updateOrder(string ordervalue,integer valueRquantity ) {
        List<Order> list_ordlistquery = [SELECT 
                                            id,
                                            Quantity__c,
                                            Received_Quantity__c,
                                            Under_QA__c,
                                            On_Hand_Recieved__c,
                                            Pending_Quantityy1__c,
                                            Status,
                                            Product__c,
                                            Warehouse__c
                                            FROM Order WHERE id=:ordervalue];
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
        for (Inventory__c objinv : list_invlist) {
            objinv.On_Order__c=objinv.On_Order__c-valueRquantity;
            objinv.Order__c=objinv.Order__c+valueRquantity;
            list_newinvlist.add(objinv);
        } 
        update list_newinvlist; 
        List<Order> list_updateOrderList = new List<Order>();
        for(Order objorder:list_ordlistquery){
            objorder.Under_QA__c= objorder.Under_QA__c   + valueRquantity;
            objorder.Received_Quantity__c = 0;
            objorder.On_Hand_Recieved__c=objorder.On_Hand_Recieved__c + valueRquantity;
            objorder.Pending_Quantityy1__c = objorder.Pending_Quantityy1__c - valueRquantity;
            system.debug('line 80=>'+ objorder.Pending_Quantityy1__c);
            list_updateOrderList.add(objorder);  
        } 
         system.debug('line 83=>'+ list_updateOrderList);
        update  list_updateOrderList;
        return   list_updateOrderList;  
    }
    
     /** 
    * @ description  :  This method  creates multiple asset records with a given product ID, batch numbers, order ID, and delivery date, associating them with the respective order and batch number records
    *  @params       :   prodId- It is used to store product id
    *  @params       :   orderid-its used to store batchnumber list
    *  @params       :    deliverydate- Its used to store delivery date
    **/
    @AuraEnabled
    public static void createAsset(String prodId,List<Object> batchNumbers,string orderid,date deliverydate) {
        OrderItem ordObj =[SELECT 
        id,
        Product2Id,
        Order.AccountId,
        Order.Id,
        Order.Warehouse__c
        FROM OrderItem  
        WHERE Product2Id=:prodId LIMIT 1];
        Batch_Number__c objBatchnumber = new  Batch_Number__c();
        objBatchnumber.Order__c = Id.valueOf(orderid);
        objBatchnumber.Delivery_date__c = deliverydate;
        insert objBatchnumber;
        List<Asset> assetObjList = new List<asset>();
        integer intlen = batchNumbers.size();
        list<Product2> pd=[select id,name from Product2 where id=:prodId];
        for(integer i=0;i<intlen;i++){
            Asset objasset = new Asset();
            objasset.InstallDate = deliverydate;
            objasset.LocationId = ordObj.Order.Warehouse__c;
            
            objasset.Product2Id = prodId;
            objasset.Name = pd[0].name +' '+ 'Asset Delivery'+' '+i;
            objasset.AccountId=ordObj.Order.AccountId;
            objasset.Quantity=1.00;
            objasset.Order_Id__c=Id.valueOf(orderid);
            objasset.SKU_Id__c = (String)batchNumbers[i];
            objasset.Batch_Number_lookup__c = objBatchnumber.Id;
            assetObjList.add(objasset);
        }
        insert assetObjList;    
    }

    /**
    * @ description  :   This method retrieves the names of all active Product2 records and returns them as a list of strings.
    **/
    @AuraEnabled
    public static List<string> getproductnamerecords() {
        List<string> list_productlist=new List<string>();
        List<Product2> list_product=[SELECT 
                                        Id,
                                        Name,
                                        IsActive 
                                        FROM Product2 
                                        WHERE IsActive=true];
        for (Product2 objproduct : list_product) {
            list_productlist.add(objproduct.Name);  
        }
        return list_productlist;      
    }

    @AuraEnabled
    public static List < OrderItem > retrieveProductRecords(String searchsname) {
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
        WHERE Product2.Name LIKE:searchsname ];    
    }
    
    /**
    * @ description  :   This method used in inventorysummary component andretrieves a list of Inventory__c records where the Product name matches the given search string and returns certain fields including the Warehouse name, Product name, and quantities.
    * @params        : searchsproductname-It is used store productoptions
    **/
    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String searchsproductname) {
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
        AND Product__r.name LIKE:searchsproductname];
    }
    
    /**
    * @ description  :   This method retrieves a list of purchase orders with supplier details that match a given search string.
    * @params        : searchSupplier-It is used store supplierstatus
    **/
    @AuraEnabled   
    public static List<Order> getSupplierDetails(String searchSupplier) {
        String key = '%' + searchSupplier + '%'; 
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
        AND Account.Name LIKE :key];
    }
    
    @AuraEnabled    
    public static List < Order > orderStatusFilter(String searchstatus) {
        if(searchstatus=='All'){
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
            WHERE Status LIKE:searchstatus];    
        }
    }   
    
     /** 
    * @ description  :  This method retrieves a list of purchase orders based on their status and product name, with the option to retrieve all orders if either of the search parameters is set to "All" or null.
    *  @params        :   searchstatus - It is used to store status change 
    *  @params        :   searchsname - It is used to store changed status 
    **/
    @AuraEnabled   
    public static List < Order > orderStatusRecords(String searchstatus, String searchsname) {
        if(searchstatus=='All' || searchstatus== null ){
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
            AND Product__r.Name LIKE:searchsname];        
        }
        else if(searchsname=='All' ||  searchsname== null){
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
            and Status LIKE:searchstatus ];    
            
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
            AND Status LIKE:searchstatus 
            AND Product__r.Name LIKE:searchsname];    
        }
    }
    
    @AuraEnabled
    public static List < Order > orderProductNameFilter(String searchsname) {
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
        FROM Order where Product__r.Name LIKE:searchsname];
    }
    
     /** 
    * @ description  :  This method  retrieves a list of order items based on specified search criteria such as status and product nam
    *  @params        :   searchstatus - It is used to store status change 
    *  @params        :   searchsname - It is used to store changed status 
    **/
    @AuraEnabled   
    public static List < OrderItem > statusRecords(String searchstatus, String searchsname) {
        if(searchstatus=='All' || searchstatus == '' || searchstatus== null ){
            if(String.isNotBlank(searchsname) && !(searchsname.containsOnly('All')) ){
                
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
                AND Product2.Name LIKE:searchsname
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
        
        else if (searchstatus=='All' && searchsname=='All') {
            
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
        }else if(searchsname=='All' || searchsname == '' || searchsname== null){
            if(String.isNotBlank(searchstatus) && !(searchstatus.containsOnly('All')) ){       
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
                WHERE Order.Status LIKE:searchstatus
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
            WHERE Order.Status LIKE:searchstatus
            AND Product2.Name LIKE:searchsname 
            AND Order.status!='Fully Received Under QA'
            AND Order.RecordType.Name = 'Purchase Orders'
            AND Order.Account.Name!=null 
            ORDER BY order.orderNumber ];     
        }    
    }
    
     /** 
    * @ description  :  This method   retrieves a list of Purchase Order records based on a search key, including the order ID, effective date, account name, warehouse name, order number, status, and product information
    *  @params        :   searchKey -  It is used to search for a supplier
    **/
    @AuraEnabled   
    public static List<Order> getOrderId(String searchKey) {
        String key = '%' + searchKey + '%'; 
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
        AND OrderNumber LIKE :key];
    }
    
    @AuraEnabled    
    public static List < OrderItem > statusRecordsWithoutProduct(String searchstatus) {
        if(searchstatus=='All'){
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
            WHERE Order.Status LIKE:searchstatus];    
            
        }
        
    }
    
    @AuraEnabled   
    public static integer getAssetRecords(String assetRecs) {
        integer intAssetListSize=0;
        list<Asset> list_assetlist=[SELECT Id,
        Order_Id__c 
        FROM Asset 
        WHERE Order_Id__c =: assetRecs];
        intAssetListSize=list_assetlist.size();
        return intAssetListSize;
        
    }
    
    /**
    * @ description  :   This method retrieves a list of Purchase Order records with certain non-null fields and sorts them in ascending order by OrderNumber.
    **/
    @AuraEnabled
    public static list<Order> OrderRecordsDatatable(){
        string Ordertypename='';
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
    
     /** 
    * @ description  :  This method is used in pfQAManagercomponent and retrieves Order Items that match a search key and have a status of "Partial Quantity Under QA" or "Fully Received Under QA".
    *  @params        :   searchKey -  It is used to store order Id
    **/
    @AuraEnabled   
    public static List<OrderItem> getOrderIdQA(String searchKey) {
        String key = '%' + searchKey + '%'; 
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
        WHERE Order.OrderNumber like:key
        AND (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') 
        ORDER BY Order.OrderNumber ASC];
    }
    
    /** 
    * @ description  :  This method fetches a list of order items with delivery information based on a search key and specific conditions 
    *  @params        :   searchKey -  It is used to search for a supplier
    **/
    @AuraEnabled
    public static List < OrderItem > fetchSearchResultsDeliveryInfo(String searchKey) {
        String searchReturn = '%'+searchKey+'%'; 
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
        AND Order.OrderNumber like:searchReturn ];    
    }
    
     /** 
    * @ description  :  This method is used in pfassetdeliverySR and returns a list of Asset records filtered by batch name and status
    *  @params        :   batchname -  It is used to store batchnumberids.
    **/
    @AuraEnabled
    public static List <Asset> Assetvalues(string batchname) {
        return[SELECT 
        name,
        Batch_Number_lookup__r.name,
        Product2.Name,
        SerialNumber,
        Batch_Number__c,
        SKU_Id__c,
        Status 
        FROM Asset WHERE Status='QA Pass' 
        AND Batch_Number_lookup__c =: batchname];    
    }  
}