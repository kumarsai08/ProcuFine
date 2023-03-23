import { LightningElement, wire, track, api } from 'lwc';
import fetchOrderProduct from '@salesforce/apex/pf_Opportunitysummary.fetchOrderProduct';
import updateOrder from '@salesforce/apex/pf_Opportunitysummary.updateOrder';
import createAsset from '@salesforce/apex/pf_Opportunitysummary.createAsset';
// //import updatePendingQuantity from '@salesforce/apex/orderdetails.updatePendingQuantity';
// import getassetrecords from '@salesforce/apex/Assetdetails.getassetrecords';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
// //import getStatusRecords from '@salesforce/apex/orderdetails.getStatusRecords';
import orderStatusRecords from '@salesforce/apex/pf_Opportunitysummary.orderStatusRecords';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
import orderStatusFilter from '@salesforce/apex/pf_Opportunitysummary.orderStatusFilter';
import { NavigationMixin } from 'lightning/navigation';


const DELAY = 300;

export default class Pf_DeliveryInformation extends NavigationMixin (LightningElement) {
    //  result;
    //  resultnumber;
    value ;
    @api productrecord;
    @api quantityvalue;
    @api changevalue=false;
    @api receivedQuan;
    @api isShowModal;
    @api dat=[];
    @api productName;
    @track OrderItem;
    @track batchNumberList=[];
    @track proId;
    @api integerquantityvalue;
    @api productNamesList=[];
    @api productNameOptions;
    @api ChangedString;
    @api AllProductList;
    @api ChangedStatus;
    @api recordPageUrl;
    @api orderIdURL;
    @api AllOrderId;
    @api orderIdStatus;
    @api quanti;
    @api StrSupplierName='';
    
    
    connectedCallback(){
    //     fetchOrderProduct({}).then(result=>{
    //         console.log('line 10');
    //        this.OrderItem=result;
    //        this.AllProductList=result;
    //        console.log('Line 12'+JSON.stringify(result));
    //     })
    // .catch(error=>{
    //     console.log('error'+error);
    // }) 
        this.loadData();
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
    //     //     this[NavigationMixin.GenerateUrl]({
    //     //         type: 'standard__recordPage',
    //     //         attributes: {
    //     //             recordId: this.orderURL',
    //     //             actionName: 'view',
    //     //         },
    //     //     }).then(url => {
    //     //             //2. Assign it to the prop
    //     //         this.recordPageUrl = url;
    //     //     });
    //     // }
    //     //     getStatusRecords({}).then(result=>{
    //     //         this.statusList.push({label:'All',value:'All'});
    //     //         result.forEach(element => {
    //     //             this.statusList.push({label:element,value:element});
    //     //             this.statusNameOptions = JSON.parse(JSON.stringify(this.statusList));
    //     //             console.log('line 53'+JSON.stringify(this.statusNameOptions));
    //     //         });
    //     // })
    //     // .catch(error=>{
    //     //     console.log('error'+error);
    //     // })
        
     }
    
    // // HandleClick(event){
    // //     const recordId = event.target.dataset.
    // //     this[NavigationMixin.GenerateUrl]({
    // //         type: 'standard__recordPage',
    // //         attributes: {
    // //             recordId: recordId,
    // //             actionName: 'view',
    // //         },
    // //     }).
    // // }
    handleOnClick(event){
        const OrderPage=event.target.dataset.orderrecordurl;
         // Navigate to a URL
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: OrderPage,
                 objectApiName: 'Order',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
    }

