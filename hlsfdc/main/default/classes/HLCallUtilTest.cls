/* -*- Mode: java; -*- */

/**
 * HLCallUtilTest.cls
 *
 * Copyright (c) 2017 HelpLightning Inc.
 * https://helplightning.com
 */

@isTest
private class HLCallUtilTest {

    /**
     * Find a call match for an HLCall that:
     *  - has never been matched on (doesn't have a callId yet)
     *  - is already complete
     *  - is successful
     * This should mark the call as a successful,
     *  completed call, and fill in the callId, duration,
     *  endTime, and other important values.
     */
    @isTest
    static void testFindCallMatchCompleted() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0));

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, true);
            System.assertEquals(result.helplightning__Duration__c, 360);
        }
    }

    /**
     * Find a call match for an HLCall that:
     *  - has never been matched on (doesn't have a callId yet)
     *  - is already complete
     *  - is successful
     *  - the email doesn't match exactly (different case)
     * This should mark the call as a successful,
     *  completed call, and fill in the callId, duration,
     *  endTime, and other important values.
     */
    @isTest
    static void testFindCallMatchCompletedCaseInsensitive() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0));

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'SUPPORT@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, true);
            System.assertEquals(result.helplightning__Duration__c, 360);
        }
    }


    /**
     * Try to find a match for an HLCall that:
     *  - started more than 3 minutes ago
     *  - has never been matched on (doesn't have a callId yet)
     *  - is NOT in our list of calls
     * This should give up, mark the call as a
     *  completed and failed call.
     */
    @isTest
    static void testFindCallWithoutMatchTimeout() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0));

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>();

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, null);
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, false);
            System.assertEquals(result.helplightning__Duration__c, 0);
        }
    }

    /**
     * Try to find a match for an HLCall that:
     *  - started less than 3 minutes ago
     *  - has never been matched on (doesn't have a callId yet)
     *  - is NOT in our list of calls
     * This should return a null object, indicating that
     *  it didn't find a match, but is too early to give up on.
     */
    @isTest
    static void testFindCallWithoutMatch() {
        // create a call for right now
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.now());

        // no matched calls
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>();

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    /**
     * Try to find a match for an HLCall that:
     *  - started less than 3 minutes ago
     *  - has never been matched on (doesn't have a callId yet)
     *  - is NOT in our list of calls
     * This should return a null object, indicating that
     *  it didn't find a match, but is too early to give up on.
     * This is the same as the above test, except we provide
     *  a list of several possibilities that don't match.
     */
    @isTest
    static void testFindCallWithoutMatch2() {
        // create a call for right now
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.now());

        // no matched calls
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', 'aabb',
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 20, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 22, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com')),
                new helplightning.HLModelCall('aabbccdd', 'ccdd',
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 25, 31),
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 26, 0),
                                              true, 0, false,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))

        };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    /**
     * Try to find a match for an HLCall that:
     *  - has already been matched on (has a valid callId)
     *  - has not yet been marked as complete
     *  - is IN our list of calls
     *  - is NOT yet complete
     * This should return a call object with no
     *  additional information filled in, since it
     *  isn't complete yet.
     */
    @isTest
    static void testFindMatchedCallIncomplete() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0),
                                                                     helplightning__HLCall_Id__c = '1234');

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              null,
                                              false, 0, false,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, false);
            System.assertEquals(result.helplightning__Successful__c, false);
            System.assertEquals(result.helplightning__Duration__c, null);
        }
    }

    /**
     * Try to find a match for an HLCall that:
     *  - has already been matched on (has a valid callId)
     *  - has not yet been marked as complete
     *  - is IN our list of calls
     *  - IS complete
     * This should return a call object and mark
     *  the call as complete, successful, and fill in
     *  additional information.
     */
    @isTest
    static void testFindMatchedCallComplete() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0),
                                                                     helplightning__HLCall_Id__c = '1234');

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 360, false,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, false);
            System.assertEquals(result.helplightning__Duration__c, 360);
        }
    }

    /**
     * Try to find a call where our user
     *  is the receiever instead of the dialer
     */
    @isTest
    static void testFindMatchedCallAsReceiver() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0));

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, true);
            System.assertEquals(result.helplightning__Duration__c, 360);
        }
    }

    /**
     * Include in the search list a call where
     *  we are neither the dialer or reciever.
     * This call should just be skipped.
     */
    @isTest
    static void testInvalidDialerReciever() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.now());

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('14', 'User1',
                                                                                'user1@helplightning.com'),
                                              new helplightning.HLModelCallUser('4', 'User2',
                                                                                'user2@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    /**
     * Test where our list of possible calls
     *  has multiple that could match based on
     *  the start time.
     * This should return the call with the closest
     *  start time.
     */
    @isTest
    static void testMultipleMatches() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0));

        // mock up some help lightning calls that the api would have returned
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', 'aabbcc',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 45, 50),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 50, 34),
                                              true, 284, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com')),
                new helplightning.HLModelCall('aabbccdd', '1234',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 52, 0),
                                              true, 360, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com')),
                new helplightning.HLModelCall('aabbccdd', 'xxyyzz',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 12),
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 56, 32),
                                              true, 620, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertNotEquals(result, null);
            System.assertEquals(result.helplightning__HLCall_Id__c, '1234');
            System.assertEquals(result.helplightning__Complete__c, true);
            System.assertEquals(result.helplightning__Successful__c, true);
            System.assertEquals(result.helplightning__Duration__c, 360);
        }
    }

    /**
     * Try to match an HLCall that:
     *  - matches us as the dialer
     *  - incorrectly matches the receiver
     * This should return a NULL call
     */
    @isTest
    static void testMatchInvalidReceiver() {
        // create a call for right now
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.now());

        // no matched calls
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', 'aabb',
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 20, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 22, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('xx', 'Invalid',
                                                                                'invalid-contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    /**
     * Try to match an HLCall that:
     *  - matches us as the receiver
     *  - incorrectly matches the dialer
     * This should return a NULL call
     */
    @isTest
    static void testMatchInvalidDialer() {
        // create a call for right now
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.now());

        // no matched calls
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', 'aabb',
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 20, 1),
                                              DateTime.newInstanceGmt(2016, 10, 14, 10, 22, 0),
                                              true, 6 * 60, true,
                                              new helplightning.HLModelCallUser('xx', 'Invalid',
                                                                                'invalid-contact@helplightning.com'),
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    /**
     * Try to match an HLCall that:
     *  - we already have a callId for
     *  - the callId we are trying to match for
     *    isn't in our list of calls.
     * This should return NULL
     */
    @isTest
    static void testMissingMatchedCall() {
        helplightning__HLCall__c call = new helplightning__HLCall__c(helplightning__Contact_Email__c = 'contact@helplightning.com',
                                                                     helplightning__Start_Time__c = DateTime.newInstanceGMT(2016, 10, 14, 11, 46, 0),
                                                                     helplightning__HLCall_Id__c = '1234');

        // mock up some help lightning calls that the api would have returned
        // Don't include 1234
        List<helplightning.HLModelCall> hlCalls = new List<helplightning.HLModelCall>{
                new helplightning.HLModelCall('aabbccdd', 'aabb',
                                              DateTime.newInstanceGmt(2016, 10, 14, 11, 46, 1),
                                              null,
                                              false, 0, false,
                                              new helplightning.HLModelCallUser('12', 'Support',
                                                                                'support@helplightning.com'),
                                              new helplightning.HLModelCallUser('32', 'Contact',
                                                                                'contact@helplightning.com'))
            };

        // run as a support@helplightning.com user, since this
        //  looks up the current user to find a match.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'support', Email='support@helplightning.com',
                          EmailEncodingKey='UTF-8', LastName='Support', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='GMT', UserName='support@helplightning.com');

        System.runAs(u) {
            helplightning__HLCall__c result = helplightning.HLCallUtil.findCallMatch(call, hlCalls);

            System.assertEquals(result, null);
        }
    }

    @isTest
    static void testBuildEmptyCall() {
        Map<String, Object> emptyCall = new Map<String, Object>();
        helplightning.HLModelCall result = helplightning.HLModelCall.build(emptyCall);
        System.assertEquals(result, null);
    }
}
