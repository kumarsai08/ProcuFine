import { LightningElement, api,track} from 'lwc';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import getSupplierNames from '@salesforce/apex/pf_Opportunitysummary.getSupplierNames';
import PFGetQuoteLineItems from '@salesforce/apex/pf_Opportunitysummary.PFGetQuoteLineItems';
import CreateQuotelineitems from '@salesforce/apex/pf_Opportunitysummary.CreateQuotelineitems';
import UpdateQuoteLineItemAndQuoteStatus from '@salesforce/apex/pf_Opportunitysummary.UpdateQuoteLineItemAndQuoteStatus';
import OrderRecords from '@salesforce/apex/pf_Opportunitysummary.OrderRecords';
import getRelatedFilesByRecordId from '@salesforce/apex/pf_Opportunitysummary.getRelatedFilesByRecordId';
import RejectedQuoteStatusUpdation from '@salesforce/apex/pf_Opportunitysummary.RejectedQuoteStatusUpdation';
import CreateQuoteAndQuoteLineItems from '@salesforce/apex/pf_Opportunitysummary.CreateQuoteAndQuoteLineItems';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SupplierDatatable extends NavigationMixin (LightningElement) {
    @api list_ProductNameFilter;
    @api list_ProductNamesList=[];
    @api strProductChange;
    @api list_SupplierNameList=[];
    @api list_SupplierNameFilter;
    @api blnShowAccordion;
    @api blnIsShowModal;
    @api blnIsShowQuoteLineItems;
    @api list_PFQuoteLineItems;
    @api strSection;
    @api StrQuoteId;
    @api intInputQuantity;
    @api intInputListPrice;
    @api strFinalised;
    @api strOpenSections
    @api strquoteID;
    @api strPricebookEntryId;
    @api strQuoteIdRedirect;
    @api intInputDiscount;
    @api strInputLineitemdescription;
    @track blnLoading = false;
    @api blnIsShowQuoteStatus;
    @api QuoteStatusValue;
    @api blnIsShowButtons=false ;
    @api blnShowFinalisedColumn = false;
    @api strStoreQuoteId;
    @api StrSelect='';
    @api list_OpenedSupplier=[];
    @api blnIsShowPDFs=false;
    @api blnShowMessage=false;
    @api list_Files=[];
    @api PDFRedirect='';
    @api strPdfid;
    @api strPdfRowId;
    @api StrPlaceOrderQId;
    @api list_QuoteIds=[];

    //In this connectedCallback function a value is assigned to a variable and a Apex method is called to populate a list of product names.
    connectedCallback(){
        this.strQuoteStatusValue='Open';
        getproductnamerecords({}).then(result=>{   
            result.forEach(element => {
                this.list_ProductNamesList.push({label:element,value:element});
                this.list_ProductNameFilter = JSON.parse(JSON.stringify(this.list_ProductNamesList));
                console.log('line 53'+JSON.stringify(this.list_ProductNameFilter));
            });
    })
    .catch(error=>{
        console.log('error'+error);
    })

   }

   //This code is used to handle the change event on a product dropdown and fetches the corresponding supplier names for the selected product, based on the quote status values.
   handleProductChange(event){
    this.strSection='';
   console.log('handle product change');
    this.strProductChange=event.detail.value;
   this.list_SupplierNameList=[];
    this.list_SupplierNameFilter = ''
    getSupplierNames({productName:this.strProductChange, QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
        result.forEach(element => {
            this.list_SupplierNameList.push(element.Supplier_Name__r.Name);
            this.list_SupplierNameFilter = JSON.parse(JSON.stringify(this.list_SupplierNameList));
            console.log('linee 53'+JSON.stringify(this.list_SupplierNameFilter));
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

   hideModalBox(event){
    this.blnIsShowModal=false;
   }

//This function handles toggling of a section and retrieving quote line items based on selected product, supplier and quote status.
handleSectionToggle(event){
    console.log('section toggle change');
    this.StrQuoteId='';
    this.blnIsShowQuoteLineItems=false;
    this.list_PFQuoteLineItems=[];
    this.strSection=String(event.detail.openSections);
    this.strOpenSections = String(event.detail.openSections);
    this.list_OpenedSupplier.push(this.strSection);
    const openSections = String(event.detail.openSections);
    console.log('osname'+  openSections);
    console.log('openSections'+  openSections);
    console.log('prod'+ this.strProductChange);

        PFGetQuoteLineItems({productname: this.strProductChange,suppliername: openSections,QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
            console.log('line 97'+JSON.stringify(result));
            this.strQuoteIdRedirect='https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Quote/'+result[0].QuoteId+'/view';
            this.strquoteID=result[0].QuoteId;
            this.productId = result[0].Quote.PF_Product__c;
            console.log('pline'+this.productId)
            this.strPricebookEntryId=result[0].PricebookEntryId;
           this.StrQuoteId = result[0].Quote.QuoteNumber;
           this.strStoreQuoteId = result[0].QuoteId;
        let templist=[];
        var newData = JSON.parse(JSON.stringify(result));
        newData.forEach(record => {
            console.log('203'+ record.QuoteId)
            this.list_QuoteIds.push(record.QuoteId);
            let tempRecs = Object.assign({},record);
            if(record.Quote.Status==='Closed'){
                tempRecs.FinalisedValue='Finalised';
                tempRecs.disabled=true;
            }else if(record.Quote.Status==='Open'){
                tempRecs.FinalisedValue='Open'
                tempRecs.disabled=true;
            }
            else{
                tempRecs.FinalisedValue='Rejected';
                tempRecs.disabled=true;
            }
       
           templist.push(tempRecs);
           console.log('old :: '+JSON.stringify(templist))
        });
        console.log('new :: '+JSON.stringify(templist))
        this.list_PFQuoteLineItems=templist;
        console.log('this.list_PFQuoteLineItems',this.list_PFQuoteLineItems)
            for(let i=0; i<this.list_PFQuoteLineItems.length;i++){
                if(this.list_PFQuoteLineItems[i].FinalisedValue ==='Open'){
                    this.list_PFQuoteLineItems[this.list_PFQuoteLineItems.length - 1].disabled = false;
                }
            }
            this.isShowAfterQLI=true;
          if(this.strQuoteStatusValue==='Closed' || this.strQuoteStatusValue==='Rejected'){
            this.disabled= true;
            this.blnIsShowButtons=false;
            this.blnShowFinalisedColumn=true;
        }
        else{
            this.disabled= false;
            this.blnIsShowButtons=true;
           this.blnShowFinalisedColumn=false;
        }
            this.blnIsShowQuoteLineItems=true;
           
        })
        .catch(error=>{
            console.log('error handleSectionToggle'+JSON.stringify(error));
        })
}

//This function used to handle a refresh event and updates list of quote line items based on the selected product, supplier and quote status values.
HandleRefresh(event){
    console.log('refresh event');
    this.list_PFQuoteLineItems=[];
    const openSections = String(this.strOpenSections);
    console.log('osname'+  openSections);
        console.log('openSections'+  openSections);
        console.log('prod'+ this.strProductChange);
        PFGetQuoteLineItems({productname: this.strProductChange,suppliername: openSections,QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
            console.log('refresh result'+JSON.stringify(result));
            let templist=[];
        var newData = JSON.parse(JSON.stringify(result));     
        newData.forEach(record => {
            let tempRecs = Object.assign({},record);
            if(record.Quote.Status==='Closed'){
                tempRecs.FinalisedValue='Finalised';
            }else{
                tempRecs.FinalisedValue='---';
            }
           templist.push(tempRecs);
        });
        this.list_PFQuoteLineItems=templist;
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
    this.strFinalised=event.target.value
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
     console.log('this.list_PFQuoteLineItems',this.list_PFQuoteLineItems)
     CreateQuotelineitems({quoteId: this.strquoteID,PEY:this.strPricebookEntryId ,Quantity:this.intInputQuantity,salesPrice:this.intInputListPrice,finalised:this.strFinalised,discount:this.intInputDiscount,lineIemDescription:this.strInputLineitemdescription}).then(result=>{
         console.log('line 97'+JSON.stringify(result));
         this.blnLoading = true;
            console.log('MailSentBro'+this.blnLoading);
                const evt = new ShowToastEvent({
                    title: 'created',
                    message: 'Quote Line Items are created ',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.blnLoading = false;
                this.HandleRefresh();
     })
     .catch(error=>{
         console.log('error handleSectionToggle'+JSON.stringify(error));
     })
     this.blnIsShowModal=false;
 }

 get QuoteStatusOptions() {
    return [
        { label: 'Open', value: 'Open' },
        { label: 'Closed', value: 'Closed' },
        { label: 'Rejected', value: 'Rejected' }
    ];
}

//This method is used to handle changes in the selected quote status value and get the corresponding list of supplier names based on the selected quote status and product name.
handleQuoteChange(event){
    console.log('line 249');
    if(event){
    this.strQuoteStatusValue=event.target.value;
    }
    console.log('line 251'+this.strQuoteStatusValue);
    this.list_SupplierNameList=[];
    this.list_SupplierNameFilter = ''
    getSupplierNames({productName:this.strProductChange,QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{  
        result.forEach(element => {
            this.list_SupplierNameList.push(element.Supplier_Name__r.Name);
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
    this.suppliernae();
    console.log('strselect'+this.StrPlaceOrderQId);
    console.log('328'+this.list_QuoteIds);
    UpdateQuoteLineItemAndQuoteStatus({QId : this.StrPlaceOrderQId, Qlist:this.list_QuoteIds}).then(result=>{
        console.log('line 345')
        this.strQuoteStatusValue='Closed';
        this.handleSectionToggle(event);
    })
    .catch(error=>{
        console.log('Handle place order error'+JSON.stringify(error));
        })
        
    }

//This function is used to call an Apex method to create order records based on selected suppliers and quote ID.
suppliernae(){
       console.log('line388'+this.supplrlist);
       OrderRecords({supplierNamesList:this.list_OpenedSupplier,quoteId:this.StrPlaceOrderQId}).then(result=>{
           console.log('result',result)
        }).catch(error=>{
           console.log('Error at creating order rec'+error);
           })
     }

//This method is used to close a modal or a popup window.
    closeModal(event){
        this.blnShowMessage=false
    }

//This function is used to preview a file with the given record ID.
    previewHandler(event){
        console.log(event.target.dataset.id)
        this.strPdfid=event.target.dataset.id;
        this.strPDFRedirect='https://absyz-2d8-dev-ed.develop.file.force.com/servlet/servlet.FileDownload?file='+ event.target.dataset.id+'&operationContext=S1';
    }
//This method is used to hide a popup or modal that displays a list of documents.
    hideDocumentsPopUp(event){
        this.blnIsShowPDFs=false;
    }

//This method is used to update the quote status as "Rejected", update the related Quote Line Items, and refresh the supplier details.
    handlereject(event){
        RejectedQuoteStatusUpdation({QuoteLineItemsList : this.list_PFQuoteLineItems} ).then(data=>{
            console.log('line 466');
            this.getSupplierDetails();
        }).catch(error=>{
            console.log('Error at Handle view documents'+error);
        })
        this.list_SupplierNameList=[];
        this.list_SupplierNameFilter = ''
        this.strQuoteStatusValue='Open'
    }
    
//This method retrieves the list of supplier names based on selected product and quote status values.
    getSupplierDetails(){
        getSupplierNames({productName:this.strProductChange, QuoteStatusValue : this.strQuoteStatusValue}).then(result=>{
            console.log('line 483'+JSON.stringify(result));
            result.forEach(element => {
                this.list_SupplierNameList.push(element.Supplier_Name__r.Name);
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
    this.list_Files=[];
    this.strPdfRowId = event.target.dataset.qid;
    console.log('pdf id : '+this.strPdfRowId);

    getRelatedFilesByRecordId({QuoteId :  this.strPdfRowId}).then(data=>{
        console.log('result',JSON.stringify(data));
        console.log(data);
        if(JSON.stringify(data)==='{}'){
            console.log('type',typeof(data))
            this.message='There are no pdfs'
            this.blnShowMessage=true
            console.log('line 418',this.message);
        }else{
            this.list_Files = Object.keys(data).map(item=>({"label":data[item],
            "value": item,
            "url":`/sfc/servlet.shepherd/document/download/${item}`
           }))
           console.log('result if',JSON.stringify(data));
           console.log(this.list_Files)
        }
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
    this.blnIsShowPDFs=true;
}

//This function is used to revise a quote by creating a new quote with the same line items and refreshing the page.
handlerevise(event){
    this.strPdfRowId = event.target.dataset.qid;
    CreateQuoteAndQuoteLineItems({QuoteId : this.strPdfRowId}).then(data=>{
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
    this.inputDeliveryDate = event.target.value;
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
    if(this.inputDeliveryDate===''){
        this.inputDeliveryDate = event.target.dataset.deliverydate;

    }

    CreateQuotelineitems({quoteLineId: this.quotelineid ,Quantity:this.intInputQuantity,salesPrice:this.intInputListPrice,discount:this.intInputDiscount,lineIemDescription:this.strInputLineitemdescription}).then(result=>{
        console.log('line 97'+JSON.stringify(result));
        this.intInputQuantity='';
        this.intInputListPrice='';
        this.intInputDiscount='';
        this.strInputLineitemdescription='';
        this.blnLoading = true;
           console.log('MailSentBro'+this.blnLoading);
               const evt = new ShowToastEvent({
                   title: 'created',
                   message: 'Quote Line Items are created ',
                   variant: 'success',
                   mode: 'dismissable'
               });
               this.dispatchEvent(evt);
               this.blnLoading = false;
               this.HandleRefresh();
    })
    .catch(error=>{
        console.log('error line 615'+JSON.stringify(error));
    })

}

//This function is used to navigate to the record page of a Quote with a specific quote ID in a new tab.
navigateToQuote(event){
    const QuoteRecordPage=event.target.dataset.quotenavigation;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: QuoteRecordPage,
             objectApiName: 'Quote',
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
              recordId: this.productId,
              objectApiName: 'Product2',
              actionName:'view'
          }
      }).then(url =>{
          window.open(url, "_blank");
      })
}

//This code is used to navigate to a quote line record in a new tab based on the quote line ID.
Navigatetoquotelinenumber(event){
    const strquotelineid=event.target.dataset.strquotelineid;
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: strquotelineid,
             objectApiName: 'QuoteLineItem',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}
}