/* -*- Mode: java; -*- */

/**
 * HLModelSession.cls
 *
 * Copyright (c) 2018 HelpLightning Inc.
 * https://helplightning.com
 */

public class HLModelInviteLink {
    /**
     * This is the model that represents
     *  a Help Lightning Session Link.
     */
    public HLModelInviteLink(String link, String signature) {
        this.link = link;
        this.signature = signature;
    }

    /**
     * Build a new model from a JSON
     *  response object
     */
    public static HLModelInviteLink build(Object linkObject) {
        if (linkObject == null)
            return null;

        Map<String,Object> s = (Map<String,Object>)linkObject;

        String link = (String)s.get('link');
        String signature = (String)s.get('signature');

        return new HLModelInviteLink(link, signature);
    }

    public String link = '';
    public String signature = '';
}
