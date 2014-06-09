//
//  JDMRepository.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation

extension String {
    func __contains(contains: String) -> Bool {
        return self.bridgeToObjectiveC().rangeOfString(contains, options: .CaseInsensitiveSearch).length > 0
    }
}

class JDMRepository: JustDeleteMeDataAccessDelegate {
    
    var items: JDMSite[] = []
    var dataAccess = JustDeleteMeDataAccess()
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
        self.all {
            sites in
            let searched = sites.filter({
                site in searchTerm.isEmpty || site.name.__contains(searchTerm)
                })
            handler(searched)
        }
    }
    
    func find(byDomain searchTerm: String, handler: (JDMSite[]) -> ()) {
        self.all {
            sites in
            let searched = sites.filter({
                site in searchTerm.__contains(site.domain)
                })
            handler(searched)
        }
    }
    
    func didReceiveSites(sites: JDMSite[]) {
        items = sites
        handler!(items)
    }
    
}