module namespace controller = 'urn:us:gov:ic:jman:storefront:controller:v0.1';

import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
import module namespace report = 'urn:us:gov:ic:jman:storefront:report:v0.01' at '/lib/report.xq';

declare function show($params as map:map) {
    (:
    let $sn := map:get($params, 'serial-number')
    return report:findby-serialnumber($sn)
    :)
    ''
};