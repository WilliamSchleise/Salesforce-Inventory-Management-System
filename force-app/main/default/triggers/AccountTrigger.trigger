trigger AccountTrigger on Account (after insert) {
    WelcomeEmailHandler.sendWelcomeEmail((List<Account>)Trigger.new);
}
