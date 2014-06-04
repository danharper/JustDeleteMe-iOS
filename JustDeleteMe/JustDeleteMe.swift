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
    var domain: String?
    var notes: String?
    
    init(name: String, url: String, difficulty: String, domain: String? = nil, notes: String? = nil) {
        self.name = name
        self.url = url
        self.difficulty = difficulty
        self.domain = domain
        self.notes = notes
    }
}

class JustDeleteMe: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var delegate: JustDeleteMeDelegate?
    var data: NSMutableData = NSMutableData()
    
    let url: NSURL = NSURL(string: "http://justdelete.me/sites.json")
    
    
    init() {
        
    }
    
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
        var error: NSError
        var response: NSArray = NSJSONSerialization.JSONObjectWithData(self.data, options: nil, error: nil) as NSArray
        
        var sites: JDMSite[] = []
        
        for data : AnyObject in response {
            var domain: String?
            if  let domains : AnyObject! = data["domains"] {
                if domains is String[] {
                    let d = domains as String[]
                    domain = d[0]
                }
            }
            
            var notes: String?
            if let n : AnyObject! = data["notes"] {
                notes = n as? String
            }
            
            
            sites += JDMSite(
                name: data["name"] as String, url: data["url"] as String, difficulty: data["difficulty"] as String, domain: domain, notes: notes
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
