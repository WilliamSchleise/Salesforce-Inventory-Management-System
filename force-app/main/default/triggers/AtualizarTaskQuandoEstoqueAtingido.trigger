trigger AtualizarTaskQuandoEstoqueAtingido on Pedido__c (after update) {
     Set<Id> produtosIds = new Set<Id>();
    List<Task> tasksParaCompletar = new List<Task>();

    for (Pedido__c pedido : Trigger.new) {
        Pedido__c pedidoAntigo = Trigger.oldMap.get(pedido.Id);

        if (!pedidoAntigo.Aprovado__c && pedido.Aprovado__c && pedido.ProdutoT__c != null) {
            produtosIds.add(pedido.ProdutoT__c);
        }
    }

    Map<Id, ProdutoT__c> produtosMap = new Map<Id, ProdutoT__c>(
        [SELECT Id, Estoque_Atual__c, Estoque_Minimo__c FROM ProdutoT__c WHERE Id IN : produtosIds]
    );

    for (Pedido__c pedido : Trigger.new) {
        Pedido__c pedidoAntigo = Trigger.oldMap.get(pedido.Id);

        if (!pedidoAntigo.Aprovado__c && pedido.Aprovado__c && pedido.ProdutoT__c != null) {
            ProdutoT__c produto = produtosMap.get(pedido.ProdutoT__c);

            if (produto != null) {
                Decimal estoqueSimulado = produto.Estoque_Atual__c + pedido.Quantidade__c;

                if (produto.Estoque_Atual__c < produto.Estoque_Minimo__c &&
                    estoqueSimulado >= produto.Estoque_Minimo__c) {

                    
                    List<Task> tarefas = [
                        SELECT Id, Status
                        FROM Task
                        WHERE WhatId = :pedido.ProdutoT__c AND Status != 'Completed'
                        LIMIT 1
                    ];

                    for (Task t : tarefas) {
                        t.Status = 'Completed';
                        tasksParaCompletar.add(t);
                    }
                }
            }
        }
    }

    if (!tasksParaCompletar.isEmpty()) {
        update tasksParaCompletar;
    }

}