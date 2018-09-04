//
//  InterestsSelectionViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/24/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class InterestsSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var searchActive: Bool = false
    
    var filtered = [String:InterestCategories]()
    var groups = SelectableInterests.sharedInstance.groups
    var selectedInterests = [String:UserInterest]()
    
    var filteredSortedKeys = SelectableInterests
        .sharedInstance.groups.keys.sort(<)
    
    var groupsSortedKeys = SelectableInterests
        .sharedInstance.groups.keys.sort(<)
    
    convenience init() {
        
        self.init(nibName: "InterestsSelectionViewController", bundle: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UserInterestManager.sharedInstance.ensureUserInterests(PFUser.currentUser()!) {
            (userInterests, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if userInterests != nil {
                for userInterest in userInterests! {
                    
                    self.selectedInterests[userInterest.selectionKey] = userInterest
                }
            }
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.searchBar.delegate = self
            
            self.tableView.reloadData()
        }
        
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.backgroundColor = UIColor.blackColor()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if !UserInterestManager.sharedInstance.isLoaded() {
            
            SVProgressHUD.setBackgroundColor(UIColor.blackColor())
            SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
            SVProgressHUD.setDefaultMaskType(.Gradient)
            SVProgressHUD.showWithStatus("Loading ...")
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonActivated(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func saveButtonActivated(sender: AnyObject) {
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Saving ...")
        
        var userInterests = [UserInterest]()
        
        for userInterest in selectedInterests.values {
            
            userInterests.append(userInterest)
        }
        
        let user = PFUser.currentUser()
        
        UserInterestManager.sharedInstance.storeUserInterests(
            user!, userInterests: userInterests) { (result, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription, preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
                
            self.dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}

extension InterestsSelectionViewController: UISearchBarDelegate {
    
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
        
        filtered.removeAll()
        
        for key in groups.keys {
            
            let categories = groups[key]!.categories.filter({ (c) -> Bool in
                
                let tmp: NSString = c.title
                let range = tmp.rangeOfString(searchText,
                    options: NSStringCompareOptions.CaseInsensitiveSearch)
                
                return range.location != NSNotFound
            })
            
            if categories.count > 0 {
                
                filtered[key] = InterestCategories()
                filtered[key]?.key = groups[key]!.key
                filtered[key]?.categories = categories
            }
            
            filteredSortedKeys = filtered.keys.sort(<)
        }
        
        if(searchText.characters.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
}

extension InterestsSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if searchActive {
            
            return filtered.count
        }
        
        return groups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            
            let sortedKeys = filteredSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(section)
            let key = sortedKeys[keyIndex]
            
            return filtered[key]!.categories.count
        }
        
        let sortedKeys = groupsSortedKeys
        let keyIndex = sortedKeys.startIndex.advancedBy(section)
        let key = sortedKeys[keyIndex]
        
        return groups[key]!.categories.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if(searchActive) {
            
            let sortedKeys = filteredSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(section)
            let key = sortedKeys[keyIndex]
            
            return key
        }

        let sortedKeys = groupsSortedKeys
        let keyIndex = sortedKeys.startIndex.advancedBy(section)
        let key = sortedKeys[keyIndex]

        return key
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(
            "Cell", forIndexPath: indexPath) as UITableViewCell
        
        if(searchActive) {
            
            if filtered.count > 0 {
                
                let sortedKeys = filteredSortedKeys
                let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
                let key = sortedKeys[keyIndex]
                let interest = filtered[key]
                
                let category = interest?.categories[indexPath.row]
                cell.textLabel?.text = category?.title
            }
            
        } else {
            
            let sortedKeys = groupsSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
            let key = sortedKeys[keyIndex]
            let interest = groups[key]
            
            let category = interest?.categories[indexPath.row]
            cell.textLabel?.text = category?.title
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor(rgb: 0x676B6F)
            cell.contentView.backgroundColor = UIColor(rgb: 0x676B6F)
            
            cell.textLabel!.textColor = UIColor.blackColor()
        }
        
        // Determind selected interests category.
        if(searchActive) {
            
            if filtered.count > 0 {
                
                let sortedKeys = filteredSortedKeys
                let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
                let key = sortedKeys[keyIndex]
                let interest = filtered[key]
                
                let category = interest!.categories[indexPath.row]
                
                let userInterest = UserInterest()
                userInterest.interestKey = interest!.key
                userInterest.categoryName = category.title
                userInterest.categoryType = "yelp"
                
                if selectedInterests[userInterest.selectionKey] == nil {
                    
                    selectedInterests[userInterest.selectionKey] = userInterest
                    
                } else {
                    
                    selectedInterests.removeValueForKey(userInterest.selectionKey)
                    tableView.reloadData()
                }
            }
            
        } else {
            
            let sortedKeys = groupsSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
            let key = sortedKeys[keyIndex]
            let interest = groups[key]
            
            let category = interest!.categories[indexPath.row]
            
            let userInterest = UserInterest()
            userInterest.interestKey = interest!.key
            userInterest.categoryName = category.title
            userInterest.categoryType = "yelp"
            
            if selectedInterests[userInterest.selectionKey] == nil {
                
                selectedInterests[userInterest.selectionKey] = userInterest
                
            } else {
                
                selectedInterests.removeValueForKey(userInterest.selectionKey)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
        }
        
        // Determind selected interests category.
        if(searchActive) {
            
            if filtered.count > 0 {
                
                let sortedKeys = filteredSortedKeys
                let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
                let key = sortedKeys[keyIndex]
                let interest = filtered[key]
                
                let category = interest!.categories[indexPath.row]
                let selectionKey = "\(interest!.key) \(category.title)"
                selectedInterests.removeValueForKey(selectionKey)
            }
            
        } else {
            
            let sortedKeys = groupsSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
            let key = sortedKeys[keyIndex]
            let interest = groups[key]
            
            let category = interest!.categories[indexPath.row]
            let selectionKey = "\(interest!.key) \(category.title)"
            selectedInterests.removeValueForKey(selectionKey)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
        var isSelected: Bool = false
            
        // Determind selected interests category.
        if(searchActive) {
            
            if filtered.count > 0 {
                
                let sortedKeys = filteredSortedKeys
                let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
                let key = sortedKeys[keyIndex]
                let interest = filtered[key]
                
                let category = interest!.categories[indexPath.row]
                let selectionKey = "\(interest!.key) \(category.title)"
                isSelected = (selectedInterests[selectionKey] != nil)
            }
            
        } else {
            
            let sortedKeys = groupsSortedKeys
            let keyIndex = sortedKeys.startIndex.advancedBy(indexPath.section)
            let key = sortedKeys[keyIndex]
            let interest = groups[key]
            
            let category = interest!.categories[indexPath.row]
            let selectionKey = "\(interest!.key) \(category.title)"
            isSelected = (selectedInterests[selectionKey] != nil)
        }
            
        if(isSelected) {
            
            cell.backgroundColor = UIColor(rgb: 0x676B6F)
            cell.contentView.backgroundColor = UIColor(rgb: 0x676B6F)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.accessibilityTraits = UIAccessibilityTraitSelected
            
        } else {
            
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.accessibilityTraits = 0
        }
    }
}
