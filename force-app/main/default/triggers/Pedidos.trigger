trigger Pedidos on Pedido__c (after update) { 
    List<Movimentacao__c> movimentacoesParaCriar = new List<Movimentacao__c>();

    for (Pedido__c pedido : Trigger.new) {
        Pedido__c pedidoAntigo = Trigger.oldMap.get(pedido.Id);

        
        if (!pedidoAntigo.Aprovado__c && pedido.Aprovado__c) {
            
            
				ProdutoT__c produto = [
    			SELECT Id, Estoque_Atual__c, Estoque_minimo__c
    			FROM ProdutoT__c
    			WHERE Id = :pedido.ProdutoT__c
    			LIMIT 1
				];

          
            Movimentacao__c mov = new Movimentacao__c();
            mov.Name = pedido.Nome_do_Produto__c;
            mov.ProdutoT__c = pedido.ProdutoT__c;
            mov.Quantidade__c = pedido.Quantidade__c;
            mov.Tipo__c = 'Entrada'; 
            mov.Data_da_Movimentacao__c = Date.today();
            mov.Pedido__c = pedido.Id; 

            movimentacoesParaCriar.add(mov);
            
               if (produto.Estoque_Atual__c + pedido.Quantidade__c >= produto.Estoque_minimo__c) {
    			List<Task> tarefas = [
        		SELECT Id, Status
        		FROM Task
        		WHERE WhatId = :produto.Id AND Status != 'Completed'
    			];
    
    		for (Task t : tarefas) {
        	t.Status = 'Completed';
    				}
    
    			update tarefas;
				}
            
            
        }
        
    }

    if (!movimentacoesParaCriar.isEmpty()) {
        insert movimentacoesParaCriar;
    }


}