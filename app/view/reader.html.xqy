xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.01";

declare variable $controller:params as map:map external;
declare variable $view:model as element() external;

let $user := map:get($controller:params, "user")
return <html>
    <body>
    <h1>Reader Page  - user: {$user}</h1>{
        page:get-main-menu($user)
    }
    <p>
        Reader Page
    </p>
    </body>
</html>   