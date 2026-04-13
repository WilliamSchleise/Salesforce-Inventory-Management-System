trigger ContactBloq on Contact (before insert) {
    if(Trigger.IsInsert && Trigger.IsBefore){
        BloqContatoSemConta.bloquearCriacaoBeforeInsert(Trigger.NEW);
        
    }

}