xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";

declare variable $controller:params as map:map external;
declare variable $view:model as element() external;

let $user := map:get($controller:params, "user")
return <html>
    <body>
        <h1>SIGINT Home page - user: {$user}</h1>{
            page:get-main-menu('kenshalo')
        }<p>
            <div id="current-information">
                Current Information View
            </div>
        </p>
        <p>
            <div id="report-production-view">
                <a href="/view/report-production">Report Production View</a>
            </div>
        </p>
        <p>
            <div id="high-priority-actors-view">
                High Priority Actors View
            </div>
        </p>
    </body>
</html>   
