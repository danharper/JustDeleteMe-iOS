//
//  JustDeleteMeDataAccess.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

protocol JustDeleteMeDataAccessDelegate {
    func didReceiveSites(sites: JDMSite[])
}

class JustDeleteMeDataAccess: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var delegate: JustDeleteMeDataAccessDelegate?
    var data: NSMutableData = NSMutableData()
    
    let url: NSURL = NSURL(string: "http://justdelete.me/sites.json")
    
    func fetchSitesLists() {
        NSLog("Loading...")
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
            
            let url = NSURL(string: data["url"] as String)
            
            sites += JDMSite(
                name: data["name"] as String, url: url, difficulty: data["difficulty"] as String, domains: domains, notes: notes
            )
        }
        
        self.delegate?.didReceiveSites(sites)
    }
    
}
