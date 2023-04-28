import { LightningElement, wire, track, api } from 'lwc';
import fetchOrderProduct from '@salesforce/apex/PF_orderdetails.fetchOrderProduct';
import updateOrder from '@salesforce/apex/PF_orderdetails.updateOrder';
import createAsset from '@salesforce/apex/PF_orderdetails.createAsset';
//import updatePendingQuantity from '@salesforce/apex/orderdetails.updatePendingQuantity';
//import getassetrecords from '@salesforce/apex/Assetdetails.getassetrecords';
import getproductnamerecords from '@salesforce/apex/PF_orderdetails.getproductnamerecords';
//import retrieveProductRecords from '@salesforce/apex/orderdetails.retrieveProductRecords';
//import getStatusRecords from '@salesforce/apex/orderdetails.getStatusRecords';
import statusRecords from '@salesforce/apex/PF_orderdetails.statusRecords';
//import getOrderId from '@salesforce/apex/orderdetails.getOrderId';
//import statusRecordsWithoutProduct from '@salesforce/apex/orderdetails.statusRecordsWithoutProduct';  
import fetchSearchResultsDeliveryInfo from '@salesforce/apex/PF_orderdetails.fetchSearchResultsDeliveryInfo';
import { NavigationMixin } from 'lightning/navigation';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';



const DELAY = 300;

export default class DeliveryInformation extends NavigationMixin (LightningElement) {
    //  result;
    //  resultnumber;
    value ;
    @api productrecord;
    @api quantityvalue=0;
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
    @api ChangedString='';
    @api AllProductList;
    @api ChangedStatus;
    @api recordPageUrl;
    @api orderIdURL;
    @api AllOrderId;
    @api orderIdStatus;
    @api quanti;
    @api StrSupplierName='';
    @api deliveredDate;
    @api List_FilteredRecords=[];
    //@api IdWarehouseValue;
    // @api DateTodaysDate;
    @api loading=false;
    

    connectedCallback(){
        //const date = new Date();
        // let day = date.getDate();
        // let month = date.getMonth() + 1;
        //  let year = date.getFullYear();
        //  let date = new Date().toLocaleDateString();
        //  this.DateTodaysDate = date;
        //   console.log(this.DateTodaysDate);
        //  console.log('51',date);

       // this.DateTodaysDate  = ${day}-${month}-${year};
        //console.log('systemdate '+ this.DateTodaysDate)
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
    console.log('loaddata')
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
       // this.IdWarehouseValue = event.target.dataset.warehousevalue;
        console.log('141 '+this.IdWarehouseValue)
        let modelshow =false;
        const pendqty=event.target.dataset.pend;
        console.log(typeof(Number(pendqty))+'___'+typeof(Number(this.quantityvalue)))
        if(Number(this.quantityvalue)>Number(pendqty)){
            event.target.setCustomValidity("Recieved quantity should not be greater than pending quantity.");
            this.isShowModal=false;
            modelshow = true; 
            this.quantityvalue=0;
           // this.showErrorMessage = true;
            //this.errorMessage = 'Value should not be greater than pending quantity';
        }
        else if(Number(this.quantityvalue)<=0){
            event.target.setCustomValidity("Recieved quantity cannot be Zero or a Negative value.");
            this.isShowModal=false;
            this.quantityvalue=0;
            modelshow = true;
        }
        else {
            event.target.setCustomValidity("");
            this.dateValue = event.target.value;
        }
         event.target.reportValidity();
    
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
        this.loading=true;
        if(!modelshow){
            this.isShowModal=true
           
        }
        this.loading=false;
        //setTimeout(() => {  this.loading=false; this.isShowModal=true}, 1000);
        


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

/*getBatchNumber(event){
    const no = event.target.value;
    this.batchNumberList.push(no)
}*/
}

hideModalBox(){
     //this.dat=[]
    //  if(this.deliveredDate >> this.DateTodaysDate){
    //     const evt = new ShowToastEvent({
    //         title: 'Check the Deliver date',
    //         message: 'The delivery date cannot be in the future',
    //         variant: 'error',
    //         mode: 'dismissable'
    //     });
    //     this.dispatchEvent(evt);

    //  }
    //  else{
     console.log('Product Id',JSON.stringify(this.prodId))
   
     /*const userInpu=[...this.template.querySelectorAll('lightning-input'),].reduce((valid,inputCmp)=>{
         inputCmp.reportValidity();
         console.log('Alert')
         return valid && inputCmp.checkValidity();
     },true);*/
     const allValid = [
         ...this.template.querySelectorAll('.batchNo'),
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
    // window.location.reload();
    // this.dispatchEvent(new CustomEvent('qarefresh')); 


 }).catch(error=>{
     console.log('Error 27:'+JSON.stringify(error));
 });
 
