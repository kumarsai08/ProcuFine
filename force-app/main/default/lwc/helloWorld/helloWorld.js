import { LightningElement, api, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    name="kumar sai";
    keychangename;
    age = 23;
    status=true;
    arr=[1,2,3];
    carlist=[{
        id:1,
        name:"a"
    },{ id:2,
        name:"b"

    }];
    @track obj={
        name:"sai",
        ag:25
    };
    title="aura";
    names=["sai","kumar","vadapalli"];
    num1=10;
    num2=20;

    changehandler(event){
        this.title=event.target.value;
    }
     trackhandler(event){
        this.obj.name=event.target.value;
    }
    get firstname(){
        return this.names[0].toLocaleUpperCase();
    }
    get sum(){
        return this.num1*this.num2;
    }
    visible=false;
    handleClick(){
this.visible=true;
    }
 
    keychange(event){
        this.keychangename=event.target.value;
    }
    get keysuccess(){
        return this.keychangename ==='hello';
    }


}