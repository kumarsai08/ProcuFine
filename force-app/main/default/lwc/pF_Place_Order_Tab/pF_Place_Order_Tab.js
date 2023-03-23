import { LightningElement,api } from 'lwc';

export default class PF_Place_Order_Tab extends LightningElement {
    @api selectedRowOnly;
    connectedCallback(){
        console.log('selectedRowOnly:'+this.selectedRowOnly);
    }
}