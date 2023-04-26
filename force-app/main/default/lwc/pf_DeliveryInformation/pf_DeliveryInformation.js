import { LightningElement, wire, track, api } from 'lwc';
import fetchOrderProduct from '@salesforce/apex/pf_Opportunitysummary.fetchOrderProduct';
import updateOrder from '@salesforce/apex/pf_Opportunitysummary.updateOrder';
import createAsset from '@salesforce/apex/pf_Opportunitysummary.createAsset';
import getproductnamerecords from '@salesforce/apex/pf_Opportunitysummary.getproductnamerecords';
import orderProductNameFilter from '@salesforce/apex/pf_Opportunitysummary.orderProductNameFilter';
import orderStatusRecords from '@salesforce/apex/pf_Opportunitysummary.orderStatusRecords';
import getOrderId from '@salesforce/apex/pf_Opportunitysummary.getOrderId';
import orderStatusFilter from '@salesforce/apex/pf_Opportunitysummary.orderStatusFilter';
import { NavigationMixin } from 'lightning/navigation';

const DELAY = 300;

export default class Pf_DeliveryInformation extends NavigationMixin (LightningElement) {
    @api strProductRecord;
    @api intQuantityValue=0;;
    @api blnChangeValue=false;
    @api intReceivedQuan;
    @api blnIsShowModal;
    @api list_Dat=[];
    @api strProductName;
    @track list_OrderItem;
    @track list_batchNumberList=[];
    @track strProId;
    @api list_productNamesList=[];
    @api list_ProductNameOptions;
    @api strChangedString;
    @api list_AllProductList;
    @api strOrderIdStatus;
    @api intQuanti;
    @api StrSupplierName='';
    @api strDeliveredDate;
    
//This is used to load data and populate a list of product names as options with 'All' as the default value.
    connectedCallback(){
        this.loadData();
        getproductnamerecords({}).then(result=>{
            this.list_productNamesList.push({label:'All',value:'All'});
            result.forEach(element => {
                this.list_productNamesList.push({label:element,value:element});
                this.list_ProductNameOptions = JSON.parse(JSON.stringify(this.list_productNamesList));
                console.log('line 53'+JSON.stringify(this.list_ProductNameOptions));
            });
        })
        .catch(error=>{
            console.log('error'+error);
        })
     }

//This method is used to navigate to order with a specific ID and opens it in a new tab.
    handleOnClick(event){
        const OrderPage=event.target.dataset.orderrecordurl;
         // Navigate to a URL
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: OrderPage,
                 objectApiName: 'Order',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
    }

    //This @api decorator is used to make the method 'loadData' available to be called from outside the component and it fetches data for 'list_OrderItem'.
    @api loadData(){ 
        fetchOrderProduct().then(result=>{
            console.log('24:'+JSON.stringify(result));
            this.list_OrderItem=result;
            this.list_AllProductList=result;
            console.log('this.list_OrderItem'+this.list_OrderItem);
        }).catch(error=>{
            console.log('Error 27:'+JSON.stringify(error));
        });
       }
       
//This method is used to navigate to product with a specific ID and opens it in a new tab.
    navigateToProduct(event){
        const ProductRedirect=event.target.dataset.orderproducturl;
         // Navigate to a URL
         this[NavigationMixin.GenerateUrl]({
             type: 'standard__recordPage',
             attributes:{
                 recordId: ProductRedirect,
                objectApiName: 'Product2',
                 actionName:'view'
             }
         }).then(url =>{
             window.open(url, "_blank");
         })
        }

    //This function is used to handle the change event of a input field and update the component with the new value.  
    handleonchange(event){
        console.log('line 15');
        this.blnChangeValue=true;
        this.intQuantityValue=event.target.value;
        console.log('line 16'+ typeof this.intQuantityValue);
    }

