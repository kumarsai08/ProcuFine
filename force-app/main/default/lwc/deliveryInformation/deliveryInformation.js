import { LightningElement, wire, track, api } from 'lwc';
import fetchOrderProduct from '@salesforce/apex/orderdetails.fetchOrderProduct';
import updateOrder from '@salesforce/apex/orderdetails.updateOrder';
import createAsset from '@salesforce/apex/orderdetails.createAsset';
//import updatePendingQuantity from '@salesforce/apex/orderdetails.updatePendingQuantity';
import getassetrecords from '@salesforce/apex/Assetdetails.getassetrecords';
import getproductnamerecords from '@salesforce/apex/orderdetails.getproductnamerecords';
import retrieveProductRecords from '@salesforce/apex/orderdetails.retrieveProductRecords';
//import getStatusRecords from '@salesforce/apex/orderdetails.getStatusRecords';
import statusRecords from '@salesforce/apex/orderdetails.statusRecords';
import getOrderId from '@salesforce/apex/orderdetails.getOrderId';
import statusRecordsWithoutProduct from '@salesforce/apex/orderdetails.statusRecordsWithoutProduct';  
import fetchSearchResultsDeliveryInfo from '@salesforce/apex/orderdetails.fetchSearchResultsDeliveryInfo';
import { NavigationMixin } from 'lightning/navigation';


const DELAY = 300;

export default class DeliveryInformation extends NavigationMixin (LightningElement) {
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
    @track prodId;
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
    @api deliveredDate;

    connectedCallback(){
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
//     this[NavigationMixin.GenerateUrl]({
//         type: 'standard__recordPage',
//         attributes: {
//             recordId: this.orderURL',
//             actionName: 'view',
//         },
//     }).then(url => {
//             //2. Assign it to the prop
//         this.recordPageUrl = url;
//     });
// }
//     getStatusRecords({}).then(result=>{
//         this.statusList.push({label:'All',value:'All'});
//         result.forEach(element => {
//             this.statusList.push({label:element,value:element});
//             this.statusNameOptions = JSON.parse(JSON.stringify(this.statusList));
//             console.log('line 53'+JSON.stringify(this.statusNameOptions));
//         });
// })
// .catch(error=>{
//     console.log('error'+error);
// })

}

// HandleClick(event){
//     const recordId = event.target.dataset.
//     this[NavigationMixin.GenerateUrl]({
//         type: 'standard__recordPage',
//         attributes: {
//             recordId: recordId,
//             actionName: 'view',
//         },
//     }).
// }
    
