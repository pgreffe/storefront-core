xquery version "1.0-ml";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare variable $controller:pararms as map:map external;
declare variable $view:model as element() external;

<ul>{
    for $bin in $view:model/bin
    return <li>{fn:concat($bin/text(), ' - ', data($bin/@count))}</li>
}</ul>
