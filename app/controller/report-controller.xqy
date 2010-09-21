module namespace controller = 'urn:us:gov:ic:jman:storefront:controller:v0.1';
(: declaring the MSP namespace helps the processor recognize the MSP XML :)
declare namespace msp = "urn:us:gov:ic:msp:v3.1";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
import module namespace report = 'urn:us:gov:ic:jman:storefront:report:v0.01' at '/lib/report.xq';


declare function show($params as map:map) as element() {
    
    let $rp := map:get($params, 'request-params')
    let $sn := map:get($rp, 'sn')
    (:return report:findby-serialnumber($sn):)
    let $doc := fn:doc($sn)
    return $doc/msp:Report
    
    
};