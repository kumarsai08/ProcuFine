import { LightningElement,api,track,wire } from 'lwc';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
import GetAssetRecordsFromProduct from '@salesforce/apex/GetSuppleirDetails.GetAssetRecordsFromProduct';
import DeliveryAutomation from '@salesforce/apex/PF_DeliveryAutomation.DeliveryAutomation';
import { NavigationMixin } from 'lightning/navigation';
import Assetvalues from '@salesforce/apex/orderdetails.Assetvalues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';

import { refreshApex } from '@salesforce/apex';




//const fs = ['Order.Id','Order.OrderNumber'];
export default class PFAssetDeliverySR extends NavigationMixin (LightningElement) {
    @api recordData=[];
    @api recordId;
    @api Product;
    @api DisplayRelatedRecords=[];
    @api checkboxValue;
    @api BatchNumbersList = [];
    @api InputIntegersList = [];
    @api IntInputNumber;
    @api idVariable;
    @api inputvalue2;
    @api inputvalue1;
    @api checkedList=[];
    @api ordervalue;
    @api loaded=false;
   
    @api checkboxvalue;
    @api showErrorMessage = false;
    @track errorMessage;
    @api batchnumberid;
    @api Asset=[];
    @track isShowModal = false;
    @api selectedRows;
    @api wiredTableData;
    @api IntGetRelatedDataInputChange;
    @api IntAssignBatchValue;
    @api GetInputValue={};
    @api ListStockValues=[];
    @api booleanvalue;
   
    @api assetIdValue;
    @api showtoast=[];
    @api showMsg;
    @api BooleanValue;
    
    @api MapAsset = new Map();
    @api IntAssetCount;
    @api IntOrderQuantity;
    @api IntSelectedQuantity;
    mapAssests =new Map();
    mapAssestsSOHValues =new Map();