    @api loadData(){ 

        fetchOrderProduct().then(result=>{
            console.log('24:'+JSON.stringify(result));
            this.OrderItem=result;
            this.AllProductList=result;
            console.log('this.OrderItem'+this.OrderItem);
        }).catch(error=>{
            console.log('Error 27:'+JSON.stringify(error));
        });
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

    handleonchange(event){
        console.log('line 15');
        this.changevalue=true;
        
        this.quantityvalue=event.target.value;
        console.log('line 16'+ typeof this.quantityvalue);
    }


    handleSave(event) {
        this.StrSupplierName= event.currentTarget.dataset.suppliername;
        console.log('supp name'+this.StrSupplierName);
        this.receivedQuan=''
        this.dat =[]
        const updatedFields = event.detail.draftValues;
        this.productrecord= event.currentTarget.dataset.idname;
        let ele =this.template.querySelector('.pt-3-half').value
        console.log('tfye',event.currentTarget.dataset.recquantity)
        this.receivedQuan=event.currentTarget.dataset.recquantity;
        console.log('tfye',this.receivedQuan)
        this.productName=event.currentTarget.dataset.proname;
        this.proId = event.currentTarget.dataset.proid;       
        //this.quantityvalue= event.currentTarget.dataset.recquantity;
        console.log('quantityy'+ this.productrecord);
        for (let i = 0; i < this.receivedQuan; i++) {
            this.dat.push(i);
        }
        console.log('line',this.dat)  
        this.isShowModal=true
                    }
  hideModalBox(){
                        console.log('Product Id',JSON.stringify(this.proId))
                        const allValid = [
                            ...this.template.querySelectorAll('lightning-input'),
                        ].reduce((validSoFar, inputCmp) => {
                            inputCmp.reportValidity('Fill the field');
                            inputCmp.showHelpMessageIfInvalid();
                            if(inputCmp.value){
                                this.batchNumberList.push(inputCmp.value);
                            }
                            console.log('sr'+inputCmp.value);
                            return validSoFar && inputCmp.checkValidity();
                        }, true);
                        if (allValid) {
                            console.log('195',this.quanti)
                            // for(let i;i<this.quanti;i++){
                            //     this.batchNumberList.push(i);
                            // }
                            this.isShowModal=false
                            //alert('All form entries look valid. Ready to submit!');
                            console.log('tyope of',this.batchNumberList)
                            //console.log('product id 161 '+this.ProductId);
                            //let ele =this.template.querySelectorAll('.pt-3-half').value
                            createAsset({prodId : this.proId,batchNumbers : this.batchNumberList, orderid : this.productrecord }).then(result=>{
                                this.prodId=''
                                this.quanti=0;
                                this.batchNumberList=[]
                                console.log('check'+this.batchNumberList);
                                this.dispatchEvent(new CustomEvent('qarefresh'));
                            }).catch(error=>{
                                console.log('Error 27:'+JSON.stringify(error));
                            });
                            
                            updateOrder({ordervalue : this.productrecord,valueRquantity : this.quantityvalue  }).then(result=>{
                                console.log('line 52'+ JSON.stringify(result));
                            }).catch(error =>{
                                console.log(error);
                            }).finally(() =>{
                                this.loadData();
                                console.log('line 64');
                            });
                            console.log('line 61');
                            this.quantityvalue=0
                        } else {
                            this.isShowModal=true
                        }
                    }
                        
                        
                        handleProductChange(event){
                            console.log('line 95');
                            this.ChangedString=event.detail.value;
                            console.log('line 95'+ this.ChangedString);
                            if(this.statusChange==null || this.statusChange=='All'){
                                if (this.ChangedString==='All') {
                                    console.log('line 104');
                                    this.OrderItem=this.AllProductList;
                                } else {
                                    
                                    orderProductNameFilter({searchsname: this.ChangedString}).then(result=>{
                                        console.log('line 13');
                                        this.OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }}
                                else{
                                    orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
                                        console.log('line 227');
                                        console.log('this.ChangedString 228'+this.ChangedString);
                                        console.log('this.statusChange 229'+this.statusChange);
                                        this.OrderItem=result;
                                        console.log('line 231'+JSON.stringify(this.OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('234 error'+JSON.stringify(error));
                                    })
                                    
                                }
                            }
                            
                            get orderOptions() {
                                return [
                                    { label: 'All', value: 'All' },
                                    { label: 'Order Placed', value: 'Order Placed' },
                                    { label: 'Partial Quantity Under QA', value: 'Partial Quantity Under QA' },
                                    { label: 'Fully Received Under QA', value: 'Fully Received Under QA' }
                                ];
                            }
                            handleStatusChange(event) {
                                console.log('line 233'+this.ChangedString);
                                this.statusChange = event.detail.value;
                                console.log('line 95');
                                
                                if ( this.ChangedString==null || this.ChangedString=='All') {
                                    //   console.log('line 104');
                                    //  this.OrderItem=this.AllProductList;
                                    orderStatusFilter({searchstatus:this.statusChange}).then(result=>{
                                        console.log('line 13');
                                        console.log('this.ChangedString'+this.ChangedString);
                                        console.log('this.statusChange'+this.statusChange);
                                        this.OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                                
                                else {
                                    //if ( this.ChangedString==='All')this.ChangedString=this.AllProductList;
                                    
                                    orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
                                        console.log('line 13');
                                        console.log('this.ChangedString'+this.ChangedString);
                                        console.log('this.statusChange'+this.statusChange);
                                        this.OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                            }
                            
                            // getOrderIdNo(event){
                            //     this.orderIdURL=event.currentTarget.dataset.orderurl;
                            //     this.recordPageUrl= 'https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.orderIdURL+'/view';
            
                            // }
                            
                            closeThePopup(event){
                                console.log('line 318');
                                this.isShowModal=false;
                                
                            }
    handleKeyChange(event) {
    this.orderIdStatus = event.detail.value;
    console.log('line 95');
    if (this.orderIdStatus==='All') {
     console.log('line 104');
     this.OrderItem=this.AllProductList;
    } 
    else {
        getOrderId({searchKey:this.orderIdStatus}).then(result=>{
        console.log('line 13');
        this.OrderItem=result;
        console.log('line 15'+JSON.stringify(this.OrderItem));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}
                            
    //                         searchKey = '';
    //                         @wire(getOrderId, { searchKey: '$searchKey' })
                            
    //                         Order;
    //                         handleKeyChange(event) {
    //                             this.orderIdStatus = event.detail.value;
    //                             console.log('line 95');
    //                             if (this.orderIdStatus==='All') {
    //                                 console.log('line 104');
    //                                 this.OrderItem=this.AllProductList;
    //                             } else {
    //                                 getOrderId({searchKey:this.orderIdStatus}).then(result=>{
    //                                     console.log('line 13');
    //                                     this.OrderItem=result;
    //                                     console.log('line 15'+JSON.stringify(this.OrderItem));
    //                                 })
    //                                 .catch(error=>{
    //                                     console.log('103 error'+error);
    //                                 })
    //                             }
    //                         }
                            
    //                         //     console.log('line 95');
    //                         //     this.ChangedStatus=event.detail.value;
    //                         //     console.log('line 95'+ this.ChangedStatus);
    //                         //     if (this.ChangedStatus==='All') {
    //                         //         console.log('line 104');
    //                         //         this.OrderItem=this.AllProductList;
                            
    //                         //     } else {
                            
    //                         //         statusRecords({searchstatus: this.ChangedStatus}).then(result=>{
    //                         //             console.log('line 13');
    //                         //             this.OrderItem=result;
    //                         //             console.log('line 15'+JSON.stringify(this.OrderItem));
                            
    //                         //         })
    //                         //         .catch(error=>{
    //                         //             console.log('103 error'+error);
    //                         //         })
                            
    //                         //     }
    //                         // }
}