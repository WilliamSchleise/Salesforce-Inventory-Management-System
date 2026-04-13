public class OpportunityTriggerHandler {
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords, 
                                                    Map<Id, Opportunity> oldMap){
	for(Opportunity newOpp : newRecords){
        if(oldMap.get(newOpp.id).StageName != newOpp.StageName){
			newOpp.Amount = newOpp.Probability * newOpp.ExpectedRevenue;
        }
          
                                                      
	}                                                 
	}                                                		
                                                        
        
        
 }