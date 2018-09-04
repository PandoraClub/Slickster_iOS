//
//  EventbriteCategorySelectionViewController.swift
//  Slickster
//
//  Created by Lucas on 9/13/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

class EventbriteCategorySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
 
    var searchActive: Bool = false
    var filtered: [EventbriteCategory] = []
    var categories: [EventbriteCategory]? = nil
    
    var templateType:String? = nil
    var activityType:String? = nil
    
    var commitSelectedCategory:Bool = false
    var selectedCategory:EventbriteCategory? = nil
    var selectableCategories:[EventbriteCategory]? = nil
    
    var delegate: EventbriteCategorySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.separatorColor = UIColor.darkGrayColor()
        tableView.backgroundColor = UIColor.blackColor()
        
        self.categories = selectableCategories
        
        if(selectedCategory != nil) {
            
            let index = self.categories!.indexOf(selectedCategory!)
            if index != nil {
                
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
            }
        }
        
        self.commitSelectedCategory = false
        
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
        
        filtered = categories!.filter({ (ec) -> Bool in
            let tmp: NSString = ec.name!
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
        
        return categories!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(
            "Cell", forIndexPath: indexPath) as UITableViewCell
        
        if(searchActive) {
            
            if filtered.count > 0 {
                cell.textLabel?.text = filtered[indexPath.row].name
            }
            
        } else {
            cell.textLabel?.text = categories![indexPath.row].name
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !searchActive {
            selectedCategory = categories![indexPath.row] as EventbriteCategory
        } else {
            selectedCategory = filtered[indexPath.row] as EventbriteCategory
        }
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor(rgb: 0x51e2d4)
            cell.contentView.backgroundColor = UIColor(rgb: 0x51e2d4)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            
            delegate?.eventBriteCategorySelectionViewController(self, didSelectCategory: selectedCategory)
        }
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedCategory = categories![indexPath.row] as EventbriteCategory
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(sender!.isKindOfClass(UIButton)) {
            
            let button = sender as! UIButton
            if(button == doneButton) {
                
                self.commitSelectedCategory = true
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}