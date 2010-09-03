(: XQuery main module :)
(:
    ActionController serves as the main controller for the application.  
    
    To add a new resource to the framework see /config/resources.xqy
    
    ActionController uses the following logic to process uris to resources:
    1. split url by /
    2. parse url backwards to find controller name
    3. create map that contains scoping information where {:key} = {value-in-uri}
    4. if there is a value for path prefix determine if additional values should
       be added to path parameter map
    5. determine HTTP method and call corresponding method in controller with 
       map as parameter.
:)

import module namespace res = "urn:us:gov:ic:jman:storefront:resources:v0.01" at "/config/resources.xqy";

(: Get some request information :)
let $url := xdmp:get-request-field("url")
let $method := xdmp:get-request-method()

(: Determine which controller to use :)
let $tokens := fn:tokenize($url, "/")
let $controller := for $key in fn:reverse($tokens)
let $value := map:get($res:resource-map, $key)
where $value
return ($key, $value)

(: 
   Create a map of parameters for controller module function call base on url
   and path value for resource definition 
:)
let $controller-name := $controller[1]
let $controller-config := $controller[2]
let $path-tokens := fn:tokenize($controller-config/path, "/")
let $params := map:map()
let $dummy := for $path-token at $pos in $path-tokens
where (fn:matches($path-token, "^:"))
return map:put($params, fn:substring-after($path-token, ":"), $tokens[$pos + 1])

(: evaluate the controller :)
let $controller-file := fn:concat('/app/controller/', $controller-name, '.xqy')
let $import-declaration := fn:concat(
            'import module namespace controller =',
            '"urn:us:gov:ic:jman:storefront:controller:v0.1" at ',
            '"', $controller-file, '";'
        )

let $ns := "controller"
let $function-call := if ($method = "DELETE") then
    fn:concat($ns, ":destroy(", $params, ")")
else if ($method = "GET") then
    fn:concat($ns, ":show(", $params, ")")
else if ($method = "POST") then
    fn:concat($ns, ":create(", $params, ")")
else if ($method = "PUT") then
    fn:concat($ns, ":update(", $params, ")")
else 
    xdmp:set-response-code(405, fn:concat("Method: ", $method, " is not supported"))
    
return try {
    xdmp:eval(fn:concat($import-declaration, $function-call),
        (),
        <options xmlns="xdmp:eval">
            <isolation>different-transaction</isolation>
            <prevent-deadlocks>true</prevent-deadlocks>
        </options>
    )
} catch ($e) {
    let $error-code := $e/error:code
    let $response := if ($error-code = "SVC-FILOPN") then
        xdmp:set-response-code(500, fn:concat("Internal Server Error. ", 
            "Could not process request method: ", $method, " uri: ", $url, 
            " Could not find controller file: ", $controller-file))
    else if ($error-code = "XDMP-UNDFUN") then
        xdmp:set-response-code(405, fn:concat("Method:", $method, " is not ",
            "supported by resource: ", $controller-name))
    else 
        xdmp:set-response-code(500, fn:concat("Internal Server Error. ", 
            "Could not process request method: ", $method, " uri: ", $url))
    return ($response, $e)
}