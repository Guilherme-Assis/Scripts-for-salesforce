/**
 * @description       : 
 * @author            : Guilherme Assis
 * @group             : 
 * @last modified on  : 06-23-2021
 * @last modified by  : Guilherme Assis
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   06-23-2021   Guilherme Assis   Initial Version
**/

public with sharing class DeleteUserPartnerCommunity {

    String[] users = new String[] {'03186788960'}; //Colocar cpf aqui
    List<String> contactNames = new List<String>(); 
    List<Contact> contacts = [select id, isActive__c, name, profile__c from contact where cpf__c =: users and profile__c = 'Partner Community User'];

    for(Contact c : contacts){
    contactNames.add(c.name);
    }

    for(Contact c : contacts){
    c.isActive__c = false;
    }
    update contacts;
    
    // Inativa usuarios
    String[] names = new String[] {'André Santolin'}; //Colocar nomes aqui
    List<User> lUsers = [select id, name, isActive from user where name =: contactNames and profileId = '00e1C000001PQJAQA4'];
    
    for (User u : lUsers){
    u.isActive = false;
    u.IsPortalEnabled = false;
    }
    update lUsers;

}