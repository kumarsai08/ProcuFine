@istest
public class Pf_TestClassFor_CustomLogExceptionClass {
  
    
    @isTest static void test_log(){
    try{
   integer integer_a=10;
        integer integer_b=0;
        integer integer_q=integer_a/integer_b;
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