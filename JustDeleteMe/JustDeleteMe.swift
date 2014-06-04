//
//  JustDeleteMe.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

protocol JustDeleteMeDelegate {
    func didReceiveSites(sites: NSArray)
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
        
        if response.count > 0 {
            self.delegate?.didReceiveSites(response)
        }
        else {
            self.delegate?.didReceiveSites(NSArray())
        }
    }
    
}
