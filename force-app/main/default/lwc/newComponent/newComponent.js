import { LightningElement,api,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import GetQuoteDetails from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetails';
import OrderRecords from '@salesforce/apex/GetSuppleirDetails.OrderRecords';
import sendemailtosuppliers from '@salesforce/apex/GetSuppleirDetails.sendemailtosuppliers';
import GetQuoteDetailsdummy from '@salesforce/apex/GetSuppleirDetails.GetQuoteDetailsdummy';
//import {LightningElement} from 'lwc';
import {loadScript} from "lightning/platformResourceLoader";
import JSPDF from '@salesforce/resourceUrl/jspdf';
import getContacts from '@salesforce/apex/PdfGenerator.getContactsController';


export default class newComponent extends LightningElement {
    @api OrdersListDispatch=[];
    @api selectedsuppliersap;
    @api SupplierLIST=[];
    @api selectedOrders=[];
    //supplier names list
    @api sendmailtoselected=[];
    @api WarehouseNames=[];
    @api mapsupplierandwarehouse={};
    @api product;
    contactList = [];
	headers = this.createHeaders([
		"Id",
		"Supplier__c",
		"warehouse__c"
	]);

	renderedCallback() {
		Promise.all([
			loadScript(this, JSPDF)
		]);
	}

	generatePdf(){
		const { jsPDF } = window.jspdf;
		const doc = new jsPDF({
			encryption: {
				userPassword: "user",
				ownerPassword: "owner",
				userPermissions: ["print", "modify", "copy", "annot-forms"]
				// try changing the user permissions granted
			}
		});

		doc.text("Bro take your products bruhh", 20, 20);
		doc.table(30, 30, this.contactList, this.headers, { autosize:true });
        console.log('line 49' + Json.stringify(doc));
		//doc.save("demo.pdf");
	}

	

	createHeaders(keys) {
		var result = [];
		for (var i = 0; i < keys.length; i += 1) {
			result.push({
				id: keys[i],
				name: keys[i],
				prompt: keys[i],
				width: 65,
				align: "center",
				padding: 0
			});
		}
		return result;
	}

    @track columns = [
    
        {
            label: 'Supplier Name',
            fieldName: 'Supplier__c',
            type: 'text',
            //typeAttributes: {label: { fieldName: 'ProdName' }, target: '_blank'},
            sortable: true
        },
        {
            label: 'Location',
            fieldName: 'warehouse__c',
            type: 'text',
            sortable: true
        },
        
        {
            label: 'Quote Id',
            fieldName: 'QuoteName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Open Quote',
            fieldName: 'openQuote',
            type: 'url',
            typeAttributes: {label: { fieldName: 'view' }, target: '_blank'},
            sortable: true
        }];
        connectedCallback(){
            GetQuoteDetails({})
            .then(result=>{
                
                
                console.log('line40')
                let templist=[];
               
                var newData = JSON.parse(JSON.stringify(result));
                console.log('line 44'+JSON.stringify(newData));
        
                
                newData.forEach(record => {
                   let tempRecs = Object.assign({},record);
                   
                   //tempRecs.SupplierName = record.supplier__c;
                   //tempRecs.locationName = record.warehouse__c;
                   tempRecs.QuoteName= record.Name;
                   tempRecs.openQuote='/'+record.Id;
                   tempRecs.view='view';
                   tempRecs.Productname = record.Product__c;
                   //tempRecs.oppName=record.Opportunity.Name;
                    //if(record.Warehouse__r.Name)tempRecs.WarehouseName=record.Warehouse__r.Name;
                   
                   templist.push(tempRecs);
                });
                this.SupplierLIST=templist;
                console.log('line 61')
                
                
            })
            .catch(error=>{
                console.log('error'+error);
            })
        }

        handlePlaceOrder(){
            
                getContacts().then(result=>{
                    this.contactList = result;
                   // this.generatePdf();
                });
            
            //selected rows to send orders
            this.selectedOrders=this.template.querySelector('lightning-datatable').getSelectedRows();
            this.sendmailtoselected=[];
            console.log('line 81'+ typeof this.selectedOrders);
           // console.log('line 75'+ JSON.stringify(this.selectedOrders));
            console.log("getSelectedRows => ", 
            JSON.stringify(this.template.querySelector('lightning-datatable').getSelectedRows()));
            this.selectedOrders.forEach(element => {
                console.log(element.Supplier__c);
                console.log(typeof element.Supplier__c);
                this.sendmailtoselected.push(element.Supplier__c);

                this.WarehouseNames.push(element.warehouse__c);
                //console.log('line 82'+ this.sendmailtoselected);
                //this.product=element.Opportunity.Name;
                //console.log('product'+this.product);

                
                
            });
            console.log('line 99');
            console.log('line 100'+ this.sendmailtoselected+ '2-'+ this.WarehouseNames+'3-'+this.selectedOrders);
            OrderRecords({supplierNamesList: this.sendmailtoselected, WarehouseNamesList: this.WarehouseNames,SelectedQuoteRows: this.selectedOrders});
            sendemailtosuppliers({suppliernames : this.sendmailtoselected});
            
            const evt = new ShowToastEvent({
                title: 'ORDERS SENT !!!',
                message: 'The Order Has been sent to the supplier',
                variant: 'success'
            });
            this.dispatchEvent(evt);

            
        }

        
        
}