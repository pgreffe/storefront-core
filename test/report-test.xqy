(: XQuery main module :)

import module namespace report = 'urn:us:gov:ic:jman:storefront:report:v0.01' at "/lib/report.xq";

report:findby-countrycodes(("NL"))