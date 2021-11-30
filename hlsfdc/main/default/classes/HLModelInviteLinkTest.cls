/* -*- Mode: java; -*- */

/**
 * HLModelInviteLinkTest.cls
 *
 * Copyright (c) 2017 HelpLightning Inc.
 * https://helplightning.com
 */

@isTest
public class HLModelInviteLinkTest {
    @isTest
    public static void build() {
        Object o = JSON.deserializeUntyped(HLModelInviteLinkTest.result);
        helplightning.HLModelInviteLink s = helplightning.HLModelInviteLink.build(o);

        System.assertEquals(s.link, 'https://r.helplightning.net/dU4JvwnLrhvUFwd97');
        System.assertEquals(s.signature, 'af304262-d232-404a-9b8b-7c13ee570661');

    }

    @isTest
    public static void buildNull() {
        helplightning.HLModelInviteLink s = helplightning.HLModelInviteLink.build(null);

        System.assertEquals(s, null);
    }

    private static String result = '{"link":"https://r.helplightning.net/dU4JvwnLrhvUFwd97", "signature": "af304262-d232-404a-9b8b-7c13ee570661"}';
}
