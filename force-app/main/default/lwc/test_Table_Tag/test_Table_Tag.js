import { LightningElement, wire, track,api } from 'lwc';
import fetchInventory from '@salesforce/apex/ExampleController.fetchInventory';
import getwarehousenamerecords from '@salesforce/apex/ExampleController.getwarehousenamerecords';
import retrieveWarehouseRecords from '@salesforce/apex/ExampleController.retrieveWarehouseRecords';
import getproductnamerecords from '@salesforce/apex/orderdetails.getproductnamerecords';
import retrieveProductNameRecords from '@salesforce/apex/ExampleController.retrieveProductNameRecords';
import productsRecords from '@salesforce/apex/ExampleController.productsRecords';
//import statusRecords from '@salesforce/apex/orderdetails.statusRecords';
import { NavigationMixin } from 'lightning/navigation';


export default class Test_Table_Tag extends NavigationMixin (LightningElement) {
    @api Inventory;
    @api productname;
    @api createtab;
    @api passproductname;
    @api warehouseNamesList=[];
    @api warehouseNameOptions;
    @api warehouseOptions;
    @track OrderItem;
    @api allWarehouseList;
    @api productNameFilter;
    @api productNamesListFilter=[];
    @api productOptions;
    @api allProductList;
   
   
   
    handleRefresh(){
       
        this.Inventory=[];
        console.log('line 18');
        this.loadInventorySummary();
        /*fetchInventory({}).then(result=>{
         //   this.allWarehouseList=result;
            var newData = JSON.parse(JSON.stringify(result));
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
       // this.allWarehouseList=templist;
        this.Inventory = templist;
        console.log('over');
        
        }).catch(error=>{
            console.log('Error fetchInventory:'+JSON.stringify(error));
        })*/
    }

   connectedCallback(){
    this.loadInventorySummary();
    getwarehousenamerecords({}).then(result=>{
        this.warehouseNamesList.push({label:'All',value:'All'});
        result.forEach(element => {
            this.warehouseNamesList.push({label:element,value:element});
            this.warehouseNameOptions = JSON.parse(JSON.stringify(this.warehouseNamesList));
            console.log('line 53'+JSON.stringify(this.warehouseNameOptions));
        });
})
.catch(error=>{
    console.log('error'+error);
})

getproductnamerecords({}).then(result=>{
    this.productNamesListFilter.push({label:'All',value:'All'});
    result.forEach(element => {
        this.productNamesListFilter.push({label:element,value:element});
        this.productNameFilter = JSON.parse(JSON.stringify(this.productNamesListFilter));
        console.log('line 53'+JSON.stringify(this.productNameFilter));
    });
})
.catch(error=>{
console.log('error'+error);
})
   }

   handleWarehouseChange(event){
    console.log('line 95');
    this.warehouseOptions=event.detail.value;
    console.log('line 95'+ this.warehouseOptions);
    if(this.productOptions==null || this.productOptions=='All'){
    if (this.warehouseOptions==='All') {
        console.log('line 104');
        this.Inventory=this.allWarehouseList;
    } else {
    
        retrieveWarehouseRecords({searchsname: this.warehouseOptions}).then(result=>{
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
        this.Inventory = templist;
       // this.allWarehouseList=result;
           // this.Inventory=result;
        console.log('line 15'+JSON.stringify(this.Inventory));
        })
        .catch(error=>{
            console.log('103 error'+error);
        });
    
   }
}
else{
    productsRecords({searchstatus:this.warehouseOptions, searchsname:this.productOptions}).then(result=>{
        console.log('line 227');
        console.log('this.productOptions 228'+this.productOptions);
        console.log('this.statusChange 229'+this.warehouseOptions);
        this.Inventory=result;
        console.log('line 231'+JSON.stringify(this.Inventory));
    })
    .catch(error=>{
        console.log('234 error'+JSON.stringify(error));
    })
    
}
   }


   handleProductFilter(event){
    console.log('line 95');
    this.productOptions=event.detail.value;
    console.log('line 95'+ this.productOptions);
    if(this.warehouseOptions==null || this.warehouseOptions=='All'){
    if (this.productOptions==='All') {
        console.log('line 104');
        this.Inventory=this.allProductList;
    } else {
    
        retrieveProductNameRecords({searchsname: this.productOptions}).then(result=>{
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
        this.Inventory = templist;
       // this.allWarehouseList=result;
           // this.Inventory=result;
        console.log('line 15'+JSON.stringify(this.Inventory));
        })
        .catch(error=>{
            console.log('103 error'+error);
        });
    
   }
}

else{
    productsRecords({searchstatus:this.warehouseOptions, searchsname:this.productOptions}).then(result=>{
        console.log('line 227');
        console.log('this.productOptions 228'+this.productOptions);
        console.log('this.statusChange 229'+this.warehouseOptions);
        this.Inventory=result;
        console.log('line 231'+JSON.stringify(this.Inventory));
    })
    .catch(error=>{
        console.log('234 error'+JSON.stringify(error));
    })
    
}
   }


   
    loadInventorySummary(){
        fetchInventory().then(result=>{
            this.allWarehouseList=result;
            this.allProductList=result;
            var newData = JSON.parse(JSON.stringify(result));
           
            let templist=[];

        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.allWarehouseList=templist;
        this.allProductList=templist;
        this.Inventory = templist;

        console.log('over'+JSON.stringify(this.Inventory));
        
        }).catch(error=>{
            console.log('Error fetchInventory:'+JSON.stringify(error));
        })
    }


   
    loadInventorySummary(){
        fetchInventory().then(result=>{
            this.allWarehouseList=result;
            this.allProductList=result;
            var newData = JSON.parse(JSON.stringify(result));
           
            let templist=[];

        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           if (record.Shortfall__c > 0) {
            tempRecs.check = true;
           }   
           templist.push(tempRecs);
        });
        this.allWarehouseList=templist;
        this.allProductList=templist;
        this.Inventory = templist;

        console.log('over'+JSON.stringify(this.Inventory));
        
        }).catch(error=>{
            console.log('Error fetchInventory:'+JSON.stringify(error));
        })
    }

   

    getProductName(event){
        console.log('line 42');
        this.productname=event.currentTarget.dataset.prod;
        console.log('line 44'+this.productname);
        this.createtab=true;
        console.log('line 46'+this.createtab);
        this.dispatchEvent(new CustomEvent('productdetails', {detail:{product : this.productname, createtaboption : this.createtab }}));
        console.log('line 48');

        
        Handleproductdetails(event);
    }

    handlepassproductname(event){
        console.log('line 51');
        this.passproductname= event.currentTarget.dataset.productname;
        console.log('line 53'+ this.passproductname);
        this.dispatchEvent(new CustomEvent('passproductdetails', {detail:{passproduct : this.passproductname }}));
        console.log('line 55');


    }

    RecordPage(event){
        const strproductid=event.target.dataset.strproductid;
         // Navigate to a URL
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: strproductid,
                 objectApiName: 'Product2',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
    }


    NavigatetowarehousePage(event){
        const ordId=event.target.dataset.strwarehouseid;
         // Navigate to a URL
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

    pagerefresh(event){
        console.log('Refreshing the content');
        this.loadInventorySummary();
    }
}