    handleonchange(event){
        console.log('line 15');
        this.changevalue=true;
        
        this.quantityvalue=event.target.value;
        console.log('line 16'+ typeof this.quantityvalue);
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
   /*
    @wire( fetchOrderProduct ) 
    caseRecord({ error, data }) { 
        if ( data ) { 
            this.OrderItem = data; 
        } else if ( error )
            console.log( 'Error is ' + JSON.stringify( error ) );
    }*/
     handleSave(event) {
        this.StrSupplierName= event.currentTarget.dataset.suppliername;
        console.log('supp name'+this.StrSupplierName)
        this.receivedQuan=''
        this.dat =[]
        const updatedFields = event.detail.draftValues;
        this.productrecord= event.currentTarget.dataset.idname;
       let ele =this.template.querySelector('.pt-3-half').value
       console.log('tfye',event.currentTarget.dataset.recquantity)
        this.receivedQuan=event.currentTarget.dataset.recquantity;
        console.log('tfye',this.receivedQuan)
        this.productName=event.currentTarget.dataset.proname;
        this.prodId = event.currentTarget.dataset.proid;
        //this.quantityvalue= event.currentTarget.dataset.recquantity;
        console.log('quantityy'+ this.productrecord);
        for (let i = 0; i < this.receivedQuan; i++) {
            this.dat.push(i);
          }
        console.log('line',this.dat) 
        this.isShowModal=true


        // updateOrder({ordervalue : this.productrecord,valueRquantity : this.quantityvalue  }).then(result=>{
        //     console.log('line 52'+ JSON.stringify(result));
        //     }).catch(error =>{
        //         console.log(error);
        //     }).finally(() =>{
        //         this.loadData();
        //         console.log('line 64');
        //     });
        //     console.log('line 61');
           // this.integerquantityvalue=Integer.ValueOf(this.quantityvalue);
            /*updatePendingQuantity({recquantity : this.integerquantityvalue}).then(result=>{
                console.log('Line 88');
                console.log('Line 89 ' + JSON.stringify(result)); })
                .catch(error =>{
                    console.log(error); });*/
        // Clear all datatable draft values
       /* this.draftValues = [];
        try {
            // Pass edited fields to the updateContacts Apex controller
            await updateOrder({ OrderUpdate: updatedFields });
            // Report success with a toast*/
           /* this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Orders updated',
                    variant: 'success'
                })
            );
            // Display fresh data in the datatable
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while updating or refreshing records',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }*/
}
/*getBatchNumber(event){
    const no = event.target.value;
    this.batchNumberList.push(no)
}*/
hideModalBox(){
     //this.dat=[]
     console.log('Product Id',JSON.stringify(this.prodId))
   
     /*const userInpu=[...this.template.querySelectorAll('lightning-input'),].reduce((valid,inputCmp)=>{
         inputCmp.reportValidity();
         console.log('Alert')
         return valid && inputCmp.checkValidity();
     },true);*/
     const allValid = [
         ...this.template.querySelectorAll('lightning-input'),
     ].reduce((validSoFar, inputCmp) => {
         inputCmp.reportValidity('Fill the field');
         inputCmp.showHelpMessageIfInvalid();
         if(inputCmp.value){
             this.batchNumberList.push(inputCmp.value);
         }
        // this.batchNumberList.push(i);
        console.log('sr'+inputCmp.value);
         return validSoFar && inputCmp.checkValidity();
     }, true);
     if (allValid) {
         console.log('195',this.quanti)
        //  for(let i;i<this.quanti;i++){
        //      this.batchNumberList.push(i);
        //  }
         this.isShowModal=false
         //alert('All form entries look valid. Ready to submit!');
         console.log('tyope of',this.batchNumberList)
 //let ele =this.template.querySelectorAll('.pt-3-half').value
 createAsset({prodId : this.prodId,batchNumbers : this.batchNumberList, orderid : this.productrecord, deliverydate : this.deliveredDate }).then(result=>{
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
        // alert('Please update the invalid form entries and try again.');
     }
 /*if(!userInpu){
 co
 }else{
     
     
    
 */
        
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
    
        retrieveProductRecords({searchsname: this.ChangedString}).then(result=>{
            console.log('line 13');
            this.OrderItem=result;
            console.log('line 15'+JSON.stringify(this.OrderItem));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }}
    else{
        statusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
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
      statusRecordsWithoutProduct({searchstatus:this.statusChange}).then(result=>{
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
    
            statusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
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

getOrderId(event){
        this.orderIdURL=event.currentTarget.dataset.orderurl;
        this.recordPageUrl= 'https://absyz-1ab-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.orderIdURL+'/view';
}

closeThePopup(event){
    console.log('line 318');
    this.isShowModal=false;

}

// searchKey = '';
    // @wire(getOrderId, { searchKey: '$searchKey' })

    // Order;
    handleKeyChange(event) {
        this.orderIdStatus = event.detail.value;
        console.log('line 95');
        if (this.orderIdStatus==='All') {
            console.log('line 104');
            this.OrderItem=this.AllProductList;
        } else {
            fetchSearchResultsDeliveryInfo({searchKey:this.orderIdStatus}).then(result=>{
                console.log('line 13');
                this.OrderItem=result;
                console.log('line 15'+JSON.stringify(this.OrderItem));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
    }

//     console.log('line 95');
//     this.ChangedStatus=event.detail.value;
//     console.log('line 95'+ this.ChangedStatus);
//     if (this.ChangedStatus==='All') {
//         console.log('line 104');
//         this.OrderItem=this.AllProductList;
        
//     } else {

//         statusRecords({searchstatus: this.ChangedStatus}).then(result=>{
//             console.log('line 13');
//             this.OrderItem=result;
//             console.log('line 15'+JSON.stringify(this.OrderItem));
            
//         })
//         .catch(error=>{
//             console.log('103 error'+error);
//         })
        
//     }
// }

Navigatetoproduct(event){
    const ordId=event.target.dataset.produrl;
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

    Navigatetoorder(event){
        const ordId=event.target.dataset.orderid;
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
        
        handledeliverydate(event){
            this.deliveredDate= event.detail.value;

        }

}