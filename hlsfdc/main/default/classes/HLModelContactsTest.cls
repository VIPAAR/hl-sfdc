
/* -*- Mode: java; -*- */

/**
 * HLModelContactsTest.cls
 *
 * Copyright (c) 2017 HelpLightning Inc.
 * https://helplightning.com
 */

@isTest
public class HLModelContactsTest {
    @isTest
    static void testBuild() {
        Object o = JSON.deserializeUntyped(HLModelContactsTest.resultsMany);
        helplightning.HLModelContacts u = helplightning.HLModelContacts.build(o);

        System.assertEquals(u.page, 1);
        System.assertEquals(u.pageSize, 20);
        System.assertEquals(u.totalEntries, 2);
        System.assertEquals(u.totalPages, 1);
    }

    private static String resultsMany = '{"entries":[{"id":3,"name": "Small Admin","username":"small_admin","avatar":{"url":null},"email":"small_admin@helplightning.com"}],"page":1,"page_size":20,"total_entries":2,"total_pages":1}';

}