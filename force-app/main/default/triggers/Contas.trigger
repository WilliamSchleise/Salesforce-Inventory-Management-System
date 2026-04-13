trigger Contas on Account (before insert) {
    if(Trigger.IsBefore){
        if(Trigger.IsInsert){
            for(Account acc : Trigger.new){
            System.debug('A conta inserida é:' + '' + acc.Name);
                }
        }
    }
}