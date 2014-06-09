//
//  JDMRepository.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

extension String {
    // NSRange in ObjC returns a structure with:
    // .location - the index of the string in the substring
    // .length - the length of the match
    // In Swift, I'm getting something else, so having to bridge to ObjC instead
    // From searching about, it's not just me who's confused...
    func __contains(contains: String) -> Bool {
        return self.bridgeToObjectiveC().rangeOfString(contains, options: .CaseInsensitiveSearch).length > 0
    }
}

class JDMRepository: JustDeleteMeDataAccessDelegate {
    
    let dataAccess = JustDeleteMeDataAccess()
    var items: JDMSite[] = []
    var handler: ((JDMSite[]) -> ())?
    
    init() {
        dataAccess.delegate = self
    }
    
    func all(handler: (JDMSite[]) -> ()) {
        if items.isEmpty {
            self.handler = handler
            dataAccess.fetchSitesLists()
        }
        else {
            handler(items)
        }
    }
    
    func find(byName searchTerm: String, handler: (JDMSite[]) -> ()) {
        self.all { sites in
            let searched = sites.filter { searchTerm.isEmpty || $0.name.__contains(searchTerm) }
            handler(searched)
        }
    }
    
    func find(byDomain searchTerm: String, handler: (JDMSite[]) -> ()) {
        self.all { sites in
            let searched = sites.filter { searchTerm.__contains($0.domain) }
            handler(searched)
        }
    }
    
    // MARK: JustDeleteMeDataAccessDelegate
    
    func didReceiveSites(sites: JDMSite[]) {
        items = sites
        handler!(items)
    }
    
}