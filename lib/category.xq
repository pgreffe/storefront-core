module namespace category = "urn:us:gov:ic:jman:storefront:category:v0.01";

import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" at "../global.xqy";
declare namespace msp = "urn:us:gov:ic:msp:v3.1";

declare function category:get-regions($region as xs:string) {
    ""
};

declare function category:get-country-buckets() {
    category:get-buckets("msp:CountryCode")
};

declare function category:get-topic-buckets() {
    category:get-buckets("msp:NIPFTopic")
};

declare function category:get-non-state-actor-buckets() {
    category:get-buckets("msp:NonStateActor")
};

declare function category:get-nipf-buckets() {
    category:get-buckets("msp:NIPFAssertion")
};

declare function category:get-buckets($e-name as xs:string) {
    <list>{
        for $bucket in cts:element-value-ranges(xs:QName($e-name), 
            cts:element-values(xs:QName($e-name)))
        let $country := $bucket/cts:minimum/text()
        return <li>
                <a href="/{$g:version}/report/country/{$country}">{$country} ({cts:frequency($bucket)})</a>
            </li>
    }</list>    
};

declare function category:get-information-need-buckets() {
    ""
};

declare function category:get-date-buckets() {
    ""
};