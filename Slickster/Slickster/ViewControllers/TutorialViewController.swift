//
//  TutorialViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 1/12/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pageViewController: UIPageViewController?
    var isLoginPageShowing = false
    
    private let contentImages = [
        "tutorial-0.png",
        "tutorial-1.png",
        "tutorial-2.png",
        "tutorial-3.png",
        "tutorial-4.png",
        "tutorial-5.png",
        "tutorial-5.png"
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPageViewController()
        setupPageControl()
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!
            .instantiateViewControllerWithIdentifier("TutorialPageViewController") as! UIPageViewController
        
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        pageViewController!.delegate = self
        
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutorialItemViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        isLoginPageShowing = false
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as? TutorialItemViewController
        
        if itemController != nil && itemController!.itemIndex + 1 < contentImages.count {
            
            return getItemController(itemController!.itemIndex + 1)
        }
            
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
    
        let viewController = pendingViewControllers[0] as? TutorialItemViewController
        
        if(viewController!.itemIndex == 6) {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func getItemController(itemIndex: Int) -> TutorialItemViewController? {
        
        if itemIndex < contentImages.count {
            let TutorialItemController = self.storyboard!
                .instantiateViewControllerWithIdentifier("TutorialItemViewController") as! TutorialItemViewController
            
            TutorialItemController.itemIndex = itemIndex
            TutorialItemController.imageName = contentImages[itemIndex]
            return TutorialItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}
