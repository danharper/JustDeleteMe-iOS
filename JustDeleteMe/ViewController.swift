//
//  ViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, JustDeleteMeDelegate {
    
    @IBOutlet var sitesTable: UITableView

    var allSites: JDMSite[] = []
    var currentSites: JDMSite[] = []
    
    var colours: Dictionary<String, UIColor> = [
        "easy": UIColor(red: 123/255, green: 172/255, blue: 123/255, alpha: 1),
        "medium": UIColor(red: 232/255, green: 198/255, blue: 116/255, alpha: 1),
        "hard": UIColor(red: 207/255, green: 90/255, blue: 90/255, alpha: 1),
        "impossible": UIColor(red: 43/255, green: 42/255, blue: 43/255, alpha: 1)
    ]
    
    var jdm: JustDeleteMe = JustDeleteMe()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        jdm.delegate = self
        jdm.fetchSitesLists()
        
//        sitesTable.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "foo")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return currentSites.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let site = currentSites[indexPath.item]
        
//        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("foo", forIndexPath: indexPath) as UITableViewCell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "foo")
        
        cell.text = site.name
        cell.detailTextLabel.text = site.domain ? " \(site.domain)" : ""
        cell.textColor = colours[site.difficulty]
        
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let site = currentSites[indexPath.item]
        let alert = UIAlertView()
        alert.title = site.name
        alert.message = site.difficulty
        alert.addButtonWithTitle("Ok, Cool")
        alert.show()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        println(searchBar.text) // lowecaseString EXC_BAD_ACCESS ??!
        
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

