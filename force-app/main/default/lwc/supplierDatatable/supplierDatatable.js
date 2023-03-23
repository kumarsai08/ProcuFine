import { LightningElement, api,track} from 'lwc';
import getwarehousenamerecords from '@salesforce/apex/ExampleController.getwarehousenamerecords';
import getProductNames from '@salesforce/apex/ExampleController.getProductNames';
import getSupplierNames from '@salesforce/apex/ExampleController.getSupplierNames';
import PFGetQuoteLineItems from '@salesforce/apex/GetSuppleirDetails.PFGetQuoteLineItems';
import CreateQuotelineitems from '@salesforce/apex/GetSuppleirDetails.CreateQuotelineitems';
import UpdateQuoteLineItemAndQuoteStatus from '@salesforce/apex/GetSuppleirDetails.UpdateQuoteLineItemAndQuoteStatus';
import OrderRecords from '@salesforce/apex/GetSuppleirDetails.OrderRecords';
import getRelatedFilesByRecordId from '@salesforce/apex/GetSuppleirDetails.getRelatedFilesByRecordId';
import RejectedQuoteStatusUpdation from '@salesforce/apex/GetSuppleirDetails.RejectedQuoteStatusUpdation';
import CreateQuoteAndQuoteLineItems from '@salesforce/apex/GetSuppleirDetails.CreateQuoteAndQuoteLineItems';
import { NavigationMixin } from 'lightning/navigation';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';



import { refreshApex } from '@salesforce/apex';

export default class SupplierDatatable extends NavigationMixin(LightningElement) {
    @api Inventory;
    @api warehouseNamesList=[];
    @api warehouseNameOptions;
    @api warehouseChange;
    @api productNameFilter;
    @api productNamesListFilter=[];
    @api productChange;
    @api supplierNameList=[];
    @api supplierNameFilter;
    @api showAccordion;
    @api isShowModal;
    @api isShowProductCombobox;
    @api prodName;
    @api wareHouseName;
    @api suppName;
    @api IsShowQuoteLineItems;
    @api PFQuoteLineItemsList;
    @api section;
     @api StrQuoteId;
    @api inputQuantity='';
    @api inputListPrice='';
    @api finalised;
    @api openSections
    @api quoteID;
    @api PricebookEntryId;
    @api QuoteIdRedirect;
    @api inputDiscount='';
    @api inputLineitemdescription='';
    @track loading = false;
    @api isShowQuoteStatus;
   @api QuoteStatusValue;
   @api isShowButtons=false ;
   @api showFinalisedColumn = false;
   @api storequoteid;
   @api StrSelect='';
   @api warehouslist=[];
    @api selectedquote;
    @api openedSupplierList=[];
    @api filesList =[];
    @api isShowPDFs=false;
    @api PDFRedirect='';
    @api message;
    @api showMessage=false
    @api isShowAfterQLI=false;
    @api pdfid;
    @api pdfrowid;
    @api StrPlaceOrderQId;
    @api ListQuoteIds=[];
    @api disabled=false;
    @api productId='';
    @api WarehouseId='';
    @api inputDeliveryDate='';
    

    

    connectedCallback(){
        this.QuoteStatusValue='Open';
    getwarehousenamerecords({}).then(result=>{
        
        result.forEach(element => {
            this.warehouseNamesList.push({label:element,value:element});
            this.warehouseNameOptions = JSON.parse(JSON.stringify(this.warehouseNamesList));
            console.log('line 53'+JSON.stringify(this.warehouseNameOptions));
        });
})
.catch(error=>{
    console.log('error'+error);
})


   }

