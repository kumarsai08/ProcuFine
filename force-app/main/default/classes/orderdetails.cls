public  class orderdetails {
    @AuraEnabled
    public static List < OrderItem > fetchOrderProduct() {

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c,Order.On_Hand_Recieved__c, Order.Account.Name, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status,Product2.Rejected_Quantity__c ,Order.RecordType.Name from OrderItem WHERE  Order.RecordType.Name = 'Purchase Orders' AND Order.status!='Fully Received Under QA' order by Order.OrderNumber ASC];    
    }
    @AuraEnabled
    public static List<Order> updateOrder(string ordervalue,integer valueRquantity ) {
        System.debug('ordervalue :: ' + ordervalue + 'valueee'+ valueRquantity );
        List<Order> ordlistquery = [Select id,Quantity__c,Received_Quantity__c,Under_QA__c,On_Hand_Recieved__c,Pending_Quantityy1__c,Status,Product__c,Warehouse__c from Order where id=:ordervalue];
        List<Inventory__c> invlist = [SELECT Id,Product__c,On_Order__c,Order__c,Warehouse__c FROM Inventory__c WHERE Product__c = : ordlistquery[0].Product__c AND Warehouse__c = : ordlistquery[0].Warehouse__c ];
        list<Inventory__c> newinvlist = new list<Inventory__c>();
        system.debug('ordlistquery :: ' + ordlistquery);
        for (Inventory__c inv : invlist) {
            inv.On_Order__c=inv.On_Order__c-valueRquantity;
            inv.Order__c=inv.Order__c+valueRquantity;
            newinvlist.add(inv);
        } 
        update newinvlist; 
        List<Order> updateOrderList = new List<Order>();
        for(Order ord:ordlistquery){
            ord.Under_QA__c= ord.Under_QA__c   + valueRquantity;
            ord.Received_Quantity__c = 0;
            ord.On_Hand_Recieved__c=ord.On_Hand_Recieved__c + valueRquantity;
            ord.Pending_Quantityy1__c = ord.Pending_Quantityy1__c - valueRquantity;
            updateOrderList.add(ord);


        } 
        system.debug('line 20');
        update  updateOrderList;
        system.debug('line 22');  
        return   updateOrderList;  
    }

    /*@AuraEnabled
    public static List<Order> updatePendingQuantity(integer recquantity){
        System.debug('Line 25');
        List<Order> ordrList = [select id,Received_Quantity__c,Pending_Quantityy1__c from Order];
        System.debug('Line 27' + ordrList);
        List<Order> orderPendingList = new List<Order>();
        for(Order ords:ordrList){
            
            System.debug('Line 30'+ords);
            orderPendingList.add(ords);
        }
        System.debug('Line 33'+orderPendingList);

        update orderPendingList;
        return orderPendingList;
    }*/

    @AuraEnabled
    public static void createAsset(String prodId,List<Object> batchNumbers,string orderid,date deliverydate) {
        System.debug('Returmnmed cdata'+prodId+''+batchNumbers);
        OrderItem ordObj =[select id,Product2Id,Order.AccountId,Order.Id,Order.Warehouse__c from OrderItem  where Product2Id=:prodId LIMIT 1];
        Batch_Number__c BNObj = new  Batch_Number__c();
        BNObj.Order__c = Id.valueOf(orderid);
        BNObj.Delivery_date__c = deliverydate;
        insert BNObj;
        List<Asset> assetObjList = new List<asset>();
        integer len = batchNumbers.size();
        //len= len-1;
        list<Product2> pd=[select id,name from Product2 where id=:prodId];
        for(integer i=0;i<len;i++){
            Asset astObj = new Asset();
            astObj.InstallDate = deliverydate;
            astObj.LocationId = ordObj.Order.Warehouse__c;

            astObj.Product2Id = prodId;
            astObj.Name = pd[0].name +' '+ 'Asset Delivery'+' '+i;
            astObj.AccountId=ordObj.Order.AccountId;
            astObj.Quantity=1.00;
            astObj.Order_Id__c=Id.valueOf(orderid);
            astObj.SKU_Id__c = (String)batchNumbers[i];
            astObj.Batch_Number_lookup__c = BNObj.Id;

            assetObjList.add(astObj);
        }
        System.debug('list'+assetObjList);
        insert assetObjList;
        System.debug('inserted');
        
    }

    @AuraEnabled
    public static List<string> getproductnamerecords() {
         List<string> productlist=new List<string>();
         List<Product2> returnlist=[Select Id, Name, IsActive From Product2 WHERE IsActive=true];
        for (Product2 product : returnlist) {
            productlist.add(product.Name);  
        }
        return productlist;     

    }
    @AuraEnabled
    public static List < OrderItem > retrieveProductRecords(String searchsname) {
        

        return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name LIKE:searchsname ];    
    }

    @AuraEnabled
    public static List < Inventory__c > retrieveProductNameRecords(String searchsproductname) {
        

        return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Exsisting_Stock_On_Hand__c, On_Order__c, defective_quantity__c, Order__c, Under_QA_Num__c, Shortfall__c,Threshold__c from Inventory__c where  Product__r.name != null AND Warehouse__r.Name!=null AND Product__r.name LIKE:searchsproductname];
    }

    @AuraEnabled   
        public static List<Order> getSupplierDetails(String searchSupplier) {
            String key = '%' + searchSupplier + '%'; 
            return[SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE RecordType.Name = 'Purchase Orders' AND Account.Name!= null AND Warehouse__r.Name != null AND Product__r.Name != null AND Account.Name LIKE :key];
        }

    @AuraEnabled    
        public static List < Order > orderStatusFilter(String searchstatus) {
                if(searchstatus=='All'){
                    return[SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order];    
                }else{
                    return[SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order where Status LIKE:searchstatus];    
                }
        }    
        @AuraEnabled   
        public static List < Order > orderStatusRecords(String searchstatus, String searchsname) {
            if(searchstatus=='All' || searchstatus== null ){
                return[SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,Order.On_Hand_Recieved__c,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE RecordType.Name = 'Purchase Orders' and Product__r.Name LIKE:searchsname];        
            }

                //else if (searchstatus=='All' && searchsname=='All') {
    
            //return[SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order];
        //}
        else if(searchsname=='All' ||  searchsname== null){
            System.debug('133');
            return[SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,Order.On_Hand_Recieved__c,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE RecordType.Name = 'Purchase Orders' AND Account.Name!= null AND Warehouse__r.Name != null AND Product__r.Name != null and Status LIKE:searchstatus ];    
    
        }else {
            return[SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,Order.On_Hand_Recieved__c,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE RecordType.Name = 'Purchase Orders' and Status LIKE:searchstatus AND Product__r.Name LIKE:searchsname];    
   }
}

