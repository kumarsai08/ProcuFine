import { LightningElement, api } from 'lwc';
import pf_ProductSummary from '@salesforce/apex/pf_Opportunitysummary.pf_ProductSummary';
import getproductnamerecords  from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import ProductNameFilterInOpp from '@salesforce/apex/pf_Opportunitysummary.ProductNameFilterInOpp';
import {NavigationMixin} from 'lightning/navigation';

export default class Pf_OpportunitySummary extends NavigationMixin(LightningElement) {
    @api Product=[];
    @api productname;
    @api productNameFilter;
    @api productNamesList=[];
    @api productNameOptions;
    @api productOptions;
    @api AllProductList;
    @api passproductname;
    @api ChangedString;
    @api currentopportunityname;
    @api opportunityId;


    handleRefresh(){
       
        this.Product=[];
        console.log('line 18');
        this.loadInventorySummary();

    }
    connectedCallback(){
        this.loadInventorySummary();
        pf_ProductSummary({}).then(result=>{
            console.log('line 10');
            //this.Product=result;
            this.AllProductList=result;
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
       // this.allWarehouseList=templist;
        this.Product=templist;
           this.AllProductList=templist;
         })
    .catch(error=>{
        console.log('error'+error);
    })  
    getproductnamerecords({}).then(result=>{
        this.productNamesList.push({label:'All',value:'All'});
        result.forEach(element => {
            this.productNamesList.push({label:element,value:element});
            this.productNameOptions = JSON.parse(JSON.stringify(this.productNamesList));
            console.log('line 53'+JSON.stringify(this.productNameOptions));
        });
    })
    .catch(error=>{
        console.log('error'+error);
    })
}

navigateToProduct(event){
    const ProductRecordPage=event.target.dataset.orderproducturl;
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: ProductRecordPage,
             objectApiName: 'order',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

// handleRefresh(){
       
//     this.Product;
//     console.log('line 18');
//     pf_ProductSummary({}).then(result=>{
//         console.log('line 10');
       
//        console.log('Line 12'+JSON.stringify(result));

//        var newData = JSON.parse(JSON.stringify(result));
       
//         let templist=[];


loadInventorySummary(){
    pf_ProductSummary().then(result=>{
        this.Product=result;
        this.AllProductList=result;
        var newData = JSON.parse(JSON.stringify(result));
        let templist=[];
    newData.forEach(record => {
       let tempRecs = Object.assign({},record);
       if (record.Quantity__c > 0) {
        tempRecs.check = true;
       }  
       templist.push(tempRecs);
    });
    this.AllProductList=templist;
    this.Product=templist;
    console.log('line 15'+JSON.stringify(this.Product));
    })
.catch(error=>{
    console.log('Error at pf_ProductSummary:'+JSON.stringify(error));
}) 
}

// getproductnamerecords({}).then(result=>{
//     this.productNamesList.push({label:'All',value:'All'});
//     result.forEach(element => {
//         this.productNamesList.push({label:element,value:element});
//         this.productNameOptions = JSON.parse(JSON.stringify(this.productNamesList));
//         console.log('line 53'+JSON.stringify(this.productNameOptions));
//     });
// })
// .catch(error=>{
//     console.log('error'+error);
// })




 /*loadInventorySummary(){
        
    }*/


    

getProductName(event){
       console.log('line 42');
       this.productname=event.currentTarget.dataset.prod;
       //this.currentopportunityname=event.currentTarget.dataset.opportunityname;

       console.log('line 44'+this.productname);
        this.createtab=true;
        console.log('line 46'+this.createtab);
        this.dispatchEvent(new CustomEvent('productdetails', {detail:{product : this.productname, createtaboption : this.createtab }}));
        console.log('line 48');
    
        
       Handleproductdetails(event);
}
    

    
    handleProductChange(event){
        console.log('line 95');
        this.ChangedString=event.detail.value;
        console.log('line 95'+ this.ChangedString);
        //if(this.statusChange==null || this.statusChange=='All'){
            if (this.ChangedString==='All') {
                console.log('line 104');
                this.Product=this.AllProductList;
            } else {
                
                ProductNameFilterInOpp({searchsname: this.ChangedString}).then(result=>{
                    console.log('line 13');
                    var newData = JSON.parse(JSON.stringify(result));
           
            let templist=[];


       
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           if (record.Quantity__c > 0) {
            tempRecs.check = true;
           }  
           templist.push(tempRecs);
        });
       // this.allWarehouseList=templist;
        this.Product=templist;
                   // this.Product=result;
                   // console.log('line 15'+JSON.stringify(this.Product));
                })
                .catch(error=>{
                    console.log('103 error'+error);
                })
            }
        }
    handlepassproductname(event){
        console.log('line 51');
        this.passproductname= event.currentTarget.dataset.productname;
       // this.opportunityId=event.currentTarget.dataset.oppid;
        console.log('line 53'+ this.passproductname);
        this.dispatchEvent(new CustomEvent('passproductdetails', {detail:{passproduct : this.passproductname}}));
        console.log('line 55');


    }
   
}