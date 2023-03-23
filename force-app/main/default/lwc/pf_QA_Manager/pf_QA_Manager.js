import { LightningElement, api , track} from 'lwc';
import QAManagerOrderPro from '@salesforce/apex/assetRecords.QAManagerOrderPro';
import producttoassestrecords from '@salesforce/apex/assetRecords.producttoassestrecords';
import CreateAssetRecords from '@salesforce/apex/assetRecords.CreateAssetRecords';
export default class Pf_QA_Manager extends LightningElement {

    @api QATableList=[];
    @track isShowModal = false;
    @track productId1 = '';
    @api aslist;
    @api statusvalue;
    @api assetValue;
    @api assestid=[];
    @api asseststatus=[];
    @api updatedvalue;

    connectedCallback(){
        QAManagerOrderPro({}).then(result=>{
            this.QATableList=result;
            
    })
    .catch(error=>{
        console.log('error'+error);
    })
    }
    closeThePopup(){
        this.isShowModal = false;
    }
    
    handleClick(event){

        this.isShowModal = true;
        this.productId1 = event.target.dataset.proid;
        const ordName=event.target.dataset.set;
        console.log('line28'+ordName);
        producttoassestrecords({proId:ordName}).then(result=>{
            console.log('line 32'+JSON.stringify(result)); 
            this.aslist=result;
        })
        .catch(error=>{
            console.log('error'+error);
        })

 

}
value = 'QA In Progress';

    get options() {
        return [
            { label: 'QA Pass', value: 'QA Pass' },
            { label: 'QA Fail', value: 'QA Fail' },
            { label: 'QA In Progress', value: 'QA In Progress' },
        ];
    }
    handlestatusupdation(event){
        console.log('line51')
        this.statusvalue=event.detail.value;
        console.log('line51'+this.statusvalue);
        this.assetValue=event.currentTarget.dataset.assetid;
        console.log('line56'+this.assetValue);
       this.assestid.push(this.assetValue);
        console.log('line61'+this.assestid);
       this.asseststatus.push(this.statusvalue);
        console.log('line63'+this.asseststatus);




    }
    hideModalBox(event){
        //this.updatedvalue=this.statusvalue;
        CreateAssetRecords({assetRecordIds:this.assestid, statusValues  : this.asseststatus}).then(result=>{
            console.log('LINE 74'+JSON.stringify(result));
        })
        .catch(error=>{
            console.log('error'+JSON.stringify(error));
        })
        this.isShowModal = false;
    }
     
    
    


/*@wire(producttoassestrecords,{proId:this.productId1})
wiredassets({error,data}){
    if (data) {
        console.log(data);
        this.data = data;
        this.initialRecords = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.data = undefined;
    }*/

}