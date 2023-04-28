import { LightningElement,track,api } from 'lwc';
import opprecords from '@salesforce/apex/PF_GetSuppleirDetails.opprecords';
export default class OppQuantityUrl extends LightningElement {
    productnamevalueselected;
    @api listopportunities;
    blnIsRendered = false;
    @api tabname;
    @track columns = [
        {
            label: 'Opportunity Name',
            fieldName: 'OppnameUrl',
            type: 'url',
            typeAttributes: {label: { fieldName: 'opporName'}, target: '_blank'},
            sortable: true
        },
        {
            label: 'Close Date',
            fieldName: 'Cdate',
            type: 'Date',
            sortable: true
        },
        {
            label: 'Quantity',
            fieldName: 'Quantity',
            type: 'Number',
            sortable: true
        },
        {
            label: 'Stage',
            fieldName: 'Sname',
            type: 'text',
            sortable: true
        }
    ];
    
    @track OppquantityList ;

    //This method is used to retrieve opportunity records related to a specified product name and adds additional fields before updating the component's data.
    @api getOpportunities(strProductName) {
        this.productnamevalueselected = strProductName;
        console.log('product name :: '+this.productnamevalueselected);
        opprecords({productname : this.productnamevalueselected })
        .then(result=>{
            this.OppquantityList=result;
            let templist=[];
            var newData = JSON.parse(JSON.stringify(result));
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               console.log('line 67'+ JSON.stringify(record));
               tempRecs.OppnameUrl= '/'+record.OpportunityId;
               console.log('OppName:'+record.Opportunity.Name);
               if(record.Opportunity.Name){tempRecs.opporName=record.Opportunity.Name};
               console.log('line 63'+ JSON.stringify(tempRecs));
               tempRecs.Cdate=record.Opportunity.CloseDate;
               tempRecs.quantityvalue=record.Opportunity.TotalOpportunityQuantity;
               if(record.Opportunity.OrderNumber__c){tempRecs.Onumber=record.Opportunity.OrderNumber__c};
               if(record.Opportunity.StageName){tempRecs.Sname=record.Opportunity.StageName};
               console.log('line 68'+ JSON.stringify(tempRecs));
               templist.push(tempRecs);
            });
            this.OppquantityList=templist;
            console.log('this.OppquantityList1'+JSON.stringify(this.OppquantityList));
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        });
    }

    //This function is used to dispatch a custom event 'removetab' to indicate that the tab needs to be closed.
    closeTab(event){
        console.log('Closed:'+JSON.stringify(this.tabname));
        const selectedEvent =new CustomEvent('removetab', {detail:{tabtitle : this.tabname }});
        this.dispatchEvent(selectedEvent);
        
    }
}