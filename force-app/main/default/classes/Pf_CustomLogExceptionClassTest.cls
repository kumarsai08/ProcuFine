@istest
public class Pf_CustomLogExceptionClassTest {
  
    
    @isTest static void test_log(){
    try{
   integer int_a=10;
        integer int_b=0;
        integer int_q=int_a/int_b;
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