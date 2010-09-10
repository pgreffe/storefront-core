xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";

declare variable $controller:params as map:map external;
declare variable $view:model as element() external;

$view:model