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
        cell.detailTextLabel.text = site.difficulty + (site.domain ? " \(site.domain)" : "")
        
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
        println(searchBar.text)
        let text = searchText // lowecaseString EXC_BAD_ACCESS ??!
        currentSites = allSites.filter({
            site in site.name.lowercaseString.hasPrefix(text)
        })
        println("New: \(currentSites.count)")
        sitesTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
//        sitesTable.reloadData()
    }
    
    func didReceiveSites(sites: JDMSite[]) {
        allSites = sites
        currentSites = allSites
//        sitesData = .filter({
//            site in site.difficulty == "impossible"
//        })
        sitesTable.reloadData()
    }


}

