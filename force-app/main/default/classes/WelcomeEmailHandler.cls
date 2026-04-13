public class WelcomeEmailHandler {
    public static void sendWelcomeEmail(List<Account> newAccounts) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : newAccounts) {
            if (acc.Email__c != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { acc.Email__c });
                email.setSubject('Bem-vindo à nossa organização!');
                email.setPlainTextBody('Olá ' + acc.Name + ',\n\nBem-vindo! Sua conta foi criada com sucesso.');
                emails.add(email);
                System.debug('Enviando e-mail para: ' + acc.Email__c);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}