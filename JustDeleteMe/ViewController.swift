//
//  ViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import UIKit

class SubtitledCell: UITableViewCell {
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
}

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SiteDetailsViewDelegate {
    
    @IBOutlet var searchBar : UISearchBar
    @IBOutlet var sitesTable: UITableView
    
    var jdm: JDMRepository = JDMRepository()

    var currentSites: JDMSite[] = []
    
    var colours: Dictionary<String, UIColor> = [
        "easy": UIColor(red: 123/255, green: 172/255, blue: 123/255, alpha: 1),
        "medium": UIColor(red: 232/255, green: 198/255, blue: 116/255, alpha: 1),
        "hard": UIColor(red: 207/255, green: 90/255, blue: 90/255, alpha: 1),
        "impossible": UIColor(red: 43/255, green: 42/255, blue: 43/255, alpha: 1)
    ]
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listen for external searches (e.g. via justdeleteme://q?=)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchQuery:", name: "siteSearchQuery", object: nil)
        
        // Register custom cell to be reusable
        sitesTable.registerClass(SubtitledCell.classForCoder(), forCellReuseIdentifier: "foo")
        
        // Fetch data and load into list
        jdm.all { sites in
            self.currentSites = sites
            self.sitesTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Data
    
    func searchSites(query: String) {
        jdm.find(byName: query) { sites in
            self.currentSites = sites
            self.sitesTable.reloadData()
        }
    }
    
    func displaySite(site: JDMSite) {
        let alert = SiteDetailsViewController(site: site)
        alert.delegate = self
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openDeletePage(site: JDMSite) {
        UIApplication.sharedApplication().openURL(site.url)
    }
    
    // MARK: NotificationCenter Query Listener
    
    func searchQuery(notification: NSNotification) {
        var query: String = notification.userInfo["query"] as String
        NSLog("Loaded with search query: \(query)")
        searchBar.text = query
        self.searchBar(searchBar, textDidChange: query)
    }
    
    // MARK: UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        self.searchSites(searchText)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return currentSites.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let site = currentSites[indexPath.item]
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("foo", forIndexPath: indexPath) as UITableViewCell
        
        cell.text = site.name
        cell.detailTextLabel.text = site.domain
        cell.textColor = colours[site.difficulty]
        
        return cell
    }
    
    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.displaySite(currentSites[indexPath.item])
    }
    
    // MARK: SiteDetailsViewDelegate
    
    func siteDetailsDidClose() {}
    
    func viewSiteDetails(site: JDMSite) {}
    
    func openSiteDetails(site: JDMSite) {
        self.openDeletePage(site)
    }



}

