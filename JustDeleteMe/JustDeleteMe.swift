//
//  JustDeleteMe.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

protocol JustDeleteMeDelegate {
    func didReceiveSites(sites: JDMSite[])
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
    
    
    init() {
        
    }
    
    func fetchSitesLists() {
        NSLog("in here, going to start connection!")
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
        NSLog("Got data...")
        var error: NSError
        var response: NSArray = NSJSONSerialization.JSONObjectWithData(self.data, options: nil, error: nil) as NSArray
        
        var sites: JDMSite[] = []
        
        for data : AnyObject in response {
//            var domain: String
//            if  let domains : AnyObject! = data["domains"] {
//                if domains is String[] {
//                    let d = domains as String[]
//                    domain = d[0]
//                }
//            }
            
            var domains: String[] = []
            
            if let dd = data["domains"] as? String[] {
                domains += dd
            }
            
            var notes: String?
            if let n = data["notes"] as? String {
                notes = n
            }
            
            
            sites += JDMSite(
                name: data["name"] as String, url: data["url"] as String, difficulty: data["difficulty"] as String, domains: domains, notes: notes
            )
        }
        
        self.delegate?.didReceiveSites(sites)
        
//        if response.count > 0 {
//            self.delegate?.didReceiveSites(response)
//        }
//        else {
//            self.delegate?.didReceiveSites(NSArray())
//        }
    }
    
}
