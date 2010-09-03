(:
    IMPORTANT
    This file should not be changed with out coordination as it will have an 
    effect on how all urls are rewritten for the entire application.

    Url rewriter for the application.  The url rewriter is configured in 
    the admin console for the specific HTTP server in the url rewriter field.
    The path to this rewriter should be components/rewriter.xqy assuming the 
    root of the HTTP server is the storefront-core directory. 
    
    The rewriter gets the request url, adds a "url" request parameter, replaces 
    any the '?' with an '&' character. All additional request parameters are 
    passed along as they were recieved.  The rewriter then returns 
    action-controller.xqy which delegates to the correct controller based on 
    the url and resource configuration.
    
    Examples:
        url: /sigint-home -> /library/action-controller.xqy?url=sigint-home
        url: /category/topic/Florida/beaches?filter=west-coast&attractions=tennis ->
            /library/action-controller.xqy?url=/category/topic/Florida/beaches
                &filter=west-coast&attractions=tennis
:)
xquery version "1.0-ml";
import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" at "/config/global.xqy";
declare namespace rewriter = "urn:us:gov:ic:jman:storefront:rewriter:v0.01";

declare function local:construct-new($url as xs:string)
as xs:string
{
    fn:concat("url=",replace($url, "\?", "&amp;"))
};

declare variable $url as xs:string := xdmp:get-request-url();
fn:concat("/components/action-controller.xqy?", local:construct-new($url))