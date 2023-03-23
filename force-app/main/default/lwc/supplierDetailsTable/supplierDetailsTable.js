import { LightningElement, wire,track,api} from 'lwc';
import GetSupplierrDetailsfornewtable from '@salesforce/apex/pf_Opportunitysummary.GetSupplierrDetailsfornewtable';
import supplierSection from '@salesforce/apex/pf_Opportunitysummary.supplierSection';
import supplierSearchFilter from '@salesforce/apex/pf_Opportunitysummary.supplierSearchFilter';
import supplierNamesList from '@salesforce/apex/pf_Opportunitysummary.supplierNamesList';
import retrieveRecords from '@salesforce/apex/pf_Opportunitysummary.retrieveRecords';
import SendAnEmail from '@salesforce/apex/pf_Opportunitysummary.SendAnEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SupplierDetailsTable extends LightningElement {


    @track OpportunityList=[];
    @api pslist;
    @track supplieroptions= [];
    @api supplierlist=[];
    @api productnamee;
    @api value='';
    @api ChangedString;
    @api AllList;
    @api checkboxlist=[];
    @api changevalue;
    @api options;
    @api ischeckvalue;
    @api warehousename;
    @track selectedSupp;
    @api orderQuantity;
    @api orderQuantityList;
    @api inptValue ="";
    @api supplierNamesList = [];
    @api inptq =[];
    @track loading = false;
    @api totalquantity;
    @api opportunityQuantity;
    @api strChangedInpQuantity='';
    @api IntTotalInputQuantity;
    @api showtotalQuantity;
    @api opp;
    @api differenceValue;
    @api IntMaxOrderingQuantity;

    connectedCallback(){
        GetSupplierrDetailsfornewtable({pname: this.productnamee})
            .then(result=>{
                console.log('line 13');
            console.log('34:'+JSON.stringify(result));
                this.OpportunityList=JSON.parse(JSON.stringify(result));
                console.log('line 15'+JSON.stringify(this.OpportunityList));
                this.IntMaxOrderingQuantity=result[0].Quantity__c - result[0].PF_On_Order__c;
                this.differenceValue= result[0].Quantity__c - result[0].PF_On_Order__c;
               // this.opportunityQuantity=this.OpportunityList[0].Opportunity.PF_Opportunity_Quantity__c;
                 console.log('line 48'+this.opportunityQuantity);
               
            })
            .catch(error=>{
                console.log('error'+error);
            })
           
           supplierSection({pnamee : this.productnamee}).then(result=>{
                console.log('line 24'+ this.productnamee);
                this.pslist=result;
                this.AllList=result;
                
               
                console.log('line 26'+  JSON.stringify(this.pslist));
                this.pslist.forEach(element => {
                    console.log('line 32'+  typeof element.Supplier_Name__r.Name);

                   
                   
                });
           
               
            })
            .catch(error=>{
                console.log('error'+error);
            })
           
            supplierNamesList({pnamee : this.productnamee}).then(result=>{
                this.supplierlist.push({label:'All',value:'All'});
                result.forEach(element => {
                    this.supplierlist.push({label:element,value:element});
                    this.supplieroptions = JSON.parse(JSON.stringify(this.supplierlist));
                    console.log('line 53'+JSON.stringify(this.supplieroptions));
                });
        })
        .catch(error=>{
            console.log('error'+error);
        })

    }
    getQuantity(event){
       
    }


    handleOrderQuantity(event){
        let inputId =[];
        let selectedRows = event.target.checked;
        console.log('inndex:'+event.target.dataset.pos);
        console.log('sname'+event.target.dataset.sname);
        inputId.push(event.currentTarget.dataset.pos);
        if(selectedRows)
        {
            this.inptq.push(this.template.querySelector(`input[data-index="${inputId[0]}"]`).value);
            this.supplierNamesList.push(this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);}
        else {
       this.inptq=this.inptq.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).value);
       this.supplierNamesList=this.supplierNamesList.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);
     }
     let totalq=0;
     this.inptq.forEach(element => {
         
         console.log('line 230');
         totalq=totalq +parseInt(element);
         this.showtotalQuantity=totalq;
         console.log('line 232'+this.showtotalQuantity);
     });
        console.log('inptq',this.inptq)
        console.log('id:'+inputId);
        console.log('snames list : '+this.supplierNamesList);
    }


    handleChange(event){
        console.log('line 95');
        this.ChangedString=event.detail.value;
        console.log('line 95'+ this.ChangedString);
        if (this.ChangedString==='All') {
            console.log('line 104');
            this.pslist=this.AllList;
           
        } else {
            retrieveRecords({pnamee: this.productnamee,searchsname: this.ChangedString}).then(result=>{
                console.log('line 13');
                this.pslist=result;
                console.log('line 15'+JSON.stringify(this.pslist));             
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
           
        }
       
       
    }


    Handlecheckbox(event){
       
        let selectedRows = this.template.querySelectorAll('lightning-input');
        for(let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].type === 'checkbox') {
                selectedRows[i].checked = event.target.checked;
            }
        }
    }
   
    handleSendMail(event){
            this.selectedSupp = [];
            //this.orderQuantity='55';
   
            let selectedRows = this.template.querySelectorAll('lightning-input');
   
            // based on selected row getting values of the contact
            for(let i = 0; i < selectedRows.length; i++) {
                if(selectedRows[i].checked && selectedRows[i].type === 'checkbox') {
                    this.selectedSupp.push(
                        // record: selectedRows[i].value,
                         selectedRows[i].dataset.id


                    );
                }
            }
            console.log('Line 171:'+JSON.stringify(this.selectedSupp));
            console.log('192');
            /*this.totalquantity=0;
            this.inptq.forEach(element => {
                console.log('line 230');
                this.totalquantity=this.totalquantity+parseInt(element);
                console.log('line 232'+this.totalquantity);
            });
            //console.log('193:'+document.getElementById(this.selectedSupp[0]).value);
            if(this.totalquantity>this.differenceValue){
                const evt = new ShowToastEvent({
                    title: 'Recheck Quantity',
                    message: 'Please Recheck the sum of input quanity',
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);


            }else{*/
            SendAnEmail({supplierids : this.selectedSupp,Orderquantity : this.inptq,supplierNamesList : this.supplierNamesList}).then(result=>{
                console.log('line 24');
               


                console.log('line 26'+ JSON.stringify(result));
                this.loading = true;
                const evt = new ShowToastEvent({
                    title: 'Email',
                    message: 'Request for Quotation',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.loading = false;    
               
        this.dispatchEvent(new CustomEvent('supplierselection', {detail:{value:"3", label:'Supplier Selection'}}));
               
            })
            .catch(error=>{
                console.log('send an email error'+JSON.stringify(error));
                this.loading = false;
            })
            
        //}
}
handleInputQuantity(event){
    console.log('258')
    this.strChangedInpQuantity=event.target.value;
    this.strSupplierNameRelated=event.currentTarget.dataset.sname;
    console.log('line 259'+this.strChangedInpQuantity);
    if (this.supplierNamesList.includes(this.strSupplierNameRelated)) {
        let indexvalue=0;
        indexvalue=this.supplierNamesList.indexOf(this.strSupplierNameRelated);
        this.inptq[indexvalue]=this.strChangedInpQuantity;
    }
    console.log('line 268'+this.inptq);
    console.log('line 269'+this.supplierNamesList);
}

}