    connectedCallback() {
       // this.fetchRecordData();
       console.log('line 15');

       
    }
    /*@wire(getRecord, { recordId: '$recordId', fields: ['OrderNumber', 'Account.Name'] })
    record;


    @api
fetchRecordData() {
    getRecord(this.recordId, { fields: ['OrderNumber', 'Product__c'] })
        .then(result => {
            this.recordData = result;
            console.log('line 19 asset'+this.recordData)
        })
        .catch(error => {
            console.error(error);
        });
}*/

@wire(getRecord, { recordId: '$recordId', fields: ['Order.Id', 'Order.Product__c','Order.OpportunityId','Order.Asset_Count__c','Order.Order_Quantity__c']  })
wiredRecord({ error, data }) {
    //this.wiredTableData = data;
    if (data) {
        console.log('line 34');
        console.log('asset 1 '+ data);
        console.log('asset '+ JSON.stringify(data));
        this.loaded=true;
        // this.mapAssests= 

       // this.record = getFieldValue(data, 'Id');
        this.Product = getFieldValue(data, 'Order.Product__c');
        this.ordervalue = getFieldValue(data, 'Order.Id');
        this.IntAssetCount = getFieldValue(data, 'Order.Asset_Count__c');
        this.IntOrderQuantity = getFieldValue(data, 'Order.Order_Quantity__c');
        console.log('ac '+this.IntAssetCount + ' oq '+this.IntOrderQuantity)

        console.log('39 '+this.Product);
        this.AssetMethods();
        //this.accountName = getFieldValue(data, 'Account.Name');
    } else if (error) {
        console.error(error);
    }
}

// GetProductIdFromOppProduct(){

// }







AssetMethods(){
    console.log('76:'+this.Product)
    GetAssetRecordsFromProduct({ productid : this.Product }).then(result=>{
        console.log('LINE 174'+JSON.stringify(result));
        const batchNames = new Set();
        let templist=[];
       
        var newData = JSON.parse(JSON.stringify(result));
    
        
        newData.forEach(record => {
            let tempRecs = Object.assign({},record);
            if(batchNames.has(record.Batch_Number_lookup__r.Name)){
                
            }
            else{
                templist.push(tempRecs);
            }

            batchNames.add(record.Batch_Number_lookup__r.Name);
    })
   
    console.log('old :: '+JSON.stringify(templist))
    console.log('128 ' +this.showMsg)
    //console.log('sorted ' +templist.sort(Batch_Number_lookup__r.Name))
   /* for (let i = 0; i < (templist.length)-1; i++) {
        if(templist[i].Batch_Number_lookup__r.Name < templist[i+1].Batch_Number_lookup__r.Name){
            this.DisplayRelatedRecords.push(templist[i])
        }
        else{
            this.DisplayRelatedRecords.push(templist[i+1])

        }
        
    }
    console.log('sorted ' +JSON.stringify(this.DisplayRelatedRecords))*/

    if(templist.length!=0){
        this.DisplayRelatedRecords = templist;
        this.loaded = false;
        this.showMsg=true;
        console.log('133 ' +this.showMsg)

    }
    else{

    }
    

    
       //this.recordId = this.record;
    
    }) .catch(error=>{
        console.log('error24 : '+JSON.stringify(error));
    })
    

}


handlecheckbox(event){
    this.selectedRows = event.target.checked;
    this.idVariable=event.target.dataset.astid;
   if(this.selectedRows){
    
    
    this.inputvalue1 = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.firstinputvalue;
    this.inputvalue2 =  this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value;
    this.InputIntegersList.push(parseInt((this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value)));
    this.BatchNumbersList.push(this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid);
    console.log('150')
    

    //this.ListStockValues.push(this.inputvalue1);
    this.assetIdValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.astid;
    console.log('line 158'+ this.assetIdValue);

    this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid;
    

    //let stockValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.stock; 
    const inputEle = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`);
    console.log('159')
    //console.log('stockValue',stockValue +'_')
    //if(this.inputvalue2==null){
    inputEle.value = this.inputvalue1;
   // }
    console.log('IntAssignBatchValue:'+JSON.stringify(this.IntAssignBatchValue))
    console.log('inputvalue1:'+JSON.stringify(this.inputvalue1))
    console.log(typeof this.mapAssests)
   this.mapAssests.set( this.IntAssignBatchValue,this.inputvalue1);
   this.mapAssestsSOHValues.set(this.IntAssignBatchValue,this.inputvalue1)
// this.mapAssests.set('key1', 'value1');
  
    //MapAsset.set(, 500);
     //this.GetInputValue = { IntAssignBatchValue : this.inputvalue1 };

   }else{
    console.log('false '+this.selectedRows );
    this.showErrorMessage =  false;
    this.inputvalue2 =  '';
    this.inputvalue1 = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.firstinputvalue;
    this.inputvalue2 =  this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value;

    this.InputIntegersList=this.InputIntegersList.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value);
    this.BatchNumbersList=this.BatchNumbersList.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid);
    this.ListStockValues=this.ListStockValues.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.firstinputvalue);
    this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid;

    this.assetIdValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.astid;

    //fruits.delete(this.inputvalue1);
    this.mapAssests.delete( this.IntAssignBatchValue);
    this.mapAssestsSOHValues.delete( this.IntAssignBatchValue);



   }



//    console.log('Map:'+JSON.stringify(this.MapAsset));
   this.mapAssests.forEach((value, key) => {
    console.log(key + ' = ' + value);
});
this.mapAssestsSOHValues.forEach((value, key) => {
    console.log( 'MAP SOH '  +key + ' = ' + value);
});
//    console.log('input value one : '+ this.inputvalue1 );
//    console.log('input two : '+ this.inputvalue2 );
//    console.log('select'+ this.selectedRows)
//    console.log('stockvalues '+ JSON.stringify(fruits));
 

    if(this.inputvalue2!= ''){
        if ((Number(this.inputvalue2)  > Number(this.inputvalue1)) && this.selectedRows) {

            // show error message
             
                //Alert has been closed
            
            console.log('Enter values is greater')
            this.booleanvalue = true;
           // this.errorMessage = ;
        } else if(this.inputvalue2 <=0){
        
            
            this.booleanvalue = true;
           // this.errorMessage = ;
        }else if(this.inputvalue2 === null){
            
    
            this.booleanvalue = true;
            // this.errorMessage = ;
         }
    }
        else {
            this.booleanvalue = false;
        }

   

    
    console.log('check boxes',this.InputIntegersList);
    console.log('113',this.BatchNumbersList);
    this.checkboxValue = event.target.checked;
    this.batchnumber = event.target.dataset.batchid;
   // console.log('check '+ this.checkboxValue)
    
    
    

}

handleinputnumbers(event){
    this.IntInputNumber = event.target.value;
    this.batchId = event.target.dataset.batchid;
    console.log('264 '+this.batchId);
    let getastid = event.target.dataset.assetid;
    this.IntGetRelatedDataInputChange = event.target.dataset.firstinputvalue;

    if(this.inputvalue2!=null){
       // this.inputvalue1 = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.firstinputvalue;
        //this.inputvalue2 =  this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value;
       // this.InputIntegersList.push(parseInt((this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value)));
   // this.BatchNumbersList.push(this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid);
    this.BooleanCheckedStatus = this.template.querySelector(`input[data-astid="${getastid}"]`);
    console.log('Boolean '+this.BooleanCheckedStatus.checked)
    this.BooleanValue = this.BooleanCheckedStatus.checked
    //console.log('input2 '+this.inputvalue2)


    if(this.BooleanValue){
        console.log('301')
        this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${getastid}"]`).dataset.batchid;
        //console.log('batchid '+ this.IntAssignBatchValue)
        this.mapAssests.set( this.batchId,this.IntInputNumber);


    }

