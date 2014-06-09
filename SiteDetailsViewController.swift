//
//  SiteDetailsViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation
import UIKit

protocol SiteDetailsViewDelegate {
    // TODO: Better delegate names
    func siteDetailsDidClose()
    func viewSiteDetails(site: JDMSite)
    func openSiteDetails(site: JDMSite)
}

class SiteDetailsViewController: UIAlertController {
    
    var delegate: SiteDetailsViewDelegate?
    
    convenience init(site: JDMSite, isExternal: Bool = false) {
        self.init()
        
        let title = "\(site.name) - \(site.difficulty.uppercaseString)"
        
        self.init(title: title, message: site.description, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            self.delegate!.siteDetailsDidClose()
        })
        
        if isExternal {
            self.addAction(UIAlertAction(title: "View in App", style: .Default) { _ in
                self.delegate!.viewSiteDetails(site)
            })
        }
        
        self.addAction(UIAlertAction(title: "Delete My Account", style: .Destructive) { _ in
            self.delegate!.openSiteDetails(site)
        })
    }
    
}