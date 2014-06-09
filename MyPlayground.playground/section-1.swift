// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var domains: String[] = []

domains.endIndex

domains += "Foo"

domains.endIndex

let url = "http://www.apple.com?q=foobar.com"

let domain = "444"

var range = url.bridgeToObjectiveC().rangeOfString(domain, options: .CaseInsensitiveSearch)

range.length == 0

let nsurl = NSURL(string: url)

nsurl.host

nsurl.host.hasPrefix("www.")

nsurl.host.substringFromIndex(4)

nsurl.query.substringFromIndex(2)

nsurl.absoluteString


