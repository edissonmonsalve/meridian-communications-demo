// Invokes the Meridian_Seed_Demo_Data autolaunched flow. Uses Flow.Interview
// with no typed field references so it is unaffected by the Network_Site__c /
// Service_Order__c.Network_Site__c standard-API describe-cache issue that
// blocks direct Apex/SOQL field access to those fields in this org.
Flow.Interview.createInterview('Meridian_Seed_Demo_Data', new Map<String, Object>()).start();
