import { LightningElement, api , track,wire} from 'lwc';
// import QAManagerOrderProduct from '@salesforce/apex/orderdetails.QAManagerOrderProduct';
import QAManagerTable from '@salesforce/apex/pf_Opportunitysummary.QAManagerTable';
 import producttoassestrecords from '@salesforce/apex/pf_Opportunitysummary.producttoassestrecords';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
// import CreateAssetRecords from '@salesforce/apex/assetRecords.CreateAssetRecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
import CreateAssetRecords from '@salesforce/apex/pf_Opportunitysummary.CreateAssetRecords';
import retrieveProductNameRecordsInQA from '@salesforce/apex/pf_Opportunitysummary.retrieveProductNameRecordsInQA';
import fetchSearchResultsDeliveryInfo from '@salesforce/apex/pf_Opportunitysummary.fetchSearchResultsDeliveryInfo';
// import getAssetRecords from '@salesforce/apex/orderdetails.getAssetRecords';
import { NavigationMixin } from 'lightning/navigation';


export default class Pf_QAManager extends NavigationMixin (LightningElement) {

    @api QATableList=[];
    @track isShowModal = false;
    @track productId1 = '';
    @api aslist;
    @api statusvalue;
    @api assetValue;
    @api assestid=[];
    @api asseststatus=[];
    @api updatedvalue;
    @api orderIdUrl;
    @api recordPage;
    @api productRecordPage;
    @api productIdUrl;
    templist=[];
    @track finalData;
    @api orderIdStatus;
   @track OrderItem;
   @api AllProductList;
   @api productNameOptions;
    @api productNamesList=[];
    @api productOptionInQA;
    @api allProductListInQA;
    @api ChangedString;
    
    connectedCallback(){
        QAManagerTable({}).then(result=>{
            console.log('line 10');
           this.QATableList=result;
           this.AllProductList=result;
           console.log('Line 12'+JSON.stringify(result));
        })
    .catch(error=>{
        console.log('error'+error);
    }) 
       
    //     QAManagerOrderPro({}).then(result=>{
    //         console.log('line 14');
    //        this.QATableList=result;
    //        this.allProductListInQA=result;
                    
    // })
    // .catch(error=>{
    //     console.log('error'+error);
    // })

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



//     navigateToOrder(event){
//         this.orderIdUrl=event.currentTarget.dataset.orderurl;
//         this.recordPage= 'https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.orderIdUrl+'/view';

// }

navigateToProduct(event){
    this.productIdUrl=event.currentTarget.dataset.orderproducturl;
    this.productRecordPage='https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.productIdUrl+'/view';
}


 closeThePopup(){
    this.isShowModal = false;
}
navigateToOrder(event){
    const OrderRedirect=event.target.dataset.orderredirection;
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: OrderRedirect,
            objectApiName: 'order',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

navigateToProduct(event){
    const ProductRedirect=event.target.dataset.orderproducturl;
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: ProductRedirect,
            objectApiName: 'Product2',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
    }

handleClick(event){

     
     this.productId1 = event.target.dataset.proid;
     const ordName=event.target.dataset.set;
     console.log('line28'+ordName);
     producttoassestrecords({proId:ordName}).then(result=>{
         console.log('line 32'+JSON.stringify(result)); 
         this.aslist=result;
     })
     .catch(error=>{
         console.log('error'+error);
     })
     this.isShowModal = true;



 }
value = 'QA In Progress';

get options() {
    return [
       { label: 'QA Pass', value: 'QA Pass' },
        { label: 'QA Fail', value: 'QA Fail' },
         { label: 'QA In Progress', value: 'QA In Progress' },
     ];
 }
 handlestatusupdation(event){
     console.log('line51')
     this.statusvalue=event.detail.value;
     console.log('line51'+this.statusvalue);
     this.assetValue=event.currentTarget.dataset.assetid;
     console.log('line56'+this.assetValue);
    this.assestid.push(this.assetValue);
     console.log('line61'+this.assestid);
    this.asseststatus.push(this.statusvalue);
     console.log('line63'+this.asseststatus);




 }
 hideModalBox(event){
     this.updatedvalue=this.statusvalue;
     CreateAssetRecords({assetRecordIds:this.assestid, statusValues  : this.asseststatus}).then(result=>{
        console.log('LINE 74'+JSON.stringify(result));
     })
     .catch(error=>{
         console.log('error'+JSON.stringify(error));
     })
     this.isShowModal = false;
    
 }
handleKeyChange(event) {
    this.orderIdStatus = event.detail.value;
    console.log('line 95');
    // if (this.orderIdStatus==='All') {
    //  console.log('line 104');
     this.QATableList=this.AllProductList;
    // } 
    // else {
        getOrderId({searchKey:this.orderIdStatus}).then(result=>{
        console.log('line 13');
        this.QATableList=result;
        console.log('line 15'+JSON.stringify(this.QATableList));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    // }
}
 searchKey = '';
 @wire(getOrderId, { searchKey: '$searchKey' })
                            
                            Order;
                           handleKeyChange(event) {
                                this.orderIdStatus = event.detail.value;
                                console.log('line 95');
                                if (this.orderIdStatus==='All') {
                                    console.log('line 104');
                                    this.OrderItem=this.AllProductList;
                                } else {
                                    getOrderId({searchKey:this.orderIdStatus}).then(result=>{
                                        console.log('line 13');
                                        this.QATableList=result;
                                        console.log('line 15'+JSON.stringify(this.QATableList));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                            }

        handleProductFilterInQA

handleProductChange(event){
    console.log('line 95');
    this.ChangedString=event.detail.value;
    console.log('line 95'+ this.ChangedString);
    if(this.statusChange==null || this.statusChange=='All'){
        if (this.ChangedString==='All') {
            console.log('line 104');
            this.QATableList=this.AllProductList;
        } else {
            
            orderProductNameFilter({searchsname: this.ChangedString}).then(result=>{
                console.log('line 13');
                this.QATableList=result;
                console.log('line 15'+JSON.stringify(this.QATableList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }}
    }
           handleRefresh(event){
            QAManagerOrderPro({}).then(result=>{
                console.log('line 14');
               this.QATableList=result;
               this.allProductListInQA=result;
            })
            .catch(error=>{
                console.log('error'+error);
            })
           }
}