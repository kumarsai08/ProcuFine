import { LightningElement,track,api } from 'lwc';
import Assetvalues from '@salesforce/apex/PF_GetSuppleirDetails.Assetvalues';

export default class ChildAssetUrl extends LightningElement {

    assetNamevalueselected;
    @api childassets;
    blnIsRendered = false;
    @api tabname;
    @track columns = [
    
        {
            label: 'Serial Number',
            fieldName: 'SerialNumber',
            type: 'Number',
            // typeAttributes: {label: { fieldName: 'opporName'}, target: '_blank'},
            sortable: true
        },
        
        {
            label: 'SKU-ID',
            fieldName: 'SKUID',
            type: 'Number',
            sortable: true
        },
        {
            label: 'Product Name',
            fieldName: 'ProductName',
            type: 'Text',
            sortable: true
        },
        
    ];
    
    @track assetList;

    @api getAssets(strAssetName) {
        this.assetNamevalueselected = strAssetName;
        console.log('Batch name :: '+this.assetNamevalueselected);
        Assetvalues({batchname : this.assetNamevalueselected })
        .then(result=>{
            
            this.assetList=result;
            let templist=[];
            var newData = JSON.parse(JSON.stringify(result));
            newData.forEach(record => {
               let tempRecs = Object.assign({},record);
               
              // tempRecs.NameUrl = '/'+tempRecs.Product__c;
               //tempRecs.ProdName = record.Product__r.Name;
            //    console.log('line 67'+ JSON.stringify(record));
            //    tempRecs.SerialNumber= '/'+record.Serial_number__c;
            //    console.log('OppName:'+record.Opportunity.Name);
            //    if(record.Opportunity.Name){tempRecs.opporName=record.Opportunity.Name};
            //    console.log('line 63'+ JSON.stringify(tempRecs));
              tempRecs.SerialNumber=record.Serial_number__c;
              tempRecs.SKUID=record.SKU_Id__c;
              tempRecs.ProductName=record.Product2.name;
              console.log('line 68'+ JSON.stringify(tempRecs));
               
               templist.push(tempRecs);
            });
    
            this.assetList=templist;
            console.log('this.assetList1'+JSON.stringify(this.assetList));
        })
        .catch(error=>{
            console.log('error in asset records'+JSON.stringify(error));
        });
    }
    closeTab(event){
        console.log('Closed:'+JSON.stringify(this.tabname));
        const selectedEvent =new CustomEvent('removetab', {detail:{tabtitle : this.tabname }});
        this.dispatchEvent(selectedEvent);
        
    }
}