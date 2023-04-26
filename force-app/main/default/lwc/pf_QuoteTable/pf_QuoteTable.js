import { LightningElement, api } from 'lwc';
import getQuoteLineItems from '@salesforce/apex/PF_GetSuppleirDetails.getQuoteLineItems';

export default class Pf_QuoteTable extends LightningElement {
    @api QuoteItem=[];

    connectedCallback(){
       
        getQuoteLineItems({}).then(result=>{
            console.log('line 10');
           this.QuoteItem = result;
           console.log('Line 12'+JSON.stringify(result));
        })
    .catch(error=>{
        console.log('error'+error);
    })  
}
}