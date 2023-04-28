import { LightningElement,api,track,wire } from 'lwc';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
import GetAssetRecordsFromProduct from '@salesforce/apex/PF_GetSuppleirDetails.GetAssetRecordsFromProduct';
import DeliveryAutomation from '@salesforce/apex/PF_DeliveryAutomation.DeliveryAutomation';
import { NavigationMixin } from 'lightning/navigation';
import Assetvalues from '@salesforce/apex/PF_orderdetails.Assetvalues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';

export default class PFAssetDeliverySR extends NavigationMixin (LightningElement) {
    @api strProduct;
    @api strShowMsg;
    @api strIdVariable;
    @api strOrdervalue;
    @api strAssetIdValue;
    @api strBatchNumberId;
    @api blnValue1;
    @api blnValue2;
    @api blnLoaded=false;
    @api blnSelectedRows;
    @api blnCheckboxValue;
    @track blnIsShowModal = false;
    @api blnShowErrorMessage = false;
    @api IntAssetCount;
    @api IntInputNumber;
    @api intInputvalue2;
    @api intInputvalue1;
    @api IntOrderQuantity;
    @api IntAssignBatchValue;
    @api IntSelectedQuantity;
    @api IntGetRelatedDataInputChange;
    @api list_Asset=[];
    @api list_Showtoast=[];
    @api list_StockValues=[];
    @api list_BatchNumbersList = [];
    @api list_InputIntegersList = [];
    @api list_DisplayRelatedRecords=[];    
    @api MapAsset = new Map();
    mapAssests =new Map();
    mapAssestsSOHValues =new Map();


//This code is used to retrieve specific fields of a Salesforce record and assign their values to variables.
@wire(getRecord, { recordId: '$recordId', fields: ['Order.Id', 'Order.Product__c','Order.OpportunityId','Order.Asset_Count__c','Order.Order_Quantity__c']  })
wiredRecord({ error, data }) {
    if (data) {
        console.log('line 34');
        console.log('asset 1 '+ data);
        console.log('asset '+ JSON.stringify(data));
        this.blnLoaded=true;
        this.strProduct = getFieldValue(data, 'Order.Product__c');
        this.strOrdervalue = getFieldValue(data, 'Order.Id');
        this.IntAssetCount = getFieldValue(data, 'Order.Asset_Count__c');
        this.IntOrderQuantity = getFieldValue(data, 'Order.Order_Quantity__c');
        console.log('ac '+this.IntAssetCount + ' oq '+this.IntOrderQuantity)
        console.log('39 '+this.strProduct);
        this.AssetMethods();
    } else if (error) {
        console.error(error);
    }
}

//This function retrieves asset records related to a specific product, filters them based on batch number, and sets them to be displayed in the UI.
AssetMethods(){
    console.log('76:'+this.strProduct)
    GetAssetRecordsFromProduct({ productid : this.strProduct }).then(result=>{
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
    console.log('128 ' +this.strShowMsg)
    if(templist.length!=0){
        this.list_DisplayRelatedRecords = templist;
        this.blnLoaded = false;
        this.strShowMsg=true;
        console.log('133 ' +this.strShowMsg)
    }
    else{
    }
    }) .catch(error=>{
        console.log('error24 : '+JSON.stringify(error));
    })
}

//The code is handling the checkbox click event and performs various actions such as getting input values, and filtering lists based on the checkbox selection.
handlecheckbox(event){
    this.blnSelectedRows = event.target.checked;
    this.strIdVariable=event.target.dataset.astid;
   if(this.blnSelectedRows){
    this.intInputvalue1 = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.firstinputvalue;
    this.intInputvalue2 =  this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).value;
    this.list_InputIntegersList.push(parseInt((this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).value)));
    this.list_BatchNumbersList.push(this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.batchid);
    console.log('150')
    this.strAssetIdValue = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.astid;
    console.log('line 158'+ this.strAssetIdValue);
    this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.batchid;
    const inputEle = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`);
    console.log('159')
    inputEle.value = this.intInputvalue1;
    console.log('IntAssignBatchValue:'+JSON.stringify(this.IntAssignBatchValue))
    console.log('inputvalue1:'+JSON.stringify(this.intInputvalue1))
    console.log(typeof this.mapAssests)
    this.mapAssests.set( this.IntAssignBatchValue,this.intInputvalue1);
    this.mapAssestsSOHValues.set(this.IntAssignBatchValue,this.intInputvalue1)
    }else{
    console.log('false '+this.blnSelectedRows );
    this.blnShowErrorMessage =  false;
    this.intInputvalue2 =  '';
    this.intInputvalue1 = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.firstinputvalue;
    this.intInputvalue2 =  this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).value;
    this.list_InputIntegersList=this.list_InputIntegersList.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).value);
    this.list_BatchNumbersList=this.list_BatchNumbersList.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.batchid);
    this.list_StockValues=this.list_StockValues.filter(value=>value !==this.template.querySelector(`lightning-input[data-assetid="${this.idVariable}"]`).dataset.firstinputvalue);
    this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.batchid;
    this.strAssetIdValue = this.template.querySelector(`lightning-input[data-assetid="${this.strIdVariable}"]`).dataset.astid;
    this.mapAssests.delete( this.IntAssignBatchValue);
    this.mapAssestsSOHValues.delete( this.IntAssignBatchValue);
   }
   this.mapAssests.forEach((value, key) => {
    console.log(key + ' = ' + value);
});
this.mapAssestsSOHValues.forEach((value, key) => {
    console.log( 'MAP SOH '  +key + ' = ' + value);
});
    if(this.intInputvalue2!= ''){
        if ((Number(this.intInputvalue2)  > Number(this.intInputvalue1)) && this.blnSelectedRows) {
            console.log('Enter values is greater')
            this.blnValue1 = true;
        } else if(this.intInputvalue2 <=0){
            this.blnValue1 = true;
        }else if(this.intInputvalue2 === null){
            this.blnValue1 = true;
         }
    }
        else {
            this.blnValue1 = false;
        }
    console.log('check boxes',this.list_InputIntegersList);
    console.log('113',this.list_BatchNumbersList);
    this.blnCheckboxValue = event.target.checked;
    this.batchnumber = event.target.dataset.batchid;
}

//The code is used to handle input numbers, validate them, and update values in various lists and maps based on the input.
handleinputnumbers(event){
    this.IntInputNumber = event.target.value;
    this.batchId = event.target.dataset.batchid;
    console.log('264 '+this.batchId);
    let getastid = event.target.dataset.assetid;
    this.IntGetRelatedDataInputChange = event.target.dataset.firstinputvalue;
    if(this.intInputvalue2!=null){
    this.BooleanCheckedStatus = this.template.querySelector(`input[data-astid="${getastid}"]`);
    console.log('Boolean '+this.BooleanCheckedStatus.checked)
    this.blnValue2 = this.BooleanCheckedStatus.checked
    if(this.blnValue2){
        console.log('301')
        this.IntAssignBatchValue = this.template.querySelector(`lightning-input[data-assetid="${getastid}"]`).dataset.batchid;
        this.mapAssests.set( this.batchId,this.IntInputNumber);
    }
       }
       this.mapAssests.forEach((value, key) => {
        console.log('mapassetbatch '+key + ' = ' + value);
    });
       if(this.intInputvalue2!= ''){
        if ((Number(this.intInputvalue2)  > Number(this.intInputvalue1)) && this.blnSelectedRows) {
            console.log('Enter values is greater')
            this.blnValue1 = true;
        } else if(this.intInputvalue2 <=0){
            this.blnValue1 = true;
        }else if(this.intInputvalue2 === null){
            this.blnValue1 = true;
         }
    }
        else {
            this.blnValue1 = false;
        }
    if(this.IntInputNumber!=''){
     if ((Number(this.IntInputNumber)  > Number(this.IntGetRelatedDataInputChange)) ) {
         LightningAlert.open({
                message: 'Value should not greater than SOH',
                theme: 'error', // a red theme intended for error states
                label: 'Error!', // this is the header text
            });        
        console.log('Enter values is greater')
        this.blnShowErrorMessage = true;
    } else if(this.IntInputNumber <=0){
        LightningAlert.open({
            message: 'Value should not be zero or negative',
            theme: 'error', // a red theme intended for error states
            label: 'Error!', // this is the header text
        });
        this.blnShowErrorMessage = true;
    }
 }

 else {
     this.blnShowErrorMessage = false;
 }
}

//This is function handles the delivery of assets and includes error handling and toast messages.
handledeliver(event){
    console.log('values '+JSON.stringify(typeof this.mapAssests.values()) );
    this.list_Showtoast=[];
    this.list_InputIntegersList=[];
    this.list_BatchNumbersList=[];
    this.mapAssests.forEach ((value, key)=>  {
    console.log(value +' '+ this.mapAssestsSOHValues.get(key)+' '+key);
    console.log('433 '+typeof value +' '+typeof this.mapAssestsSOHValues.get(key));
    this.list_InputIntegersList.push(value)
    this.list_BatchNumbersList.push(key)
    if(Number(value)> Number(this.mapAssestsSOHValues.get(key))){
        console.log('440 ')
        this.list_Showtoast.push(true);
    }else if(Number(value)<=0){
        console.log('445 ')
        this.list_Showtoast.push(true);
}else{
    console.log('451 ')
    this.list_Showtoast.push(false);}
  });
  console.log('InputIntegersList  '+ this.list_InputIntegersList)
  this.IntSelectedQuantity = 0;
  this.list_InputIntegersList.forEach(element => {
  this.IntSelectedQuantity= this.IntSelectedQuantity + Number(element)  
  });
  console.log('intq '+this.IntSelectedQuantity)
  console.log('toast'+this.list_Showtoast);
  console.log('436 '+this.list_Showtoast.includes(true));
    if(this.list_InputIntegersList.length!==0){
     if(this.list_Showtoast.includes(true)){
        const evt = new ShowToastEvent({
            title: 'Check the Errors',
            message: 'Please check the error and enter proper values before clicking the deliver button',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
     }else{
        console.log('Batches '+this.list_BatchNumbersList)
        console.log('input integers '+this.list_InputIntegersList)
        console.log('order '+this.strOrdervalue)
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
        DeliveryAutomation({ batchnumber : this.list_BatchNumbersList,inputqunatity : this.list_InputIntegersList, orderid : this.strOrdervalue  }).then(result=>{
            console.log('result'); 
            const evt = new ShowToastEvent({
                title: 'SUCCESS',
                message: 'Product Assets assigned to the sales order',
                variant: 'Success',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);             
            this.blnLoaded = true;
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
}

//This method is used to navigate to batch number with a specific ID and opens it in a new tab.
Navigatetobatchnumber(event){
    const strassetid=event.target.dataset.strassetid;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: strassetid,
             objectApiName: 'Batch_Number__c',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

//This function is used to get asset details based on the selected batch number and display them in a modal popup window.
getassestdetails(event){
    this.strBatchNumberId = event.currentTarget.dataset.strbatch;
    Assetvalues({batchname:this.strBatchNumberId}).then(result=>{
        console.log('line 13');
        // this.Asset=result;
        let resultArray=result;
        this.list_Asset = resultArray.map((record, index) => {
          return {...record,index: index+1};
        });    
    console.log('line 17'+JSON.stringify(result));
    }).catch(error=>{
        console.log('error'+error);
    });    
    this.blnIsShowModal = true;
}

//This function is used to hide a modal box in the user interface.
hideModalBox() {  
    this.blnIsShowModal = false;
}
}