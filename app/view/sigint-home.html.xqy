xquery version "1.0-ml";
import module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1' at '/app/helper/page.xqy';
declare namespace view = "urn:us:gov:ic:jman:storefront:view:v0.1";
declare variable $view:model as element() external;

<html>
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
