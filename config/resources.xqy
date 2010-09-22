(:

:)

module namespace res = 'urn:us:gov:ic:jman:storefront:resources:v0.01';

(:
    Contains configuration information for resources 
:)
declare variable $res:resource-config as element(resources) := <resources>
    <resource name="sigint-home">
        <path>/:user/sigint-home</path>
        <representations>
            <representation extension="html" default="true"/>
            <representation extension="json" />
        </representations>
    </resource>
    <resource name="search">
        <path>/:user/search</path>
    </resource>
    <resource name="reader">
        <path>/:user/reader</path>
    </resource>
    <resource name="report">
        <path>/:user/report/(:serialnumber)?</path>
    </resource>
    <resource name="currentinformation">
        <path>/view/current-information</path>
    </resource>
    <resource name="report-production">
        <path>/view/report-production</path>
    </resource>
    <resource name="user">
        <path>/user/:user</path>
    </resource>
    <resource name="category">
        <path>/category/(:categoryname)?/(:categoryfilter)?</path>
    </resource>
</resources>;

(:
    Mime-types for action-controller.  Extension in url us used to to set 
    response content-type header.  For example, {url}.json will set a 
    content-type header application/json.  If a matching extension is not found
    res:default-content-type is used by action controller.  The default
    attribute is used if no extension is passed in the url or a bad extension
    is passed in the url.
:)
declare variable $res:mime-types as element(mime-types) := <mime-types>
    <mime-type extension="html" content-type="text/html" default="true"/>
    <mime-type extension="json" content-type="application/json" />
</mime-types>;

(:
    Contains information used by action-controller to service requests
:)
declare variable $res:resources as element(resources) := res:init();

declare variable $url-req-regex as xs:string := "(/\w+)";
declare variable $url-opt-regex as xs:string := "(/\w+)?";
declare variable $path-req-regex as xs:string := "(/:\w+)";
declare variable $path-opt-regex as xs:string := "(/\(:\w+\)\?)";

(::)
declare function res:init() {
    <resources>{
    for $res in $res:resource-config/resource
    let $reps := $res/representations
    let $exts := fn:string-join($reps/representation/@extension, '|')
    return <resource name="{$res/@name}">
        {$res/path}
        <url-regex>{res:get-url-regex($res/path, $exts)}</url-regex>
        <path-regex>{res:get-path-regex($res/path, $exts)}</path-regex>
        {$reps}
        </resource>
    }</resources>
};

declare function res:get-url-regex($path as xs:string, $exts as xs:string){
    let $r-path := res:path-replace($path, $url-req-regex, $url-opt-regex)
    let $regex := fn:concat('^', $r-path, '(\.(', $exts, '))?$')
    return $regex
};

declare function res:get-path-regex($path as xs:string, $exts as xs:string) {
    let $p-path := res:path-replace($path, $path-req-regex, $path-opt-regex)
    let $regex := fn:concat('^', $p-path, '(\.(', $exts, '))?$')
    return $regex
};

declare function res:path-replace($path as xs:string, $req-regex, $opt-regex) {
    let $tokens := fn:tokenize($path, "/")
    let $regex := for $token in $tokens
    let $seg := if (fn:matches($token, '\(:\w+\)')) then
        $opt-regex
    else if (fn:matches($token, ":\w+")) then
        $req-regex
    else if (fn:string-length($token)) then 
        fn:concat("(/", $token, ")")
    else
        ""        
    return $seg

    return fn:string-join($regex, '')
};
