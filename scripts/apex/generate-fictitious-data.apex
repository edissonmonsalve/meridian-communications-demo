/**
 * Meridian Communications — fictitious data generator.
 *
 * Run once against a freshly deployed Scratch Org:
 *   sf apex run --file scripts/apex/generate-fictitious-data.apex
 *
 * Entirely synthetic data for a fictional company. No client data, no real
 * people, no real companies. Safe to run repeatedly on a disposable Scratch
 * Org (it does not check for existing data / is not idempotent — intended
 * for a clean org).
 *
 * Populates, in dependency order:
 *   Accounts (Business Customer + Partner-Reseller, split across regions)
 *   -> Contacts, Network Sites, Billing Accounts
 *   Product2 (service catalog)
 *   Opportunities (some Closed Won)
 *   -> Service Orders (+ line items, some over the 20% discount threshold
 *      on purpose, to exercise the Discount Approval process)
 *   Service Subscriptions
 *   Cases (+ a handful of Critical/Escalated ones to exercise the SLA
 *      Breach Monitor and the Case Sharing Rule)
 *
 * Provisioning_Task__c records are intentionally NOT created here — they
 * are generated automatically by Service_Order_Fulfillment_Orchestration
 * when the Service Orders below are inserted, which also doubles as a live
 * smoke test of that flow.
 */

Integer NORTH_ACCOUNTS = 6;
Integer SOUTH_ACCOUNTS = 6;
Integer PARTNER_ACCOUNTS = 3;

List<String> northCityState = new List<String>{
  'Bristonville, Cape Aldren',
  'Fenwick Bay, Cape Aldren',
  'Harrowgate, Cape Aldren',
  'Millbrook Crossing, Cape Aldren',
  'Stonefield, Cape Aldren',
  'Ashcombe, Cape Aldren'
};
List<String> southCityState = new List<String>{
  'Port Delmara, Verrin Coast',
  'Calder Springs, Verrin Coast',
  'Thornbury, Verrin Coast',
  'Wrenfield, Verrin Coast',
  'Oakhaven, Verrin Coast',
  'Brackenridge, Verrin Coast'
};

List<String> businessNames = new List<String>{
  'Northgate Logistics',
  'Aldren Manufacturing Co',
  'Bristonville Medical Group',
  'Fenwick Retail Partners',
  'Harrowgate Financial Services',
  'Millbrook Data Systems',
  'Stonefield Construction',
  'Ashcombe Hospitality Group',
  'Delmara Shipping Co',
  'Calder Springs Utilities',
  'Thornbury Legal Associates',
  'Wrenfield Educational Trust'
};

List<String> partnerNames = new List<String>{
  'Coastal Connect Resellers',
  'Verrin Technology Partners',
  'Aldren Channel Solutions'
};

// ---------------------------------------------------------------------
// Record Types
// ---------------------------------------------------------------------
Id rtAccountBusiness = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
  .get('Business_Customer')
  .getRecordTypeId();
Id rtAccountPartner = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
  .get('Partner_Reseller')
  .getRecordTypeId();

Id rtCaseOutage = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
  .get('Service_Outage')
  .getRecordTypeId();
Id rtCaseBilling = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
  .get('Billing_Inquiry')
  .getRecordTypeId();
Id rtCaseProvisioning = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
  .get('Provisioning_Request')
  .getRecordTypeId();
Id rtCaseGeneral = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
  .get('General_Support')
  .getRecordTypeId();
List<Id> caseRecordTypes = new List<Id>{
  rtCaseOutage,
  rtCaseBilling,
  rtCaseProvisioning,
  rtCaseGeneral
};

Id rtOrderNew = Schema.SObjectType.Service_Order__c.getRecordTypeInfosByDeveloperName()
  .get('New_Service')
  .getRecordTypeId();
Id rtOrderUpgrade = Schema.SObjectType.Service_Order__c.getRecordTypeInfosByDeveloperName()
  .get('Upgrade')
  .getRecordTypeId();
Id rtOrderCancel = Schema.SObjectType.Service_Order__c.getRecordTypeInfosByDeveloperName()
  .get('Cancellation')
  .getRecordTypeId();

// ---------------------------------------------------------------------
// Accounts
// ---------------------------------------------------------------------
List<Account> accounts = new List<Account>();

