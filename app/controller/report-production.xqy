module namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.1";
(:
    Report production controller.
    
    TODO determine if DatePublished is the correct element in MSP for
    report activity; could also use MarkLogic created property of document
    
    TODO topic bins (search:bucket) elements will be configurable by content 
    owners.  The search options should be saved as an XML document at URI 
    /app/config/admin/report-production-opts.  Search bins must be in 
    ascending order
:)
import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";
import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" at "/config/global.xqy";
import module namespace json = "urn:us:gov:ic:jman:storefront:json:v0.01" at "/lib/json.xq";

declare namespace msp = "urn:us:gov:ic:msp:v3.1";
declare variable $search-opts := fn:doc('/app/config/admin/report-production.xml')/search:options;

(: HTTP GET :)
(:
declare function controller:show($params as map:map) {
    for $key in map:keys($params)
    let $value := map:get($params, $key)
    return fn:concat("GET => ", $key, "=", $value)
};
:)

(: HTTP PUT :)

declare function controller:update($params as map:map) {
    for $key in map:keys($params)
    let $value := map:get($params, $key)
    return fn:concat("PUT => ", $key, "=", $value)
};

(: HTTP DELETE :)
declare function controller:destroy($params as map:map) {
    for $key in map:keys($params)
    let $value := map:get($params, $key)
    return fn:concat("DELETE => ", $key, "=", $value)
};

(: HTTP POST :)
declare function controller:create($params as map:map) {
    for $key in map:keys($params)
    let $value := map:get($params, $key)
    return fn:concat("POST => ", $key, "=", $value)    
};

    (:
    let $is-topic := if ($topic = "topic") then
        fn:true()
    else 
        fn:false()
    
    return if ($is-topic) then
        <ul>{
            for $bucket in $search-opts/search:constraint/search:range/search:bucket
            return <li>{$bucket/text()}</li>
        }</ul>
    else 
        <table>
            <tr>
                <th>Topic</th>
                <th>Day</th>
                <th>Hour</th>
            </tr>
            <tbody>{
                let $d := xs:date("2007-02-08")
                for $facet in search:search(fn:concat("date-published:", $d), $search-opts)//search:facet-value
                return <tr>
                    <td>{$facet/text()}</td>
                    <td>{fn:data($facet/@count)}</td>
                    <td></td>
                </tr>
            }</tbody>
        </table>
    :)
