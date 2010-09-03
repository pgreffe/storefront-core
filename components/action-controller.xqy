(:
    IMPORTANT: 
    This file should NOT have to be modified.  Modification will have impact 
    to all controllers in the application and should be coordinated among the
    team.  

    ADDING A CONTROLLER:
    There are two steps to add your controller:
    1.  Update the resources.xqy with your controller name and path information
        the key for the map should be the file name of the controller
    2.  Add the implementation of your controller module to /app/controller
        HTTP method to functions:
        -------------------------
        GET => controller:show
        PUT => controller:update
        DELETE => controller:destroy
        POST => controller:create
    
    DETAILS ABOUT ADDING CONTROLLERS:
    To add a new controller (resource) to the framework see /config/resources.xqy
    This file contains configuration information about the controller that
    backs the resource.
    
    Example Controller Code:
    module namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.1";
    
    HTTP GET 
    declare function controller:show($params as map:map) {
        for $key in map:keys($params)
        let $value := map:get($params, $key)
        return fn:concat("GET => ", $key, "=", $value)
    };
    
    HTTP PUT
    declare function controller:update($params as map:map) {
        for $key in map:keys($params)
        let $value := map:get($params, $key)
        return fn:concat("PUT => ", $key, "=", $value)
    };
    
    HTTP DELETE
    declare function controller:destroy($params as map:map) {
        for $key in map:keys($params)
        let $value := map:get($params, $key)
        return fn:concat("DELETE => ", $key, "=", $value)
    };
    
    HTTP POST
    declare function controller:create($params as map:map) {
        for $key in map:keys($params)
        let $value := map:get($params, $key)
        return fn:concat("POST => ", $key, "=", $value)    
    };

    ActionController is a main xquery module that serves as the main controller 
    for the application.  This module is returned by the applcation's URL
    rewriter. (see rewriter.xqy)  
    
    ActionController uses the following logic to process uris to controllers 
    (resources):
    1. split url by /
    2. parse url backwards to find controller name
    3. create map that contains scoping information where {:key} = {value-in-uri}
    4. if there is a value for path prefix determine if additional values should
       be added to path parameter map
    5. determine HTTP method and call corresponding method in controller with 
       map as parameter.
       
    TODO 
    Add support for setting content-type header in HTTP response.  Controller
    implementations should not perform this action.
    
    TODO
    Add support for version in urls.  This needs to look at g:local-dev flag.
    For example if g:local-dev flag is true always evaluate controller at uri
    /app/controller.  If g:local-dev flag is false and a version is prepended to
    the url for example /v0.01/sigint-home or /v0.01/report-production then
    evaluate the controller at uri /v0.01/app/controller.
    
    TODO 
    Add support in resources.xqy and logic in eval-controller for subordinate
    controller directories.  For example evaluate a controller at uri
    fn:concat($controllers-dir, 'some-dir') where 'some-dir' is defined in 
    resources.xqy
:)

xquery version "1.0-ml";
import module namespace res = "urn:us:gov:ic:jman:storefront:resources:v0.01" at "/config/resources.xqy";
import module namespace error = "urn:us:gov:ic:jman:storefront:error:v0.01" at "/components/error.xqy";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";

(:
    declare variable $controllers-ns as xs:string := "controller"
    declare variable $controllers-ext as xs:string := ".xqy"
    declare variable $controllers-dir as xs:string := "/app/controller"
    declare variable $url-request-field as xs:string := "url"
:)

declare function controller:process-request() {
    (: Get request information :)
    let $url := xdmp:get-request-field("url")
    let $http-method := xdmp:get-request-method()
    let $url-tokens := fn:tokenize($url, "/")
    (: TODO fix this parse off end of url :)
    let $repersentation := "html"
    
    let $controller-config := controller:get-controller-config($url-tokens)
    let $controller-name := $controller-config/name

    return if ($controller-name) then  
        let $controller-path-prefix := $controller-config/resource/path-prefix
        let $controller-path := $controller-config/resource/path 
        let $params := controller:get-parameter-map($controller-path, 
            $url-tokens)
        return controller:eval-controller($controller-name, $http-method, 
            $params, $url, "text/html")
        else 
            error:page(404, "Not Found")
}; 

declare function controller:get-controller-config($tokens as xs:string*) {
    (: Determine which controller to use :)
    let $controller := for $key in fn:reverse($tokens)
    let $value := map:get($res:resource-map, $key)
    where $value
    return <controller>
        <name>{$key}</name>
        {$value}
    </controller>
    
    return $controller
};

declare function controller:get-parameter-map($controller-path as xs:string, 
    $url-tokens as xs:string*) {
    let $path-tokens := fn:tokenize($controller-path, "/")
    let $params := map:map()
    let $dummy := for $path-token at $pos in $path-tokens
    where (fn:matches($path-token, "^:"))
    return map:put($params, fn:substring-after($path-token, ":"), $url-tokens[$pos + 1])
    
    return $params
};

declare function controller:eval-controller($controller-name as xs:string, 
    $method as xs:string, $params as map:map, $url as xs:string, 
    $content-type as xs:string) {
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
        let $model := xdmp:eval(fn:concat($import-declaration, $function-call),
            (),
            <options xmlns="xdmp:eval">
                <isolation>different-transaction</isolation>
                <prevent-deadlocks>true</prevent-deadlocks>
            </options>
        )
        
        (: set the response content type :)
        let $d := xdmp:set-response-content-type($content-type)
        return xdmp:invoke("/app/view/report-production.html.xqy", 
            (xs:QName("view:model"), $model))
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
};

(: This is a main module so call the function... :)
controller:process-request()