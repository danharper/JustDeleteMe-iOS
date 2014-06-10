//
//  SiteDetailsViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 09/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation
import UIKit

class SiteDetailsViewController: UIAlertController {
    
    convenience init(site: JDMSite, completion: ((site: JDMSite) -> Void)? = nil) {
        self.init(site: site, isExternal: false, completion: completion)
    }
    
    convenience init(site: JDMSite, isExternal: Bool, completion: ((site: JDMSite) -> Void)? = nil) {
        self.init()
        
        let title = "\(site.name) - \(site.difficulty.uppercaseString)"
        
        self.init(title: title, message: site.description, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        self.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in completion?(site: site); return })
        
        if isExternal {
            self.addAction(UIAlertAction(title: "View in App", style: .Default) { _ in
                UIApplication.sharedApplication().openURL(NSURL(string: "justdeleteme://?q=\(site.name)"))
                completion?(site: site)
            })
        }
        
        self.addAction(UIAlertAction(title: "Delete My Account", style: .Destructive) { _ in
            UIApplication.sharedApplication().openURL(site.url)
            completion?(site: site)
        })
    }
    
}