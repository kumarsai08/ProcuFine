import { LightningElement ,api, wire, track} from 'lwc';
import fetchOrderProduct from '@salesforce/apex/pf_Opportunitysummary.fetchOrderProduct';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
import orderStatusFilter from '@salesforce/apex/pf_Opportunitysummary.orderStatusFilter';
import orderStatusRecords from '@salesforce/apex/pf_Opportunitysummary.orderStatusRecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import getSupplierDetails from '@salesforce/apex/pf_Opportunitysummary.getSupplierDetails';
import getPickListValuesIntoList from '@salesforce/apex/pf_Opportunitysummary.getPickListValuesIntoList';
import {NavigationMixin} from 'lightning/navigation';

export default class Pf_OrderDatable extends NavigationMixin(LightningElement) {


@api list_Order=[];
@api strChangedString;
@api list_ProductNameOptions;
@api list_ProductNamesList=[];
@api list_AllProductList;
@api strOrderIdStatus;
@api strSupplierNameStatus;
blnIsAsc = false;
blnIsDsc = false;
blnIsDateSort = false;
strSortedDirection = 'asc';
strSortedColumn;
@api strSupplierName = '';
@api list_PicklistStatus=[];
@api list_PicklistValuies=[];

//This code is used to fetch and store data in component variables during the component's initialization.
connectedCallback(){
    fetchOrderProduct({}).then(result=>{
                console.log('line 10');
               this.list_Order=result;
               this.list_AllProductList=result;
               console.log('Line 12'+JSON.stringify(result));
            })
        .catch(error=>{
            console.log('error'+error);
        })  
getproductnamerecords({}).then(result=>{
    this.list_ProductNamesList.push({label:'All',value:'All'});
    result.forEach(element => {
        this.list_ProductNamesList.push({label:element,value:element});
        this.list_ProductNameOptions = JSON.parse(JSON.stringify(this.list_ProductNamesList));
        console.log('line 53'+JSON.stringify(this.list_ProductNameOptions));
    });
})
.catch(error=>{
    console.log('error'+error);
}) 
getPickListValuesIntoList({}).then(result=>{
    this.list_PicklistStatus.push({"label":'All',"value":'All'})
    console.log('result',result)
    for(let i=0;i<result.length;i++){
        this.list_PicklistStatus.push({"label":result[i],"value":result[i]})
    }
    this.list_PicklistValuies=this.list_PicklistStatus;
        console.log('hiii'+JSON.stringify(this.list_PicklistStatus));
    }).catch(error=>{
        console.log('error'+error);
    })   
}

//This method is used to navigate to Order with a specific ID and opens it in a new tab.
handleClick(event){
    const OrderRecordPage=event.target.dataset.orderurl;
     // Navigate to a URL
     this[NavigationMixin.GenerateUrl]({
         type: 'standard__recordPage',
         attributes:{
             recordId: OrderRecordPage,
             objectApiName: 'order',
             actionName:'view'
         }
     }).then(url =>{
         window.open(url, "_blank");
     })
}

//This function is used to handle the change in the selected supplier name and filter the order list accordingly based on the selected supplier.    
handleSupplierChange(event) {
    this.strSupplierNameStatus = event.detail.value;
    console.log('line 95');
    console.log('line 97'+this.strSupplierNameStatus);
    if (this.strSupplierNameStatus==='All') {
     console.log('line 104');
     this.list_Order=this.list_AllProductList;
    } 
    else {
        getSupplierDetails({searchSupplier:this.strSupplierNameStatus}).then(result=>{
        console.log('line 13');
        this.list_Order=result;
        console.log('line 15'+JSON.stringify(result));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

//This function handles changes in the product dropdown and updates the order list based on the selected product and order status.
handleProductChange(event){
    console.log('line 95');
    this.strChangedString=event.detail.value;
    console.log('line 95'+ this.strChangedString);
    if(this.statusChange==null || this.statusChange=='All'){
        if (this.strChangedString==='All') {
            console.log('line 104');
            this.list_Order=this.list_AllProductList;
        } else {
            orderProductNameFilter({searchsname: this.strChangedString}).then(result=>{
                console.log('line 13');
                this.list_Order=result;
                console.log('line 15'+JSON.stringify(this.list_Order));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }}
        else {            
            orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
                console.log('line 13');
                console.log('this.strChangedString'+this.strChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.list_Order=result;
                console.log('line 15'+JSON.stringify(this.list_Order));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
    }

//This function handles the change of order status and filters the order records based on the selected status and the previously selected product name. 
handleStatusChange(event) {
    console.log('line 233'+this.strChangedString);
    this.statusChange = event.detail.value;
    console.log('line 95');
    if ( this.strChangedString==null || this.strChangedString=='All') {
        orderStatusFilter({searchstatus:this.statusChange}).then(result=>{
            console.log('line 13');
            console.log('this.strChangedString'+this.strChangedString);
            console.log('this.statusChange'+this.statusChange);
            this.list_Order=result;
            console.log('line 15'+JSON.stringify(this.list_Order));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
    else {        
        orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
            console.log('line 13');
            console.log('this.strChangedString'+this.strChangedString);
            console.log('this.statusChange'+this.statusChange);
            this.list_Order=result;
            console.log('line 15'+JSON.stringify(this.list_Order));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

//This is used to handle changes in the search key input field and retrieve the list of orders matching the search key using a wire method called getOrderId.
        searchKey = '';
            @wire(getOrderId, { searchKey: '$searchKey' })
            Order;
                handleKeyChange(event) {
                    this.strOrderIdStatus = event.detail.value;
                    console.log('line 95');
                    if (this.strOrderIdStatus==='All') {
                     console.log('line 104');
                     this.list_Order=this.list_AllProductList;
                    } 
                    else {
                        getOrderId({searchKey:this.strOrderIdStatus}).then(result=>{
                        console.log('line 13');
                        this.list_Order=result;
                        console.log('line 15'+JSON.stringify(this.list_Order));
                        })
                        .catch(error=>{
                            console.log('103 error'+error);
                        })
                    }
                }
                
//This function is used to sort the data based on the column name passed as a parameter and the current sort direction.
                sortDate(event) {
                    this.blnIsDateSort = true;
                    this.sortData(event.currentTarget.dataset.id);
                   }
                   sortData(sortColumnName) {
                    // check previous column and direction
                    if (this.strSortedColumn === sortColumnName) {
                        this.strSortedDirection = this.strSortedDirection === 'asc' ? 'desc' : 'asc';
                    } 
                    else {
                        this.strSortedDirection = 'asc';
                    }
                    // check arrow direction
                    if (this.strSortedDirection === 'asc') {
                        this.blnIsAsc = true;
                        this.blnIsDsc = false;
                    } 
                    else {
                        this.blnIsAsc = false;
                        this.blnIsDsc = true;
                    }
                    // check reverse direction
                    let isReverse = this.strSortedDirection === 'asc' ? 1 : -1;
                    this.strSortedColumn = sortColumnName;
                    // sort the data
                    this.list_Order = JSON.parse(JSON.stringify(this.list_Order)).sort((a, b) => {
                        a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
                        b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';
                        return a > b ? 1 * isReverse : -1 * isReverse;
                    });;
                }    
}