    //This function handles the logic for validating and displaying a modal based on user input, and sets various values and lists in the component.
    handleSave(event) {
        let modelshow =false;
        const pendqty=event.target.dataset.pend;
        console.log(typeof(Number(pendqty))+'___'+typeof(Number(this.intQuantityValue)))
        if(Number(this.intQuantityValue)>Number(pendqty)){
            event.target.setCustomValidity("Recieved quantity should not be greater than pending quantity.");
            this.blnIsShowModal=false;
            modelshow = true; 
            this.intQuantityValue=0;
        }
        else if(Number(this.intQuantityValue)<=0){
            event.target.setCustomValidity("Recieved quantity cannot be Zero or a Negative value.");
            this.blnIsShowModal=false;
            this.intQuantityValue=0;
            modelshow = true;
        }
        else {
            event.target.setCustomValidity("");
            this.dateValue = event.target.value;
            this.blnIsShowModal=true
        }
         event.target.reportValidity();
        this.StrSupplierName= event.currentTarget.dataset.suppliername;
        console.log('supp name'+this.StrSupplierName);
        this.intReceivedQuan=''
        this.list_Dat =[]
        const updatedFields = event.detail.draftValues;
        this.strProductRecord= event.currentTarget.dataset.idname;
        let ele =this.template.querySelector('.pt-3-half').value
        console.log('tfye',event.currentTarget.dataset.recquantity)
        this.intReceivedQuan=event.currentTarget.dataset.recquantity;
        console.log('tfye',this.intReceivedQuan)
        this.strProductName=event.currentTarget.dataset.proname;
        this.strProId = event.currentTarget.dataset.proid;       
        //this.quantityvalue= event.currentTarget.dataset.recquantity;
        console.log('quantityy'+ this.strProductRecord);
        for (let i = 0; i < this.intReceivedQuan; i++) {
            this.list_Dat.push(i);
        }
        console.log('line',this.list_Dat)  
        
}
                   
//This function is used to hide a modal box and perform various actions like creating an asset, updating an order, and fetching search results based on different conditions.
                hideModalBox(){
                        console.log('Product Id',JSON.stringify(this.strProId))
                        const allValid = [
                            ...this.template.querySelectorAll('lightning-input'),
                        ].reduce((validSoFar, inputCmp) => {
                            inputCmp.reportValidity('Fill the field');
                            inputCmp.showHelpMessageIfInvalid();
                            if(inputCmp.value){
                                this.list_batchNumberList.push(inputCmp.value);
                            }
                            console.log('sr'+inputCmp.value);
                            return validSoFar && inputCmp.checkValidity();
                        }, true);
                        if (allValid) {
                            console.log('195',this.intQuanti)
                            this.blnIsShowModal=false
                            console.log('tyope of',this.list_batchNumberList)
                            createAsset({prodId : this.strProId,batchNumbers : this.list_batchNumberList, orderid : this.strProductRecord, deliverydate : this.strDeliveredDate }).then(result=>{
                                this.strProId=''
                                this.intQuanti=0;
                                this.list_batchNumberList=[]
                                console.log('check'+this.list_batchNumberList);
                                this.dispatchEvent(new CustomEvent('qarefresh'));
                            }).catch(error=>{
                                console.log('Error 27:'+JSON.stringify(error));
                            });
                            
                            updateOrder({ordervalue : this.strProductRecord,valueRquantity : this.intQuantityValue  }).then(result=>{
                                console.log('line 52'+ JSON.stringify(result));
                            }).catch(error =>{
                                console.log(error);
                            }).finally(() =>{
                                this.loadData();
                                console.log('line 64');
                            });
                            console.log('line 61');
                            this.intQuantityValue=0
                        } else {
                            this.blnIsShowModal=true
                        }
                    }
                        
                        //This function is used to handle changes in the product search input and update the list of order items based on the new search criteria.
                        handleProductChange(event){
                            console.log('line 95');
                            this.strChangedString=event.detail.value;
                            console.log('line 95'+ this.strChangedString);
                            if(this.statusChange==null || this.statusChange=='All'){
                                if (this.strChangedString==='All') {
                                    console.log('line 104');
                                    this.list_OrderItem=this.list_AllProductList;
                                } else {
                                    
                                    orderProductNameFilter({searchsname: this.strChangedString}).then(result=>{
                                        console.log('line 13');
                                        this.list_OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.list_OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }}
                                else{
                                    orderStatusRecords({searchstatus:this.statusChange, searchsname:this.strChangedString}).then(result=>{
                                        console.log('line 227');
                                        console.log('this.strChangedString 228'+this.strChangedString);
                                        console.log('this.statusChange 229'+this.statusChange);
                                        this.list_OrderItem=result;
                                        console.log('line 231'+JSON.stringify(this.list_OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('234 error'+JSON.stringify(error));
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

                            //This method is used to handle the change event on a status field which fetches and display order items based on the selected status.
                            handleStatusChange(event) {
                                console.log('line 233'+this.strChangedString);
                                this.statusChange = event.detail.value;
                                console.log('line 95');
                                if ( this.strChangedString==null || this.strChangedString=='All') {
                                    orderStatusFilter({searchstatus:this.statusChange}).then(result=>{
                                        console.log('line 13');
                                        console.log('this.strChangedString'+this.strChangedString);
                                        console.log('this.statusChange'+this.statusChange);
                                        this.list_OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.list_OrderItem));
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
                                        this.list_OrderItem=result;
                                        console.log('line 15'+JSON.stringify(this.list_OrderItem));
                                    })
                                    .catch(error=>{
                                        console.log('103 error'+error);
                                    })
                                }
                            }
    
                            //This function is used to close a popup modal and reset some variables.
                            closeThePopup(event){
                                console.log('line 318');
                                this.blnIsShowModal=false;
                                
                            }
                  
//This method is used to handle the change in search input field and fetch the search results based on the input value.
    handleKeyChange(event) {
    this.strOrderIdStatus = event.detail.value;
    console.log('line 95');
    if (this.strOrderIdStatus==='All') {
     console.log('line 104');
     this.list_OrderItem=this.list_AllProductList;
    } 
    else {
        getOrderId({searchKey:this.strOrderIdStatus}).then(result=>{
        console.log('line 13');
        this.list_OrderItem=result;
        console.log('line 15'+JSON.stringify(this.list_OrderItem));
        })
        .catch(error=>{
            console.log('103 error'+error);
        })
    }
}

//This function updates the value of strDeliveredDate based on the user input and the curDate function returns the current date in a specific format.        
handledeliverydate(event){
    this.strDeliveredDate= event.target.value;
            console.log('505 '+ this.strDeliveredDate);
        }
        get curDate(){
            let d = new Date();
            console.log('check',d);
             let month = d.getMonth()+1;
             console.log('hiii'+month+d.getMonth())
             let date = d.getDate();
             console.log(d.getFullYear() + '-' + month + '-' + date+'_____DATE')
             return d.getFullYear() + '-' + month + '-' + date;
        }
}