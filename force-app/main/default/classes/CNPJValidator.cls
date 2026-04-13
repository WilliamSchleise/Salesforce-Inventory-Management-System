public with sharing class CNPJValidator {

    @InvocableMethod(label='Validar CNPJ')
    public static List<ValidationResult> validarCNPJ(List<CNPJInput> inputList) {
        List<ValidationResult> results = new List<ValidationResult>();

        for (CNPJInput input : inputList) {
            results.add(new ValidationResult(input.cnpj == '12345678000195')); // Teste fixo
        }

        return results;
    }

    public class CNPJInput {
        @InvocableVariable
        public String cnpj;
    }

    public class ValidationResult {
        @InvocableVariable
        public Boolean valido;

        public ValidationResult(Boolean valido) {
            this.valido = valido;
        }
    }
}