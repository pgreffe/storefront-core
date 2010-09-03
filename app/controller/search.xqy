module namespace controller = "urn:us:gov:ic:jman:storefront:controller:v0.1";

import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';

declare function controller:show($params as map:map) {
    let $content-type := xdmp:set-response-content-type('text/html')
    return <html>
        <body>{
            page:get-main-menu(())
        }
        <p>
            Search Page
        </p>
        </body>
    </html>   
};