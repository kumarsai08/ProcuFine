import { LightningElement ,api,track} from 'lwc';
import opprecords from '@salesforce/apex/GetSuppleirDetails.opprecords';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation'


export default class Pathparentcomponent extends LightningElement {
    @api productName;
    @api productnamefrominvdatatable;
    @api opentab;
    list_Opportunities;
    @api passproductvalue;
    @api StrPassWarehouseValue;
    @api activeTab='Inventory Management';

    @track tabs = [];
    @api show = false;
    @api showOppTab= false;

    @track steps = [
        { label: 'Inventory Summary', value: 'Inventory Summary' },
        { label: 'Order Inventory', value: 'Order Inventory' },
        { label: 'Supplier Selection', value: 'Supplier Selection' },
        { label: 'Order Summary', value: 'Order Summary' }
    ];
    @track currentStep="Inventory Summary";
    @track isInvSummary =true;
    @track isOrderInv=false;
    @track isSupplierSelection=false;
    @track isOrderSummary=false;
    @track sendOrderData =[];

    isShowModal=false;
    connectedCallback(){
        console.log('inside connected callback');
    //     this.isInvSummary =true;
    //     this.isOrderInv =false;
    //     this.isSupplierSelection=false;
    //     this.isOrderSummary=false;
    }
    moveToCmp(event){
        if(event.target.value==='Inventory Summary') {
            this.currentStep="Inventory Summary";
            this.isInvSummary =true;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Order Inventory') {
            this.currentStep="Order Inventory";
            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Supplier Selection') {
            this.currentStep="Supplier Selection";
            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=true;
            this.isOrderSummary=false;
        }
        else if(event.target.value==='Order Summary'){
            this.currentStep="Order Summary";
            this.isInvSummary =false;
            this.isOrderInv =false;
            this.isSupplierSelection=false;
            this.isOrderSummary=true;
        }
    }

    handleAnswer(event){
        this.currentStep="Order Inventory";
        this.isInvSummary =false;
        this.isOrderInv =true;
        this.isSupplierSelection=false;
        this.isOrderSummary=false;
        this.selectedRow=event.detail.row;
    } 
    moveToSupplierSelection(event){
         this.currentStep="Supplier Selection";
        this.isInvSummary =false;
        this.isOrderInv =false;
        this.isSupplierSelection=true;
        this.isOrderSummary=false;
         }

    handleproductname(event){
        this.productName=event.detail.product;
    }

    Handleproductdetails(event){
        console.log('line 72');
        this.productnamefrominvdatatable=event.detail.product;
        console.log('line 74'+ this.productnamefrominvdatatable);
        this.opentab=event.detail.createtaboption;
        console.log('line 75'+this.opentab);
        // this.opentab=true;
        this.getOpportunities(this.productnamefrominvdatatable);
        
        //console.log('producttable'+producttable);
        this.show=true;
        this.showOppTab=true;
        console.log('line 98'+this.productnamefrominvdatatable);
        //this.activeTab=this.productnamefrominvdatatable+' Opportunity Information ';
        console.log('100:'+this.activeTab);
        //this.activeTab=1;
       // this.activeTab = activeTab.toString();

    } 

    handlepassproductdetails(event){
        console.log('line 91');
        this.passproductvalue=event.detail.passproduct;
        this.StrPassWarehouseValue = event.detail.passwarehouse;
        console.log('parentwarehousename'+this.StrPassWarehouseValue)

        console.log('line 94'+ this.passproductvalue);



        this.currentStep="Order Inventory";
        this.isInvSummary =false;
        this.isOrderInv =true;
        this.isSupplierSelection=false;
        this.isOrderSummary=false;

    }

    

    handleActive(event){
        console.log('121:'+event.target.value);
        this.activeTab = event.target.value;
        try{
            if(this.activeTab ==='Delivery Information'){
                console.log('132')
                this.template.querySelector('c-delivery-information').loadData();
               // onqarefresh={handleqarefresh}
            }
        }

        catch (error) {
            console.log('Check'+error);
         }
       
        
    }
   // handleQAactive(event){
      //  this.template.querySelector("c-p-f-q-a-manager-component").handlerefresh();  

   // }
   handleqarefresh(){
    console.log('qa refresh : ')
    this.template.querySelector("c-p-f-q-a-manager-component").handlerefresh(); 
   }


    getOpportunities(strProductName) {
        this.productnamevalueselected = strProductName;
        //console.log('product name :: '+this.productnamevalueselected);
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
           this.oppTab=strProductName;
           this.tabContent=this.list_Opportunities;
           this.isShowModal=true;
        //    this.activeTab=strProductName;
        // this.tabs.push({ label: strProductName, content: this.list_Opportunities ,value:strProductName}); 
      

        
        console.log('line 159'+JSON.stringify(this.activeTab));

           // console.log('this.OppquantityList1 :: '+JSON.stringify(templist));
            //return templist;
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        });
    }
    @api handleRemoveTab(event){
        console.log('inside handle remove tab');
        this.tabs.pop(event.detail.tabtitle);
    }

    closeThePopup(event){
        console.log('line 318');
        this.isShowModal=false;
    
    }
}