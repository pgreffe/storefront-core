xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare variable $view:model as element() external;

<html>
    <body>
    <h1>Search Page</h1>{
        page:get-main-menu(())
    }
    <p>
        Search Page
    </p>
    </body>
</html>   