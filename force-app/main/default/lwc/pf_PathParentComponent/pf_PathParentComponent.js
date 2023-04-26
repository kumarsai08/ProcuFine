import { LightningElement ,api,track} from 'lwc';
import opprecords from '@salesforce/apex/pf_Opportunitysummary.opprecords';


export default class Pf_PathParentComponent extends LightningElement {
    @api strAllProductNames;
    @api strProductNameFromInvDatatable;
    @api blnOpenTab;
    list_Opportunities;
    @api strPassProductValue;
    @api blnActiveTab='Inventory Management';
    @track list_Tabs = [];
    @api blnShow = false;
    @api blnShowOppTab= false;
    @api strOppNameFromOppSummary;
    @track list_Steps = [
        { label: 'Inventory Summary', value: 'Inventory Summary' },
        { label: 'Order Inventory', value: 'Order Inventory' },
        { label: 'Supplier Selection', value: 'Supplier Selection' },
        { label: 'Order Summary', value: 'Order Summary' }
    ];
    @track strCurrentStep="Inventory Summary";
    @track blnIsInvSummary =true;
    @track blnIsOrderInv=false;
    @track blnIsSupplierSelection=false;
    @track blnIsOrderSummary=false;
    blnIsShowModal=false;


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
        this.isOrderSummary=false;
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
        this.strProductNameFromInvDatatable=event.detail.product;
        console.log('line 74'+ this.strProductNameFromInvDatatable);
        this.blnOpenTab=event.detail.createtaboption;
        this.strOppNameFromOppSummary=event.detail.oppname;
        console.log('line 75'+this.blnOpenTab);
        // this.opentab=true;
        this.getOpportunities(this.strProductNameFromInvDatatable);
        
        //console.log('producttable'+producttable);
        this.blnShow=true;
        this.blnShowOppTab=true;
        console.log('line 98'+this.strProductNameFromInvDatatable);
        //this.activeTab=this.productnamefrominvdatatable+' Opportunity Information ';
        console.log('100:'+this.blnActiveTab);
        //this.activeTab=1;
       // this.activeTab = activeTab.toString();

    } 

    //This function is used to handle and update the values passed from the child component and update the current step and other related boolean values accordingly.
    handlepassproductdetails(event){
        console.log('line 91');
        this.strPassProductValue=event.detail.passproduct;
        //this.oppIdfromOppSummary=event.detail.oppid;
        //console.log('opp summary id : '+ this.oppIdfromOppSummary);



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
            if(this.blnActiveTab ==='Receiving Manger'){
                this.template.querySelector('c-delivery-information').loadData();
            }
        }

        catch (error) {
            console.log('Check'+error);
         }
       
        
    }

//This method retrieves opportunity records for a selected product and displays data in the UI.
    getOpportunities(strProductName) {
        this.productnamevalueselected = strProductName;
        console.log('product name :: '+this.productnamevalueselected);
        opprecords({productname : strProductName })
        .then(result=>{
            
            this.OppquantityList=result;

            
            let templist=[];
           
            var newData = JSON.parse(JSON.stringify(result));
    
            
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               
              // tempRecs.NameUrl = '/'+tempRecs.Product__c;
               //tempRecs.ProdName = record.Product__r.Name;
            //    console.log('line 67'+ JSON.stringify(record));
               tempRecs.OppnameUrl= '/'+record.OpportunityId;
               console.log('OppName:'+record.Opportunity.Name);
               if(record.Opportunity.Name){tempRecs.opporName=record.Opportunity.Name};
            //    console.log('line 63'+ JSON.stringify(tempRecs));
              tempRecs.Cdate=record.Opportunity.CloseDate;
              tempRecs.quantityvalue=record.Opportunity.TotalOpportunityQuantity;
              if(record.Opportunity.OrderNumber__c){tempRecs.Onumber=record.Opportunity.OrderNumber__c};
              if(record.Opportunity.StageName){tempRecs.Sname=record.Opportunity.StageName};
             // console.log('line 68'+ JSON.stringify(tempRecs));
               
               templist.push(tempRecs);
            });
    
            this.list_Opportunities = templist;
           this.oppTab=this.productnamevalueselected;
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