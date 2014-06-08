//
//  JustDeleteMe.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

protocol JustDeleteMeDelegate {
    func didReceiveSites(sites: JDMSites)
}

class JDMSites {
    var items: JDMSite[] = []
    
    init(sites: JDMSite[] = []) {
        items += sites
    }
    
    // NSRange in ObjC returns a structure with:
    // .location - the index of the string in the substring
    // .length - the length of the match
    // In Swift, I'm getting something else, so having to bridge to ObjC instead
    // From searching about, it's not just me who's confused...
    
    func filter(#byName: String) -> JDMSite[] {
        return items.filter({
            site in site.name.bridgeToObjectiveC().rangeOfString(byName, options: .CaseInsensitiveSearch).length > 0
        })
    }
    
    func filter(#byDomain: String) -> JDMSite[] {
        return items.filter({
            site in byDomain.bridgeToObjectiveC().rangeOfString(site.domain, options: .CaseInsensitiveSearch).length > 0
        })
    }
}

class JDMSite {
    var name: String
    var url: String
    var difficulty: String
    var domains: String[]
    var notes: String?
    
    init(name: String, url: String, difficulty: String, domains: String[] = [], notes: String? = nil) {
        self.name = name
        self.url = url
        self.difficulty = difficulty
        self.domains = domains
        self.notes = notes
    }
    
    var description: String {
        return self.notes ? self.notes! : "No notes available"
    }
    
    var domain: String {
        return domains[domains.endIndex-1]
    }
}

class JustDeleteMe: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var delegate: JustDeleteMeDelegate?
    var data: NSMutableData = NSMutableData()
    
    let url: NSURL = NSURL(string: "http://justdelete.me/sites.json")
    
    func fetchSitesLists() {
        var request = NSURLRequest(URL: self.url)
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var response: NSArray = NSJSONSerialization.JSONObjectWithData(self.data, options: nil, error: nil) as NSArray
        
        var sites: JDMSite[] = []
        
        for data : AnyObject in response {
            var domains: String[] = []
            
            if let d = data["domains"] as? String[] {
                domains += d
            }
            
            var notes: String?
            if let n = data["notes"] as? String {
                notes = n
            }
            
            
            sites += JDMSite(
                name: data["name"] as String, url: data["url"] as String, difficulty: data["difficulty"] as String, domains: domains, notes: notes
            )
        }
        
        self.delegate?.didReceiveSites(JDMSites(sites: sites))
    }
    
}
