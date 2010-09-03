(:

:)

module namespace res = 'urn:us:gov:ic:jman:storefront:resources:v0.01';

declare variable $res:resource-map as map:map := res:init();


declare function res:init() {
    let $map := map:map()
    let $put := map:put($map, "sigint-home",
            <resource>
                <path-prefix></path-prefix>
                <path>sigint-home/:user</path>
            </resource>
    )
    let $put := map:put($map, "search",
            <resource>
                <path-prefix></path-prefix>
                <path>search/:user</path>
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

    return $map
};