trigger OpportunityTrigger on Opportunity (before update) {
    if(Trigger.IsUpdate && Trigger.IsBefore){
        OpportunityTriggerHandler.handleActivitiesBeforeUpdate(Trigger.NEW, Trigger.oldMap);
        
    }

}