   handleWarehouseChange(event){
    this.section='';
   // this.IsShowQuoteLineItems=false;

    console.log('line 95');
    this.warehouseChange=event.detail.value;
    this.warehouslist.push(event.detail.value);
    this.productNamesListFilter=[];
    getProductNames({wareHouseName:this.warehouseChange}).then(result=>{
        
        result.forEach(element => {
            this.productNamesListFilter.push({label:element.Product__r.Name,value:element.Product__r.Name});
            this.productNameFilter = JSON.parse(JSON.stringify(this.productNamesListFilter));
            console.log('line 53'+JSON.stringify(this.productNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.isShowProductCombobox=true;

   }
   
   handleProductChange(event){
    this.section='';
    
   console.log('handle product change');
    //this.IsShowQuoteLineItems=false;
    this.productChange=event.detail.value;
    this.supplierNameList=[];
    this.supplierNameFilter = ''
    getSupplierNames({productName:this.productChange,WarehouseName : this.warehouseChange , QuoteStatusValue : this.QuoteStatusValue}).then(result=>{
        
        result.forEach(element => {
            this.supplierNameList.push(element.Account__r.Name);
            this.supplierNameFilter = JSON.parse(JSON.stringify(this.supplierNameList));
            console.log('line 53'+JSON.stringify(this.supplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.isShowButtons=true;
    this.isShowQuoteStatus = true;
    this.showAccordion=true;
    

   // this.showAccordion=true;



   }
   HandleCreateButton(event){
    this.isShowModal=true;
   }

   hideModalBox(event){
    this.isShowModal=false;
   }

//    RecordPage(event){
    // const attributesyyyy = event.target.name;
        // this[NavigationMixin.Navigate]({
            // type: 'standard__recordPage',
            // attributes: {
               // recordId: attributesyyyy,
               //objectApiName: 'Contact',
                // actionName: 'view'
            // },
        // });
    // }

handleSectionToggle(event){
    //this.section='';
    console.log('section toggle change');
    this.StrQuoteId='';
    // this.QuoteIdRedirect='';
    this.IsShowQuoteLineItems=false;
   // if(this.showAccordion===true){
     // event.stopPropagation();
    //}
    this.PFQuoteLineItemsList=[];
    this.section=String(event.detail.openSections);
    this.openSections = String(event.detail.openSections);
    this.openedSupplierList.push(this.section);



    const openSections = String(event.detail.openSections);
    console.log('osname'+  openSections);
        console.log('openSections'+  openSections);
        console.log('prod'+ this.productChange);
        console.log('ware'+ this.warehouseChange);
        

        PFGetQuoteLineItems({productname: this.productChange,suppliername: openSections,warehouse:this.warehouseChange,QuoteStatusValue : this.QuoteStatusValue}).then(result=>{
            console.log('line 97'+JSON.stringify(result));
            this.QuoteIdRedirect='https://absyz-1ab-dev-ed.develop.lightning.force.com/lightning/r/Quote/'+result[0].QuoteId+'/view';
            this.quoteID=result[0].QuoteId;

            this.productId = result[0].Quote.Product__c;
            console.log('pline'+this.productId)
            this.PricebookEntryId=result[0].PricebookEntryId;
            //this.quotelineid=  result[0].Id;
           // this.PFQuoteLineItemsList=result;
           this.StrQuoteId = result[0].Quote.QuoteNumber;
           this.storequoteid = result[0].QuoteId;
           //if(this.QuoteStatusValue==='Closed'){
            //this.PFInvList=result;
        
        let templist=[];
       
        var newData = JSON.parse(JSON.stringify(result));

        
        newData.forEach(record => {
            console.log('203'+ record.QuoteId)
            this.ListQuoteIds.push(record.QuoteId);


            let tempRecs = Object.assign({},record);
            if(record.Quote.Status==='Closed'){
                tempRecs.FinalisedValue='Finalised';
            }else{
                tempRecs.FinalisedValue='Rejected';

            }
        
           templist.push(tempRecs);
           console.log('old :: '+JSON.stringify(templist))
           


        });
        //templist.shift();
        console.log('new :: '+JSON.stringify(templist))
        this.PFQuoteLineItemsList=templist;
        //this.isShowAfterQLI=false;

        //if(this.PFQuoteLineItemsList.length>1){
            this.isShowAfterQLI=true;
        //}

         

       
        //this.PFInvList=templist;
        
        
    
          // }else{
           // this.PFQuoteLineItemsList=result;
          // }
          if(this.QuoteStatusValue==='Closed' || this.QuoteStatusValue==='Rejected'  ){
            this.disabled= true;
            this.isShowButtons=false;
            this.showFinalisedColumn=true;

        }
        else{
            this.disabled= false;

            this.isShowButtons=true;
           this.showFinalisedColumn=false;
        }
            this.IsShowQuoteLineItems=true;
           
        })
        .catch(error=>{
            console.log('error handleSectionToggle'+JSON.stringify(error));
        })
        

}


HandleRefresh(){
    console.log('refresh event');
    //this.StrQuoteId='';
    //if(this.showAccordion===true){
     //   event.stopPropagation();
   // }
    this.PFQuoteLineItemsList=[];
    //this.section=String(event.detail.openSections);

    const openSections = String(this.openSections);
    console.log('osname'+  openSections);
        console.log('openSections'+  openSections);
        console.log('prod'+ this.productChange);
        console.log('ware'+ this.warehouseChange);

        PFGetQuoteLineItems({productname: this.productChange,suppliername: openSections,warehouse:this.warehouseChange,QuoteStatusValue : this.QuoteStatusValue}).then(result=>{
            console.log('refresh result'+JSON.stringify(result)); 

            
           // this.quoteID=result[0].QuoteId;
           /* console.log('160'+this.quoteID);
           this.StrQuoteId = result[0].Quote.QuoteNumber;
           console.log('157'+JSON.stringify(this.StrQuoteId));

           
            this.PricebookEntryId=result[0].PricebookEntryId;
            
            
            console.log('164'+this.PricebookEntryId);*/
            //this.IsShowQuoteLineItems=false;
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
        //templist.shift();
        this.PFQuoteLineItemsList=templist;

           // this.PFQuoteLineItemsList=result;
           // this.PFQuoteLineItemsList=result;
            //this.IsShowQuoteLineItems=true;
           
        })
        .catch(error=>{
            console.log('error handleSectionToggle'+JSON.stringify(error));
        })

}
handleInputChange1(event){
   
    if(event.target.name ==='Quantity'){
     this.inputQuantity=event.target.value
    }
    if(event.target.name ==='SalesPrice'){
     this.inputListPrice=event.target.value
    }
    if(event.target.name ==='finalise'){
    this.finalised=event.target.value
      this.StrSelect=event.target.dataset.quoteid
      console.log('line 273'+this.StrSelect);
        var notselected = [...this.template.querySelectorAll('lightning-input')].filter(input => input.dataset.quoteid!=`${this.StrSelect}`)
        notselected.forEach(ele=>{ele.checked=false});
        console.log(JSON.parse(JSON.stringify(notselected)));
    }
    if(event.target.name ==='Discount'){
        this.inputDiscount=event.target.value
    }
    if(event.target.name ==='Line Item Description'){
        this.inputLineitemdescription=event.target.value
    }
    this.StrPlaceOrderQId= event.target.dataset.quoteid;
    console.log('line 336'+this.StrPlaceOrderQId)
}

 HandleCreateQLI(event){
     console.log('method called');
     console.log('this.PFQuoteLineItemsList',this.PFQuoteLineItemsList)
     CreateQuotelineitems({quoteId: this.quoteID,PEY:this.PricebookEntryId ,Quantity:this.inputQuantity,salesPrice:this.inputListPrice,finalised:this.finalised,discount:this.inputDiscount,lineIemDescription:this.inputLineitemdescription}).then(result=>{
         console.log('line 97'+JSON.stringify(result));
         this.loading = true;
            console.log('MailSentBro'+this.loading);
                const evt = new ShowToastEvent({
                    title: 'created',
                    message: 'Quote Line Items are created ',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.loading = false;

                this.HandleRefresh();
         
     })
     .catch(error=>{
         console.log('error handleSectionToggle'+JSON.stringify(error));
     })

     this.isShowModal=false;
     
     //this.isShowAfterQLI=true;
 }


 get QuoteStatusOptions() {
    return [
        { label: 'Open', value: 'Open' },
        { label: 'Closed', value: 'Closed' },
        { label: 'Rejected', value: 'Rejected' }
       
    ];
}

handleQuoteChange(event){
    console.log('line 249');
    if(event){
    this.QuoteStatusValue=event.target.value;
    }
    
    console.log('line 251'+this.QuoteStatusValue);
    this.supplierNameList=[];
    this.supplierNameFilter = ''
    getSupplierNames({productName:this.productChange,WarehouseName : this.warehouseChange , QuoteStatusValue : this.QuoteStatusValue}).then(result=>{
        
        result.forEach(element => {
            this.supplierNameList.push(element.Account__r.Name);
            this.supplierNameFilter = JSON.parse(JSON.stringify(this.supplierNameList));
            console.log('line 53'+JSON.stringify(this.supplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
    this.showAccordion = true;
    if(this.QuoteStatusValue === 'Rejected'){
        this.isShowButtons=false;
    }
   

}


HandlePlaceOrder(event){
    this.suppliernae();

    console.log('strselect'+this.StrPlaceOrderQId);
    console.log('411'+this.ListQuoteIds)

    UpdateQuoteLineItemAndQuoteStatus({QId : this.StrPlaceOrderQId,Qlist : this.ListQuoteIds }).then(result=>{
        console.log('line 345')
        this.QuoteStatusValue='Closed';
         this.handleSectionToggle(event);

    })
    .catch(error=>{
        console.log('Handle place order error'+JSON.stringify(error));
        })
}

suppliernae(){
    console.log('line388'+this.supplrlist);
    OrderRecords({supplierNamesList:this.openedSupplierList,WarehouseNamesList:this.warehouslist,quoteId:this.StrPlaceOrderQId}).then(result=>{
        console.log('result',result)
        
        
    }).catch(error=>{
        console.log('Error at creating order rec'+error);
    })
    
}


handleViewDocuments(event){
    getRelatedFilesByRecordId({QuoteId : this.storequoteid}).then(data=>{
        console.log('result',JSON.stringify(data));
        console.log(data);
        if(JSON.stringify(data)==='{}'){

            console.log('type',typeof(data))
            this.message='There are no pdfs'
            this.showMessage=true
            this.filesList={};

            console.log('line 418',this.message);
       
        }else{
            
            
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
            "value": item,
            "url":`/sfc/servlet.shepherd/document/download/${item}`
           }))
           console.log('result if',JSON.stringify(data));
           console.log(this.filesList)
        }
            
        
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
    this.isShowPDFs=true;


    

}
closeModal(event){
    this.showMessage=false
}


previewHandler(event){
    console.log(event.target.dataset.id)
    this.pdfid=event.target.dataset.id;
    /*this[NavigationMixin.Navigate]({ 
        type:'standard__namedPage',
        attributes:{ 
            pageName:'filePreview'
        },
        state:{ 
            selectedRecordId: event.target.dataset.id
        }
    })*/
    this.PDFRedirect='https://absyz-1ab-dev-ed.develop.file.force.com/servlet/servlet.FileDownload?file='+ event.target.dataset.id+'&operationContext=S1';



   
}
hideDocumentsPopUp(event){
    this.isShowPDFs=false;

}
handlereject(event){
    RejectedQuoteStatusUpdation({QuoteLineItemsList : this.PFQuoteLineItemsList } ).then(data=>{
        console.log('line 466');
        this.getSupplierDetails();
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
    this.supplierNameList=[];
    this.supplierNameFilter = ''
    this.QuoteStatusValue='Open'
    

  

}

getSupplierDetails(){
    getSupplierNames({productName:this.productChange,WarehouseName : this.warehouseChange , QuoteStatusValue : this.QuoteStatusValue}).then(result=>{
        console.log('line 483'+JSON.stringify(result));
        result.forEach(element => {
            this.supplierNameList.push(element.Account__r.Name);
            this.supplierNameFilter = JSON.parse(JSON.stringify(this.supplierNameList));
            console.log('line 53'+JSON.stringify(this.supplierNameFilter));
        });
    })
    .catch(error=>{
    console.log('error'+error);
    })
}



handlepdfids(event){
    console.log('line 521')
    this.filesList=[];
    this.pdfrowid = event.target.dataset.qid;
    console.log('pdf id : '+this.pdfrowid);

    getRelatedFilesByRecordId({QuoteId :  this.pdfrowid}).then(data=>{
        console.log('result',JSON.stringify(data));
        console.log(data);
        if(JSON.stringify(data)==='{}'){

            console.log('type',typeof(data))
            this.message='There are no pdfs'
            this.showMessage=true
            //this.filesList={};

            console.log('line 418',this.message);
       
        }else{
            
            
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
            "value": item,
            "url":`/sfc/servlet.shepherd/document/download/${item}`
           }))
           console.log('result if',JSON.stringify(data));
           console.log(this.filesList)
        }
            
        
    }).catch(error=>{
        console.log('Error at Handle view documents'+error);
    })
    this.isShowPDFs=true;

}


handlerevise(event){
    this.pdfrowid = event.target.dataset.qid;

    CreateQuoteAndQuoteLineItems({QuoteId : this.pdfrowid}).then(data=>{
        console.log('line 562');
        this.HandleRefresh();
        
            
        
    }).catch(error=>{
        console.log('error lie 562'+ JSON.stringify(error));
    })


}

handledescription(event){
    this.inputLineitemdescription = event.target.value;
    
}

handlesalesprice(event){
    this.inputListPrice=event.target.value;
}

handlequantity(event){
    this.inputQuantity = event.target.value;

}

handlediscount(event){
    this.inputDiscount = event.target.value;
}
handleDeliveryDate(event){
    this.inputDeliveryDate = event.target.value;
}


handleupdate(event){

    this.quotelineid = event.target.dataset.qlid;
    if(this.inputQuantity===''){
        this.inputQuantity = event.target.dataset.quantity;

    }
    if(this.inputListPrice===''){
        this.inputListPrice = event.target.dataset.salesprice;

    }
    if(this.inputDiscount===''){
        this.inputDiscount = event.target.dataset.discount;

    }
    if(this.inputLineitemdescription===''){
        this.inputLineitemdescription = event.target.dataset.description;

    }
    if(this.inputDeliveryDate===''){
        this.inputDeliveryDate = event.target.dataset.deliverydate;

    }


    
    CreateQuotelineitems({quoteLineId: this.quotelineid ,Quantity:this.inputQuantity,salesPrice:this.inputListPrice,discount:this.inputDiscount,lineIemDescription:this.inputLineitemdescription, estimateddeliverydate : this.inputDeliveryDate}).then(result=>{
        console.log('line 97'+JSON.stringify(result));
        this.inputQuantity='';
        this.inputListPrice='';
        this.inputDiscount='';
        this.inputLineitemdescription='';

        this.loading = true;
           console.log('MailSentBro'+this.loading);
               const evt = new ShowToastEvent({
                   title: 'created',
                   message: 'Quote Line Items are created ',
                   variant: 'success',
                   mode: 'dismissable'
               });
               this.dispatchEvent(evt);
               this.loading = false;

               this.HandleRefresh();
        
    })
    .catch(error=>{
        console.log('error line 615'+JSON.stringify(error));
    })

}

Navigatetoquotenumber(event){
    const strquoteid=event.target.dataset.strquoteid;
    // alert('checj'+strquoteid)
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: strquoteid,
             objectApiName: 'quote',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}


Navigatetoquotelinenumber(event){
    const strquotelineid=event.target.dataset.strquotelineid;
     // Navigate to a URL
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


// NavigatetoProduct(event){
//     const strquoteid=event.target.dataset.strquoteid;
//     // alert('checj'+strquoteid)
//      // Navigate to a URL
//      this[NavigationMixin.GenerateUrl]({
//          type: 'standard__recordPage',
//          attributes:{
//              recordId: strquoteid,
//              objectApiName: 'quote',
//              actionName:'view'
//          }
//      }).then(url =>{
//          window.open(url, "_blank");
//      })
// }

NavigatetoProduct(event){
   //const productId=event.target.dataset.productnav;
    // alert('checj'+strquoteid)
     // Navigate to a URL
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



        

}