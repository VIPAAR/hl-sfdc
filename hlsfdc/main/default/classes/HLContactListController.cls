/* -*- Mode: java; -*- */

/**
 * HLContactListController.cls
 *
 * Copyright (c) 2021 HelpLightning Inc.
 * https://helplightning.com
 */
public with sharing class HLContactListController {
    /**
     * Get the contact list and filter by search term
     */

    @AuraEnabled(cacheable=true)
    public static helplightning.HLModelContacts getContacts(string searchTerm, string pageNumber) {
        try {

            // Gets all users/contacts for the enterprise. Might need to change to /contacts endpoint if this doesn't fit user case.
            helplightning.HLModelContacts contacts = helplightning.HLGaldrClient.searchContacts(searchTerm, pageNumber);
            return contacts;

        } catch (helplightning.HLConfigurationException e) {
            throw new AuraHandledException('The Help Lightning component must be configured first.');
        }
    }
}