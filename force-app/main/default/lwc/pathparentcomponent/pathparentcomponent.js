import { LightningElement ,api,track} from 'lwc';
import opprecords from '@salesforce/apex/PF_GetSuppleirDetails.opprecords';

export default class Pathparentcomponent extends LightningElement {
    @api strAllProductNames;
    @api strProductnamefrominvdatatable;
    @api blnOpenTab;
    list_Opportunities;
    @api strPassProductValue;
    @api StrPassWarehouseValue;
    @api blnActiveTab='Inventory Management';
    @track list_Tabs = [];
    @api blnShow = false;
    @api blnShowOppTab= false;
    @track strCurrentStep="Inventory Summary";
    @track blnIsInvSummary =true;
    @track blnIsOrderInv=false;
    @track blnIsSupplierSelection=false;
    @track blnIsOrderSummary=false;
    blnIsShowModal=false;
    @track list_Steps = [
        { label: 'Inventory Summary', value: 'Inventory Summary' },
        { label: 'Order Inventory', value: 'Order Inventory' },
        { label: 'Supplier Selection', value: 'Supplier Selection' },
        { label: 'Order Summary', value: 'Order Summary' } ];

    connectedCallback(){
        console.log('inside connected callback');
    }

//This function sets certain flags to true or false based on the value of an event target.
    moveToCmp(event){
        if(event.target.value==='Inventory Summary') {
            this.strCurrentStep="Inventory Summary";
            this.blnIsInvSummary =true;
            this.blnIsOrderInv =false;
            this.blnIsSupplierSelection=false;
            this.blnIsOrderSummary=false;
        }
        else if(event.target.value==='Order Inventory') {
            this.strCurrentStep="Order Inventory";
            this.blnIsInvSummary =false;
            this.blnIsOrderInv =false;
            this.blnIsSupplierSelection=false;
            this.blnIsOrderSummary=false;
        }
        else if(event.target.value==='Supplier Selection') {
            this.strCurrentStep="Supplier Selection";
            this.blnIsInvSummary =false;
            this.blnIsOrderInv =false;
            this.blnIsSupplierSelection=true;
            this.blnIsOrderSummary=false;
        }
        else if(event.target.value==='Order Summary'){
            this.strCurrentStep="Order Summary";
            this.blnIsInvSummary =false;
            this.blnIsOrderInv =false;
            this.blnIsSupplierSelection=false;
            this.blnIsOrderSummary=true;
        }
    }

    //This method is used to handle an event and update the state of certain variables change in the displayed content.
    handleAnswer(event){
        this.strCurrentStep="Order Inventory";
        this.blnIsInvSummary =false;
        this.blnIsOrderInv =true;
        this.blnIsSupplierSelection=false;
        this.blnIsOrderSummary=false;
        this.selectedRow=event.detail.row;
    } 

    //This function is used to set the current step to "Supplier Selection" and show the corresponding UI components while hiding others.
    moveToSupplierSelection(event){
         this.strCurrentStep="Supplier Selection";
        this.blnIsInvSummary =false;
        this.blnIsOrderInv =false;
        this.blnIsSupplierSelection=true;
        this.blnIsOrderSummary=false;
         }

    //This function is used to handle the product name selected by the user.
    handleproductname(event){
        this.strAllProductNames=event.detail.product;
    }
    //This method is used to handle the product details and create an opportunity tab based on the selected product from the inventory data table.
    Handleproductdetails(event){
        console.log('line 72');
        this.strProductnamefrominvdatatable=event.detail.product;
        console.log('line 74'+ this.strProductnamefrominvdatatable);
        this.blnOpenTab=event.detail.createtaboption;
        console.log('line 75'+this.blnOpenTab);
        this.getOpportunities(this.strProductnamefrominvdatatable);
        this.blnShow=true;
        this.blnShowOppTab=true;
        console.log('line 98'+this.strProductnamefrominvdatatable);
        console.log('100:'+this.blnActiveTab);
    } 

    //This function is used to handle and update the values passed from the child component and update the current step and other related boolean values accordingly.
    handlepassproductdetails(event){
        console.log('line 91');
        this.strPassProductValue=event.detail.passproduct;
        this.StrPassWarehouseValue = event.detail.passwarehouse;
        console.log('parentwarehousename'+this.StrPassWarehouseValue)
        console.log('line 94'+ this.strPassProductValue);
        this.strCurrentStep="Order Inventory";
        this.blnIsInvSummary =false;
        this.blnIsOrderInv =true;
        this.blnIsSupplierSelection=false;
        this.blnIsOrderSummary=false;
    } 

    //This method is used to handle the selection of an active tab and load data for a specific tab here it is ('Delivery Information') if it is selected.
    handleActive(event){
        console.log('121:'+event.target.value);
        this.blnActiveTab = event.target.value;
        try{
            if(this.blnActiveTab ==='Delivery Information'){
                console.log('132')
                this.template.querySelector('c-delivery-information').loadData();
            }
        }
        catch (error) {
            console.log('Check'+error);
         } 
    }
   
   //This method is used to refresh the data in QA Manager component when called by the parent component.
   handleqarefresh(){
    console.log('qa refresh : ')
    this.template.querySelector("c-p-f-q-a-manager-component").handlerefresh(); 
   }

//This method retrieves opportunity records for a selected product and displays data in the UI.
    getOpportunities(strProductName) {
        this.productnamevalueselected = strProductName;
        opprecords({productname : strProductName })
        .then(result=>{
            this.OppquantityList=result;
            let templist=[];
            var newData = JSON.parse(JSON.stringify(result));
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               tempRecs.OppnameUrl= '/'+record.OpportunityId;
               console.log('OppName:'+record.Opportunity.Name);
               if(record.Opportunity.Name){tempRecs.opporName=record.Opportunity.Name};
              tempRecs.Cdate=record.Opportunity.CloseDate;
              tempRecs.quantityvalue=record.Opportunity.TotalOpportunityQuantity;
              if(record.Opportunity.OrderNumber__c){tempRecs.Onumber=record.Opportunity.OrderNumber__c};
              if(record.Opportunity.StageName){tempRecs.Sname=record.Opportunity.StageName};               
               templist.push(tempRecs);
            });
            this.list_Opportunities = templist;
           this.oppTab=strProductName;
           this.tabContent=this.list_Opportunities;
           this.blnIsShowModal=true;
        console.log('line 159'+JSON.stringify(this.blnActiveTab));
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        });
    }

    //This function is used to close a popup.
    closeThePopup(event){
        console.log('line 318');
        this.blnIsShowModal=false;
    
    }
}