module namespace g = 'urn:us:gov:ic:jman:storefront:global:v0.01';

declare variable $g:server as xs:string := "localhost:9000";
declare variable $g:version as xs:string := "v0.01";
declare variable $g:local-dev as xs:boolean := fn:true();
declare variable $g:resource-suffix as xs:string := "-resource.xqy";