for (Integer i = 0; i < NORTH_ACCOUNTS; i++) {
  accounts.add(
    new Account(
      Name = businessNames[i],
      RecordTypeId = rtAccountBusiness,
      Type = 'Business Customer',
      Region__c = 'North',
      BillingCity = northCityState[i].split(',')[0],
      BillingState = 'Cape Aldren'
    )
  );
}
for (Integer i = 0; i < SOUTH_ACCOUNTS; i++) {
  accounts.add(
    new Account(
      Name = businessNames[NORTH_ACCOUNTS + i],
      RecordTypeId = rtAccountBusiness,
      Type = 'Business Customer',
      Region__c = 'South',
      BillingCity = southCityState[i].split(',')[0],
      BillingState = 'Verrin Coast'
    )
  );
}
for (Integer i = 0; i < PARTNER_ACCOUNTS; i++) {
  accounts.add(
    new Account(
      Name = partnerNames[i],
      RecordTypeId = rtAccountPartner,
      Type = 'Partner-Reseller',
      Region__c = (Math.mod(i, 2) == 0) ? 'North' : 'South'
    )
  );
}
insert accounts;

List<Account> businessAccounts = new List<Account>();
for (Account a : accounts) {
  if (a.RecordTypeId == rtAccountBusiness) {
    businessAccounts.add(a);
  }
}

// ---------------------------------------------------------------------
// Contacts (2 per business account)
// ---------------------------------------------------------------------
List<String> firstNames = new List<String>{
  'Jordan',
  'Casey',
  'Morgan',
  'Riley',
  'Avery',
  'Quinn',
  'Reese',
  'Skyler',
  'Rowan',
  'Dakota',
  'Emerson',
  'Finley'
};
List<String> lastNames = new List<String>{
  'Whitfield',
  'Ashby',
  'Marlowe',
  'Sutcliffe',
  'Delacroix',
  'Fenwick',
  'Harrow',
  'Brannigan',
  'Colbourne',
  'Radcliffe',
  'Sinclair',
  'Tremaine'
};

List<Contact> contacts = new List<Contact>();
Integer nameIdx = 0;
for (Account acc : businessAccounts) {
  for (Integer j = 0; j < 2; j++) {
    contacts.add(
      new Contact(
        AccountId = acc.Id,
        FirstName = firstNames[Math.mod(nameIdx, firstNames.size())],
        LastName = lastNames[Math.mod(nameIdx, lastNames.size())],
        Title = (j == 0) ? 'IT Director' : 'Accounts Payable Manager',
        Email = 'contact' + nameIdx + '@example-meridian-demo.invalid'
      )
    );
    nameIdx++;
  }
}
insert contacts;

// ---------------------------------------------------------------------
// Network Sites (1-2 per business account)
// ---------------------------------------------------------------------
List<Network_Site__c> sites = new List<Network_Site__c>();
for (Account acc : businessAccounts) {
  Integer siteCount = (Math.mod(nameIdx, 2) == 0) ? 1 : 2;
  for (Integer s = 0; s < siteCount; s++) {
    sites.add(
      new Network_Site__c(
        Account__c = acc.Id,
        Site_Name__c = acc.Name + ' - Site ' + (s + 1),
        Street__c = (100 + s) + ' Meridian Way',
        City__c = acc.BillingCity,
        State_Province__c = acc.BillingState,
        Postal_Code__c = '9' + String.valueOf(10000 + sites.size()).right(4),
        Country__c = 'Kestrelia'
      )
    );
  }
}
insert sites;

Map<Id, List<Network_Site__c>> sitesByAccount = new Map<Id, List<Network_Site__c>>();
for (Network_Site__c site : sites) {
  if (!sitesByAccount.containsKey(site.Account__c)) {
    sitesByAccount.put(site.Account__c, new List<Network_Site__c>());
  }
  sitesByAccount.get(site.Account__c).add(site);
}

// ---------------------------------------------------------------------
// Billing Accounts (1 per business account)
// ---------------------------------------------------------------------
List<String> paymentTerms = new List<String>{
  'Net 15',
  'Net 30',
  'Net 45',
  'Net 60'
};
List<Billing_Account__c> billingAccounts = new List<Billing_Account__c>();
Integer bIdx = 0;
for (Account acc : businessAccounts) {
  billingAccounts.add(
    new Billing_Account__c(
      Account__c = acc.Id,
      Payment_Terms__c = paymentTerms[Math.mod(bIdx, paymentTerms.size())],
      Currency_Code__c = 'USD'
    )
  );
  bIdx++;
}
insert billingAccounts;

