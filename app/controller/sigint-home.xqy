module namespace controller = 'urn:us:gov:ic:jman:storefront:controller:v0.1';

import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';

declare function controller:show($params as map:map) {
    let $content-type := xdmp:set-response-content-type('text/html')
    return <html>
        <body>
            <h1>SIGINT Home page</h1>{
                page:get-main-menu(())
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
};
