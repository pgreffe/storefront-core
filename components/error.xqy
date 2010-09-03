import module namespace g = "urn:us:gov:ic:jman:storefront:global:v0.01" at "global.xqy";

let $h := xdmp:set-response-code(404,"Not Found")

return 
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>404 Not Found</title>
    <meta name="robots" content="noindex,nofollow"/>
  </head>
  <body>
    <h1>404 Not Found</h1>
    <p class="application">
        <a href="/{$g:version}/storefront/home">Latest Storefront Home {$g:version}</a>
    </p>
    <p class="webservice">
        <a href="/{$g:version}/storefront">Latest Storefront Webserivce {$g:version}</a>
    </p>
  </body>
</html>
