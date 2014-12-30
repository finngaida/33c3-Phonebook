//
//  ViewController.swift
//  #31c3
//
//  Created by Finn Gaida on 29.12.14.
//  Copyright (c) 2014 Finn Gaida. All rights reserved.
//

import UIKit
import CoreTelephony

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate {

    @IBOutlet weak var tableView: UITableView!
    var barCtrl: UISearchDisplayController!
    var dat: FGDatenSchleuder!
    var isOnCCC: Bool!
    var data: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isOnCCC = (CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode? == "42")
        dat = FGDatenSchleuder()
        data = dat.jsonDict
        
        
        var bar = UISearchBar()
        barCtrl = UISearchDisplayController(searchBar: bar, contentsController: self)
        barCtrl.delegate = self
        barCtrl.searchResultsDataSource = self
        barCtrl.searchResultsDelegate = self
        self.tableView.tableHeaderView = bar
        self.tableView.contentOffset = CGPointMake(0, 44)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let alphabeat = ["#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9"]
        return alphabeat[section]
    }
    
    func tableView(tv: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = data[indexPath.row]["name"] as? String
        
        var number = UILabel(frame: CGRectMake(cell.frame.size.width-20, 0, 50, cell.frame.size.height))
        number.backgroundColor = UIColor.clearColor()
        number.textColor = UIColor.darkGrayColor()
        number.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        number.text = "#".stringByAppendingString(data[indexPath.row]["extension"] as String)
        cell.contentView.addSubview(number)
        
        return cell
        
    }
    
    func tableView(tv: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tv.deselectRowAtIndexPath(indexPath, animated: true)
        
        let url: NSURL = NSURL(string: "tel:".stringByAppendingString(data[indexPath.row]["extension"] as String))!
        
        // print("is on ccc: \(isOnCCC)  |  can open: \(UIApplication.sharedApplication().canOpenURL(url))  |  URL: \(url)")
        
        if (isOnCCC!) {
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                
                var alert = UIAlertController(title: "Oops", message: "Your device seems to not be able to call numbers. Maybe get yourself an iPhone?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            var alert = UIAlertController(title: "Oops", message: "You don't seem to be on the 31c3 GSM network. goto CCH;;", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
        barCtrl.searchBar.resignFirstResponder()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        var predicate = NSPredicate(format: "name contains[c] %@", searchString)?
        data = (dat.jsonDict as NSArray).filteredArrayUsingPredicate(predicate!)
        
        self.tableView.reloadData()
        
        return true
        
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        
        data = dat.jsonDict
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

