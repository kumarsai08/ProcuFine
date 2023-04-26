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
@api OrderList=[];
@api ChangedString;
@api productNameOptions;
@api productNamesList=[];
@api AllProductList;
@api orderIdStatus;
@api supplierNameStatus;
isAsc = false;
isDsc = false;
isDateSort = false;
sortedDirection = 'asc';
sortedColumn;
@track searchData;
@track errorMsg = '';
@api strSupplierName = '';
@api displayFullData;
searchKey = '';
supplierName = '';

connectedCallback(){
       
    OrderRecordsDatatable({}).then(result=>{
        console.log('line 10');
       this.OrderList=result;
       this.AllProductList=result;
       console.log('Line 12'+JSON.stringify(result));
    })
.catch(error=>{
    console.log('error'+error);
})  
getproductnamerecords({}).then(result=>{
    this.productNamesList.push({label:'All',value:'All'});
    result.forEach(element => {
        this.productNamesList.push({label:element,value:element});
        this.productNameOptions = JSON.parse(JSON.stringify(this.productNamesList));
        console.log('line 53'+JSON.stringify(this.productNameOptions));
    });
})
.catch(error=>{
    console.log('error'+error);
})          
                
}

// handleKeyChange(event) {
//     this.orderIdStatus = event.detail.value;
//     console.log('line 95');
//     if (this.orderIdStatus==='All') {
//      console.log('line 104');
//      this.OrderList=this.AllProductList;
//     } 
//     else {
//         getOrderId({searchKey:this.orderIdStatus}).then(result=>{
//         console.log('line 13');
//         this.OrderList=result;
//         console.log('line 15'+JSON.stringify(this.OrderList));
//         })
//         .catch(error=>{
//             console.log('103 error'+error);
//         })
//     }
// }

