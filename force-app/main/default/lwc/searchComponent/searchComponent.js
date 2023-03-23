import { LightningElement, wire } from 'lwc';
import FetchOrders from '@salesforce/apex/OrderController.FetchOrders';
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' },
];
 
const columns = [   
    { label: 'SupplierName', fieldName: 'Name' },
    { label: 'WarehouseName', fieldName: 'Name' },
    { label: 'Status', fieldName: 'status', type: 'Text' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class LightingDataTableSearch extends NavigationMixin( LightningElement ) {
     
    availableOrders;
    error;
    columns = columns;
    searchString;
    initialRecords;

    @wire( FetchOrders )  
    wiredOrder( { error, data } ) {

        if ( data ) {

            this.availableOrders = data;
            this.initialRecords = data;
            this.error = undefined;

        } else if ( error ) {

            this.error = error;
            this.availableOrders = undefined;

        }

    }

    handleRowAction( event ) {

        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch ( actionName ) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'order',
                        actionName: 'edit'
                    }
                });
                break;
            default:
        }

    }

    handleSearchChange( event ) {

        this.searchString = event.detail.value;
        console.log( 'Updated Search String is ' + this.searchString );

    }

    handleSearch( event ) {

        const searchKey = event.target.value.toLowerCase();
        console.log( 'Search String is ' + searchKey );

        if ( searchKey ) {

            this.availableorders = this.initialRecords;
            console.log( 'Account Records are ' + JSON.stringify( this.availableorders ) );
            
            if ( this.availableorders ) {

                let recs = [];
                
                for ( let rec of this.availableorders ) {

                    console.log( 'Rec is ' + JSON.stringify( rec ) );
                    let valuesArray = Object.values( rec );
                    console.log( 'valuesArray is ' + JSON.stringify( valuesArray ) );
 
                    for ( let val of valuesArray ) {

                        console.log( 'val is ' + val );
                        let strVal = String( val );
                        
                        if ( strVal ) {

                            if ( strVal.toLowerCase().includes( searchKey ) ) {

                                recs.push( rec );
                                break;
                        
                            }

                        }

                    }
                    
                }

                console.log( 'Matched Accounts are ' + JSON.stringify( recs ) );
                this.availableorders = recs;

             }
 
        }  else {

            this.availableorders = this.initialRecords;

        }        

    }

}