// ---------------------------------------------------------------------
// Product catalog
// ---------------------------------------------------------------------
List<Product2> products = new List<Product2>{
  new Product2(
    Name = 'Dedicated Internet Access - 100Mbps',
    IsActive = true,
    ProductCode = 'DIA-100'
  ),
  new Product2(
    Name = 'Dedicated Internet Access - 1Gbps',
    IsActive = true,
    ProductCode = 'DIA-1000'
  ),
  new Product2(
    Name = 'SIP Trunking - 10 Channels',
    IsActive = true,
    ProductCode = 'VOICE-10'
  ),
  new Product2(
    Name = 'Managed Firewall',
    IsActive = true,
    ProductCode = 'SEC-FW'
  ),
  new Product2(
    Name = 'Cloud Backup - 1TB',
    IsActive = true,
    ProductCode = 'BKUP-1TB'
  )
};
insert products;

// ---------------------------------------------------------------------
// Opportunities (1-2 per business account, most Closed Won)
// ---------------------------------------------------------------------
List<Opportunity> opportunities = new List<Opportunity>();
Integer oppIdx = 0;
for (Account acc : businessAccounts) {
  Integer oppCount = (Math.mod(oppIdx, 3) == 0) ? 2 : 1;
  for (Integer o = 0; o < oppCount; o++) {
    Boolean closedWon = Math.mod(oppIdx, 4) != 0; // 75% closed won
    opportunities.add(
      new Opportunity(
        AccountId = acc.Id,
        Name = acc.Name + ' - Connectivity Deal ' + (o + 1),
        StageName = closedWon ? 'Closed Won' : 'Prospecting',
        CloseDate = closedWon
          ? Date.today().addDays(-30)
          : Date.today().addDays(30),
        Has_Service_Order__c = false
      )
    );
    oppIdx++;
  }
}
insert opportunities;

List<Opportunity> closedWonOpps = new List<Opportunity>();
for (Opportunity o : opportunities) {
  if (o.StageName == 'Closed Won') {
    closedWonOpps.add(o);
  }
}

// ---------------------------------------------------------------------
// Service Orders + Line Items
// ---------------------------------------------------------------------
List<String> orderStages = new List<String>{
  'Submitted',
  'Provisioning',
  'Active',
  'Active',
  'Suspended'
};
List<Service_Order__c> orders = new List<Service_Order__c>();
Integer soIdx = 0;
for (Opportunity opp : closedWonOpps) {
  List<Network_Site__c> accSites = sitesByAccount.get(opp.AccountId);
  Id chosenRecordType = rtOrderNew;
  if (Math.mod(soIdx, 5) == 3) {
    chosenRecordType = rtOrderUpgrade;
  }
  if (Math.mod(soIdx, 7) == 5) {
    chosenRecordType = rtOrderCancel;
  }

  orders.add(
    new Service_Order__c(
      Account__c = opp.AccountId,
      Opportunity__c = opp.Id,
      RecordTypeId = chosenRecordType,
      Stage__c = orderStages[Math.mod(soIdx, orderStages.size())],
      Order_Date__c = Date.today().addDays(-Math.mod(soIdx, 60)),
      Network_Site__c = (accSites != null && !accSites.isEmpty())
        ? accSites[0].Id
        : null
    )
  );
  soIdx++;
}
insert orders;

List<Service_Order_Line__c> lines = new List<Service_Order_Line__c>();
Integer lineIdx = 0;
for (Service_Order__c ord : orders) {
  Integer lineCount = (Math.mod(lineIdx, 3) == 0) ? 1 : 2;
  for (Integer l = 0; l < lineCount; l++) {
    Decimal discount = 5;
    // Every 6th line gets a discount above the 20% approval threshold,
    // to exercise Service_Order_Discount_Approval_Router / the approval process.
    if (Math.mod(lineIdx, 6) == 0) {
      discount = 25;
    } else if (Math.mod(lineIdx, 3) == 0) {
      discount = 12;
    }
    lines.add(
      new Service_Order_Line__c(
        Service_Order__c = ord.Id,
        Product__c = products[Math.mod(lineIdx, products.size())].Id,
        Quantity__c = 1,
        Unit_Price__c = 250 + (Math.mod(lineIdx, 5) * 75),
        Discount_Percent__c = discount
      )
    );
    lineIdx++;
  }
}
insert lines;

