public class ScheduleInventoryEveryday implements Schedulable {
    public void execute(SchedulableContext SC){
         // We now call the batch class to be scheduled
        PFbatchClass Inv = new PFbatchClass();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(Inv);
    }

}