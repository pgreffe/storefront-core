module namespace global = 'urn:us:gov:ic:jman:storefront:global:v0.01';

declare namespace msp = "urn:us:gov:ic:msp:v3.1";

declare variable $global:server as xs:string := "localhost:9000";
declare variable $global:version as xs:string := "v0.01";
declare variable $global:local-dev as xs:boolean := fn:true();