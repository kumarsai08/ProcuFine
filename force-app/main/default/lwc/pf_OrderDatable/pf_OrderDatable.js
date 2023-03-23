import { LightningElement ,api, wire, track} from 'lwc';
import fetchOrderProduct from '@salesforce/apex/pf_Opportunitysummary.fetchOrderProduct';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
// import OrderRecordsDatatable from '@salesforce/apex/GetSuppleirDetails.OrderRecordsDatatable';
import orderStatusFilter from '@salesforce/apex/pf_Opportunitysummary.orderStatusFilter';
import orderStatusRecords from '@salesforce/apex/pf_Opportunitysummary.orderStatusRecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
// import getOrderIdDetails from '@salesforce/apex/GetSuppleirDetails.getOrderIdDetails';
 import getSupplierDetails from '@salesforce/apex/pf_Opportunitysummary.getSupplierDetails';
 import getPickListValuesIntoList from '@salesforce/apex/pf_Opportunitysummary.getPickListValuesIntoList';
import {NavigationMixin} from 'lightning/navigation';

export default class Pf_OrderDatable extends NavigationMixin(LightningElement) {


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
@api orderIdURL;
@api recordPageUrl;
@api pickliststatus=[];
@api picklistValuies=[];
url;

connectedCallback(){

    fetchOrderProduct({}).then(result=>{
                console.log('line 10');
               this.OrderList=result;
               this.AllProductList=result;
               console.log('Line 12'+JSON.stringify(result));
            })
        .catch(error=>{
            console.log('error'+error);
        })  
       
//     OrderRecordsDatatable({}).then(result=>{
//         console.log('line 10');
//        this.OrderList=result;
//        this.AllProductList=result;
//        console.log('Line 12'+JSON.stringify(result));
//     })
// .catch(error=>{
//     console.log('error'+error);
// })  
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
getPickListValuesIntoList({}).then(result=>{
    this.pickliststatus.push({"label":'All',"value":'All'})
    console.log('result',result)
    for(let i=0;i<result.length;i++){
        this.pickliststatus.push({"label":result[i],"value":result[i]})
    }
    this.picklistValuies=this.pickliststatus;
       //this.pickliststatus=result;
        console.log('hiii'+JSON.stringify(this.pickliststatus));
    }).catch(error=>{
        console.log('error'+error);
    })
                
       
}
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
                


// handleKeyChange(event) {
//     this.orderIdStatus = event.detail.value;
//     console.log('line 95');
//     if (this.orderIdStatus==='All') {
//      console.log('line 104');
//      this.OrderList=this.AllProductList;
//     } 
//     else {
//         getOrderIdDetails({searchKey:this.orderIdStatus}).then(result=>{
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

    if (this.supplierNameStatus==='All') {
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
            
            orderProductNameFilter({searchsname: this.ChangedString}).then(result=>{
                console.log('line 13');
                this.OrderList=result;
                console.log('line 15'+JSON.stringify(this.OrderList));
            })
            .catch(error=>{
                console.log('103 error'+error);
            })
        }}
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
// get orderOptions() {
//     return [
//         { label: 'All', value: 'All' },
//         { label: 'Order Placed', value: 'Order Placed' },
//         { label: 'Partial Quantity Under QA', value: 'Partial Quantity Under QA' },
//         { label: 'Fully Received Under QA', value: 'Fully Received Under QA' }
//     ];
// }


handleStatusChange(event) {
    console.log('line 233'+this.ChangedString);
    this.statusChange = event.detail.value;
    console.log('line 95');
    
    if ( this.ChangedString==null || this.ChangedString=='All') {
        //   console.log('line 104');
        //  this.OrderItem=this.AllProductList;
        orderStatusFilter({searchstatus:this.statusChange}).then(result=>{
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

        searchKey = '';
            @wire(getOrderId, { searchKey: '$searchKey' })
            Order;
                handleKeyChange(event) {
                    this.orderIdStatus = event.detail.value;
                    console.log('line 95');
                    if (this.orderIdStatus==='All') {
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
                
                // getOrderIdNo(event){
                //     // this.orderIdURL=event.currentTarget.dataset.orderurl;
                //     const selectedOrderId=event.target.dataset.orderurl;
                //     this[NavigationMixin.Navigate]({
                //         type: 'standard__recordPage',
                //         attributes:{
                //             recordId: selectedOrderId,
                //             actionName:'view'
                //         }
                        
                       
                //     })
                //     // this.recordPageUrl= 'https://absyz-2d8-dev-ed.develop.lightning.force.com/lightning/r/Order/'+this.orderIdURL+'/view';

                // }

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
                
                    
}