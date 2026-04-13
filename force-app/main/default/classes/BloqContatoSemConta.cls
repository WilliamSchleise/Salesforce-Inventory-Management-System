public class BloqContatoSemConta {
    public static void bloquearCriacaoBeforeInsert(List<Contact> newRecords){
        for(Contact conRecord : newRecords){
            if(conRecord.AccountId == null){
                conRecord.addError('Precisa de uma conta para criar um Contato');
            }
        }
        
    }

}