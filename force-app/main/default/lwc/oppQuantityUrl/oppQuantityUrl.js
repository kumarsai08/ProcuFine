import { LightningElement,track,api } from 'lwc';
import opprecords from '@salesforce/apex/GetSuppleirDetails.opprecords';
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
            label: 'Order Number',
            fieldName: 'Onumber',
            type: 'Text',
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
    /*connectedCallback(){
        opprecords({productname : this.productnamevalueselected })
        .then(result=>{
            
            this.OppquantityList=result;

            
            let templist=[];
           
            var newData = JSON.parse(JSON.stringify(result));
    
            
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               
              // tempRecs.NameUrl = '/'+tempRecs.Product__c;
               //tempRecs.ProdName = record.Product__r.Name;
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
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        })
    }*/

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
               
              // tempRecs.NameUrl = '/'+tempRecs.Product__c;
               //tempRecs.ProdName = record.Product__r.Name;
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
            //return this.OppquantityList;
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        });
    }
    closeTab(event){
        console.log('Closed:'+JSON.stringify(this.tabname));
        // this.OppquantityList.pop(this.tabName);
        const selectedEvent =new CustomEvent('removetab', {detail:{tabtitle : this.tabname }});
        this.dispatchEvent(selectedEvent);
        
    }
}