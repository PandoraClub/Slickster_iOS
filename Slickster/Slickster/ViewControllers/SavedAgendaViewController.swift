//
//  SavedAgendaViewController.swift
//  Slickster
//
//  Created by NonGT on 10/18/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView
import SVProgressHUD
import Parse

class SavedAgendaViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource {

    @IBOutlet weak var savedAgendasSwipeView: SwipeView!
    @IBOutlet weak var noAgendaView: UIView!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var userAgendas: [UserAgenda]?
    var currentAgendaIndex: Int = 0
    var isLoaded: Bool = false
    
    private let transitionManager = TransitionManager(useScreenSize: true, duration: 0.3)
    
    convenience init() {
        
        self.init(nibName: "SavedAgendaViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        noAgendaView.hidden = true
        savedAgendasSwipeView.hidden = false
        openButton.enabled = false
        pageControl.hidden = true
        pageControl.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if isLoaded {
        
            return
        }
    
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Loading ...")
        
        AgendaManager.sharedInstance.getUserAgendas(PFUser.currentUser()!, callback: {
            (userAgendas: [UserAgenda]?, error: NSError?) in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: UIAlertActionStyle.Default,
                    handler: { (action: UIAlertAction) -> Void in
                        
                        self.presentingViewController?
                            .dismissViewControllerAnimated(true, completion: nil)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            self.isLoaded = true
            self.initData(userAgendas)
        })
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func backActivated(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openActivated(sender: AnyObject) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let agendaViewController =
            storyBoard.instantiateViewControllerWithIdentifier(
                "AgendaViewController") as! AgendaViewController
        
        agendaViewController.transitioningDelegate = transitionManager
        agendaViewController.userAgenda = userAgendas![currentAgendaIndex]
        agendaViewController.sourceViewController = self
        
        self.presentViewController(agendaViewController, animated: true, completion: nil)
    }

    func initData(userAgendas: [UserAgenda]?) {
        
        self.userAgendas = userAgendas
        
        if userAgendas == nil || userAgendas!.count == 0 {
            
            noAgendaView.hidden = false
            savedAgendasSwipeView.hidden = true
            
            return
        }
            
        noAgendaView.hidden = true
        savedAgendasSwipeView.hidden = false
        
        savedAgendasSwipeView.alignment = SwipeViewAlignment.Edge
        savedAgendasSwipeView.pagingEnabled = true
        savedAgendasSwipeView.itemsPerPage = 1
        savedAgendasSwipeView.truncateFinalPage = true
        savedAgendasSwipeView.delegate = self
        savedAgendasSwipeView.dataSource = self
        savedAgendasSwipeView.scrollOffset = 0
        savedAgendasSwipeView.currentItemIndex = 0
        
        currentAgendaIndex = 0
        openButton.enabled = true
        
        pageControl.numberOfPages = self.userAgendas!.count
        pageControl.currentPage = 0
        pageControl.updateCurrentPageDisplay()
        pageControl.hidden = false
    }
    
    // MARK - SwipeView Delegate
    
    func numberOfItemsInSwipeView(swipeView: SwipeView) -> Int {
        
        return userAgendas!.count
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        self.currentAgendaIndex = swipeView.currentItemIndex
        
        pageControl.currentPage = self.currentAgendaIndex
        pageControl.updateCurrentPageDisplay()
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, swipeView.bounds.height)
    }
    
    func swipeView(swipeView: SwipeView,
        viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
            
        if view == nil {
            
            let newView: SavedAgendaItemView! =
            NSBundle.mainBundle().loadNibNamed("SavedAgendaItemView",
                owner: self, options: nil)[0] as! SavedAgendaItemView
            
            fillData(newView, index: index)
            
            return newView
        }
        
        let savedView: SavedAgendaItemView = view as! SavedAgendaItemView
        fillData(savedView, index: index)
        
        return view!
    }
    
    func fillData(view: SavedAgendaItemView, index: Int) {
    
        let userAgenda = self.userAgendas![index]
        view.setUserAgenda(userAgenda)
    }
    
    @IBAction func pageControlChanged(sender: AnyObject) {
        
        savedAgendasSwipeView.currentItemIndex = pageControl.currentPage
    }
}
