public with sharing class accountclass
{
	@AuraEnabled
	public static List<account> getaccountController(){
		return [SELECT Id,name,email__c FROM account];
	}
}