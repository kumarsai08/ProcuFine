import { LightningElement, wire, track,api } from 'lwc';
import fetchInventory from '@salesforce/apex/Pf_Inventory_Summary.fetchInventory';
import getwarehousenamerecords from '@salesforce/apex/Pf_Inventory_Summary.getwarehousenamerecords';
import retrieveWarehouseRecords from '@salesforce/apex/Pf_Inventory_Summary.retrieveWarehouseRecords';
import getproductnamerecords from '@salesforce/apex/PF_orderdetails.getproductnamerecords';
import retrieveProductNameRecords from '@salesforce/apex/PF_orderdetails.retrieveProductNameRecords';
import productsRecords from '@salesforce/apex/Pf_Inventory_Summary.productsRecords';
import { NavigationMixin } from 'lightning/navigation';

export default class InventorySummary extends NavigationMixin (LightningElement) {
    @api list_Inventory;
    @api blnLoading;
    @api strProductName;
    @api strWarehouseNames;
    @api strProductOptions;
    @api strPassProductName;
    @api strWarehouseOptions;
    @api list_ProductNameFilter;
    @api list_AllWarehouse;
    @api list_AllProductList;
    @api list_WarehouseNames=[];
    @api list_ProductNamesFilter=[];
    @api list_WarehouseNameOptions;
    
    //This method is used to reload the inventory data on clicking of a button.
    handleRefresh(){
        this.list_Inventory=[];
        console.log('line 18');
        this.loadInventorySummary();
    }

    //This method is used to retrieve and load options for the 'Product' and 'Warehouse' dropdown menus in the UI. 
    connectedCallback(){
    this.loadInventorySummary();
    getwarehousenamerecords({}).then(result=>{
        this.list_WarehouseNames.push({label:'All',value:'All'});
        result.forEach(element => {
            this.list_WarehouseNames.push({label:element,value:element});
            this.list_WarehouseNameOptions = JSON.parse(JSON.stringify(this.list_WarehouseNames));
            console.log('line 53'+JSON.stringify(this.list_WarehouseNameOptions));
        });
})
.catch(error=>{
    console.log('error'+error);
})

getproductnamerecords({}).then(result=>{
    this.list_ProductNamesFilter.push({label:'All',value:'All'});
    result.forEach(element => {
        this.list_ProductNamesFilter.push({label:element,value:element});
        this.list_ProductNameFilter = JSON.parse(JSON.stringify(this.list_ProductNamesFilter));
        console.log('line 53'+JSON.stringify(this.list_ProductNameFilter));
    });
})
.catch(error=>{
console.log('error'+error);
})
   }


   //This method updates the Inventory list based on selected warehouse and product options, by fetching the data from the server and updating the list.
   handleWarehouseChange(event){
    console.log('line 95');
    this.strWarehouseOptions=event.detail.value;
    console.log('line 95'+ this.strWarehouseOptions);
    if(this.strProductOptions==null || this.strProductOptions=='All'){
    if (this.strWarehouseOptions==='All') {
        console.log('line 104');
        this.list_Inventory=this.list_AllWarehouse;
    } else {
        retrieveWarehouseRecords({searchsname: this.strWarehouseOptions}).then(result=>{
            console.log('line 13');
            let newData = JSON.parse(JSON.stringify(result));
            console.log('line 15');
            let templist=[];
            console.log('line 17');
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.list_Inventory = templist;
        console.log('line 15'+JSON.stringify(this.list_Inventory));
        })
        .catch(error=>{
            console.log('103 error'+error);
        });
   }
}
else{
    productsRecords({searchstatus:this.strWarehouseOptions, searchsname:this.strProductOptions}).then(result=>{
        console.log('line 227');
        console.log('this.strProductOptions 228'+this.strProductOptions);
        console.log('this.statusChange 229'+this.strWarehouseOptions);
        let newData = JSON.parse(JSON.stringify(result));
            console.log('line 15');
            let templist=[];
            console.log('line 17');        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.list_Inventory = templist;
        console.log('FINAL RESULT : '+JSON.stringify(this.list_Inventory));
        console.log('line 231'+JSON.stringify(this.list_Inventory));
    })
    .catch(error=>{
        console.log('234 error'+JSON.stringify(error));
    })
    
}
   }


   //This method filters product options and updates the Inventory based on the selected product or warehouse option.
   handleProductFilter(event){
    console.log('line 95');
    this.strProductOptions=event.detail.value;
    console.log('line 95'+ this.strProductOptions);
    if(this.strWarehouseOptions==null || this.strWarehouseOptions=='All'){
    if (this.strProductOptions==='All') {
        console.log('line 104');
        this.list_Inventory=this.list_AllProductList;
    } else {
        retrieveProductNameRecords({searchsproductname: this.strProductOptions}).then(result=>{
            console.log('RESULT : '+ JSON.stringify(result) );
            let newData = JSON.parse(JSON.stringify(result));
            console.log('line 15');
            let templist=[];
            console.log('line 17');
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.list_Inventory = templist;
        console.log('FINAL RESULT : '+JSON.stringify(this.list_Inventory));
        })
        .catch(error=>{
            console.log('103 error'+error);
        });
   }
}
else{
    productsRecords({searchstatus:this.strWarehouseOptions, searchsname:this.strProductOptions}).then(result=>{
        console.log('line 227');
        console.log('this.strProductOptions 228'+this.strProductOptions);
        console.log('this.statusChange 229'+this.strWarehouseOptions);
        let newData = JSON.parse(JSON.stringify(result));
            console.log('line 15');
            let templist=[];
            console.log('line 17');
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.list_Inventory = templist;
        console.log('FINAL RESULT : '+JSON.stringify(this.list_Inventory));
        console.log('line 231'+JSON.stringify(this.list_Inventory));
    })
    .catch(error=>{
        console.log('234 error'+JSON.stringify(error));
    })   
}
   }

    //This function fetches inventory data,checks for records with shortfall and assigns the updated data to different list variables.   
    loadInventorySummary(){
        fetchInventory().then(result=>{
            this.list_AllWarehouse=result;
            this.list_AllProductList=result;
            var newData = JSON.parse(JSON.stringify(result));
            let templist=[];
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.list_AllWarehouse=templist;
        this.list_AllProductList=templist;
        this.list_Inventory = templist;
        console.log('over'+JSON.stringify(this.list_Inventory));
        }).catch(error=>{
            console.log('Error fetchInventory:'+JSON.stringify(error));
        })
    }

    //This function handles a click event on a product and warehouse names, saves them and dispatches a custom event with the data.
    handlepassproductname(event){
        console.log('line 51');
        this.blnLoading=true;
        this.strWarehouseNames = event.currentTarget.dataset.strwarenames;
        this.strPassProductName= event.currentTarget.dataset.strProductName;
        console.log('line 53'+ this.strPassProductName);
        this.dispatchEvent(new CustomEvent('passproductdetails', {detail:{passproduct : this.strPassProductName, passwarehouse : this.strWarehouseNames }}));
        this.blnLoading=false;
        console.log('line 55');
    }

    //This method is used to navigate to product with a specific ID and opens it in a new tab.
    RecordPage(event){
        const prodID=event.target.dataset.strproductid;
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: prodID,
                 objectApiName: 'Product2',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
    }

    //This method is used to navigate to warehouse with a specific ID and opens it in a new tab.
    NavigatetowarehousePage(event){
        const ordId=event.target.dataset.strwarehouseid;
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: ordId,
                 objectApiName: 'Location',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
    }

     
  
    
}