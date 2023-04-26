import { LightningElement,api, } from 'lwc';
import Supplierquantity from '@salesforce/apex/PF_GetSuppleirDetails.Supplierquantity'; 
export default class Redirecttosupplier extends LightningElement {
    @api Quote;
    @api records;
    connectedCallback(){
        Supplierquantity({}).then(result=>{
          
             this.Quote=result;
            // let tempRecords = JSON.parse( JSON.stringify(result) );
             
         
             //this.error = undefined;
            console.log('line 8=>'+JSON.stringify(this.Quote));
             //console.log('line 11'+JSON.stringify(this.Quote));
    }).catch(error=>{
             console.log('error+++'+error);
         })
    
}
}