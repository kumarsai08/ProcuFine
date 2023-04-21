import { LightningElement,api } from 'lwc';

export default class App extends LightningElement {
    section = [];
     
    @api isShowModal
    handleSectionToggle(event) {
        this.section = event.detail.openSections;
    }
    handleClick(event){
        this.isShowModal=true;
        console.log('show modal',this.isShowModal)
    }
    closePopup(){
        this.isShowModal=false;
    }
}