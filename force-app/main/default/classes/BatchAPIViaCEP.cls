public class BatchVIACEP implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, BillingPostalCode 
            FROM Account 
            WHERE BillingPostalCode != null 
              AND LastModifiedDate = TODAY
        ]);
    }

    public void execute(Database.BatchableContext context, List<Account> scope) {
        List<Account> accountsToUpdate = new List<Account>();

        System.debug('Iniciando o processamento de ' + scope.size() + ' contas.');

        for (Account acc : scope) {
            try {

                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('https://viacep.com.br/ws/' + acc.BillingPostalCode + '/json/');
                req.setMethod('GET');
                req.setTimeout(5000); // 5 segundos

                HttpResponse res = h.send(req);

                if (res.getStatusCode() == 200 && !String.isBlank(res.getBody())) {
                    ViaCEP endereco = (ViaCEP) JSON.deserialize(res.getBody(), ViaCEP.class);

                    if (endereco != null && !String.isBlank(endereco.cep)) {
                        acc.BillingStreet = endereco.logradouro;
                        acc.BillingCity = endereco.localidade;
                        acc.BillingState = endereco.uf;
                        acc.BillingCountry = 'Brazil';
                        acc.BillingPostalCode = endereco.cep;

                        accountsToUpdate.add(acc);
                    }
                } else {
                    System.debug('Erro na resposta da API para o CEP: ' + acc.BillingPostalCode);
                }
                
            } catch (Exception e) {
                System.debug('Erro ao consultar o CEP ' + acc.BillingPostalCode + ': ' + e.getMessage());
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            try {
                update accountsToUpdate;
            } catch (DmlException dmlEx) {
                System.debug('Erro ao atualizar contas: ' + dmlEx.getMessage());
            }
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('BatchVIACEP finalizado com sucesso.');
    }

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchVIACEP(), 50);
    }

    public class ViaCEP {
        public String cep;
        public String logradouro;
        public String complemento;
        public String bairro;
        public String localidade;
        public String uf;
        public String ibge;
        public String gia;
        public String ddd;
        public String siafi;
    }
}