// Seeds a minimal, realistic dataset for the Meridian Service Assistant
// (Agentforce) demo: one account, one network site, one service order in
// Provisioning stage, and three provisioning tasks -- one complete, one
// blocked, one pending -- so the agent has a real blocking scenario and a
// real pending-tasks scenario to talk about. Entirely fictional data.

Account demoAccount = new Account(
    Name = 'Bright Harbor Logistics'
);
insert demoAccount;

Network_Site__c site = new Network_Site__c(
    Account__c = demoAccount.Id
);
insert site;

Service_Order__c demoOrder = new Service_Order__c(
    Account__c = demoAccount.Id,
    Network_Site__c = site.Id,
    Stage__c = 'Provisioning',
    Order_Date__c = Date.today().addDays(-9)
);
insert demoOrder;

List<Provisioning_Task__c> tasks = new List<Provisioning_Task__c>();
tasks.add(new Provisioning_Task__c(
    Service_Order__c = demoOrder.Id,
    Task_Type__c = 'Site Survey',
    Status__c = 'Complete',
    Assigned_Queue__c = 'Provisioning',
    Due_Date__c = Date.today().addDays(-6)
));
tasks.add(new Provisioning_Task__c(
    Service_Order__c = demoOrder.Id,
    Task_Type__c = 'Equipment Install',
    Status__c = 'Blocked',
    Assigned_Queue__c = 'Provisioning',
    Due_Date__c = Date.today().addDays(-2)
));
tasks.add(new Provisioning_Task__c(
    Service_Order__c = demoOrder.Id,
    Task_Type__c = 'Configuration',
    Status__c = 'Not Started',
    Assigned_Queue__c = 'Provisioning',
    Due_Date__c = Date.today().addDays(3)
));
insert tasks;

System.debug('DEMO_ORDER_NAME=' + [SELECT Name FROM Service_Order__c WHERE Id = :demoOrder.Id].Name);