// ---------------------------------------------------------------------
// Service Subscriptions (2-3 per business account)
// ---------------------------------------------------------------------
List<String> serviceTypes = new List<String>{
  'Internet',
  'Voice',
  'Managed Security',
  'Cloud Backup'
};
List<String> subStatuses = new List<String>{
  'Active',
  'Active',
  'Active',
  'Suspended',
  'Cancelled'
};
List<Service_Subscription__c> subscriptions = new List<Service_Subscription__c>();
Integer subIdx = 0;
for (Account acc : businessAccounts) {
  Integer subCount = 2 + Math.mod(subIdx, 2); // 2 or 3
  for (Integer s = 0; s < subCount; s++) {
    subscriptions.add(
      new Service_Subscription__c(
        Account__c = acc.Id,
        Service_Type__c = serviceTypes[Math.mod(subIdx, serviceTypes.size())],
        Status__c = subStatuses[Math.mod(subIdx, subStatuses.size())],
        Start_Date__c = Date.today().addMonths(-Math.mod(subIdx, 24)),
        Monthly_Recurring_Revenue__c = 300 + (Math.mod(subIdx, 8) * 125)
      )
    );
    subIdx++;
  }
}
insert subscriptions;

// ---------------------------------------------------------------------
// Cases (2-4 per business account, a handful Critical/Escalated)
// ---------------------------------------------------------------------
List<String> caseSubjects = new List<String>{
  'Intermittent packet loss on primary circuit',
  'Invoice discrepancy on latest billing cycle',
  'Request to add a second network site',
  'General question about service upgrade options',
  'Firewall rule change request',
  'Voice trunk one-way audio issue'
};
List<Case> cases = new List<Case>();
Integer caseIdx = 0;
for (Account acc : businessAccounts) {
  Integer caseCount = 2 + Math.mod(caseIdx, 3); // 2, 3, or 4
  for (Integer c = 0; c < caseCount; c++) {
    Id chosenRt = caseRecordTypes[Math.mod(caseIdx, caseRecordTypes.size())];
    Boolean makeCriticalEscalated = (chosenRt == rtCaseOutage &&
    Math.mod(caseIdx, 5) == 0);
    Case newCase = new Case(
      AccountId = acc.Id,
      RecordTypeId = chosenRt,
      Subject = caseSubjects[Math.mod(caseIdx, caseSubjects.size())],
      Priority = makeCriticalEscalated
        ? 'Critical'
        : (Math.mod(caseIdx, 3) == 0 ? 'High' : 'Medium'),
      Status = makeCriticalEscalated ? 'Escalated' : 'New',
      Origin = 'Phone'
    );
    if (
      chosenRt == rtCaseOutage &&
      (makeCriticalEscalated || Math.mod(caseIdx, 4) == 1)
    ) {
      // Give SLA-relevant outage cases a target so SLA_Breach_Monitor has data to act on.
      newCase.SLA_Target_DateTime__c = DateTime.now()
        .addHours(-2 - Math.mod(caseIdx, 10));
    }
    cases.add(newCase);
    caseIdx++;
  }
}
insert cases;

// ---------------------------------------------------------------------
// Summary
// ---------------------------------------------------------------------
System.debug('=== Meridian Communications fictitious data load complete ===');
System.debug(
  'Accounts: ' +
    accounts.size() +
    ' (' +
    businessAccounts.size() +
    ' business customers, ' +
    PARTNER_ACCOUNTS +
    ' partners)'
);
System.debug('Contacts: ' + contacts.size());
System.debug('Network Sites: ' + sites.size());
System.debug('Billing Accounts: ' + billingAccounts.size());
System.debug('Products: ' + products.size());
System.debug(
  'Opportunities: ' +
    opportunities.size() +
    ' (' +
    closedWonOpps.size() +
    ' Closed Won)'
);
System.debug('Service Orders: ' + orders.size());
System.debug('Service Order Lines: ' + lines.size());
System.debug('Service Subscriptions: ' + subscriptions.size());
System.debug('Cases: ' + cases.size());
System.debug('Note: Provisioning_Task__c records are created automatically by');
System.debug(
  'Service_Order_Fulfillment_Orchestration as a side effect of the Service Order inserts above.'
);
