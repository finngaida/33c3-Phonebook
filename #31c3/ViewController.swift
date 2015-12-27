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
    var newBarCtrl: UISearchController!
    var data: [Number]!
    var isOnCCC: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isOnCCC = (CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode == "42")
        loadData()
        
        let bar = UISearchBar()
        barCtrl = UISearchDisplayController(searchBar: bar, contentsController: self)
        barCtrl.delegate = self
        barCtrl.searchResultsDataSource = self
        barCtrl.searchResultsDelegate = self
        self.tableView.tableHeaderView = bar
        self.tableView.contentOffset = CGPointMake(0, 44)
        
    }
    
    func loadData() {
        do {
            data = try DatenSchleuder.phonebook()
        } catch {
            print("error: \(error)")
        }
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
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = data[indexPath.row].name
        
        let number = UILabel(frame: CGRectMake(cell.frame.size.width-20, 0, 50, cell.frame.size.height))
        number.backgroundColor = UIColor.clearColor()
        number.textColor = UIColor.darkGrayColor()
        number.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        number.text = "#".stringByAppendingString(data[indexPath.row].xtension)
        cell.contentView.addSubview(number)
        
        return cell
        
    }
    
    func tableView(tv: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tv.deselectRowAtIndexPath(indexPath, animated: true)
        
        let url: NSURL = NSURL(string: "tel:".stringByAppendingString(data[indexPath.row].xtension))!
        
        // print("is on ccc: \(isOnCCC)  |  can open: \(UIApplication.sharedApplication().canOpenURL(url))  |  URL: \(url)")
        
        if (isOnCCC!) {
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            } else {
                
                let alert = UIAlertController(title: "Oops", message: "Your device seems to not be able to call numbers. Maybe get yourself an iPhone?", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            let alert = UIAlertController(title: "Oops", message: "You don't seem to be on the 31c3 GSM network. goto CCH;;", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func searchDisplayControllerDidBeginSearch(controller: UISearchDisplayController) {
        barCtrl.searchBar.resignFirstResponder()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        
//        let predicate = NSPredicate(format: "name contains[c] %@", searchString!)
        data = data.filter({ (num) -> Bool in
//            return predicate.evaluateWithObject(num.name)
            
            let contains = num.name.rangeOfString(searchString!) != nil
            print("\(num.name) \(contains) \(searchString)")
            
            return contains
        })
        
        self.tableView.reloadData()
        
        return true
        
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        
        loadData()
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

