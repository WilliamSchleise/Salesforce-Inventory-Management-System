public class EstoqueServico {
    public static void atualizarEstoque(List<Movimentacao__c> movimentacoes) {

        Map<Id, Decimal> somaMovimentacoes = new Map<Id, Decimal>();

        for (Movimentacao__c mov : movimentacoes) {
            if (mov.ProdutoT__c == null || mov.Quantidade__c == null || mov.Tipo__c == null) continue;

            Decimal qtd = mov.Tipo__c == 'Entrada' ? mov.Quantidade__c : -mov.Quantidade__c;

            if (!somaMovimentacoes.containsKey(mov.ProdutoT__c)) {
                somaMovimentacoes.put(mov.ProdutoT__c, qtd);
            } else {
                somaMovimentacoes.put(mov.ProdutoT__c, somaMovimentacoes.get(mov.ProdutoT__c) + qtd);
            }
        }

        List<ProdutoT__c> produtos = [SELECT Id, Name, Estoque_Atual__c, Estoque_Minimo__c FROM ProdutoT__c
                                     WHERE Id IN : somaMovimentacoes.keySet()];

        List<ProdutoT__c> produtosParaAtualizar = new List<ProdutoT__c>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (ProdutoT__c prod : produtos) {
            Decimal novoEstoque = (prod.Estoque_Atual__c == null ? 0 : prod.Estoque_Atual__c) + somaMovimentacoes.get(prod.Id);
            prod.Estoque_Atual__c = novoEstoque;
            produtosParaAtualizar.add(prod);
            
            // Criar Task
            if (prod.Estoque_Minimo__c != null && novoEstoque < prod.Estoque_Minimo__c) {
   			 	Task alertaEstoque = new Task(
        		Subject = '⚠️ Estoque Baixo: ' + prod.Name,
        		Priority = 'Alta',
        		Status = 'Em Andamento',
        		WhatId = prod.Id,
        		OwnerId = UserInfo.getUserId(),
        		Description = 'Produto "' + prod.Name + '" abaixo do estoque mínimo. Atual: ' + 
                novoEstoque + ', Mínimo: ' + prod.Estoque_Minimo__c,
        		ActivityDate = Date.today().addDays(7)
    					);
    			insert alertaEstoque;
										}

            // Enviar e-mail se estoque estiver abaixo do mínimo
            if (prod.Estoque_Minimo__c != null && novoEstoque < prod.Estoque_Minimo__c) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { 'schleisewilliam@gmail.com' }); 
                email.setSubject('Estoque Baixo: ' + prod.Name);
                email.setPlainTextBody(
                    'O produto "' + prod.Name + '" está com estoque abaixo do mínimo.\n\n' +
                    'Estoque atual: ' + novoEstoque + '\n' +
                    'Estoque mínimo: ' + prod.Estoque_Minimo__c
                );
                emails.add(email);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

        update produtosParaAtualizar;
    }
}