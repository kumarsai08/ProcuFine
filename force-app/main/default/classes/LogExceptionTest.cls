public class LogExceptionTest {
   @Auraenabled(cacheable=true)
    public static void test1()
    {
        try
        {
           integer i = 1/0;    
        }
        catch(exception ex)
            
        {
            system.debug(ex);
            new CustomLogException().Log(ex);
               
                
        }
    }
    
    public static void test2()
    {
        try
        {
          list<Account> acc = [SELECT Id, Name FROM Account 
                         WHERE Name =  '7uygft6'];  
            for(integer i=0;i<2;i++){
                system.debug(acc[i]);
            }
        }
        catch(exception ex)
        {
            new CustomLogException()
                .Module('unitTestModule')
                .ExceptionCause('Probably no data in account')
                .Log(ex);
        }

    }
        public static list<account> test3(){
            list<account> act=[select id,name from account];
            list<account> acd=new list<account>();
            
                
                account ac=new account();
                ac.Email__c='kk@gmail.com';
                acd.add(ac);
            try{
                insert ac;
            }
                
            
                    catch(exception ex)
        {
            new CustomLogException()
                .Module('unitTestModule')
                .ExceptionCause('Probably no data in account')
                .Log(ex);
        }
            return act;
            
            
        }
        
    
}