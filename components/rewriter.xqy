(:
    
:)
xquery version "1.0-ml";
import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" at "/config/global.xqy";
declare namespace rewriter = "urn:us:gov:ic:jman:storefront:rewriter:v0.01";

(:
    Takes url parameter adds a url request parameter and removes any '?'
    All additional request parameters are passed along in the url
:)
declare function local:construct-new($url as xs:string)
as xs:string
{
    fn:concat("url=",replace($url, "\?", "&amp;"))
};

declare variable $url as xs:string := xdmp:get-request-url();
fn:concat("/components/action-controller.xqy?", local:construct-new($url))