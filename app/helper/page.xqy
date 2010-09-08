module namespace page = 'urn:us:gov:ic:jman:storefront:page:v0.1';

declare function page:get-main-menu($user as xs:string) as element(ul) {
    <ul>
        <li><a href="{fn:concat("/", $user, "/sigint-home")}">SIGINT Home</a></li>
        <li><a href="{fn:concat("/", $user, "/search")}">Search</a></li>
        <li><a href="{fn:concat("/", $user, "/reader")}">Reader</a></li>
    </ul>    
};

declare function page:get-template() {
    ""
};