 updateOrder({ordervalue : this.productrecord,valueRquantity : this.quantityvalue  }).then(result=>{
     console.log('line 52'+ JSON.stringify(result));
     }).catch(error =>{
         console.log(error);
     }).finally(() =>{
        // this.loadData();
        this.dispatchEvent(new CustomEvent('qarefresh')); 
        if(this.orderIdStatus===null && this.statusChange ===null && this.ChangedString ===null){
            console.log('275')
            this.loadData();
        }else
         if(this.statusChange!=null ||this.ChangedString!=null ){
            console.log('inside 1')
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

         }else if(this.orderIdStatus!='') {
            console.log('inside 2')

            fetchSearchResultsDeliveryInfo({searchKey:this.orderIdStatus}).then(result=>{
                console.log('line 13');
                this.OrderItem=result;
                console.log('line 15'+JSON.stringify(this.OrderItem));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })

         }
         
         console.log('line 64');
     });
     console.log('line 61');
     this.quantityvalue=0
     } else {
         this.isShowModal=true
        // alert('Please update the invalid form entries and try again.');
     }
    }
 /*if(!userInpu){
 co
 }else{
     
     
    
 */
        
 


handleProductChange(event){
    this.orderIdStatus='';

    console.log('line 95');
    this.ChangedString=event.detail.value;
    console.log('line 95'+ this.ChangedString);
   // this.statusChange==null ||
    if( this.statusChange=='All'){
    if (this.ChangedString==='All') {
        console.log('line 104');
        this.loadData();
    }  else {
        console.log('enetered');
    
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
      //  { label: 'Fully Received Under QA', value: 'Fully Received Under QA' }
    ];
}

 handleStatusChange(event) {
    this.orderIdStatus='';
    console.log('line 233'+this.ChangedString);
    this.statusChange = event.detail.value;
    console.log('line 95');
    if( this.statusChange=='All'){
        if (this.ChangedString==='All') {
            console.log('line 104');
            this.loadData();
        } else{
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
    
    /*if ( this.ChangedString==null || this.ChangedString=='All') {
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
}*/
 
    // else {
        //if ( this.ChangedString==='All')this.ChangedString=this.AllProductList;
} else{
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
    this.deliverydate='';
    this.quantityvalue='';

}

// searchKey = '';
    // @wire(getOrderId, { searchKey: '$searchKey' })

    // Order;
    handleKeyChange(event) {
        
        this.orderIdStatus = event.detail.value;
        console.log('line 95');
        if (this.orderIdStatus==='' || this.orderIdStatus=== null ) {
            console.log('line 104');
            this.loadData();

            
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
            this.deliveredDate= event.target.value;
            console.log('505 '+ this.deliveredDate);
            // console.log('506 '+ this.DateTodaysDate);
            

        }
        get curDate(){
            let d = new Date();
            console.log('check',d);
             let month = d.getMonth()+1;
             console.log('hiii'+month+d.getMonth())
             let date = d.getDate();
             console.log(d.getFullYear() + '-' + month + '-' + date+'_____DATE')
             return d.getFullYear() + '-' + month + '-' + date;
        }
    }