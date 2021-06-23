/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-23-2021
 * @last modified by  : Guilherme Assis
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-23-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

//Remove duplicated leads

Savepoint sp = Database.setSavepoint();  

try 
{ 
    List<AggregateResult> lar = [SELECT MIN(Id) MinId, CPF__c FROM Lead GROUP BY CPF__c HAVING COUNT(Id) > 1 LIMIT 2000];

    if (lar.size() <= 0)
    {
        System.debug('DEBUGGER :: LISTA VAZIA ');
    }
    else 
    {
        Map<String, String> scpf = new Map<String, String>(); 

        for (AggregateResult ar : lar)
        {
            scpf.put((String) ar.get('CPF__c'), (String) ar.get('MinId'));

            System.debug('DEBUGGER :: CPF : ' + (String) ar.get('CPF__c'));
        }

        Map<String, Schema.SObjectField> fieldMap = CampaignMember.sObjectType.getDescribe().fields.getMap();
        Iterable<String> fieldNames = (Iterable<String>) fieldMap.keySet();

        String sqcm = ' SELECT Lead.CPF__c, ' + String.join(fieldNames, ',')
                    + ' FROM CampaignMember '
                    + ' WHERE Lead.CPF__c IN ' + Utils.getSetToQueryString(scpf.keySet());

        List<CampaignMember> lcm = Database.query(sqcm);

        Map<Id, CampaignMember> mncm = new Map<Id, CampaignMember>();

        for (CampaignMember cm : lcm)
        {
            CampaignMember ncm = cm.clone(false, true, true, true);
            ncm.LeadId = scpf.get(cm.Lead.CPF__c);

            mncm.put(cm.Id, ncm);

            System.debug('DEBUGGER :: CAMPAIGN MEMBER : ' + cm.Id + ' :: ' + ncm);
        }

        List<CampaignMember> ldcm = [SELECT Id FROM CampaignMember WHERE Id IN :mncm.keySet()];
        delete ldcm;

        insert mncm.values();
        
        List<CampaignMemberFilter__c> lcmf = [SELECT Id, CampaignMemberId__c FROM CampaignMemberFilter__c WHERE CampaignMemberId__c IN :mncm.keySet()];

        for (CampaignMemberFilter__c cmf : lcmf)
        {
            cmf.CampaignMemberId__c = mncm.get(cmf.CampaignMemberId__c).Id;

            System.debug('DEBUGGER :: CAMPAIGN MEMBER FILTER : ' + cmf);
        }

        update lcmf;

        List<Lead> lld = [SELECT Id FROM Lead WHERE CPF__c IN :scpf.keySet() AND Id NOT IN :scpf.values()];

        System.debug('DEBUGGER :: LEADS TO DELETE : ' + lld.size());

        delete lld;
    }
} 
catch (Exception ex) {
    Database.rollback(sp);

    System.debug('DEBUGGER :: EXCEPTION : ' + ex.getStackTraceString());
}
