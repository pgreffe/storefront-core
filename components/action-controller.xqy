(:
    IMPORTANT: 
    This file should NOT have to be modified.  Modification will have impact 
    to all controllers in the application and should be coordinated among the
    team.  

    ADD A CONTROLLER FOR THE RESOURCE
    ----------------------------------------------------------------------------
    There are three steps to add a controller:
    1.  Update the resources.xqy with the controller name and path information.
    2.  Add the implementation of the controller module to /app/controller directory.
            The file name of the controller should be the key specified in 
            resources.xqy with "-controller" appended to the file name.  
            For example, controller-key = "xyz", then 
            controller file would be /app/controller/xyz-controller.xqy.
    3.  Determine which HTTP methods the controller will support.
            Below is a mapping of HTTP methods to controller functions:            
            HTTP method => controller function
            ----------------------------------
            GET => controller:show
            PUT => controller:update
            DELETE => controller:destroy
            POST => controller:create
    
    ADDING A RESOURCE REPERSENTATION (view)
    ----------------------------------------------------------------------------
    There are two steps to add a view:
    1.  Determine the the repersentations that the resource will support.
        (JSON is free)
    2.  For each resource repersentation (excluding JSON) add a implementation 
        of the repersentation app/view directory.
            The file name of the view should follow naming convention: 
                {controller-key}.{repersentation}.xqy.
            To access the model generated by the controller in the view define:
            declare variable $view:model as element() external;
            
            To access the parameters passed to the controller in the view define:
            declare variable $controller:params as map:map external;
            
            HTTP request parameters are also available to views and controllers
            with the key 'request-params' which will return a map:map element   
    
    Example Controller Code
    ----------------------------------------------------------------------------
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

    Example Repersentation (View) code
    ----------------------------------------------------------------------------
    xquery version "1.0-ml";
    declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
    declare variable $controller:pararms as map:map external;
    declare variable $view:model as element() external;
    
    <html>
        <h1>Some parameter... {map:get($controller:params, "someparam")}</h1>
        <ul>{
            for $bin in $view:model/bin
            return <li>{fn:concat($bin/text(), ' - ', data($bin/@count))}</li>
        }</ul>
    </html>

    ActionController is a main xquery module that serves as the main controller 
    for the application.  This module is returned by the applcation's URL
    rewriter. (see rewriter.xqy)  
    
    ActionController uses the following logic to process uris to controllers 
    (resources):
    1. split url by /
    2. determine request-content type to set from url
    3. parse url backwards to find controller name
    4. create map that contains scoping information where {:key} = {value-in-uri}
    5. if there is a value for path prefix determine if additional values should
       be added to path parameter map
    6. determine HTTP method and call corresponding method in controller with 
       map as parameter.
        
    TODO 
    Add better handling of url parameter replacement and processing.  Currently
    /sigint-home.html will set user key incorrectly to controller name.  When
    this is fixed change :user commented code in resources.xqy
       
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
    
    TODO
    Should bad repersentation request generate an error or return default
    mime-type defined in res:mime-types?  Currently returns default.
:)

xquery version "1.0-ml";
import module namespace res = "urn:us:gov:ic:jman:storefront:resources:v0.01" at "/config/resources.xqy";
import module namespace error = "urn:us:gov:ic:jman:storefront:error:v0.01" at "/components/error.xqy";
import module namespace json = "urn:us:gov:ic:jman:storefront:json:v0.01" at "/lib/json.xq";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";

(:
    
:)
declare variable $controller:url-request-field as xs:string := "url";
declare variable $controller:controller-dir as xs:string := "/app/controller/";
declare variable $controller:view-dir as xs:string := "/app/view/";

declare function controller:process-request() {
    (: Get request information :)
    let $url := xdmp:get-request-field($controller:url-request-field)
    let $http-method := xdmp:get-request-method()
    let $mime-type := controller:get-mime-type($url)
    let $content-type := data($mime-type/@content-type)
    let $ext := data($mime-type/@extension)
    (: Determine if a resource repersentation was requested :)
    let $url-tokens := if(fn:substring-before($url, ".")) then
        fn:tokenize(fn:substring-before($url, "."), "/")
    else 
        fn:tokenize($url, "/")
    let $controller-config := controller:get-controller-config($url-tokens)
    let $controller-name := $controller-config/name
    
    return if ($controller-name) then  
        let $controller-path-prefix := $controller-config/resource/path-prefix
        let $controller-path := $controller-config/resource/path 
        let $params := controller:get-parameter-map($controller-path, 
            $url-tokens)
        return controller:eval-controller($controller-name, $http-method, 
            $params, $url, $content-type, $ext)
        else 
            error:page(404, "Not Found")
}; 

declare function controller:get-mime-type($url as xs:string) {
    let $repersentation := fn:substring-after($url, ".")
    let $node := $res:mime-types/mime-type[@extension = $repersentation]
    return if ($node) then
        $node
    else
        $res:mime-types/mime-type[@default = "true"]
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
    return map:put($params, fn:substring-after($path-token, ":"), 
        $url-tokens[$pos + 1])
    
    (: pass through HTTP request parameters :)
    (: TODO make sure PUT and POST pass through parameters :)
    let $request-params := map:map()
    let $dummy := for $fn in xdmp:get-request-field-names()
    return map:put($request-params, $fn, xdmp:get-request-field($fn))
    
    (: add them with key 'request-params' :)
    let $dummy := map:put($params, 'request-params', $request-params)
    return $params
};

declare function controller:eval-controller($controller-name as xs:string, 
    $method as xs:string, $params as map:map, $url as xs:string, 
    $content-type as xs:string, $ext as xs:string) {
    (: evaluate the controller :)
    let $controller-file := fn:concat($controller:controller-dir, 
        $controller-name, '-controller.xqy')
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
        let $view-file := fn:concat($controller:view-dir, $controller-name, ".", 
            $ext, ".xqy")
        (: 
          invoke the view module - JSON by-passes this step and uses library 
          function in lib/json.xqy 
        :)
        return if ($ext = "json") then
            json:node-to-json($model)
        else 
            xdmp:invoke($view-file, (xs:QName("view:model"), $model, 
                xs:QName("controller:params"), $params))
    } catch ($e) {
        let $error-code := $e/error:code
        let $t := xdmp:set-response-content-type("text/xml")
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