handleSupplierChange(event) {
    this.supplierNameStatus = event.detail.value;

    console.log('line 95');
    console.log('line 97'+this.supplierNameStatus);

    if (this.supplierNameStatus==='') {
     console.log('line 104');
     this.OrderList=this.AllProductList;
    } 
    else {
        getSupplierDetails({searchSupplier:this.supplierNameStatus}).then(result=>{
        console.log('line 13');
        this.OrderList=result;
        console.log('line 15'+JSON.stringify(result));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

handleProductChange(event){
    console.log('line 95');
    this.ChangedString=event.detail.value;
    console.log('line 95'+ this.ChangedString);
    if(this.statusChange==null || this.statusChange=='All'){
        if (this.ChangedString==='All') {
            console.log('line 104');
            this.OrderList=this.AllProductList;
        } else {
             orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
                console.log('line 13');
                console.log('this.ChangedString'+this.ChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.OrderList=result;
                console.log('line 15'+JSON.stringify(this.OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
            
            /*orderProductNameFilter({searchsname: this.ChangedString}).then(result=>{
                console.log('line 13');
                this.OrderList=result;
                console.log('line 15'+JSON.stringify(this.OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }*/
    }
        else {            
            orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
                console.log('line 13');
                console.log('this.ChangedString'+this.ChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.OrderList=result;
                console.log('line 15'+JSON.stringify(this.OrderList));
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

handleStatusChange(event) {
    console.log('line 233'+this.ChangedString);
    this.statusChange = event.detail.value;
    console.log('line 95');
    
    if ( this.ChangedString==null || this.ChangedString=='All') {
        //   console.log('line 104');
        //  this.OrderItem=this.AllProductList;
        if(this.statusChange == 'All'){
            console.log('148')
            console.log(this.AllProductList)
            this.OrderList= this.AllProductList;
        } else{
            orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
                console.log('enter')
                console.log('line 13');
                console.log('this.ChangedString'+this.ChangedString);
                console.log('this.statusChange'+this.statusChange);
                this.OrderList=result;
                console.log('line 15'+JSON.stringify(this.OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }
        
        /*orderStatusFilter({searchstatus:this.statusChange}).then(result=>{
            console.log('line 13');
            console.log('this.ChangedString'+this.ChangedString);
            console.log('this.statusChange'+this.statusChange);
            this.OrderList=result;
            console.log('line 15'+JSON.stringify(this.OrderList));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }*/
    }
    
    else {
        //if ( this.ChangedString==='All')this.ChangedString=this.AllProductList;
        
        orderStatusRecords({searchstatus:this.statusChange, searchsname:this.ChangedString}).then(result=>{
            console.log('enter')
            console.log('line 13');
            console.log('this.ChangedString'+this.ChangedString);
            console.log('this.statusChange'+this.statusChange);
            this.OrderList=result;
            console.log('line 15'+JSON.stringify(this.OrderList));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

        searchKey = '';
            @wire(getOrderId, { searchKey: '$searchKey' })
            Order;
                handleKeyChange(event) {
                    this.orderIdStatus = event.detail.value;
                    console.log('SEARCHVALUE : '+ this.orderIdStatus );
                    
                    if (this.orderIdStatus==='') {
                     console.log('line 104');
                     this.OrderList=this.AllProductList;
                    } 
                    else {
                        getOrderId({searchKey:this.orderIdStatus}).then(result=>{
                        console.log('line 13');
                        this.OrderList=result;
                        console.log('line 15'+JSON.stringify(this.OrderList));
                        })
                        .catch(error=>{
                            console.log('103 error'+error);
                        })
                    }
                }

                sortDate(event) {
                    this.isDateSort = true;
                    this.sortData(event.currentTarget.dataset.id);
                   }
                   sortData(sortColumnName) {
                    // check previous column and direction
                    if (this.sortedColumn === sortColumnName) {
                        this.sortedDirection = this.sortedDirection === 'asc' ? 'desc' : 'asc';
                    } 
                    else {
                        this.sortedDirection = 'asc';
                    }
                
                    // check arrow direction
                    if (this.sortedDirection === 'asc') {
                        this.isAsc = true;
                        this.isDsc = false;
                    } 
                    else {
                        this.isAsc = false;
                        this.isDsc = true;
                    }
                
                    // check reverse direction
                    let isReverse = this.sortedDirection === 'asc' ? 1 : -1;
                
                    this.sortedColumn = sortColumnName;
                
                    // sort the data
                    this.OrderList = JSON.parse(JSON.stringify(this.OrderList)).sort((a, b) => {
                        a = a[sortColumnName] ? a[sortColumnName].toLowerCase() : ''; // Handle null values
                        b = b[sortColumnName] ? b[sortColumnName].toLowerCase() : '';
                
                        return a > b ? 1 * isReverse : -1 * isReverse;
                    });;
                }
                
                
                RecordPage(event){
                    const ordId=event.target.dataset.strorderid;
                    // Navigate to a URL
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
                
                
                    Navigatetoproductpage(event){
                        const ordId=event.target.dataset.strprodid;
                    // Navigate to a URL
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

//                 // handlesuppliername(event) {
//                 //             this.strSupplierName = event.detail.value;
//                 //             console.log(this.strSupplierName);
//                 //             if(!this.strSupplierName) {
//                 //                 //this.errorMsg = 'Please enter Supplier name to search.';
//                 //                 this.displayFullData=true;
//                 //                 this.searchData = undefined;
//                 //                 return;
//                 //             }
//                 //             this.displayFullData=false;
                    
//                 //             searchOrders({strSupplierName : this.strSupplierName,Ordertypename : this.OrderTypeValue})
//                 //             .then(result => {
//                 //                 let templist=[];
                           
//                 //             var newData = JSON.parse(JSON.stringify(result));
//                 //             console.log('line 44'+JSON.stringify(newData));
                    
                            
//                 //             newData.forEach(record => {
//                 //                let tempRecs = Object.assign({},record);
//                 //                console.log('LINE 1'+JSON.stringify(tempRecs));
                               
//                 //                //tempRecs.SupplierName = record.supplier__c;
//                 //                tempRecs.suppliername = record.Account.Name;
//                 //                console.log('LINE 2'+record.Account.Name);
                               
//                 //                tempRecs.OrderUrl='/'+record.Id;
//                 //                console.log('LINE 3'+record.Id);
//                 //                tempRecs.ProductName= record.Product__r.Name;
//                 //                console.log('LINE 4'+record.OrderNumber);
//                 //                tempRecs.warehousename=record.Warehouse__r.Name;
                               
//                 //                //if(record.Warehouse__r.Name)tempRecs.warehousename=record.Warehouse__r.Name;
//                 //                 //Console.log('LINE 5');
                               
//                 //                templist.push(tempRecs);
//                 //                console.log('LINE 6'+templist);
//                 //             });
                            
//                 //                 this.searchData = templist;
                                
//                 //             })
//                 //             .catch(error => {
//                 //                 this.searchData = undefined;
//                 //                 window.console.log('error =====> '+JSON.stringify(error));
//                 //                 if(error) {
//                 //                     this.errorMsg = error.body.message;
//                 //                 }
//                 //             }) 
//                 //         }
                    
                        
}