@AuraEnabled
    public static List < Order > orderProductNameFilter(String searchsname) {
        return[SELECT Name,Id,Type,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name FROM Order where Product__r.Name LIKE:searchsname];
    }


    // @AuraEnabled(cacheable=true)
    // public static List<string> getStatusRecords() {
    //      List<string> orderlist=new List<string>();
    //      List<Order> returnlist=[Select Id, Status From Order];
    //     for (Order odrs : returnlist) {
    //         orderlist.add(odrs.status);     
    //     }
    //     return orderlist;     

    // }
    @AuraEnabled   
    public static List < OrderItem > statusRecords(String searchstatus, String searchsname) {
        system.debug(searchstatus);
        system.debug(searchsname);

        if(searchstatus=='All' || searchstatus == '' || searchstatus== null ){
            if(String.isNotBlank(searchsname) && !(searchsname.containsOnly('All')) ){

            return[Select id,Product2.Name,Product2Id,OrderId, Order.RecordType.Name,Order.Account.Name,Order.On_Hand_Recieved__c, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name !=null AND Order.RecordType.Name = 'Purchase Orders' AND Order.Account.Name != null AND Order.status!='Fully Received Under QA' AND Product2.Name LIKE:searchsname order by order.orderNumber ];      
          }
          else{
            return [Select id,Product2.Name,Product2Id,OrderId,Order.Account.Name, Order.RecordType.Name, Order.On_Hand_Recieved__c, Order.OrderNumber, Order.Quantity__c,Order.Under_QA__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem WHERE Order.Account.Name!=null AND Order.status!='Fully Received Under QA'  AND Order.RecordType.Name = 'Purchase Orders' order by order.orderNumber ] ;

        }
        }
        
    



            else if (searchstatus=='All' && searchsname=='All') {

        return[Select id,Product2.Name,Product2Id,OrderId,Order.Account.Name, Order.RecordType.Name, Order.On_Hand_Recieved__c, Order.OrderNumber, Order.Quantity__c,Order.Under_QA__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem WHERE Order.Account.Name!=null AND Order.status!='Fully Received Under QA'  AND Order.RecordType.Name = 'Purchase Orders' order by order.orderNumber ] ;
    }else if(searchsname=='All' || searchsname == '' || searchsname== null){
        if(String.isNotBlank(searchstatus) && !(searchstatus.containsOnly('All')) ){        return[Select id,Product2.Name,Product2Id,OrderId,Order.Account.Name,Order.RecordType.Name, Order.On_Hand_Recieved__c, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus AND Order.Account.Name!=null AND Order.RecordType.Name = 'Purchase Orders' AND Order.status!='Fully Received Under QA' order by order.orderNumber ];    
        }
        else{
            return [Select id,Product2.Name,Product2Id,OrderId,Order.Account.Name, Order.RecordType.Name, Order.On_Hand_Recieved__c, Order.OrderNumber, Order.Quantity__c,Order.Under_QA__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem WHERE Order.Account.Name!=null AND Order.status!='Fully Received Under QA'  AND Order.RecordType.Name = 'Purchase Orders' order by order.orderNumber ] ;

        }
    }else {
        return[Select id,Product2.Name,Product2Id,OrderId,Order.Account.Name, Order.RecordType.Name,Order.On_Hand_Recieved__c, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus AND Product2.Name LIKE:searchsname  AND Order.status!='Fully Received Under QA' AND Order.RecordType.Name = 'Purchase Orders' AND Order.Account.Name!=null order by order.orderNumber ];    

    }
        
            

    }

    // @AuraEnabled   
    // public static List < Inventory__c > productRecords(String searchstatus) {
    //     if(searchstatus=='All'){
    //         return [ select id, Warehouse__r.Name, Product__r.name, Quantity__c, Stock_On_Hand__c, On_Order__c, Product__r.Rejected_Quantity__c, Order__c, Under_QA__c, Shortfall__c from Inventory__c where Product__r.name LIKE:searchstatus];      
    //     }   
    // }

    // @AuraEnabled   
    //     public static List<OrderItem> getOrderId(String searchKey) {
    //         String key = '%' + searchKey + '%';
    //         return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.OrderNumber LIKE :key];
    //     }
        @AuraEnabled   
        public static List<Order> getOrderId(String searchKey) {
            String key = '%' + searchKey + '%'; 
            return[SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE RecordType.Name = 'Purchase Orders' AND Account.Name!= null AND Warehouse__r.Name != null AND Product__r.Name != null AND OrderNumber LIKE :key];
            // return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where OrderNumber LIKE :key];
        }

        @AuraEnabled    
        public static List < OrderItem > statusRecordsWithoutProduct(String searchstatus) {
            //if(searchstatus=='All'){
               // return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name LIKE:searchsname];        }
               // else{
                if(searchstatus=='All'){
                    return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem ];    


                }else{
                    return[Select id,Product2.Name,Product2Id,OrderId, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Order.Status LIKE:searchstatus];    

                }
    
    
    
               // }
    
        }
    
        

    @AuraEnabled   
        public static integer getAssetRecords(String assetRecs) {
        integer AssetListSize=0;
        list<Asset> assetlist=[SELECT Id,Order_Id__c from Asset Where Order_Id__c =: assetRecs];
        AssetListSize=assetlist.size();
        return AssetListSize;

        }

        @AuraEnabled
        public static list<Order> OrderRecordsDatatable(){
        string Ordertypename='';
        system.debug('Ordertypename'+Ordertypename);
        return [SELECT Id,EffectiveDate,Account.Name,Warehouse__r.Name,OrderNumber,Status,Product__c,Product__r.Name,RecordType.Name FROM Order  WHERE EffectiveDate!=null AND Account.Name!=null AND Warehouse__r.Name!=null AND OrderNumber!=null AND Status!=null AND Product__c!=null AND Product__r.Name!=null AND RecordType.Name = 'Purchase Orders' Order by OrderNumber ASC];
        

    }

    @AuraEnabled   
        public static List<OrderItem> getOrderIdQA(String searchKey) {
            String key = '%' + searchKey + '%'; 
            return [SELECT Order.Id,Order.OrderNumber,Product2.Id,Order.Status,Order.On_Hand_Recieved__c, Product2.Name,Order.Pending_Quantityy1__c,Order.Under_QA__c, Order.Approved_Quantity__c, Order.Reject_Quantity__c from OrderItem WHERE Order.OrderNumber like:key AND (Order.Status='Partial Quantity Under QA' OR Order.Status='Fully Received Under QA') order by Order.OrderNumber ASC];
            // return[select id,PF_Product__r.Name,OrderNumber,Account.Name,EffectiveDate,Quantity__c,Received_Quantity__c,PF_Pending_Quantity__c,PF_Under_QA__c,Status FROM Order where OrderNumber LIKE :key];
        }
           
        @AuraEnabled
        public static List < OrderItem > fetchSearchResultsDeliveryInfo(String searchKey) {
            String searchReturn = '%'+searchKey+'%';
            system.debug('line230'+searchReturn);
    
            return[Select id,Product2.Name,Product2Id,OrderId, Order.Account.Name, Order.OrderNumber,Order.Under_QA__c, Order.Quantity__c,Order.Received_Quantity__c,Order.On_Hand_Recieved__c,Order.Pending_Quantityy1__c, Order.Status from OrderItem where Product2.Name!=null AND Order.Account.Name != null AND  Order.Status !='Fully Received Under QA' AND Order.OrderNumber like:searchReturn ];    
        }

        @AuraEnabled
        public static List <Asset> Assetvalues(string batchname) {
    
            return[select name,Batch_Number_lookup__r.name,Product2.Name,SerialNumber,Batch_Number__c,SKU_Id__c,Status from Asset where Status='QA Pass' AND Batch_Number_lookup__c =: batchname];    
        }
   
                                                                                               

}