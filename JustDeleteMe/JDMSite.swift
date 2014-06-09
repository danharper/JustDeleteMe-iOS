//
//  JDMSite.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

class JDMSite {
    var name: String
    var url: NSURL
    var difficulty: String
    var domains: String[]
    var notes: String?
    
    init(name: String, url: NSURL, difficulty: String, domains: String[] = [], notes: String? = nil) {
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