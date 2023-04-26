import { LightningElement, api , track,wire} from 'lwc';
import QAManagerTable from '@salesforce/apex/pf_Opportunitysummary.QAManagerTable';
import producttoassestrecords from '@salesforce/apex/pf_Opportunitysummary.producttoassestrecords';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
import CreateAssetRecords from '@salesforce/apex/pf_Opportunitysummary.CreateAssetRecords';
import { NavigationMixin } from 'lightning/navigation';


export default class Pf_QAManager extends NavigationMixin (LightningElement) {

    @api list_QATableList=[];
    @track blnIsShowModal = false;
    @track strProductId1 = '';
    @api list_Asset;
    @api list_StatusValue;
    @api list_AssetValue;
    @api list_Assestid=[];
    @api list_asseststatus=[];
    @api list_UpdatedValue;
    @api strProductRecordPage;
    @api strProductIdUrl;
    @api strOrderIdStatus;
    @track list_OrderItem;
    @api list_AllProductList;
    @api list_ProductNameOptions;
    @api list_ProductNamesList=[];
    @api list_AllProductListInQA;
    @api strChangedString;
    
//This code is used to fetch data and initialize variables.
//The getproductnamerecords function is being called to retrieve a list of product names, which are then used to populate a filter list.
    connectedCallback(){
        QAManagerTable({}).then(result=>{
            console.log('line 10');
           this.list_QATableList=result;
           this.list_AllProductList=result;
           console.log('Line 12'+JSON.stringify(result));
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
    this.strProductIdUrl=event.currentTarget.dataset.orderproducturl;
    this.strProductRecordPage='https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.strProductIdUrl+'/view';
}

//The function is used to reset certain variables and close a popup window.
 closeThePopup(){
    this.blnIsShowModal = false;
}

//This method is used to navigate to order with a specific ID and opens it in a new tab.
navigateToOrder(event){
    const OrderRedirect=event.target.dataset.orderredirection;
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

//This method is used to navigate to product with a specific ID and opens it in a new tab.
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

//This method is used to handle the click event on a particular element, set some values, and fetch some data from the server using a Apex method and update a list.
handleClick(event){
     this.strProductId1 = event.target.dataset.proid;
     const ordName=event.target.dataset.set;
     console.log('line28'+ordName);
     producttoassestrecords({proId:ordName}).then(result=>{
         console.log('line 32'+JSON.stringify(result)); 
         this.list_Asset=result;
     })
     .catch(error=>{
         console.log('error'+error);
     })
     this.blnIsShowModal = true;
 }

//It defines options for a picklist with the default value set to 'QA In Progress'.
value = 'QA In Progress';
get options() {
    return [
       { label: 'QA Pass', value: 'QA Pass' },
        { label: 'QA Fail', value: 'QA Fail' },
         { label: 'QA In Progress', value: 'QA In Progress' },
     ];
 }

 //This code handles the selection of status update for an asset and stores the asset ID and status value in separate arrays.
 handlestatusupdation(event){
     console.log('line51')
     this.list_StatusValue=event.detail.value;
     console.log('line51'+this.list_StatusValue);
     this.list_AssetValue=event.currentTarget.dataset.assetid;
     console.log('line56'+this.list_AssetValue);
    this.list_Assestid.push(this.list_AssetValue);
     console.log('line61'+this.list_Assestid);
    this.list_asseststatus.push(this.list_StatusValue);
     console.log('line63'+this.list_asseststatus);
 }

 //This function is used to update the status of assets based on the user's selection and update any assets that failed the QA test, and then close the modal popup.
 hideModalBox(event){
     this.list_UpdatedValue=this.list_StatusValue;
     CreateAssetRecords({assetRecordIds:this.list_Assestid, statusValues  : this.list_asseststatus}).then(result=>{
        console.log('LINE 74'+JSON.stringify(result));
     })
     .catch(error=>{
         console.log('error'+JSON.stringify(error));
     })
     this.blnIsShowModal = false;
 }

 //This method is used to handle the change event of a search input field and retrieve a list of order IDs that match the search term to display in a table.
handleKeyChange(event) {
    this.strOrderIdStatus = event.detail.value;
    console.log('line 95');
     this.list_QATableList=this.list_AllProductList;
        getOrderId({searchKey:this.strOrderIdStatus}).then(result=>{
        console.log('line 13');
        this.list_QATableList=result;
        console.log('line 15'+JSON.stringify(this.list_QATableList));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
}

 searchKey = '';
 @wire(getOrderId, { searchKey: '$searchKey' })
                            
                            Order;
                           handleKeyChange(event) {
                                this.strOrderIdStatus = event.detail.value;
                                console.log('line 95');
                                if (this.strOrderIdStatus==='All') {
                                    console.log('line 104');
                                    this.list_OrderItem=this.list_AllProductList;
                                } else {
                                    getOrderId({searchKey:this.strOrderIdStatus}).then(result=>{
                                        console.log('line 13');
                                        this.list_QATableList=result;
                                        console.log('line 15'+JSON.stringify(this.list_QATableList));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                            }

//This function is used to filter and retrieve the QA table list based on the selected product option.
handleProductChange(event){
    console.log('line 95');
    this.strChangedString=event.detail.value;
    console.log('line 95'+ this.strChangedString);
    if(this.statusChange==null || this.statusChange=='All'){
        if (this.strChangedString==='All') {
            console.log('line 104');
            this.list_QATableList=this.list_AllProductList;
        } else {
            
            orderProductNameFilter({searchsname: this.strChangedString}).then(result=>{
                console.log('line 13');
                this.list_QATableList=result;
                console.log('line 15'+JSON.stringify(this.list_QATableList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }}
    }

    //This method is used to refresh the list of records displayed in the QA Manager component by calling an Apex method to retrieve the latest data from the server.
           handleRefresh(event){
            QAManagerOrderPro({}).then(result=>{
                console.log('line 14');
               this.list_QATableList=result;
               this.list_AllProductListInQA=result;
            })
            .catch(error=>{
                console.log('error'+error);
            })
           }
}