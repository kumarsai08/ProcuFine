import { LightningElement,track } from 'lwc';
import opprecords from '@salesforce/apex/pf_Opportunitysummary.opprecords';
import { NavigationMixin } from 'lightning/navigation';

export default class Pf_PathComponent extends LightningElement {
    summary ='';
    @track isShowModal=false;
    handleAnswer(event) {
        /*eslint-disable-next-line*/
        
        this.selectedRow=event.detail.row;
        console.log('row: '+JSON.stringify(this.selectedRow));
        this.currentvalue = event.detail.value;
        // this.currentvalue= event.detail.value;
        //this.currentvalue='2';
        this.selectedvalue = event.detail.label;
        
        this.PlaceOrder=true;
        this.summary=false;
        this.send=false;
        
        
    }
    pathHandler(event) {
        var targetValue = event.currentTarget.value;
        var selectedvalue = event.currentTarget.label;
        this.currentvalue = targetValue;
        this.selectedvalue = selectedvalue;
        
        this.summary=true;
        this.PlaceOrder=false;
        this.send=false;
        
        
    }
    
    Handleproductdetails(event){
        console.log('line 72');
        this.productnamefrominvdatatable=event.detail.product;
        console.log('line 74'+ this.productnamefrominvdatatable);
        this.opentab=event.detail.createtaboption;
        console.log('line 75'+this.opentab);
        // this.opentab=true;
        this.getOpportunities(this.productnamefrominvdatatable);
        
        //console.log('producttable'+producttable);
        this.show=true;
        this.showOppTab=true;
        console.log('line 98'+this.productnamefrominvdatatable);
        //this.activeTab=this.productnamefrominvdatatable+' Opportunity Information ';
        //console.log('100:'+this.activeTab);
        //this.activeTab=1;
        // this.activeTab = activeTab.toString();
        
    } 
    getOpportunities(strProductName) {
        console.log('line 56');
        this.productnamevalueselected = strProductName;
        //console.log('product name :: '+this.productnamevalueselected);
        opprecords({productname : strProductName })
        .then(result=>{
            console.log('line 61');
            
            this.OppquantityList=result;
            
            
            let templist=[];
            
            var newData = JSON.parse(JSON.stringify(result));
            
            
            newData.forEach(record => {
                let tempRecs = Object.assign({},record);
                console.log('line 72');
                
                // tempRecs.NameUrl = '/'+tempRecs.Product__c;
                //tempRecs.ProdName = record.Product__r.Name;
                //    console.log('line 67'+ JSON.stringify(record));
                tempRecs.OppnameUrl= '/'+record.OpportunityId;
                console.log('OppName:'+record.Opportunity.Name);
                if(record.Opportunity.Name){tempRecs.opporName=record.Opportunity.Name};
                //    console.log('line 63'+ JSON.stringify(tempRecs));
                tempRecs.Cdate=record.Opportunity.CloseDate;
                tempRecs.quantityvalue=record.Opportunity.TotalOpportunityQuantity;
                if(record.Opportunity.OrderNumber__c){tempRecs.Onumber=record.Opportunity.OrderNumber__c};
                if(record.Opportunity.StageName){tempRecs.Sname=record.Opportunity.StageName};
                // console.log('line 68'+ JSON.stringify(tempRecs));
                
                templist.push(tempRecs);
            });
            console.log('line 90');
            
            
            this.list_Opportunities = templist;
            console.log('line 94'+JSON.stringify(this.list_Opportunities));
            this.oppTab=strProductName;
            this.tabContent=this.list_Opportunities;
            this.isShowModal=true;
            console.log('98:'+ this.isShowModal);
            //    this.activeTab=strProductName;
            // this.tabs.push({ label: strProductName, content: this.list_Opportunities ,value:strProductName}); 
            
            
            
            //console.log('line 159'+JSON.stringify(this.activeTab));
            
            // console.log('this.OppquantityList1 :: '+JSON.stringify(templist));
            //return templist;
        })
        .catch(error=>{
            console.log('error in Oppquantityurl_Records'+JSON.stringify(error));
        });
    }
    closeThePopup(){
        this.isShowModal = false;
    }
}