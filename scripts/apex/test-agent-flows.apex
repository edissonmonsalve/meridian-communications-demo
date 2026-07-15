// Exercises the 3 Meridian Service Assistant agent-action flows directly
// against the seeded demo data (SO-00001), the same way the Agentforce
// Action layer would invoke them. Uses Flow.Interview (no direct field
// references) so it is unaffected by the standard-API describe-cache issue.
// Prints outputs to debug log for verification.

Map<String, Object> statusParams = new Map<String, Object>{ 'orderNumber' => 'SO-00001' };
Flow.Interview statusInterview = Flow.Interview.createInterview('Meridian_Get_Service_Order_Status', statusParams);
statusInterview.start();
System.debug('STATUS_FOUND=' + statusInterview.getVariableValue('found'));
System.debug('STATUS_STAGE=' + statusInterview.getVariableValue('stage'));
System.debug('STATUS_HAS_BLOCKING=' + statusInterview.getVariableValue('hasBlockingTasks'));
System.debug('STATUS_SUMMARY=' + statusInterview.getVariableValue('blockingTaskSummary'));

Map<String, Object> pendingParams = new Map<String, Object>{ 'orderNumber' => 'SO-00001' };
Flow.Interview pendingInterview = Flow.Interview.createInterview('Meridian_List_Pending_Provisioning_Tasks', pendingParams);
pendingInterview.start();
System.debug('PENDING_FOUND=' + pendingInterview.getVariableValue('found'));
System.debug('PENDING_COUNT=' + pendingInterview.getVariableValue('taskCount'));
System.debug('PENDING_SUMMARY=' + pendingInterview.getVariableValue('taskListSummary'));

Map<String, Object> notFoundParams = new Map<String, Object>{ 'orderNumber' => 'SO-99999' };
Flow.Interview notFoundInterview = Flow.Interview.createInterview('Meridian_Get_Service_Order_Status', notFoundParams);
notFoundInterview.start();
System.debug('NOTFOUND_FOUND=' + notFoundInterview.getVariableValue('found'));
System.debug('NOTFOUND_SUMMARY=' + notFoundInterview.getVariableValue('blockingTaskSummary'));

Map<String, Object> escalateParams = new Map<String, Object>{
    'orderNumber' => 'SO-00001',
    'reason' => 'Equipment install is overdue and blocking activation; customer wants a status update from a human.'
};
Flow.Interview escalateInterview = Flow.Interview.createInterview('Meridian_Escalate_Service_Order', escalateParams);
escalateInterview.start();
System.debug('ESCALATE_SUCCESS=' + escalateInterview.getVariableValue('success'));
System.debug('ESCALATE_CASE_ID=' + escalateInterview.getVariableValue('caseNumber'));
System.debug('ESCALATE_LOG_ID=' + escalateInterview.getVariableValue('escalationNumber'));
System.debug('ESCALATE_MESSAGE=' + escalateInterview.getVariableValue('resultMessage'));