   // console.log('mapassetbatch ')
    //this.assetIdValue = this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.astid;
    //fruits.set(this.inputvalue1, this.inputvalue2);
    //console.log('252 '+ fruits)

       // this.InputIntegersList.push(parseInt((this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value)));
       // this.BatchNumbersList.push(this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid);
      // this.ListStockValues.push(this.inputvalue1);
       }
       this.mapAssests.forEach((value, key) => {
        console.log('mapassetbatch '+key + ' = ' + value);
    });




       if(this.inputvalue2!= ''){
        if ((Number(this.inputvalue2)  > Number(this.inputvalue1)) && this.selectedRows) {

            // show error message
             
                //Alert has been closed
            
            console.log('Enter values is greater')
            this.booleanvalue = true;
           // this.errorMessage = ;
        } else if(this.inputvalue2 <=0){
        
            
            this.booleanvalue = true;
           // this.errorMessage = ;
        }else if(this.inputvalue2 === null){
            
    
            this.booleanvalue = true;
            // this.errorMessage = ;
         }
    }
        else {
            this.booleanvalue = false;
        }
      /* if(this.inputvalue2!= ''){
        if ((Number(this.inputvalue2)  > Number(this.inputvalue1)) && this.selectedRows) {

            // show error message
             LightningAlert.open({
                    message: 'Value should not greater than SOH',
                    theme: 'error', // a red theme intended for error states
                    label: 'Error!', // this is the header text
                });
                //Alert has been closed
            
            console.log('Enter values is greater')
            this.showErrorMessage = true;
           // this.errorMessage = ;
        } else if(this.inputvalue2 <=0){
        
            LightningAlert.open({
                message: 'Value should not be zero or negative',
                theme: 'error', // a red theme intended for error states
                label: 'Error!', // this is the header text
            });
            this.showErrorMessage = true;
           // this.errorMessage = ;
        }

        
     }
     
     else {
         this.showErrorMessage = false;
     }*/
    if(this.IntInputNumber!=''){


     if ((Number(this.IntInputNumber)  > Number(this.IntGetRelatedDataInputChange)) ) {

        // show error message
         LightningAlert.open({
                message: 'Value should not greater than SOH',
                theme: 'error', // a red theme intended for error states
                label: 'Error!', // this is the header text
            });
            //Alert has been closed
        
        console.log('Enter values is greater')
        this.showErrorMessage = true;
       // this.errorMessage = ;
    } else if(this.IntInputNumber <=0){
    
        LightningAlert.open({
            message: 'Value should not be zero or negative',
            theme: 'error', // a red theme intended for error states
            label: 'Error!', // this is the header text
        });
        this.showErrorMessage = true;
       // this.errorMessage = ;
    }

    
 }
 
 else {
     this.showErrorMessage = false;
 }




}

