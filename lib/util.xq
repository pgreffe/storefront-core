module namespace util = 'urn:us:gov:ic:jman:storefront:util:v0.01';

declare function util:trim($arg as xs:string) {
    fn:replace(fn:replace($arg,'\s+$',''),'^\s+','')
};

declare function util:trim-trailing-slash($arg as xs:string) {
    fn:replace($arg, '/$', '')
};

declare function util:trim-slashes($arg as xs:string) {
    fn:replace(fn:replace($arg,'/$',''),'^/','')
};