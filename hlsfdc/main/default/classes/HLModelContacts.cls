/* -*- Mode: java; -*- */

/**
 * HLModelContacts.cls
 *
 * Copyright (c) 2022 HelpLightning Inc.
 * https://helplightning.com
 */

public class HLModelContacts {
    /**
     * This is the model that represents
     *  a Help Lightning Contact User object.
     */
    public HLModelContacts(List<helplightning.HLModelEnterpriseUser> entries, Integer page, Integer pageSize,
    Integer totalEntries, Integer totalPages) {
        this.entries = entries;
        this.page = page;
        this.pageSize = pageSize;
        this.totalEntries = totalEntries;
        this.totalPages = totalPages;
    }

    /**
     * Build a new model from a JSON
     *  response object
     */
    public static HLModelContacts build(Object entryObject) {
        Map<String, Object> e = (Map<String, Object>)entryObject;
        List<helplightning.HLModelEnterpriseUser> entries = helplightning.HLModelEnterpriseUser.buildMany(entryObject);

        return new HLModelContacts(entries,
                                         (Integer)e.get('page'),
                                         (Integer)e.get('page_size'),
                                         (Integer)e.get('total_entries'),
                                         (Integer)e.get('total_pages'));
    }

    @auraEnabled
    public List<helplightning.HLModelEnterpriseUser> entries = new List<helplightning.HLModelEnterpriseUser>();
    @auraEnabled
    public Integer page = 0;
    @auraEnabled
    public Integer pageSize = 0;
    @auraEnabled
    public Integer totalEntries = 0;
    @auraEnabled
    public Integer totalPages = 0;
}
