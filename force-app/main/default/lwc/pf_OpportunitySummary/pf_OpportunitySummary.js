import { LightningElement, api } from 'lwc';
import pf_ProductSummary from '@salesforce/apex/pf_Opportunitysummary.pf_ProductSummary';
import getproductnamerecords  from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import ProductNameFilterInOpp from '@salesforce/apex/pf_Opportunitysummary.ProductNameFilterInOpp';
import {NavigationMixin} from 'lightning/navigation';

export default class Pf_OpportunitySummary extends NavigationMixin(LightningElement) {
    @api List_Product=[];
    @api list_AllProductList;
    @api list_ProductNameOptions;
    @api list_ProductNamesList=[];
    @api strProductName;
    @api strPassProductName;
    @api strChangedString;

    //This method is used to reload the inventory data on clicking of a button.
    handleRefresh(){
        this.List_Product=[];
        console.log('line 18');
        this.loadInventorySummary();
    }

    //This method is used to retrieve and load options for the 'Product' dropdown menu in the UI. 
    connectedCallback(){
        this.loadInventorySummary();
        pf_ProductSummary({}).then(result=>{
            console.log('line 10');
            //this.Product=result;
            this.list_AllProductList=result;
           console.log('Line 12'+JSON.stringify(result));
           var newData = JSON.parse(JSON.stringify(result));
            let templist=[];

        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           if (record.Quantity__c > record.PF_On_Order__c) {
            tempRecs.check = true;
           }  
           templist.push(tempRecs);
        });
        this.List_Product=templist;
           this.list_AllProductList=templist;
         })
    .catch(error=>{
        console.log('error'+error);
    })  
    getproductnamerecords({}).then(result=>{
        this.list_ProductNamesList.push({label:'All',value:'All'});
        result.forEach(element => {
            this.list_ProductNamesList.push({label:element,value:element});
            this.list_ProductNameOptions = JSON.parse(JSON.stringify(this.list_ProductNamesList));
            console.log('line 53'+JSON.stringify(this.list_ProductNameOptions));
        });
    })
    .catch(error=>{
        console.log('error'+error);
    })
}

//This method is used to navigate to product with a specific ID and opens it in a new tab.
navigateToProduct(event){
    const ProductRecordPage=event.target.dataset.orderproducturl;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: ProductRecordPage,
             objectApiName: 'Product2',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

//This function fetches inventory data,checks for records with opportunity quantity and assigns the updated data to different list variables.   
loadInventorySummary(){
    pf_ProductSummary().then(result=>{
        //this.Product=result;
        this.list_AllProductList=result;
        var newData = JSON.parse(JSON.stringify(result));
        let templist=[];
    newData.forEach(record => {
       let tempRecs = Object.assign({},record);
       if (record.Quantity__c > 0) {
        tempRecs.check = true;
       }  
       templist.push(tempRecs);
    });
    this.list_AllProductList=templist;
    this.List_Product=templist;
    console.log('line 15'+JSON.stringify(this.List_Product));
    })
.catch(error=>{
    console.log('Error at pf_ProductSummary:'+JSON.stringify(error));
}) 
}

//The code is handles a click event on product name, stores the selected product's name in a variable, and creats a tab. Then it's dispatching a custom event, and calls a function with the same event object.
getProductName(event){
       console.log('line 42');
       this.strProductName=event.currentTarget.dataset.prod;
       console.log('line 44'+this.strProductName);
        this.createtab=true;
        console.log('line 46'+this.createtab);
        this.dispatchEvent(new CustomEvent('productdetails', {detail:{product : this.strProductName, createtaboption : this.createtab }}));
        console.log('line 48');
       Handleproductdetails(event);
}
    

//This method filters product options and updates the Inventory based on the selected product option.
    handleProductChange(event){
        console.log('line 95');
        this.strChangedString=event.detail.value;
        console.log('line 95'+ this.strChangedString);
            if (this.strChangedString==='All') {
                console.log('line 104');
                this.List_Product=this.list_AllProductList;
            } else {                
                ProductNameFilterInOpp({searchsname: this.strChangedString}).then(result=>{
                    console.log('line 13');
                    let newData = JSON.parse(JSON.stringify(result));
                    console.log('line 15');
                    let templist=[];
                    console.log('line 17');
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           console.log('line 19'+tempRecs);
           console.log('line 20'+JSON.stringify(tempRecs));
           if (record.Quantity__c > 0) {
            tempRecs.check = true;
           }  
           templist.push(tempRecs);
        });
        this.List_Product=templist;
                console.log('line 15'+JSON.stringify(this.List_Product));
                })
                .catch(error=>{
                    console.log('103 error'+error);
                })
            }
        }
//This function handles a click event on product names, saves them and dispatches a custom event with the data.
    handlepassproductname(event){
        console.log('line 51');
        this.strPassProductName= event.currentTarget.dataset.productname;
        console.log('line 53'+ this.strPassProductName);
        this.dispatchEvent(new CustomEvent('passproductdetails', {detail:{passproduct : this.strPassProductName}}));
        console.log('line 55');


    }
   
}