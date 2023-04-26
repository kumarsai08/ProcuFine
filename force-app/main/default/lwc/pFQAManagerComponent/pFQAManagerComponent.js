import { LightningElement, api , track,wire} from 'lwc';
import QAManagerOrderPro from '@salesforce/apex/PF_AssetRecords.QAManagerOrderPro';
import producttoassestrecords from '@salesforce/apex/PF_AssetRecords.producttoassestrecords';
import getproductnamerecords from '@salesforce/apex/PF_orderdetails.getproductnamerecords';
import CreateAssetRecords from '@salesforce/apex/PF_AssetRecords.CreateAssetRecords';
import retrieveProductNameRecordsInQA from '@salesforce/apex/PF_AssetRecords.retrieveProductNameRecordsInQA';
import getOrderIdQA from '@salesforce/apex/PF_orderdetails.getOrderIdQA';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import UpdateFailedAssetRecords from '@salesforce/apex/PF_AssetRecords.UpdateFailedAssetRecords';

export default class PFQAManagerComponent extends NavigationMixin (LightningElement) {

    @api list_QATableList=[];
    @api list_Asset;
    @api list_AssestId=[];
    @api list_AssestStatus=[];
    @api list_AssetFailIds = [];
    @api list_AllProductListInQA;
    @api list_ProductNameFilterInQA;
    @api list_ProductNamesFilter=[];
    @api strAssetValue;
    @api strStatusvalue;
    @api strOrderIdStatus;
    @track strProductId1 = '';
    @api strProductOptionInQA;
    @api objSelectedValues = {};
    @api blnLoading=false;
    @api blnIsShowModal = false;

//This code is used to fetch data and initialize variables.
//The getproductnamerecords function is being called to retrieve a list of product names, which are then used to populate a filter list.
    connectedCallback(){
       QAManagerOrderPro({}).then(result=>{
           console.log('line 14');
           this.list_QATableList=result;
           this.list_AllProductListInQA=result; 
    })
    .catch(error=>{
        console.log('error'+error);
    })

    getproductnamerecords({}).then(result=>{
        this.list_ProductNamesFilter.push({label:'All',value:'All'});
        result.forEach(element => {
            this.list_ProductNamesFilter.push({label:element,value:element});
            this.list_ProductNameFilterInQA = JSON.parse(JSON.stringify(this.list_ProductNamesFilter));
           // console.log('line 53'+JSON.stringify(this.list_ProductNameFilterInQA));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    console.log('102');
    }

//The function is used to reset certain variables and close a popup window.
closeThePopup(){
    console.log('line 122');
    this.list_AssestId=[];
    this.list_AssestStatus=[];
    this.blnIsShowModal = false;
}

//This method is used to handle the click event on a particular element, set some values, and fetch some data from the server using a Apex method and update a list.
handleClick(event){
    this.blnIsShowModal = true;
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
    const assetId = event.currentTarget.dataset.assetid;
    const selectedValue = event.detail.value;
    this.objSelectedValues = { ...this.objSelectedValues, [assetId]: selectedValue };
    this.strStatusvalue=event.detail.value;
    console.log('line51'+this.strStatusvalue);
    this.strAssetValue=event.currentTarget.dataset.assetid;
    console.log('line56'+this.strAssetValue);
    this.list_AssestId.push(this.strAssetValue);
    console.log('line61'+this.list_AssestId);
    this.list_AssestStatus.push(this.strStatusvalue);
    console.log('line63'+this.list_AssestStatus);
}

//This function is used to update the status of assets based on the user's selection and update any assets that failed the QA test, and then close the modal popup.
hideModalBox(event){
    console.log('asset ids '+this.list_AssestId)
    console.log('asset ids '+this.list_AssestStatus)
    for (let i = 0; i < this.list_AssestStatus.length; i++) {
        if(this.list_AssestStatus[i]==='QA Fail'){
            this.list_AssetFailIds.push(this.list_AssestId[i]);
        }
    }
    CreateAssetRecords({assetRecordIds:this.list_AssestId, statusValues  : this.list_AssestStatus}).then(result=>{
        console.log('LINE 74'+JSON.stringify(result));
        console.log('array length '+this.list_AssetFailIds.length)
        if(this.list_AssetFailIds.length==0){
            console.log('length ')
            this.list_AssestId=[];
        this.list_AssestStatus=[];   
        }
        refreshApex(this.list_QATableList);
        this.handlerefresh();
    })
    .catch(error=>{
        console.log('error'+JSON.stringify(error));
    })
    console.log('200 '+this.list_AssestStatus)
    console.log('202 '+this.list_AssetFailIds)
    UpdateFailedAssetRecords({FailedAssetIds : this.list_AssetFailIds}).then(result=>{
        console.log('assetlist'+JSON.stringify(result));
        this.list_AssestId=[];
        this.list_AssestStatus=[];
        this.list_AssetFailIds=[];
        refreshApex(this.list_QATableList);
        this.handlerefresh(); 
    })
    .catch(error=>{
        console.log('error'+JSON.stringify(error));
    })
    console.log('After methods  '+this.list_AssestId)
    console.log('After methods  '+this.list_AssestStatus)
    console.log('After methods  '+this.list_AssetFailIds)
    this.blnIsShowModal = false;
    console.log('line 173');
}
                           
Order;
//This method is used to handle the change event of a search input field and retrieve a list of order IDs that match the search term to display in a table.
    handleKeyChange(event) {
        this.strOrderIdStatus = event.detail.value;
        console.log('line 95' + this.strOrderIdStatus);
        getOrderIdQA({searchKey:this.strOrderIdStatus}).then(result=>{
        console.log('line 13');
        this.list_QATableList=result;
        console.log('line 15'+JSON.stringify(this.list_QATableList));
        })
        .catch(error=>{
        console.log('103 error'+error);
        })
                                
    }

    //This function is used to filter and retrieve the QA table list based on the selected product option.
        handleProductFilterInQA(event){
            console.log('line 95');
            this.strProductOptionInQA=event.detail.value;
            console.log('line 95'+ this.strProductOptionInQA);
            if(this.statusChange==null || this.statusChange=='All'){
            if (this.strProductOptionInQA==='All') {
                console.log('line 104');
                this.list_QATableList=this.list_AllProductListInQA;
            } else {
                retrieveProductNameRecordsInQA({proIdInQA: this.strProductOptionInQA}).then(result=>{
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
          @api handlerefresh(event){
            console.log('line 222');
            QAManagerOrderPro({}).then(result=>{
                console.log('line 14');
               this.list_QATableList=result;
               this.list_AllProductListInQA=result;
            })
            .catch(error=>{
                console.log('error'+error);
            })
           }

//This method is used to navigate to order with a specific ID and opens it in a new tab.
    Navigatetoorder(event){
        const ordId=event.target.dataset.strorderid;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes:{
                recordId: ordId,
                objectApiName: 'order',
                actionName:'view'
            }
        }).then(url =>{
            window.open(url, "_blank");
        })
        }

//This method is used to navigate to product with a specific ID and opens it in a new tab.
        Navigatetoproduct(event){
            const ordId=event.target.dataset.strproducturl;
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes:{
                    recordId: ordId,
                    objectApiName: 'product2',
                    actionName:'view'
                }
            }).then(url =>{
                window.open(url, "_blank");
            })
            }

//This method is used to navigate to batch number with a specific ID and opens it in a new tab.
            NavigatetoBatchnumber(event){
                const StrBatchId=event.target.dataset.batchid;
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes:{
                        recordId: StrBatchId,
                        objectApiName: 'Batch_Number__c',
                        actionName:'view'
                    }
                }).then(url =>{
                    window.open(url, "_blank");
                })
                }
}