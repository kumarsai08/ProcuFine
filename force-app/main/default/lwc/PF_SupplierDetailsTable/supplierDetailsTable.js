import { LightningElement, wire,track,api} from 'lwc';
import GetSupplierrDetailsfornewtable from '@salesforce/apex/pf_Opportunitysummary.GetSupplierrDetailsfornewtable';
import supplierSection from '@salesforce/apex/pf_Opportunitysummary.supplierSection';
import supplierNamesList from '@salesforce/apex/pf_Opportunitysummary.supplierNamesList';
import retrieveRecords from '@salesforce/apex/pf_Opportunitysummary.retrieveRecords';
import SendAnEmail from '@salesforce/apex/pf_Opportunitysummary.SendAnEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SupplierDetailsTable extends LightningElement {

    @track list_Opportunity=[];
    @api list_ProductSuppliers;
    @track list_SupplierOptions= [];
    @api list_Supplierlist=[];
    @api strProductNamee;
    @api strChangedString;
    @api list_AllList;
    @track list_SelectedSupp;
    @api list_SupplierNamesList = [];
    @api list_inptq =[];
    @track blnLoading = false;
    @api strChangedInpQuantity='';
    @api IntTotalInputQuantity;
    @api intShowTotalQuantity;
    @api intDifferenceValue;
    @api IntMaxOrderingQuantity;

//This method is used for fetching and updating inventory and supplier data for a particular product.
    connectedCallback(){
        GetSupplierrDetailsfornewtable({pname: this.strProductNamee})
            .then(result=>{
                console.log('line 13');
            console.log('34:'+JSON.stringify(result));
                this.list_Opportunity=JSON.parse(JSON.stringify(result));
                console.log('line 15'+JSON.stringify(this.list_Opportunity));
                this.IntMaxOrderingQuantity=result[0].Quantity__c - result[0].PF_On_Order__c;
                this.intDifferenceValue= result[0].Quantity__c - result[0].PF_On_Order__c;
            })
            .catch(error=>{
                console.log('error'+error);
            })
           supplierSection({pnamee : this.strProductNamee}).then(result=>{
                console.log('line 24'+ this.strProductNamee);
                this.list_ProductSuppliers=result;
                this.list_AllList=result;
                console.log('line 26'+  JSON.stringify(this.list_ProductSuppliers));
                this.list_ProductSuppliers.forEach(element => {
                    console.log('line 32'+  typeof element.Supplier_Name__r.Name);
                });
            })
            .catch(error=>{
                console.log('error'+error);
            })
            supplierNamesList({pnamee : this.strProductNamee}).then(result=>{
                this.list_Supplierlist.push({label:'All',value:'All'});
                result.forEach(element => {
                    this.list_Supplierlist.push({label:element,value:element});
                    this.list_SupplierOptions = JSON.parse(JSON.stringify(this.list_Supplierlist));
                    console.log('line 53'+JSON.stringify(this.list_SupplierOptions));
                });
        })
        .catch(error=>{
            console.log('error'+error);
        })
    }
    

    //This function is used to handle the quantity of orders placed by a user for a particular supplier selected from a list of suppliers. 
    //It also stores the supplier name and the quantity ordered by the user for each supplier.
    handleOrderQuantity(event){
        let inputId =[];
        let selectedRows = event.target.checked;
        console.log('inndex:'+event.target.dataset.pos);
        console.log('sname'+event.target.dataset.sname);
        inputId.push(event.currentTarget.dataset.pos);
        if(selectedRows)
        {
            this.list_inptq.push(this.template.querySelector(`input[data-index="${inputId[0]}"]`).value);
            this.list_SupplierNamesList.push(this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);}
        else {
       this.list_inptq=this.list_inptq.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).value);
       this.list_SupplierNamesList=this.list_SupplierNamesList.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);
     }
     let totalq=0;
     this.list_inptq.forEach(element => {
         
         console.log('line 230');
         totalq=totalq +parseInt(element);
         this.intShowTotalQuantity=totalq;
         console.log('line 232'+this.intShowTotalQuantity);
     });
        console.log('inptq',this.list_inptq)
        console.log('id:'+inputId);
        console.log('snames list : '+this.list_SupplierNamesList);
    }

//This function is used to handle changes in a picklist selection.It sets a variable to the new selected value and displays all records or retrieves new records based on the new value selected from the picklist.
    handleChange(event){
        console.log('line 95');
        this.strChangedString=event.detail.value;
        console.log('line 95'+ this.strChangedString);
        if (this.strChangedString==='All') {
            console.log('line 104');
            this.list_ProductSuppliers=this.list_AllList;
           
        } else {
            retrieveRecords({pnamee: this.strProductNamee,searchsname: this.strChangedString}).then(result=>{
                console.log('line 13');
                this.list_ProductSuppliers=result;
                console.log('line 15'+JSON.stringify(this.list_ProductSuppliers));             
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
           
        }
       
       
    }

    //This function handles a checkbox event and selects/deselects all the checkboxes based on whether the "Select All" checkbox is checked or unchecked.
    Handlecheckbox(event){
       
        let selectedRows = this.template.querySelectorAll('lightning-input');
        for(let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].type === 'checkbox') {
                selectedRows[i].checked = event.target.checked;
            }
        }
    }

   //This code is used to handle the event of sending an email for a request for quotation.It retrieves the suppliers selected based on the checkboxes.
    //Then it displays a toast message to confirm that the email has been sent.
    handleSendMail(event){
            this.list_SelectedSupp = [];
            let selectedRows = this.template.querySelectorAll('lightning-input');   
            for(let i = 0; i < selectedRows.length; i++) {
                if(selectedRows[i].checked && selectedRows[i].type === 'checkbox') {
                    this.list_SelectedSupp.push(
                         selectedRows[i].dataset.id
                    );
                }
            }
            console.log('Line 171:'+JSON.stringify(this.list_SelectedSupp));
            console.log('192');
            SendAnEmail({supplierids : this.list_SelectedSupp,Orderquantity : this.list_inptq,supplierNamesList : this.list_SupplierNamesList}).then(result=>{
                console.log('line 24');
                console.log('line 26'+ JSON.stringify(result));
                this.blnLoading = true;
                const evt = new ShowToastEvent({
                    title: 'Email',
                    message: 'Request for Quotation',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.blnLoading = false;    
        this.dispatchEvent(new CustomEvent('supplierselection', {detail:{value:"3", label:'Supplier Selection'}}));
            })
            .catch(error=>{
                console.log('send an email error'+JSON.stringify(error));
                this.blnLoading = false;
            })
}

//This method is used to handle changes made in the input field for quantity. 
handleInputQuantity(event){
    console.log('258')
    this.strChangedInpQuantity=event.target.value;
    this.strSupplierNameRelated=event.currentTarget.dataset.sname;
    console.log('line 259'+this.strChangedInpQuantity);
    if (this.list_SupplierNamesList.includes(this.strSupplierNameRelated)) {
        let indexvalue=0;
        indexvalue=this.list_SupplierNamesList.indexOf(this.strSupplierNameRelated);
        this.list_inptq[indexvalue]=this.strChangedInpQuantity;
    }
    console.log('line 268'+this.list_inptq);
    console.log('line 269'+this.list_SupplierNamesList);
}

}