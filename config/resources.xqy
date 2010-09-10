(:

:)

module namespace res = 'urn:us:gov:ic:jman:storefront:resources:v0.01';

(:
    Map that contains resource name and url information.  See init() function
    below to add your resource.
:)
declare variable $res:resource-map as map:map := res:init();

(:
    Mime-types for action-controller.  Extension in url us used to to set 
    response content-type header.  For example, {url}.json will set a 
    content-type header application/json.  If a matching extension is not found
    res:default-content-type is used by action controller.  The default
    attribute is used if no extension is passed in the url or a bad extension
    is passed in the url.
:)
declare variable $res:mime-types as element(mime-types) := <mime-types>
    <mime-type extension="html" content-type="text/html" default="true"></mime-type>
    <mime-type extension="json" content-type="application/json"></mime-type>
</mime-types>;

declare function res:init() {
    let $map := map:map()
    let $put := map:put($map, "sigint-home",
            <resource>
                <path-prefix></path-prefix>
                <path>sigint-home</path>
            </resource>
    )
    let $put := map:put($map, "search",
            <resource>
                <path-prefix></path-prefix>
                <path>search</path>
            </resource>
    )
    let $put := map:put($map, "reader",
            <resource>
                <path-prefix></path-prefix>
                <path>reader/:user</path>
            </resource>
    )
    let $put:= map:put($map, "report-production", 
            <resource>
                <path-prefix></path-prefix>
                <path>view/report-production/:topic/:date</path>
            </resource>
    )
    let $put := map:put($map,"user",
        <resource>
            <path-prefix></path-prefix>
            <path>user/:user</path>
        </resource>
    )
    let $put := map:put($map, "category",
        <resource>
            <path-prefix></path-prefix>
            <path>category/:category-name/:category-filter</path>
        </resource>
    )
    let $put := map:put($map, "viewer", 
        <resource>
            <path-prefix></path-prefix>
            <path>report</path>
        </resource>
    )
    return $map
};