import { LightningElement,track,api } from 'lwc';

export default class Stages_Parent_Component extends LightningElement {
    @api selectedsupplierdetails;
    @api Orders;
    
    //currentvalue = '1';
   // selectedvalue = 'Inventory Summary';
    summary='';
    @track selectedRow ;
    handleAnswer(event) {
        /*eslint-disable-next-line*/
        
        this.selectedRow=event.detail.row;
        console.log('row: '+JSON.stringify(this.selectedRow));
        this.currentvalue = event.detail.value;
       // this.currentvalue= event.detail.value;
        //this.currentvalue='2';
        this.selectedvalue = event.detail.label;
      
        this.PlaceOrder=true;
        this.summary=false;
        this.send=false;
        

      }

      moveToSupplierSelection(event){
                this.currentvalue = event.detail.value;
               // this.currentvalue= event.detail.value;
                //this.currentvalue='2';
                this.selectedvalue = event.detail.label;
              
                this.PlaceOrder=false;
                this.summary=true;
                this.send=false;
              }
        
        
    pathHandler2(event){
        var targetValue = event.currentTarget.value;
        var selectedvalue = event.currentTarget.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue;
        this.PlaceOrder=true;
        this.summary=false;
        this.send=false;
    }
    pathHandler(event) {
        var targetValue = event.currentTarget.value;
        var selectedvalue = event.currentTarget.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue;
        
        this.summary=true;
        this.PlaceOrder=false;
        this.send=false;
        

         }
    /*handlesupplierdetails(event){
        console.log('line 47');
        this.selectedsupplierdetails=event.detail.slist;
        console.log('line 48'+this.selectedsupplierdetails);

    }*/

    pathHandler3(event){
        console.log('line 52');
        var targetValue = event.detail.value;
        var selectedvalue = event.detail.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue;
        console.log('line 56' + this.currentvalue);
        console.log('line 57'+ this.selectedvalue);
        
        this.summary=false;
        this.PlaceOrder=false;
        this.send=true;
        console.log('line 65'+this.summary+this.PlaceOrder+this.send);

    }
    pathHandler4(event){
        console.log('line 52');
        var targetValue = event.detail.value;
        var selectedvalue = event.detail.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue;
        console.log('line 56' + this.currentvalue);
        console.log('line 57'+ this.selectedvalue);
        
        this.summary=false;
        this.PlaceOrder=false;
        this.send=false;
        this.Orders=true;
        console.log('line 65'+this.summary+this.PlaceOrder+this.send);

    }
    

    
         
        
    }
    
    
        //console.log('line 14');
    
    //console.log('line 20' + summary);