handledeliver(event){
    console.log('values '+JSON.stringify(typeof this.mapAssests.values()) );
    this.showtoast=[];
    this.InputIntegersList=[];
    this.BatchNumbersList=[];
    
    

   /* fruits.forEach (function(value, key) {
        if(key<= value){
            this.showtoast=true;
        }else if(value<=0){
        this.showtoast=true;
    }else{
        this.showtoast=false;
    }
      })*/
    
    /*for (let i = 0; i <= fruits.size; i++) {
        
        if(this.ListStockValues[i]<= this.InputIntegersList[i]){
            this.showtoast=true;
        }else if(this.InputIntegersList[i]<=0){
        this.showtoast=true;
    }else{
        this.showtoast=false;
    }
}*/
this.mapAssests.forEach ((value, key)=>  {
    
    console.log(value +' '+ this.mapAssestsSOHValues.get(key)+' '+key);
    console.log('433 '+typeof value +' '+typeof this.mapAssestsSOHValues.get(key));

    this.InputIntegersList.push(value)
    this.BatchNumbersList.push(key)
    //console.log(this.mapAssestsSOHValues.get(key));
    //console.log(key);
    if(Number(value)> Number(this.mapAssestsSOHValues.get(key))){
        console.log('440 ')
        
        
        this.showtoast.push(true);
    }else if(Number(value)<=0){
        console.log('445 ')

        this.showtoast.push(true);
        

}else{
    console.log('451 ')


    this.showtoast.push(false);}
  });

  console.log('InputIntegersList  '+ this.InputIntegersList)

  this.IntSelectedQuantity = 0;

  this.InputIntegersList.forEach(element => {
    this.IntSelectedQuantity= this.IntSelectedQuantity + Number(element)

    
  });
  console.log('intq '+this.IntSelectedQuantity)

   

  console.log('toast'+this.showtoast);
  console.log('436 '+this.showtoast.includes(true));




    if(this.InputIntegersList.length!==0){


     if(this.showtoast.includes(true)){
        const evt = new ShowToastEvent({
            title: 'Check the Errors',
            message: 'Please check the error and enter proper values before clicking the deliver button',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    

     }else{
        console.log('Batches '+this.BatchNumbersList)
        console.log('input integers '+this.InputIntegersList)
        console.log('order '+this.ordervalue)
        if((this.IntSelectedQuantity + this.IntAssetCount)>this.IntOrderQuantity){
            const evt = new ShowToastEvent({
                title: 'delivery error',
                message: 'Please check the error and enter proper values before clicking the deliver button',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        

        }
        else{



        DeliveryAutomation({ batchnumber : this.BatchNumbersList,inputqunatity : this.InputIntegersList, orderid : this.ordervalue  }).then(result=>{
            console.log('result'); 
            
            const evt = new ShowToastEvent({
                title: 'SUCCESS',
                message: 'Product Assets assigned to the sales order',
                variant: 'Success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt); 
            
            //return refreshApex(this.wiredTableData);
            this.loaded = true;
          // this.AssetMethods();
           //window.location.reload();
            
            
        }).catch(error=>{
            console.log('error 192: '+JSON.stringify(error));
        })
    }







     }






    
    }
    else{

        const evt = new ShowToastEvent({
            title: 'Select atleast one row',
            message: 'Please select atleast one row before clicking the deliver button',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);

    }
   
    
    
       //this.recordId = this.record;
    
     
}

Navigatetobatchnumber(event){
    const strassetid=event.target.dataset.strassetid;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: strassetid,
             objectApiName: 'quote',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })


}

getassestdetails(event){
       
    this.batchnumberid = event.currentTarget.dataset.strbatch;


    Assetvalues({batchname:this.batchnumberid}).then(result=>{
       
        console.log('line 13');
        // this.Asset=result;
        let resultArray=result;
        this.Asset = resultArray.map((record, index) => {
          return {...record,index: index+1};
        });    
    console.log('line 17'+JSON.stringify(result));
    }).catch(error=>{
        console.log('error'+error);
    });    
    this.isShowModal = true;
}


hideModalBox() {  
    this.isShowModal = false;
}







}