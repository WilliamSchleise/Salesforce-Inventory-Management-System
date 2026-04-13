public class BatchVIACEP implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts{
   
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, BillingPostalCode FROM Account]);
    }
    
     public void execute(Database.BatchableContext bc, List<Account> scope){
        List<Account> accountsToUpdate = new List<Account>();
         for(Account acc : scope){
             if(acc.BillingPostalCode != null){
                 Try{
                     Http h = new Http();
                     HttpRequest req = new HttpRequest();
                     req.setEndpoint('https://viacep.com.br/ws/' + acc.BillingPostalCode + '/json/');
                     req.setMethod('GET');
                     
                     
                     HttpResponse res = h.send(req);
                     
                     
                     if(res.getStatusCode() == 200){
							ViaCEP endereco = (ViaCEP) JSON.deserialize(res.getBody(), ViaCEP.class);
                     			
                         	acc.BillingStreet = endereco.logradouro;
                         	acc.BillingCity = endereco.localidade;
                         	acc.BillingState = endereco.uf;
                         	acc.BillingCountry = 'Brasil';
                         	acc.BillingPostalCode = endereco.cep;
                         
                         	accountsToUpdate.add(acc);

                     } 
                     
                 } 
             	catch(Exception e){
                         System.debug('Erro ao consultar o CEP:' + e.getMessage());
                     }
             	
             }
             if(!accountsToUpdate.IsEmpty()){
                 update accountsToUpdate;
             }
         }
    }
  
    
    public void finish(Database.BatchableContext bc){
        System.debug('Batch Job Finished');
    }
    
      
    public void execute(SchedulableContext sc){
        BatchVIACEP batch = new BatchVIACEP();
        Database.executeBatch(batch, 100);
    }
    
   
    public class ViaCEP{
        String cep;
        String logradouro;
        String complemento;
        String bairro;
        String localidade;
        String uf;
        String ibge;
        String gia;
        String ddd;
        String siafi;
    }
    


}