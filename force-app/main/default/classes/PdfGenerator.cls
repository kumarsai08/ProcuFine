public with sharing class PdfGenerator
{
	@AuraEnabled
	public static List<quote> getContactsController(){
		return [SELECT Id, Supplier__c, warehouse__c FROM Quote];
	}
}