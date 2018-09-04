//
//  InterestSelectionGridViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 4/29/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView
import Parse
import SVProgressHUD

class InterestSelectionGridViewController: UIViewController {

    @IBOutlet weak var swipeView: SwipeView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var selectedInterests = [String:UserInterest]()
    var currentGroupIndex = 0

    convenience init() {
        
        self.init(nibName: "InterestSelectionGridViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserInterestManager.sharedInstance.ensureUserInterests(PFUser.currentUser()!) {
            (userInterests, error) -> Void in
            
            SVProgressHUD.dismiss()
            
            for userInterest in userInterests! {
                
                self.selectedInterests[userInterest.selectionKey] = userInterest
            }
            
            print(self.selectedInterests)
            
            self.swipeView.delegate = self
            self.swipeView.dataSource = self
            
            self.swipeView.reloadData()
            
            self.pageControl.numberOfPages = AgendaDefault.selectableCategories.count
            self.pageControl.currentPage = 0
            self.pageControl.updateCurrentPageDisplay()
            self.pageControl.hidden = false
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backActivated(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func saveActivated(sender: AnyObject) {
     
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
    
    @IBAction func pageControlChanged(sender: AnyObject) {
        
        swipeView.currentItemIndex = pageControl.currentPage
    }
}

extension InterestSelectionGridViewController: SwipeViewDelegate, SwipeViewDataSource {
 
    func numberOfItemsInSwipeView(swipeView: SwipeView) -> Int {
        
        return AgendaDefault.selectableCategories.count
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        self.currentGroupIndex = swipeView.currentItemIndex
        
        pageControl.currentPage = self.currentGroupIndex
        pageControl.updateCurrentPageDisplay()
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, swipeView.bounds.height)
    }
    
    func swipeView(swipeView: SwipeView,
                   viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        if view == nil {
            
            let newView:InterestSelectionGridView! =
                NSBundle.mainBundle().loadNibNamed(
                    "InterestSelectionGridView", owner: self, options: nil)[0] as! InterestSelectionGridView
            
            fillData(newView, index: index)
            
            return newView
        }
        
        let interestGridView: InterestSelectionGridView = view as! InterestSelectionGridView
        fillData(interestGridView, index: index)
        
        return view!
    }
    
    private func fillData(interestGridView: InterestSelectionGridView, index: Int) {
        
        let groups = AgendaDefault.selectableCategories
        let keys = ["casual", "romantic", "family", "outdoor"]
        
        let agendaTypeCategories = groups[keys[index]]
        
        interestGridView.delegate = self
        interestGridView.setData(keys[index],
                                 agendaTypeCategories: agendaTypeCategories!,
                                 selectedInterests: selectedInterests)
    }
}

extension InterestSelectionGridViewController: InterestSelectionGridDelegate {
    
    func interestSelected(interestKey: String!, interest: UserInterest!) {
        
        selectedInterests[interestKey] = interest
    }
    
    func interestDeselected(interestKey: String!, interest: UserInterest!) {
        
        selectedInterests.removeValueForKey(interestKey)
    }
}
