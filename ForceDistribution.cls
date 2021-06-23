/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-23-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   06-23-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
//Variables 
String campaignId = '00v4R0000237RK6QAM';
String taskId = '00T4R00005BjlRzUAJ';
String newSeller = '0031500001vD4VOAA0';

//Querys
CampaignMemberFilter__c lCampaignFilter = [select id, salesRep__c from campaignMemberFilter__c where campaignMemberId__c =:campaignId];
campaignMember lCampaignMember = [select id, salesRep__c from campaignMember where id =:campaignId];
task lTask = [select Id, OwnerId from task where id =:taskId];

//updates
public void updateCampaignMemberFilter(){
    lCampaignFilter.salesRep__c = newSeller;
    update lCampaignFilter;
}

public void updateCampaignMember(){
    lCampaignMember.salesRep__c = newSeller;
    update lCampaignMember;
}

public void updateTask(){
    lTask.OwnerId = newSeller;
    update lTask;
}

updateCampaignMemberFilter();
updateCampaignMember();
updateTask();
