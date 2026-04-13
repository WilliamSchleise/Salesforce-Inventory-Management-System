trigger MovimentacaoTrigger on Movimentacao__c (after insert) {
 EstoqueServico.atualizarEstoque(Trigger.new);
}
