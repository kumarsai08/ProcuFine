import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';

export default class PfAssetDelivery extends NavigationMixin (LightningElement) {
    @api BatchNumber=[];
    @api Product;
    @api recordId;
    @track isShowModal = false;
    connectedCallback(){
    //     OrdertoAssests({}).then(result=>{
    //         console.log('line 10');
    //        this.BatchNumber=result;
           
    //        console.log('Line 12'+JSON.stringify(result));
    //     })
    // .catch(error=>{
    //     console.log('error'+error);
    // })  
                    
    }
    
    Navigatetobatchnumber(event){
        const strbatchid=event.target.dataset.strbatchid;
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: strbatchid,
                 objectApiName: 'quote',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })

    }



    @wire(getRecord, { recordId: '$recordId', fields: [ 'Order.Product__c']  })
wiredRecord({ error, data }) {
    if (data) {
        console.log('line 34');
        console.log('asset 1 '+ data);
        console.log('asset '+ JSON.stringify(data));
       // this.record = getFieldValue(data, 'Id');
        this.Product = getFieldValue(data, 'Order.Product__c');
        console.log('39 '+this.Product);
        //this.accountName = getFieldValue(data, 'Account.Name');
        OrdertoAssests({prodname:this.Product}).then(result=>{
            console.log('line 10');
           this.BatchNumber=result;
           
           console.log('Line 12'+JSON.stringify(result));
        })
    .catch(error=>{
        console.log('error'+error);
    })  
    } else if (error) {
        console.error(error);
    }
}


    getassestdetails(event){
        this.isShowModal = true;

    }



    hideModalBox() {  
        this.isShowModal = false;
    }
}