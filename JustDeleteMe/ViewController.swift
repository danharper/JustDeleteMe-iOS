//
//  ViewController.swift
//  JustDeleteMe
//
//  Created by Dan Harper on 04/06/2014.
//  Copyright (c) 2014 Dan Harper. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, JustDeleteMeDelegate {
    
    @IBOutlet var sitesTable: UITableView

    var sitesData: NSArray = NSArray()
    
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
        return sitesData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let site = sitesData[indexPath.item] as Dictionary<String, String>
        
//        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("foo", forIndexPath: indexPath) as UITableViewCell
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "foo")
        
        cell.text = site["name"]
        cell.detailTextLabel.text = site["difficulty"]
        
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let site = sitesData[indexPath.item] as Dictionary<String, String>
        let alert = UIAlertView()
        alert.title = site["name"]
        alert.message = site["difficulty"]
        alert.addButtonWithTitle("Ok, Cool")
        alert.show()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func didReceiveSites(sites: NSArray) {
        sitesData = sites
        sitesTable.reloadData()
    }


}

