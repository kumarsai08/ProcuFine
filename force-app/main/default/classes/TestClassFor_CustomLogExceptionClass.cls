@istest
public class TestClassFor_CustomLogExceptionClass {
  
    
    @isTest static void test_log(){
    try{
   integer a=10;
        integer b=0;
        integer q=a/b;
    }
    catch(exception ex){
        CustomLogException ce=new CustomLogException();
        ce.log(ex);
    }
    }
    @istest static void test_module(){
          CustomLogException ce=new CustomLogException();
        ce.module('ex');
        
    }
    @istest static void test_ExceptionCause(){
          CustomLogException ce=new CustomLogException();
        ce.ExceptionCause('ExceptionCause');
        
    }

    
}