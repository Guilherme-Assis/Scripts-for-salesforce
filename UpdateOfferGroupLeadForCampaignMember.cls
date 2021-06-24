/**
 * @description       : 
 * @author            : Guilherme Assis
 * @group             : 
 * @last modified on  : 06-24-2021
 * @last modified by  : Guilherme Assis
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   06-24-2021   Guilherme Assis   Initial Version
**/
Savepoint sp = Database.setSavepoint();

try 
{
    List<CampaignMember> lcm = [SELECT Id, LeadId, TaskId__c FROM CampaignMember WHERE CampaignId = '7014R000002G4OVQA0' AND TaskId__c <> null AND LeadId <> null LIMIT 2000];

    Map<String, String> mcmt = new Map<String, String>();

    for (CampaignMember cm : lcm)
    {
        mcmt.put(cm.TaskId__c, cm.LeadId);

        System.debug('DEBUGGER :: TASK : ' + cm.TaskId__c + ' :: LEAD : ' + cm.LeadId);
    }

    List<Task> lt = [SELECT Id, OfferGroup__c FROM Task WHERE Id IN :mcmt.keySet() AND OfferGroup__c <> null];

    Map<String, String> mtog = new Map<String, String>();

    for (Task t : lt)
    {
        mtog.put(t.OfferGroup__c, t.Id);

        System.debug('DEBUGGER :: OFFER GROUP : ' + t.OfferGroup__c + ' :: TASK : ' + t.Id);
    }

    List<OfferGroup__c> log = [SELECT Id, Lead__c FROM OfferGroup__c WHERE Id IN :mtog.keySet() AND Lead__c = null];

    Integer countLead = 0;
    for (OfferGroup__c og : log)
    {
        if (mcmt.containsKey(mtog.get(og.Id)))
        {
            countLead++;
            og.Lead__c = mcmt.get(mtog.get(og.Id));

            System.debug('DEBUGGER :: OFFER GROUP : ' + og.Id + ' :: LEAD : ' + og.Lead__c);
        }
    }

    update log;

    System.debug('DEBUGGER :: OFFER GROUP UPDATED : ' + countLead);
} 
catch (Exception ex) {
    Database.rollback(sp);

    System.debug('DEBUGGER :: EXCEPTION : ' + ex.getStackTraceString());
}