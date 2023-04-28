import { LightningElement ,api, track, wire} from 'lwc';
import OrderRecordsDatatable from '@salesforce/apex/PF_orderdetails.OrderRecordsDatatable';
import orderStatusFilter from '@salesforce/apex/PF_orderdetails.orderStatusFilter';
import orderStatusRecords from '@salesforce/apex/PF_orderdetails.orderStatusRecords';
import orderProductNameFilter from '@salesforce/apex/PF_orderdetails.orderProductNameFilter';
import getproductnamerecords from '@salesforce/apex/PF_orderdetails.getproductnamerecords';
import getOrderId from '@salesforce/apex/PF_orderdetails.getOrderId';
import getSupplierDetails from '@salesforce/apex/PF_orderdetails.getSupplierDetails';
import { NavigationMixin } from 'lightning/navigation';

export default class OrdersDatatable extends NavigationMixin (LightningElement) {
@api list_OrderList=[];
@api strChangedString;
@api list_ProductNameOptions;
@api list_ProductNamesList=[];
@api list_AllProductList;
@api strOrderIdStatus;
@api strSupplierNameStatus;
@api strSortedDirection = 'asc';
@api strSortedColumn;
@api strSupplierName = '';
blnIsAsc = false;
blnIsDsc = false;
blnIsDateSort = false;
strSearchKey = '';
//@track searchData;
//@track strErrorMessage = '';
//@api displayFullData;
//strSupplierName = '';

//This code is used to fetch and store data in component variables during the component's initialization.
connectedCallback(){
    OrderRecordsDatatable({}).then(result=>{
        console.log('line 10');
       this.list_OrderList=result;
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
                
}

//This function is used to handle the change in the selected supplier name and filter the order list accordingly based on the selected supplier.    
handleSupplierChange(event) {
    this.strSupplierNameStatus = event.detail.value;
    console.log('line 95');
    console.log('line 97'+this.strSupplierNameStatus);
    if (this.strSupplierNameStatus==='') {
     console.log('line 104');
     this.list_OrderList=this.list_AllProductList;
    } 
    else {
        getSupplierDetails({searchSupplier:this.strSupplierNameStatus}).then(result=>{
        console.log('line 13');
        this.list_OrderList=result;
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
            this.list_OrderList=this.list_AllProductList;
        } else {
             orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
                console.log('line 13');
                console.log('this.strChangedString'+this.strChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.list_OrderList=result;
                console.log('line 15'+JSON.stringify(this.list_OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
    }
        else {            
            orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
                console.log('line 13');
                console.log('this.strChangedString'+this.strChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.list_OrderList=result;
                console.log('line 15'+JSON.stringify(this.list_OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
    }

get orderOptions() {
    return [
        { label: 'All', value: 'All' },
        { label: 'Order Placed', value: 'Order Placed' },
        { label: 'Partial Quantity Under QA', value: 'Partial Quantity Under QA' },
        { label: 'Fully Received Under QA', value: 'Fully Received Under QA' }
    ];
}

//This function handles the change of order status and filters the order records based on the selected status and the previously selected product name. 
handleStatusChange(event) {
    console.log('line 233'+this.strChangedString);
    this.statusChange = event.detail.value;
    console.log('line 95');
    
    if ( this.strChangedString==null || this.strChangedString=='All') {
        if(this.statusChange == 'All'){
            console.log('148')
            console.log(this.list_AllProductList)
            this.list_OrderList= this.list_AllProductList;
        } else{
            orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
                console.log('enter')
                console.log('line 13');
                console.log('this.strChangedString'+this.strChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.list_OrderList=result;
                console.log('line 15'+JSON.stringify(this.list_OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
    }
    else {        
        orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
            console.log('enter')
            console.log('line 13');
            console.log('this.strChangedString'+this.strChangedString);
            console.log('this.statusChange'+this.statusChange);
            this.list_OrderList=result;
            console.log('line 15'+JSON.stringify(this.list_OrderList));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

//This is used to handle changes in the search key input field and retrieve the list of orders matching the search key using a wire method called getOrderId.
            strSearchKey = '';
            @wire(getOrderId, { searchKey: '$searchKey' })
            Order;
                handleKeyChange(event) {
                    this.strOrderIdStatus = event.detail.value;
                    console.log('SEARCHVALUE : '+ this.strOrderIdStatus );
                    
                    if (this.strOrderIdStatus==='') {
                     console.log('line 104');
                     this.list_OrderList=this.list_AllProductList;
                    } 
                    else {
                        getOrderId({searchKey:this.strOrderIdStatus}).then(result=>{
                        console.log('line 13');
                        this.list_OrderList=result;
                        console.log('line 15'+JSON.stringify(this.list_OrderList));
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
                    this.list_OrderList = JSON.parse(JSON.stringify(this.list_OrderList)).sort((a, b) => {
                        a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
                        b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';
                        return a > b ? 1 * isReverse : -1 * isReverse;
                    });;
                }
                
        //This method is used to navigate to Order with a specific ID and opens it in a new tab.
                RecordPage(event){
                    const ordId=event.target.dataset.strorderid;
                    this[NavigationMixin.GenerateUrl]({
                        type: 'standard__recordPage',
                        attributes:{
                            recordId: ordId,
                            objectApiName: 'order',
                            actionName:'view'
                        }
                    }).then(url =>{
                        window.open(url, "_blank");
                    })
                    }
                
     //This method is used to navigate to product with a specific ID and opens it in a new tab.
                    Navigatetoproductpage(event){
                        const ordId=event.target.dataset.strprodid;
                        this[NavigationMixin.GenerateUrl]({
                        type: 'standard__recordPage',
                        attributes:{
                            recordId: ordId,
                            objectApiName: 'product',
                            actionName:'view'
                        }
                    }).then(url =>{
                        window.open(url, "_blank");
                    })
                    }   
}