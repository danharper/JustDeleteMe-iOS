//
//  ViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, JustDeleteMeDelegate {
    
    @IBOutlet var searchBar : UISearchBar
    @IBOutlet var sitesTable: UITableView

    var allSites: JDMSite[] = []
    var currentSites: JDMSite[] = []
    
    var selectedSite: JDMSite?
    
    var colours: Dictionary<String, UIColor> = [
        "easy": UIColor(red: 123/255, green: 172/255, blue: 123/255, alpha: 1),
        "medium": UIColor(red: 232/255, green: 198/255, blue: 116/255, alpha: 1),
        "hard": UIColor(red: 207/255, green: 90/255, blue: 90/255, alpha: 1),
        "impossible": UIColor(red: 43/255, green: 42/255, blue: 43/255, alpha: 1)
    ]
    
    var jdm: JustDeleteMe = JustDeleteMe()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchQuery:", name: "siteSearchQuery", object: nil)
        
        // part of dequeueReusableCell..
        // sitesTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "foo")
        
        jdm.delegate = self
        jdm.fetchSitesLists()
    }
    
    func searchQuery(notification: NSNotification) {
        var query: String = notification.userInfo["query"] as String
        NSLog("Loaded with search query: \(query)")
        searchBar.text = query
        self.searchBar(searchBar, textDidChange: query)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return currentSites.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let site = currentSites[indexPath.item]
        
        // to dequeueReusableCell need to either use the default style, or sub-class UITableViewCell to use a custom style by default
        // let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("foo", forIndexPath: indexPath) as UITableViewCell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "foo")
        
        cell.text = site.name
        cell.detailTextLabel.text = site.domain
        cell.textColor = colours[site.difficulty]
        
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        selectedSite = currentSites[indexPath.item]
        let site = selectedSite!
        
        let a = UIAlertController(title: "\(site.name) - \(site.difficulty.uppercaseString)", message: site.description, preferredStyle: UIAlertControllerStyle.ActionSheet)
        a.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        a.addAction(UIAlertAction(title: "Open Safari", style: .Default, handler: { (alert) in
            UIApplication.sharedApplication().openURL(NSURL(string: site.url)); return
        }))
        self.presentViewController(a, animated: true, completion: nil)
    }

//    func sectionIndexTitlesForTableView(tableView: UITableView!) -> AnyObject[]! {
////        return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
//        // any more characters, it hangs compiling?!
//        return ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"]
//    }
//
//    func tableView(tableView: UITableView!, sectionForSectionIndexTitle title: String!, atIndex index: Int) -> Int {
//        return 0
//    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {       
        if searchText.isEmpty {
            currentSites = allSites
        }
        else {
            currentSites = allSites.filter({
                site in site.name.bridgeToObjectiveC().rangeOfString(searchText, options: .CaseInsensitiveSearch).length > 0
            })
        }
        
        sitesTable.reloadData()
    }
    
    func didReceiveSites(sites: JDMSite[]) {
        allSites = sites
        currentSites = allSites
        sitesTable.reloadData()
    }


}

