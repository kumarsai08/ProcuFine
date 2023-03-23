import { LightningElement,track,wire,api } from 'lwc';

export default class Dummy extends LightningElement {

    @api num=0;
    @api tabs=[];
    @api show=false;
    handle(event){
        console.log('line 9');
        
        this.num=this.num+1;
        this.tabs.push({ label: 'Tab '+this.num, content: 'Tab 1 content' });
        this.show=true;
        /*if (this.num>=3) {
            this.tabs.pop();
        }*/

    }
    

   /* for (let index = 0; index < num; index++) {
        const element = array[index];
        
    }*/

    /*tabs = [
        { label: 'Tab 1', content: 'Tab 1 content' },
        { label: 'Tab 2', content: 'Tab 2 content' },
        { label: 'Tab 3', content: 'Tab 3 content' },
    ];*/





}