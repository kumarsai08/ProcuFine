import { LightningElement, api , track,wire} from 'lwc';
import QAManagerOrderProduct from '@salesforce/apex/orderdetails.QAManagerOrderProduct';
import QAManagerOrderPro from '@salesforce/apex/assetRecords.QAManagerOrderPro';
import producttoassestrecords from '@salesforce/apex/assetRecords.producttoassestrecords';
import getproductnamerecords from '@salesforce/apex/orderdetails.getproductnamerecords';
import CreateAssetRecords from '@salesforce/apex/assetRecords.CreateAssetRecords';
import retrieveProductNameRecordsInQA from '@salesforce/apex/assetRecords.retrieveProductNameRecordsInQA';
import getOrderId from '@salesforce/apex/orderdetails.getOrderId';
import getAssetRecords from '@salesforce/apex/orderdetails.getAssetRecords';
//import getOrderIdQA from '@salesforce/apex/orderdetails.getOrderIdQA';
import fetchSearchResultsDeliveryInfo from '@salesforce/apex/orderdetails.fetchSearchResultsDeliveryInfo';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';



export default class PFQAManagerComponent extends NavigationMixin (LightningElement) {

    @api QATableList=[];
    @api isShowModal = false;
    @track productId1 = '';
    @api aslist;
    @api statusvalue;
    @api assetValue;
    @api assestid=[];
    @api asseststatus=[];
    @api updatedvalue;
    @api orderIdUrl;
    // @api recordPage;
    // @api productRecordPage;
    @api productIdUrl;
    templist=[];
    @track finalData;
    @api orderIdStatus;
   @track OrderItem;
   @api AllProductList;
   @api productNameFilterInQA;
    @api productNamesListFilterInQA=[];
    @api productOptionInQA;
    @api allProductListInQA;
    @api ListValues = [];
    @api selectedValues = {};
    connectedCallback(){
       
       QAManagerOrderPro({}).then(result=>{
            console.log('line 14');
           this.QATableList=result;
           this.allProductListInQA=result;
            /*var newData = JSON.parse(JSON.stringify(result));
            console.log('line 44'+JSON.stringify(newData));

    
            newData.forEach(record => {
                  let tempRecs = Object.assign({},record);
                

                   console.log('LINE 1'+JSON.stringify(tempRecs));
                   getAssetRecords({assetRecs : record.Order.Id}).then(result=>{
                    console.log('line 26');
                    console.log('line 27'+result);
                    tempRecs.underqaquantity=result;
                    console.log('LINE 25'+tempRecs.underqaquantity);
                    console.log('line 30'+JSON.stringify(tempRecs));
                    this.templist.push(tempRecs);
                    console.log('line 32'+JSON.stringify(this.templist));
                   });
                   console.log('Line 36:'+this.templist);
                });

                console.log('line 39'+this.templist);
       
                  // tempRecs.suppliername = record.Account.Name;
                 //  console.log('LINE 2'+record.Account.Name);
       
       
     
       
       
                 
                           
       
    
    console.log('line 45'+JSON.stringify(this.templist));   
    
    this.QATableList=this.templist;
    console.log('line 61')*/
    



        
    })
    .catch(error=>{
        console.log('error'+error);
    })

    getproductnamerecords({}).then(result=>{
        this.productNamesListFilterInQA.push({label:'All',value:'All'});
        result.forEach(element => {
            this.productNamesListFilterInQA.push({label:element,value:element});
            this.productNameFilterInQA = JSON.parse(JSON.stringify(this.productNamesListFilterInQA));
           // console.log('line 53'+JSON.stringify(this.productNameFilterInQA));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    console.log('102');
    }


    Navigatetoorder(event){
        const ordId=event.target.dataset.strorderid;
        // Navigate to a URL
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

        Navigatetoproduct(event){
            const ordId=event.target.dataset.strproducturl;
            // Navigate to a URL
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

//     navigateToOrder(event){
//         this.orderIdUrl=event.currentTarget.dataset.orderurl;
//         this.recordPage= 'https://absyz-1ab-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.orderIdUrl+'/view';
// }

// navigateToProduct(event){
//     this.productIdUrl=event.currentTarget.dataset.orderproducturl;
//     this.productRecordPage= 'https://absyz-1ab-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.productIdUrl+'/view';
// }

closeThePopup(){
    console.log('line 122');
    this.isShowModal = false;
}

handleClick(event){

    this.isShowModal = true;
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



}
value = 'QA In Progress';

get options() {
    return [
        { label: 'QA Pass', value: 'QA Pass' },
        { label: 'QA Fail', value: 'QA Fail' },
        //{ label: 'QA In Progress', value: 'QA In Progress' },
    ];
}
handlestatusupdation(event){
    console.log('line51')
   // this.ListValues.push(event.detail.value);
   const assetId = event.currentTarget.dataset.assetid;
    const selectedValue = event.detail.value;

    // Update the selectedValues property with the new selected value for the row
    this.selectedValues = { ...this.selectedValues, [assetId]: selectedValue };
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
    //this.updatedvalue=this.statusvalue;
    CreateAssetRecords({assetRecordIds:this.assestid, statusValues  : this.asseststatus}).then(result=>{
        console.log('LINE 74'+JSON.stringify(result));
        refreshApex(this.QATableList);
        this.pagerefresh();
        try{
            const refreshinventorymanagement= new CustomEvent("refreshinventory",{
            detail:''
        });
        this.dispatchEvent(refreshinventorymanagement);
    }
    catch(error){
        console.log('hello'+error.getMessage());

    }
//
        
    })
    .catch(error=>{
        console.log('error'+JSON.stringify(error));
    })
    this.isShowModal = false;
    console.log('line 173');
    
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
                                    fetchSearchResultsDeliveryInfo({searchKey:this.orderIdStatus}).then(result=>{
                                        console.log('line 13');
                                        this.QATableList=result;
                                        console.log('line 15'+JSON.stringify(this.QATableList));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                            }

        //handleProductFilterInQA

        handleProductFilterInQA(event){
            console.log('line 95');
            this.productOptionInQA=event.detail.value;
            console.log('line 95'+ this.productOptionInQA);
            if(this.statusChange==null || this.statusChange=='All'){
            if (this.productOptionInQA==='All') {
                console.log('line 104');
                this.QATableList=this.allProductListInQA;
            } else {
            
                retrieveProductNameRecordsInQA({proIdInQA: this.productOptionInQA}).then(result=>{
                    console.log('line 13');
                    this.QATableList=result;
                    console.log('line 15'+JSON.stringify(this.QATableList));
                })
                    .catch(error=>{
                    console.log('103 error'+error);
                    })
             }}
           }

          @api handlerefresh(event){
            console.log('line 222');
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