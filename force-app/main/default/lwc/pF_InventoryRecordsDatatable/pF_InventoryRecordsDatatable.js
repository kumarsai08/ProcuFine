import { LightningElement  ,api, wire, track} from 'lwc';
import PF_GetInventory_Records from '@salesforce/apex/PF_GetInventory_Records.PF_GetInventory_Records';
export default class PF_InventoryRecordsDatatable extends LightningElement {
    @track columns = [
    
    {
        label: 'Product Name',
        fieldName: 'NameUrl',
        type: 'url',
        typeAttributes: {label: { fieldName: 'ProdName' }, target: '_blank'},
        sortable: true
    },
    {
        label: 'Quantity',
        fieldName: 'Quantity__c',
        type: 'Number',
        sortable: true
    },
    
    {
        label: 'Threshold Value',
        fieldName: 'Threshold__c',
        type: 'Number',
        sortable: true
    },
    {
        label: 'Warehouse',
        fieldName: 'WarehouseUrl',
        type: 'url',
        typeAttributes: {label: { fieldName: 'WarehouseName' }, target: '_blank'},
        sortable: true
    },
    {
        label: '',
        fieldName: 'ButtonAction',
        type: 'button',
        typeAttributes: {label: 'Pre-Order', target: '_blank',variant: "brand",iconPosition: "right",class : "slds-align_absolute-center"}

    }
    
];
@track actionName;
//@track dataRow;
//@track 
handleClick(event) {
        

        const dataRow2 = event.detail.row;
        console.log('row detail2-'+JSON.stringify(dataRow2.Name));
     
      
        this.dispatchEvent(new CustomEvent('valuee', {detail:{value:"2", label:'Place Order',row:dataRow2}}));
        
        
}


@track error;
@track PFInvList ;
// @wire(PF_GetInventory_Records)
// wiredInventoryRecords({
//     error,
//     data            
// }) {
//     if (data) {
//         this.PFInvList = data;
//     } else if (error) {
//         this.PFInvList = error;
//     }
// }

connectedCallback(){
    PF_GetInventory_Records({})
    .then(result=>{
        
        this.PFInvList=result;
        
        let templist=[];
       
        var newData = JSON.parse(JSON.stringify(result));

        
        newData.forEach(record => {
           let tempRecs = Object.assign({},record);
           
           tempRecs.NameUrl = '/'+tempRecs.Product__c;
           tempRecs.ProdName = record.Product__r.Name;
           tempRecs.WarehouseUrl= '/'+tempRecs.Warehouse__c;
            if(record.Warehouse__r.Name)tempRecs.WarehouseName=record.Warehouse__r.Name;
           
           templist.push(tempRecs);
        });
         

        /*newData.forEach(element => {
            console.log('line 62');
            element.NameUrl = '/'+element.Id;
            element.ProdName = element.Name;
            console.log('line 655'+ JSON.stringify(element.Id));
            console.log('line 65' + JSON.stringify(element.Warehouse__r.Name));
            element.WarehouseUrl= '/'+element.Warehouse__c;
            element.WarehouseName=element.Warehouse__r.Name;
            


        });*/
        //console.log('line 72-result from PF_GetInventory_Records'+JSON.stringify(PFInvList));
        this.PFInvList=templist;
        //console.log('line 74-result from PF_GetInventory_Records'+JSON.stringify(newData));
        
    })
    .catch(error=>{
        console.log('error in PF_GetInventory_Records'+JSON.stringify(error));
    })
}
// @wire(PF_GetInventory_Records, {})
//     wiredAccount({ error, data }) {
//         if (data) {
//             console.log('Line 53 ' + JSON.stringify(data));
//             var newData = JSON.parse(JSON.stringify(data));
//             newData.forEach(element => {
//                 element.NameUrl = '/' + element.Id;
//             });
//             this.PFInvList = newData;
//         } else if (error) {
//             console.log('Line 55 ' + error);
//         }
//     }
/*@wire(PF_GetInventory_Records, {})
    wiredAccount({ error, data }) {
        console.log('line 65');
        if (data) {
            console.log('line 67');
            console.log(JSON.stringify(data));
            
            let tempRecords = JSON.parse( JSON.stringify( data ) );
            console.log('tempRecords:'+JSON.stringify(tempRecords));
            tempRecords = tempRecords.map( row => {
                return { WarehouseName: Warehouse__r.Name, WarehouseUrl: '/' + Warehouse__r.Id };
            })
            this.PFInvList = tempRecords;
            this.error = undefined;
        }
        else if(error){
            console.log('Error:'+JSON.stringify(error));
        }

    }*/
}
    




/*PF_GetInventory_Records()
            .then(result => {
                this.PFInvList = result;
            })
            .catch(error => {
                this.PFInvList = error;
            });
}{}*/