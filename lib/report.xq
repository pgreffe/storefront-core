(:
    Xquery library to search reports.
:)
module namespace report = 'urn:us:gov:ic:jman:storefront:report:v0.01';

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace global = "urn:us:gov:ic:jman:storefront:global:v0.01" at "/config/global.xqy";

declare variable $search-opts := 
<search:options>
    <search:search-option>unfiltered</search:search-option>
    <search:page-length>10</search:page-length>
    <search:term>
        <search:empty apply="all-results" />
        <search:term-option>punctuation-insensitive</search:term-option>
    </search:term>
    <search:constraint name="country-code">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="CountryCode" />
        </search:range>
    </search:constraint>
    <search:constraint name="date-published">
        <search:range type="xs:date" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="DatePublished" />
        </search:range>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="topic">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="NIPFTopic" />
        </search:range>
    </search:constraint>
    <search:constraint name="actor">
        <search:range collation="http://marklogic.com/collation/"
            type="xs:string" facet="true">
            <search:facet-option>frequency-order</search:facet-option>
            <search:facet-option>descending</search:facet-option>
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="NonStateActorCode" />
        </search:range>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="date-revised">
        <search:range type="xs:date" facet="true">
            <search:facet-option>limit=10</search:facet-option>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="DateRevised" />
        </search:range>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="serial-number">
        <search:word>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="DocumentID" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="subject">
        <search:word>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="Subject" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="text">
        <search:word>
            <search:field name="report-metadata" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:constraint name="poc">
        <search:word>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="POCInfo" />
            <search:term-option>punctuation-insensitive</search:term-option>
        </search:word>
        <search:annotation>
        </search:annotation>
    </search:constraint>
    <search:operator name="sort">
        <search:state name="relevance">
            <search:sort-order>
                <search:score />
            </search:sort-order>
        </search:state>
        <search:state name="DatePublished">
            <search:sort-order direction="descending" type="xs:date">
                <search:element ns="urn:us:gov:ic:msp:v3.1" name="DatePublished" />
            </search:sort-order>
            <search:sort-order>
                <search:score />
            </search:sort-order>
        </search:state>
    </search:operator>
    <search:transform-results apply="snippet">
        <search:preferred-elements>
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
            <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
            <search:element ns="http://marklogic.com/entity" name="person" />
            <search:element ns="http://marklogic.com/entity" name="organization" />
        </search:preferred-elements>
        <search:max-matches>1</search:max-matches>
        <search:max-snippet-chars>150</search:max-snippet-chars>
        <search:per-match-tokens>20</search:per-match-tokens>
    </search:transform-results>
    <search:return-query>1</search:return-query>
    <search:operator name="results">
        <search:state name="compact">
            <search:transform-results apply="snippet">
                <search:preferred-elements>
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
                    <search:element ns="http://marklogic.com/entity"
                        name="person" />
                    <search:element ns="http://marklogic.com/entity"
                        name="organization" />
                </search:preferred-elements>
                <search:max-matches>1</search:max-matches>
                <search:max-snippet-chars>150</search:max-snippet-chars>
                <search:per-match-tokens>20</search:per-match-tokens>
            </search:transform-results>
        </search:state>
        <search:state name="detailed">
            <search:transform-results apply="snippet">
                <search:preferred-elements>
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="Para" />
                    <search:element ns="urn:us:gov:ic:msp:v3.1" name="EmphasizedText" />
                    <search:element ns="http://marklogic.com/entity"
                        name="person" />
                    <search:element ns="http://marklogic.com/entity"
                        name="organization" />
                </search:preferred-elements>
                <search:max-matches>2</search:max-matches>
                <search:max-snippet-chars>400</search:max-snippet-chars>
                <search:per-match-tokens>30</search:per-match-tokens>
            </search:transform-results>
        </search:state>
    </search:operator>
</search:options>;

(:
    Search all reports
    TODO add date component to this search so that entire database is not
    searched
:)
declare function report:search($q as xs:string) as element(search:response) {
    search:search($q, $search-opts)
};

declare function report:findby-serialnumber($sn as xs:string) 
    as element (search:response) {
    search:search(report:query-from-criteria($sn, 'serial-number', ''), $search-opts)
};

declare function report:findby-serialnumbers($sn as xs:string*)
    as element(search:response) {
    search:search(report:query-from-criteria($sn, 'serial-number', 'OR'), $search-opts)
};

declare function report:findby-contrycode($code as xs:string) 
    as element (search:response) {
    search:search(report:query-from-criteria($code, 'country-code', ''), $search-opts)
};

declare function report:findby-countrycodes($codes as xs:string*)
    as element (search:response) {
    search:search(report:query-from-criteria($codes, 'country-code', 'OR'), $search-opts)
};

declare function report:findby-pubdate($date as xs:date)
    as element(search:response) {
    ''  
};

declare function report:findby-pubdaterange($s-date as xs:date, 
    $e-date as xs:date) as element(search:response) {
    ''
};

declare function report:findby-revisiondate($date as xs:date) 
    as element(search:response) {
    ''
};

declare function report:findby-revisiondaterange($s-date as xs:date, 
    $e-date as xs:date) as element(search:response) {
    ''    
};

declare function report:findby-topic($topic as xs:string) {
    search:search(report:query-from-criteria($topic, 'topic', ''), $search-opts)
};

declare function report:findby-topics($topics as xs:string*)
   as element(search:response) {
    search:search(report:query-from-criteria($topics, 'topic', 'OR'), $search-opts)
};

declare function report:findby-nipf($nipf as xs:string*)
    as element(search:response) {
    ''    
};

declare function report:findby-nipf-element($nipf as element(nipf))
    as element(search:response) {
    ''    
};

declare function report:findby-nipfs($nipf as xs:string*)
    as element(search:response) {
    ''
};

declare function report:findby-nipfs-element($nipf as element(nipf-list))
    as element(search:response) {
    ''
};

declare function report:findby-countrycode-and-tagsubject($code as xs:string,
    $tag-subject as xs:string) as element(search:response) {
    ''
};

declare function report:findby-countrycode-and-tagsubjects($code as xs:string,
    $tag-subjects as xs:string*) as element(search:response) {
   ''  
};

declare function report:query-from-criteria($seq as xs:string*, 
    $constraint as xs:string, $join-condition as xs:string) as xs:string {
    let $t := for $item in $seq
    return fn:concat($constraint, ':', $item)
    let $jc-space := fn:concat(' ', $join-condition, ' ')
    
    return fn:string-join($t, $jc-space)
};

declare function report:query-from-nipfcriteria($nipfs as xs:string*)
    as xs:string {
   fn:concat('(country-code:', $nipfs[1], ' OR actor:', $nipfs[1], ') 
    AND topic:', $nipfs[2]) 
};