import { LightningElement, api,track} from 'lwc';
import getwarehousenamerecords from '@salesforce/apex/Pf_Inventory_Summary.getwarehousenamerecords';
import getProductNames from '@salesforce/apex/Pf_Inventory_Summary.getProductNames';
import getSupplierNames from '@salesforce/apex/Pf_Inventory_Summary.getSupplierNames';
import PFGetQuoteLineItems from '@salesforce/apex/PF_GetSuppleirDetails.PFGetQuoteLineItems';
import CreateQuotelineitems from '@salesforce/apex/PF_GetSuppleirDetails.CreateQuotelineitems';
import UpdateQuoteLineItemAndQuoteStatus from '@salesforce/apex/PF_GetSuppleirDetails.UpdateQuoteLineItemAndQuoteStatus';
import OrderRecords from '@salesforce/apex/PF_GetSuppleirDetails.OrderRecords';
import getRelatedFilesByRecordId from '@salesforce/apex/PF_GetSuppleirDetails.getRelatedFilesByRecordId';
import RejectedQuoteStatusUpdation from '@salesforce/apex/PF_GetSuppleirDetails.RejectedQuoteStatusUpdation';
import CreateQuoteAndQuoteLineItems from '@salesforce/apex/PF_GetSuppleirDetails.CreateQuoteAndQuoteLineItems';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SupplierDatatable extends NavigationMixin(LightningElement) {

    @api list_WarehouseNamesList=[];
    @api list_WarehouseNameOptions;
    @api list_ProductNameFilter;
    @api list_ProductNamesListFilter=[];
    @api list_PFQuoteLineItemsList;
    @api list_SupplierNameList=[];
    @api list_SupplierNameFilter;
    @api list_warehouslist=[];
    @api list_openedSupplierList=[];
    @api list_FilesList =[];
    @api list_QuoteIds=[];
    @api strSection;
    @api StrQuoteId;
    @api strMessage;
    @api strWarehouseChange;
    @api strwareHouseName;
    @api strproductChange;
    @api strQuoteIDs;
    @api strPricebookEntryId;
    @api strQuoteIdRedirect;
    @api strInputLineitemdescription='';
    @api strQuoteStatusValue;
    @api strStorequoteid;
    @api StrSelect='';
    @api strPdfid;
    @api strPdfrowid;
    @api StrPlaceOrderQId;
    @api strProductId='';
    @api strWarehouseId='';
    @api strInputDeliveryDate='';
    @api strRecordId;
    @api blnShowAccordion;
    @api blnIsShowModal;
    @api blnFinalised;
    @api blnIsShowProductCombobox;
    @api blnIsShowQuoteLineItems;
    @track blnloading = false;
    @api blnDisabled=false;
    @api blnIsShowQuoteStatus;
    @api blnIsShowButtons=false ;
    @api blnIsShowPDFs=false;
    @api blnshowMessage=false
    @api blnIsShowAfterQLI=false;
    @api blnshowFinalisedColumn = false;
    @api intInputQuantity='';
    @api intInputListPrice='';
    @api intInputDiscount='';
    @api openSections;
    
    //In this connectedCallback function a value is assigned to a variable and a Apex method is called to populate a list of warehouse names.
    connectedCallback(){
        this.strQuoteStatusValue='Open';
    getwarehousenamerecords({}).then(result=>{
        result.forEach(element => {
            this.list_WarehouseNamesList.push({label:element,value:element});
            this.list_WarehouseNameOptions = JSON.parse(JSON.stringify(this.list_WarehouseNamesList));
            console.log('line 53'+JSON.stringify(this.list_WarehouseNameOptions));
        });
})
.catch(error=>{
    console.log('error'+error);
})
   }

   //This method is used to handle the change event when the user selects a warehouse, and it populates the product names list based on the selected warehouse.
   handleWarehouseChange(event){
    this.strSection='';
    console.log('line 95');
    this.strWarehouseChange=event.detail.value;
    this.list_warehouslist.push(event.detail.value);
    this.list_ProductNamesListFilter=[];
    getProductNames({strwareHouseName:this.strWarehouseChange}).then(result=>{  
        result.forEach(element => {
            this.list_ProductNamesListFilter.push({label:element.Product__r.Name,value:element.Product__r.Name});
            this.list_ProductNameFilter = JSON.parse(JSON.stringify(this.list_ProductNamesListFilter));
            console.log('line 53'+JSON.stringify(this.list_ProductNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.blnIsShowProductCombobox=true;
   }
   
   //This code is used to handle the change event on a product dropdown and fetches the corresponding supplier names for the selected product, based on the warehouse and quote status values.
   handleProductChange(event){
    this.strSection='';
   console.log('handle product change');
    //this.IsShowQuoteLineItems=false;
    this.strproductChange=event.detail.value;
    this.list_SupplierNameList=[];
    this.list_SupplierNameFilter = ''
    getSupplierNames({productName:this.strproductChange,WarehouseName : this.strWarehouseChange , QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
        result.forEach(element => { 
            this.list_SupplierNameList.push(element.Account__r.Name);
            this.list_SupplierNameFilter = JSON.parse(JSON.stringify(this.list_SupplierNameList));
            console.log('line 53'+JSON.stringify(this.list_SupplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.blnIsShowButtons=true;
    this.blnIsShowQuoteStatus = true;
    this.blnShowAccordion=true;
   }

   
   HandleCreateButton(event){
    this.blnIsShowModal=true;
   }

   //This method is used to hide a modal box by setting the boolean variable.
   hideModalBox(event){
    this.blnIsShowModal=false;
   }

//This function handles toggling of a section and retrieving quote line items based on selected product, supplier, warehouse, and quote status.
handleSectionToggle(event){
    console.log('section toggle change');
    this.StrQuoteId='';
    this.blnIsShowQuoteLineItems=false;
    this.list_PFQuoteLineItemsList=[];
    this.strSection=String(event.detail.openSections);
    this.openSections = String(event.detail.openSections);
    this.list_openedSupplierList.push(this.strSection);
    const openSections = String(event.detail.openSections);
    console.log('osname'+  openSections);
        console.log('openSections'+  openSections);
        console.log('prod'+ this.strproductChange);
        console.log('ware'+ this.strWarehouseChange);
        PFGetQuoteLineItems({productname: this.strproductChange,suppliername: openSections,warehouse:this.strWarehouseChange,QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
            console.log('line 97'+JSON.stringify(result));
            this.strQuoteIdRedirect='https://absyz-1ab-dev-ed.develop.lightning.force.com/lightning/r/Quote/'+result[0].QuoteId+'/view';
            this.strQuoteIDs=result[0].QuoteId;
            this.strProductId = result[0].Quote.Product__c;
            console.log('pline'+this.strProductId)
            this.strPricebookEntryId=result[0].PricebookEntryId;
           this.StrQuoteId = result[0].Quote.QuoteNumber;
           this.strStorequoteid = result[0].QuoteId;
        let templist=[];
        var newData = JSON.parse(JSON.stringify(result));
        newData.forEach(record => {
            console.log('203'+ record.QuoteId)
            this.list_QuoteIds.push(record.QuoteId);
            let tempRecs = Object.assign({},record);
            if(record.Quote.Status==='Closed'){
                tempRecs.FinalisedValue='Finalised';
                tempRecs.blnDisabled=true;
            }else if(record.Quote.Status==='Open'){
                tempRecs.FinalisedValue='Open';
                tempRecs.blnDisabled=true;
            }else{
                tempRecs.FinalisedValue='Rejected';
                tempRecs.blnDisabled=true;
            }
           templist.push(tempRecs);
           console.log('old :: '+JSON.stringify(templist))
        });
        console.log('new :: '+JSON.stringify(templist))
        this.list_PFQuoteLineItemsList=templist;
        console.log('this.list_PFQuoteLineItemsList',this.list_PFQuoteLineItemsList)
            for(let i=0; i<this.list_PFQuoteLineItemsList.length;i++){
                if(this.list_PFQuoteLineItemsList[i].FinalisedValue ==='Open'){
                    this.list_PFQuoteLineItemsList[this.list_PFQuoteLineItemsList.length - 1].blnDisabled = false;
                }
            }
            this.blnIsShowAfterQLI=true;
          if(this.strQuoteStatusValue==='Closed' || this.strQuoteStatusValue==='Rejected'  ){
            this.blnDisabled= true;
            this.blnIsShowButtons=false;
            this.blnshowFinalisedColumn=true;
        }
        else{
            this.blnDisabled= false;
            this.blnIsShowButtons=true;
            this.blnshowFinalisedColumn=false;
        }
            this.blnIsShowQuoteLineItems=true;
        })
        .catch(error=>{
            console.log('error handleSectionToggle'+JSON.stringify(error));
        })
}

//This function used to handle a refresh event and updates list of quote line items based on the selected product, supplier, warehouse, and quote status values.
HandleRefresh(){
    console.log('refresh event');
    this.list_PFQuoteLineItemsList=[];
    const openSections = String(this.openSections);
    console.log('osname'+  openSections);
        console.log('openSections'+  openSections);
        console.log('prod'+ this.strproductChange);
        console.log('ware'+ this.strWarehouseChange);

        PFGetQuoteLineItems({productname: this.strproductChange,suppliername: openSections,warehouse:this.strWarehouseChange,QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
            console.log('refresh result'+JSON.stringify(result)); 
            let templist=[];
        var newData = JSON.parse(JSON.stringify(result));
        newData.forEach(record => {
            let tempRecs = Object.assign({},record);
            if(record.Quote.Status==='Closed'){
                tempRecs.FinalisedValue='Finalised';
                tempRecs.blnDisabled=true;
            }else if(record.Quote.Status==='Open'){
                tempRecs.FinalisedValue='Open';
                tempRecs.blnDisabled=true;
            }else{
                tempRecs.FinalisedValue='Rejected';
                tempRecs.blnDisabled=true;
            }
           templist.push(tempRecs);
           
        });
        this.list_PFQuoteLineItemsList=templist;
            for(let i=0; i<this.list_PFQuoteLineItemsList.length;i++){
                if(this.list_PFQuoteLineItemsList[i].FinalisedValue ==='Open'){
                    this.list_PFQuoteLineItemsList[this.list_PFQuoteLineItemsList.length - 1].blnDisabled = false;
                }
            }
            this.blnIsShowAfterQLI=true;
        })
        .catch(error=>{
            console.log('error handleSectionToggle'+JSON.stringify(error));
        })
}

//The function is used to handle input changes in a form and update the corresponding properties in the component state.
handleInputChange1(event){
    if(event.target.name ==='Quantity'){
     this.intInputQuantity=event.target.value
    }
    if(event.target.name ==='SalesPrice'){
     this.intInputListPrice=event.target.value
    }
    if(event.target.name ==='finalise'){
    this.blnFinalised=event.target.checked
      this.StrSelect=event.target.dataset.quoteid
      console.log('line 273'+this.StrSelect);
        var notselected = [...this.template.querySelectorAll('lightning-input')].filter(input => input.dataset.quoteid!=`${this.StrSelect}`)
        notselected.forEach(ele=>{ele.checked=false});
        console.log(JSON.parse(JSON.stringify(notselected)));
    }
    if(event.target.name ==='Discount'){
        this.intInputDiscount=event.target.value
    }
    if(event.target.name ==='Line Item Description'){
        this.strInputLineitemdescription=event.target.value
    }
    this.StrPlaceOrderQId= event.target.dataset.quoteid;
    console.log('line 336'+this.StrPlaceOrderQId)
}

//This method is used to create Quote Line Items.
 HandleCreateQLI(event){
     console.log('method called');
     console.log('this.list_PFQuoteLineItemsList',this.list_PFQuoteLineItemsList)
     CreateQuotelineitems({quoteId: this.strQuoteIDs,PEY:this.strPricebookEntryId ,Quantity:this.intInputQuantity,salesPrice:this.intInputListPrice,finalised:this.blnFinalised,discount:this.intInputDiscount,lineIemDescription:this.strInputLineitemdescription}).then(result=>{
         console.log('line 97'+JSON.stringify(result));
         this.blnloading = true;
            console.log('MailSentBro'+this.blnloading);
                const evt = new ShowToastEvent({
                    title: 'created',
                    strMessage: 'Quote Line Items are created ',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.blnloading = false;
                this.HandleRefresh();
     })
     .catch(error=>{
         console.log('error handleSectionToggle'+JSON.stringify(error));
     })
     this.blnIsShowModal=false;
}

//This function is used to provide options for the Quote Status field in a form, where the user can select from a list of predefined values.
 get QuoteStatusOptions() {
    return [
        { label: 'Open', value: 'Open' },
        { label: 'Closed', value: 'Closed' },
        { label: 'Rejected', value: 'Rejected' }
       
    ];
}

//This method is used to handle changes in the selected quote status value and get the corresponding list of supplier names based on the selected quote status, warehouse name, and product name.
handleQuoteChange(event){
    console.log('line 249');
    if(event){
    this.strQuoteStatusValue=event.target.value;
    }
    console.log('line 251'+this.strQuoteStatusValue);
    this.list_SupplierNameList=[];
    this.list_SupplierNameFilter = ''
    getSupplierNames({productName:this.strproductChange,WarehouseName : this.strWarehouseChange , QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
        
        result.forEach(element => {
            this.list_SupplierNameList.push(element.Account__r.Name);
            this.list_SupplierNameFilter = JSON.parse(JSON.stringify(this.list_SupplierNameList));
            console.log('line 53'+JSON.stringify(this.list_SupplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.blnShowAccordion = true;
    if(this.strQuoteStatusValue === 'Rejected'){
        this.blnIsShowButtons=false;
    }
}

//This function is used to handle the Place Order functionality, which updates the Quote Line Item and Quote Status based on the selected checkbox and Quote Id.
HandlePlaceOrder(event){
    console.log('line 330'+this.blnFinalised);
    if(this.blnFinalised==null || this.blnFinalised==false ){
            const evt = new ShowToastEvent({
                title: 'created',
                strMessage: 'please check the checkbox',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
    }
    else{
    this.suppliernae();

    console.log('strselect'+this.StrPlaceOrderQId);
    console.log('411'+this.list_QuoteIds)

    UpdateQuoteLineItemAndQuoteStatus({QId : this.StrPlaceOrderQId,Qlist : this.list_QuoteIds }).then(result=>{
        console.log('line 345')
        this.strQuoteStatusValue='Closed';
         this.handleSectionToggle(event);

    })
    .catch(error=>{
        console.log('Handle place order error'+JSON.stringify(error));
        })
    }
}

//This function is used to call an Apex method to create order records based on selected suppliers, warehouses, and a quote ID.
suppliernae(){
    console.log('line388'+this.supplrlist);
    OrderRecords({supplierNamesList:this.list_openedSupplierList,list_WarehouseNamesList:this.list_warehouslist,quoteId:this.StrPlaceOrderQId}).then(result=>{
        console.log('result',result)
        
        
    }).catch(error=>{
        console.log('Error at creating order rec'+error);
    })
    
}

//This method is used to close a modal or a popup window.
closeModal(event){
    this.blnshowMessage=false
}

//This function is used to preview a file with the given record ID.
previewHandler(event){
    console.log(event.target.dataset.id)
    this.strPdfid=event.target.dataset.id;
    this[NavigationMixin.Navigate]({ 
        type:'standard__namedPage',
        attributes:{ 
            pageName:'filePreview'
        },
        state:{ 
            selectedRecordId: event.target.dataset.id
        }
    })
}

//This method is used to hide a popup or modal that displays a list of documents.
hideDocumentsPopUp(event){
    this.blnIsShowPDFs=false;
}

//This method is used to update the quote status as "Rejected", update the related Quote Line Items, and refresh the supplier details.
handlereject(event){
    RejectedQuoteStatusUpdation({QuoteLineItemsList : this.list_PFQuoteLineItemsList } ).then(data=>{
        console.log('line 466');
        this.getSupplierDetails();
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
    this.list_SupplierNameList=[];
    this.list_SupplierNameFilter = ''
    this.strQuoteStatusValue='Open'
}

//This method retrieves the list of supplier names based on selected product, warehouse and quote status values.
getSupplierDetails(){
    getSupplierNames({productName:this.strproductChange,WarehouseName : this.strWarehouseChange , QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
        console.log('line 483'+JSON.stringify(result));
        result.forEach(element => {
            this.list_SupplierNameList.push(element.Account__r.Name);
            this.list_SupplierNameFilter = JSON.parse(JSON.stringify(this.list_SupplierNameList));
            console.log('line 53'+JSON.stringify(this.list_SupplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
}


//This function is used to retrieve and display related files for a specific Quote record.
handlepdfids(event){
    console.log('line 521')
    this.list_FilesList=[];
    this.strMessage=''
    this.blnshowMessage=false
    this.strPdfrowid = event.target.dataset.qid;
    console.log('pdf id : '+this.strPdfrowid);
    getRelatedFilesByRecordId({QuoteId :  this.strPdfrowid}).then(data=>{
        console.log('result',JSON.stringify(data));
        console.log(data);
        if(JSON.stringify(data)==='{}'){
            console.log('573')
            console.log('type',typeof(data))
            this.strMessage='There are no documents attached yet!'
            this.blnshowMessage=true
            console.log('line 418',this.strMessage);
        }else{
            console.log('583')
            this.list_FilesList = Object.keys(data).map(item=>({"label":data[item],
            "value": item,
            //"url":`/sfc/servlet.shepherd/document/download/${item}`
           }))
           console.log('result if',JSON.stringify(data));
           console.log(this.list_FilesList)
        }
        this.blnIsShowPDFs=true;
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
}

//This function is used to revise a quote by creating a new quote with the same line items and refreshing the page.
handlerevise(event){
    this.strPdfrowid = event.target.dataset.qid;
    CreateQuoteAndQuoteLineItems({QuoteId : this.strPdfrowid}).then(data=>{
        console.log('line 562');
        this.HandleRefresh();
    }).catch(error=>{
        console.log('error lie 562'+ JSON.stringify(error));
    })
}

//This is used to handle the input value for a line item description in an event.
handledescription(event){
    this.strInputLineitemdescription = event.target.value;
}

//This function is used to handle the user input for a sales price and store it in a variable for later use.
handlesalesprice(event){
    this.intInputListPrice=event.target.value;
}

//This function is used to handle changes in the input quantity value and update the corresponding component variable.
handlequantity(event){
    this.intInputQuantity = event.target.value;
}

//This is used to update the discount property with the value entered in the discount input field by the user.
handlediscount(event){
    this.intInputDiscount = event.target.value;
}

//This is used to handle the input value of the delivery date field.
handleDeliveryDate(event){
    this.strInputDeliveryDate = event.target.value;
}

//This function is used to update the values of a specific quote line item and create a new quote line item with updated values.
handleupdate(event){
    this.quotelineid = event.target.dataset.qlid;
    if(this.intInputQuantity===''){
        this.intInputQuantity = event.target.dataset.quantity;
    }
    if(this.intInputListPrice===''){
        this.intInputListPrice = event.target.dataset.salesprice;
    }
    if(this.intInputDiscount===''){
        this.intInputDiscount = event.target.dataset.discount;
    }
    if(this.strInputLineitemdescription===''){
        this.strInputLineitemdescription = event.target.dataset.description;
    }
    if(this.strInputDeliveryDate===''){
        this.strInputDeliveryDate = event.target.dataset.deliverydate;
    }

    CreateQuotelineitems({quoteLineId: this.quotelineid ,Quantity:this.intInputQuantity,salesPrice:this.intInputListPrice,discount:this.intInputDiscount,lineIemDescription:this.strInputLineitemdescription, estimateddeliverydate : this.strInputDeliveryDate}).then(result=>{
        console.log('line 97'+JSON.stringify(result));
        this.intInputQuantity='';
        this.intInputListPrice='';
        this.intInputDiscount='';
        this.strInputLineitemdescription='';
        this.blnloading = true;
           console.log('MailSentBro'+this.blnloading);
               const evt = new ShowToastEvent({
                   title: 'created',
                   strMessage: 'Quote Line Items are created ',
                   variant: 'success',
                   mode: 'dismissable'
               });
               this.dispatchEvent(evt);
               this.blnloading = false;
               this.HandleRefresh();
    })
    .catch(error=>{
        console.log('error line 615'+JSON.stringify(error));
    })
}

//This function is used to navigate to the record page of a Quote with a specific quote ID in a new tab.
Navigatetoquotenumber(event){
    const strquoteid=event.target.dataset.strquoteid;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
            strRecordId: strquoteid,
             objectApiName: 'quote',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

//This code is used to navigate to a quote line record in a new tab based on the quote line ID.
Navigatetoquotelinenumber(event){
    const strquotelineid=event.target.dataset.strquotelineid;
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
            strRecordId: strquotelineid,
             objectApiName: 'QuoteLineItem',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

//This method is used to navigate to the detail page of a specific product.
NavigatetoProduct(event){
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
            strRecordId: this.strProductId,
             objectApiName: 'Product2',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })

}
}