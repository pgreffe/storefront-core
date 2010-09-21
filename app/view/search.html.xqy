xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";
declare namespace search = "http://marklogic.com/appservices/search";

declare variable $controller:params as map:map external;
declare variable $view:model as element() external;

let $request-params := map:get($controller:params, 'request-params')
let $q := map:get($request-params, 'q')
return 
<html>
    <body>
    <h1>Search Page</h1>{
        page:get-main-menu('kenshalo')
    }
    <p>
        <div id="search-view">
            <form method="GET" action="/search">
                <input type="text" name="q" value="{$q}"/>
                <input type="submit" value="Search" />
            </form>
        </div>
    </p>
    <p>
        <div id='search-results-view'><ul>{
            for $result in $view:model/search:result
            return <li>
                <a href="{fn:concat('/report.json?sn=', data($result/@uri))}">{data($result/@uri)}</a>
            </li>
        }</ul></div>
    </p>
    <p>
        <div id='search-facets-view'>
            
        </div>
    </p>
    <p>
        <div id='search-filters-view'>
            
        </div>
    </p>
    
    </body>
</html>   