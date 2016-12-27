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
        self.tableView.contentOffset = CGPoint(x: 0, y: 44)
        
    }
    
    func loadData() {
        do {
            data = try DatenSchleuder.phonebook()
        } catch {
            print("error: \(error)")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let alphabeat = ["#0", "#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9"]
        return alphabeat[section]
    }
    
    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = data[indexPath.row].name
        
        let number = UILabel(frame: CGRect(x: cell.contentView.frame.size.width-40, y: 0, width: 100, height: cell.frame.size.height))
        number.backgroundColor = UIColor.clear
        number.textColor = UIColor.darkGray
        number.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        number.text = "#" + data[indexPath.row].xtension
        number.textAlignment = .right
        cell.contentView.addSubview(number)
        
        return cell
        
    }
    
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        tv.deselectRow(at: indexPath, animated: true)
        
        let url: URL = URL(string: "tel:" + data[indexPath.row].xtension)!
        
        // print("is on ccc: \(isOnCCC)  |  can open: \(UIApplication.sharedApplication().canOpenURL(url))  |  URL: \(url)")
        
        if (isOnCCC!) {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                
                let alert = UIAlertController(title: "Oops", message: "Your device seems to not be able to call numbers. Maybe get yourself an iPhone?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            let alert = UIAlertController(title: "Oops", message: "You don't seem to be on the 31c3 GSM network. goto CCH;;", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func searchDisplayControllerDidBeginSearch(_ controller: UISearchDisplayController) {
        barCtrl.searchBar.resignFirstResponder()
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        
        //        let predicate = NSPredicate(format: "name contains[c] %@", searchString!)
        data = data.filter({ (num) -> Bool in
            //            return predicate.evaluateWithObject(num.name)
            
            let contains = num.name.range(of: searchString!) != nil
            print("\(num.name) \(contains) \(searchString)")
            
            return contains
        })
        
        self.tableView.reloadData()
        
        return true
        
    }
    
    func searchDisplayControllerDidEndSearch(_ controller: UISearchDisplayController) {
        
        loadData()
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

