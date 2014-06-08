//
//  ShareViewController.swift
//  SiteChecker
//
//  Created by Dan Harper on 05/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import Foundation
import UIKit
import Social
import JustDeleteMe
import MobileCoreServices

class ShareViewController: UIViewController, JustDeleteMeDelegate {
    
    let jdm = JustDeleteMe()
    var lookupUrl: String = ""
    
    var urlAttachmentProvider: NSItemProvider?
    
    var loadingAlert: UIAlertController = UIAlertController(title: "Loading...", message: nil, preferredStyle: .Alert)
    
    override func beginRequestWithExtensionContext(context: NSExtensionContext) {
        super.beginRequestWithExtensionContext(context)
        let input = context.inputItems as NSExtensionItem[]
        
        urlAttachmentProvider = input[0].attachments[0] as? NSItemProvider
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jdm.delegate = self
        
        if let provider = urlAttachmentProvider {
            provider.loadItemForTypeIdentifier("public.url", options: nil) {
                (item, error) in
            
                self.lookupUrl = "\(item)"
            
                self.displayLoading()
            }
        }
        else {
            self.closeExtension()
        }
    }
        
    func displayLoading() {
        var shortUrl = NSURL(string: lookupUrl).host
        
        if (shortUrl.hasPrefix("www.")) {
            shortUrl = shortUrl.substringFromIndex(4)
        }
        
        loadingAlert.title = "Checking \(shortUrl)…"
        loadingAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in self.closeExtension() })
        
        // I'd rather fetch sites _before_ the completion handler, but if I do this, the loadingAlert
        // never closes - I'm guessing the HTTP call is faster than the animation, and can't close a
        // view controller which isn't fully animated in yet?
        
        self.presentViewController(loadingAlert, animated: true) {
            self.jdm.fetchSitesLists() // delegates to didReceiveSites:sites
        }
    }
    
    func didReceiveSites(sites: JDMSites) {       
        var searched = sites.filter(byDomain: lookupUrl)
        
        self.loadingAlert.dismissViewControllerAnimated(true) {
            // Not entirely sure why I need to delay for 0, but reminds me of setTimeout 0 in JS
            // Guessing the stack needs time to clear, but I'm sure there must be a cleaner way of displaying
            // a different view controller immediately after one closes?
            // Seems horrible to have to revert to C function calls (see inside delayForSeconds)
            self.delayForSeconds(0) {
                if searched.count > 0 {
                    self.displaySiteDetailsAlert(searched[0]);
                }
                else {
                    self.displayNotFoundAlert()
                }
            }
        }
    }
    
    func displaySiteDetailsAlert(site: JDMSite) {
        let title = "\(site.name) - \(site.difficulty.uppercaseString)"
        
        let alert = UIAlertController(title: title, message: site.description, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in self.closeExtension() })
        alert.addAction(UIAlertAction(title: "View in App", style: .Default) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: "justdeleteme://?q=\(site.name)"))
            self.closeExtension()
        })
        
        alert.addAction(UIAlertAction(title: "Delete My Account", style: .Destructive) { _ in
            UIApplication.sharedApplication().openURL(NSURL(string: site.url))
            self.closeExtension()
        })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayNotFoundAlert() {
        let alert = UIAlertController(title: "Not Found", message: "Information not known for current site", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Close", style: .Cancel) { _ in self.closeExtension() })
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func closeExtension() {
        self.extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    func delayForSeconds(seconds: Double, completion: () -> ()) {
        // Dispatch back onto current queue after x seconds
        let delay = seconds * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_current_queue()) {
            completion()
        }
    }
    
}
