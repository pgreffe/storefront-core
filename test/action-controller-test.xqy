import module namespace res = "urn:us:gov:ic:jman:storefront:resources:v0.01" at "/config/resources.xqy";

declare function local:get-parameter-map($url as xs:string, $resource as element(resource)) {
    let $url-regex := fn:concat($resource/url-regex/text())
    let $resource-path := $resource/path/text()
    let $resource-regex := $resource/path-regex/text()

    (: determine the number of tokens in the url :)
    let $map-tokens := 
        for $idx in 1 to fn:count(fn:tokenize($resource-path, "/")) - 1
        return fn:concat("$", $idx, "=>\$", $idx)
    let $map-str := fn:string-join($map-tokens, ";")

    (: replace keys in map :)
    let $map-keys := fn:replace($resource-path, $resource-regex, $map-str)
        
    (: replace values for corresponding keys :)
    let $map := fn:replace($url, $url-regex, $map-keys)
  
    (: create the map - removes whitespace before inserting values :)
    let $params := map:map()
    let $d := 
        for $str in fn:tokenize($map, ";")
        let $kv-pair := fn:tokenize($str, "=>")
        let $key := $kv-pair[1]
        let $val := $kv-pair[2]
        return if ($key != $val and fn:string-length($val) and $val != '/') then
            map:put($params, fn:replace($key, '\W+', ''), fn:replace($val, '\W+', ''))
        else ''
    
    (:
    for $key in map:keys($params)
    let $value := map:get($params, $key)
    return fn:concat($key, "=", $value)
    :)
    return $map
};

declare function local:trim($arg as xs:string) {
     replace(replace($arg,'\s+$',''),'^\s+','')
};

declare function local:remove-trailing-slash($arg as xs:string) {
    fn:replace($arg, '/$', '')
};

(:
let $resource := $res:resources/resource[@name = "siginthome"]
return local:get-parameter-map(local:remove-trailing-slash('/kenshalo/siginthome'), $resource)
:)
$res:resources



