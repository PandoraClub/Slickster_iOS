//
//  CountrySelectionViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/15/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

class CountrySelectionViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var searchActive: Bool = false
    var filtered: [String] = []
    var countries: [String] = []
    var countryNamelookup = [String:String]()
    
    var templateType:String? = nil
    var activityType:String? = nil
    
    var commitSelectedCountry: Bool = false
    var selectedCountry: String? = nil
    var delegate: CountrySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.backgroundColor = UIColor.blackColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        for code in NSLocale.ISOCountryCodes() as [String] {
            
            let id = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: code])
            let name = NSLocale(localeIdentifier: "en_US")
                .displayNameForKey(NSLocaleIdentifier, value: id) ?? "Country not found for code: \(code)"
            
            countryNamelookup[code] = name
            countries.append(code)
        }
        
        if(selectedCountry != nil) {
            
            let index = self.countries.indexOf(selectedCountry!)
            if index != nil {
                
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
            }
        }
        
        self.commitSelectedCountry = false
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = countries.filter({ (c) -> Bool in
            let tmp: NSString = c
            let range = tmp.rangeOfString(searchText,
                options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        }
        
        return countries.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(
            "Cell", forIndexPath: indexPath) as UITableViewCell
        
        if(searchActive) {
            
            if filtered.count > 0 {
                
                let code = filtered[indexPath.row]
                let name = countryNamelookup[code]
                cell.textLabel?.text = name
            }
            
        } else {
            
            let code = countries[indexPath.row]
            let name = countryNamelookup[code]
            cell.textLabel?.text = name
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedCountry = countries[indexPath.row] as String
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor(rgb: 0x51e2d4)
            cell.contentView.backgroundColor = UIColor(rgb: 0x51e2d4)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            
            delegate?.countrySelectionViewController(self, didSelectCountry: self.selectedCountry)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedCountry = countries[indexPath.row] as String
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
        if(cell.selected) {
            
            cell.backgroundColor = UIColor(rgb: 0x51e2d4)
            cell.contentView.backgroundColor = UIColor(rgb: 0x51e2d4)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.accessibilityTraits = UIAccessibilityTraitSelected
            
        } else {
            
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.accessibilityTraits = 0
        }
    }
    
    @IBAction func backActivated(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func doneActivated(sender: AnyObject) {
        
        self.commitSelectedCountry = true
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}