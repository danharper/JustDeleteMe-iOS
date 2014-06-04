//
//  ViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate, JustDeleteMeDelegate {
    
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
        
        // part of dequeueReusableCell..
        // sitesTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "foo")
        
        jdm.delegate = self
        jdm.fetchSitesLists()
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
        selectedSite = currentSites[indexPath.item]
        let site = selectedSite!
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "\(site.name) [\(site.difficulty)]"
        alert.message = site.notes
        alert.addButtonWithTitle("Cancel")
        alert.addButtonWithTitle("Delete Me")
        alert.cancelButtonIndex = 1
        alert.show()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex { return } // cancel button is really the Delete Me button, so it's bold
        UIApplication.sharedApplication().openURL(NSURL(string: selectedSite!.url))
        self.selectedSite = nil
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        println(searchBar.text) // .lowecaseString --> EXC_BAD_ACCESS ??!
        
        if searchText.isEmpty {
            currentSites = allSites
        }
        else {
            currentSites = allSites.filter({
                site in site.name.lowercaseString.hasPrefix(searchText)
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

