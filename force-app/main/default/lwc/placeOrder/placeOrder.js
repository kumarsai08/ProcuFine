import { LightningElement ,api,track,wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import GetSuppleirDetails from '@salesforce/apex/GetSuppleirDetails.GetSuppleirDetails';
import SendAnEmail from '@salesforce/apex/GetSuppleirDetails.SendAnEmail';


export default class PlaceOrder extends LightningElement {
    @api QuotesList;
    @api selectedrowonly;
    @api productName;
    @api Thresholdvalue;
    @api Name;
    @api ChangeValue;
    @api WarehouseName;
    
    
    @api SuppliersNamesList=[];
    @api obj;
    @api ChangedOrderQuantity;
    @api supplierdata;
    @api SupplierLIST;

    // drop down
    @api options=[];

    @track noResultMessage;
    @track showDropdown = false;
    // @wire(GetSuppleirDetails,{Productid : this.selectedrowonly.Product__c}) 
    // suppliers({data,error}){
    //     if(data){
    //         console.log(data);
    //         for (let key in data) {
    //             console.log('key:'+key+':Value:'+data[key]);
    //             this.options.push(key,data[key]);
    //          }
    //     }
    // }


    connectedCallback(){
        
        GetSuppleirDetails({Productid : this.selectedrowonly.Product__c})
        .then(result=>{
            console.log('result:'+JSON.stringify(result));
            for (let key in result) {
                console.log('key:'+key+':Value:'+result[key]);
                this.options.push({label:result[key],value:key});
             }
             console.log('options'+this.options);
             this.getSupplier(this.options);
            });
            // console.log('SuppliersNamesList'+this.SuppliersNamesList);
            //this.options== Object.keys(result).map(key => ({ key: key, value: result[key] }));
          //  console.log('suppliers:'+JSON.stringify(this.suppliers));
            // var newData = JSON.parse(JSON.stringify(result));
            // console.log('line 188');
            // newData.forEach(element => {
            //     console.log('line 200');
            //     this.obj={label:element,value:element};
            //     console.log(JSON.stringify(element));
            //     this.options.push((this.obj));
            //     console.log('LINE 24');
            // });


           
     
       

    //     //console.log('selectedRowOnly:'+JSON.stringify(this.selectedrowonly));
    }
    getSupplier(Supplieroptions){
        console.log('opt:'+Supplieroptions);
        this.SuppliersNamesList=Supplieroptions;
        this.productName=this.selectedrowonly.Name;
        // console.log('line 34'+JSON.stringify(this.options));

        this.Thresholdvalue=this.selectedrowonly.Threshold__c;
        this.WarehouseName=this.selectedrowonly.Warehouse__r.Name;
    }
    handleChange(event){
        console.log('line 74');
        this.ChangeValue=event.detail.value;
        this.SupplierNamesChangeValues=event.detail.label;
        console.log('line 76'+typeof this.ChangeValue);
        console.log('line 77'+JSON.stringify(this.ChangeValue));
      

    }
    GetOrderQuantity(event){
        this.ChangedOrderQuantity=event.detail.value;
        console.log('line 84'+ typeof this.ChangedOrderQuantity);

    }
    HandleSendOrder(event){
        console.log('line 90'+ this.selectedrowonly.Product__c + JSON.stringify(this.ChangeValue) + JSON.stringify(this.ChangedOrderQuantity) + this.selectedrowonly.Product__r.Name+ JSON.stringify(this.selectedrowonly.Warehouse__r.Name));
        
        SendAnEmail({productid : this.selectedrowonly.Product__c,supplierids: this.ChangeValue,productname : this.selectedrowonly.Product__r.Name,Orderquantity: this.ChangedOrderQuantity,WarehouseName:this.selectedrowonly.Warehouse__r.Name ,productcode:this.selectedrowonly.Product__r.ProductCode}).then(result=>{
            console.log('line 99');
            //this.dispatchEvent(new CustomEvent('Supplierdetails', {detail:{product : productname}}));
            
            
            console.log('line 97'+ JSON.stringify(result));
           
        }).catch(error=>{
            console.log(error);
        });
        const evt = new ShowToastEvent({
            title: 'EMAILS SENT.',
            message: 'Emails have been sent to the selected suppliers',
            variant: 'success'
        });
        this.dispatchEvent(evt);


        console.log('line 82'+  this.ChangeValue);
         
    }
    //console.log('line 77'+JSON.stringify(ChangeValue));
    
    
    
    
    


}