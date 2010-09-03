xquery version "1.0-ml";
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare variable $view:model as element() external;

<ul>{
    for $bin in $view:model/bin
    return <li>{fn:concat($bin/text(), ' - ', data($bin/@count))}</li>
}</ul>
