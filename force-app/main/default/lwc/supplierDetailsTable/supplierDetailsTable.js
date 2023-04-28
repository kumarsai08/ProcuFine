import { LightningElement, wire,track,api} from 'lwc';
import GetSupplierrDetailsfornewtable from '@salesforce/apex/PF_GetSuppleirDetails.GetSupplierrDetailsfornewtable';
import supplierSection from '@salesforce/apex/PF_GetSuppleirDetails.supplierSection';
import supplierSearchFilter from '@salesforce/apex/PF_GetSuppleirDetails.supplierSearchFilter';
import supplierNamesList from '@salesforce/apex/PF_GetSuppleirDetails.supplierNamesList';
import retrieveRecords from '@salesforce/apex/PF_GetSuppleirDetails.retrieveRecords';
import SendAnEmail from '@salesforce/apex/PF_GetSuppleirDetails.SendAnEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class SupplierDetailsTable extends NavigationMixin (LightningElement) {

    @api list_AllList;
    @api list_inptq =[];
    @api list_Inventory=[];
    @api list_SelectedSupp;
    @api list_ProductSuppliers;
    @api list_SupplierNames=[];
    @api list_SupplierOptions= [];
    @api list_SupplierNamesList = [];
    @api strWareName;
    @api strproductnamee;
    @api strwarehousename;
    @api strChangedString;
    @api strChangedInpQuantity=''; 
    @api intTotalQuantity;
    @api intThresholdValue;
    @api intStockOnHandValue;
    @api intDifferenceValue;
    @api IntTotalInputQuantity;
    @api intShowTotalQuantity;
    @api IntMaxOrderingQuantity;
    @api blnLoading = false;
    @api strValue='';

    //This method is used for fetching and updating inventory and supplier data for a particular product and warehouse.
    connectedCallback(){
        console.log('strwarehousename'+this.strwarehousename)
        GetSupplierrDetailsfornewtable({pname : this.strproductnamee , wname : this.strwarehousename })
            .then(result=>{
                console.log('line 13');
            console.log('34:'+JSON.stringify(result));
                this.list_Inventory=JSON.parse(JSON.stringify(result));
                console.log('line 15'+JSON.stringify(this.list_Inventory));
                console.log('line 38'+JSON.stringify(this.list_Inventory[0].Warehouse__r.Name));
                this.strWareName=this.list_Inventory[0].Warehouse__r.Name;
                this.intThresholdValue=this.list_Inventory[0].Threshold__c;
                console.log('line 48'+this.intThresholdValue);
                this.intStockOnHandValue=this.list_Inventory[0].Stock_On_Hand__c;
                console.log('line 48'+this.intStockOnHandValue);
                this.IntMaxOrderingQuantity = this.list_Inventory[0].Shortfall__c;
                this.intDifferenceValue=this.intThresholdValue-this.intStockOnHandValue-this.list_Inventory[0].On_Order__c-this.list_Inventory[0].Order__c;  
            })
            .catch(error=>{
                console.log('error'+error);
            })
        
           supplierSection({pnamee : this.strproductnamee}).then(result=>{
                console.log('line 24'+ this.strproductnamee);
                this.list_ProductSuppliers=result;
                this.list_AllList=result;
                console.log('line 26'+  this.list_ProductSuppliers);
                this.list_ProductSuppliers.forEach(element => {
                    console.log('line 32'+  typeof element.Account__r.Name);
                });
            })
            .catch(error=>{
                console.log('error'+error);
            })
            
            supplierNamesList({pnamee : this.strproductnamee}).then(result=>{
                this.list_SupplierNames.push({label:'All',value:'All'});
                result.forEach(element => {
                    this.list_SupplierNames.push({label:element,value:element});
                    this.list_SupplierOptions = JSON.parse(JSON.stringify(this.list_SupplierNames));
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
            this.list_SupplierNamesList.push(this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);
        }
        else {
       this.list_inptq=this.list_inptq.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).value);
       this.list_SupplierNamesList=this.list_SupplierNamesList.filter(value=>value !==this.template.querySelector(`input[data-index="${inputId[0]}"]`).dataset.sname);
     }
     console.log('dom',this.list_inptq)
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
            retrieveRecords({pnamee: this.strproductnamee,searchsname: this.strChangedString}).then(result=>{
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
            // based on selected row getting values of the contact
            for(let i = 0; i < selectedRows.length; i++) {
                if(selectedRows[i].checked && selectedRows[i].type === 'checkbox') {
                    this.list_SelectedSupp.push(
                        // record: selectedRows[i].value,
                         selectedRows[i].dataset.id
                    );
                }
            }
            console.log('Line 171:'+JSON.stringify(this.list_SelectedSupp));
            console.log('192');
            this.intDifferenceValue=this.intThresholdValue-this.intStockOnHandValue;
            console.log('line 236'+this.intDifferenceValue);
            this.intTotalQuantity=0;
            this.list_inptq.forEach(element => {
                console.log('line 230');
                this.intTotalQuantity=this.intTotalQuantity+parseInt(element);
                console.log('line 232'+this.intTotalQuantity);
            });
            SendAnEmail({supplierids : this.list_SelectedSupp,Orderquantity : this.list_inptq,supplierNamesList : this.list_SupplierNamesList,WarehouseName : this.strWareName}).then(result=>{
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

        //This method is used to navigate to product with a specific ID and opens it in a new tab.
        RecordPage(event){
            const prodID=event.target.dataset.strproductid;
             this[NavigationMixin.GenerateUrl]({
                 type: 'standard__recordPage',
                 attributes:{
                     recordId: prodID,
                     objectApiName: 'Product2',
                     actionName:'view'
                 }
             }).then(url =>{
                 window.open(url, "_blank");
             })
        }

        //This method is used to navigate to warehouse with a specific ID and opens it in a new tab.
        NavigatetowarehousePage(event){
            const ordId=event.target.dataset.strwarehouseid;
             this[NavigationMixin.GenerateUrl]({
                 type: 'standard__recordPage',
                 attributes:{
                     recordId: ordId,
                     objectApiName: 'Location',
                     actionName:'view'
                 }
             }).then(url =>{
                 window.open(url, "_blank");
             })
        }
}