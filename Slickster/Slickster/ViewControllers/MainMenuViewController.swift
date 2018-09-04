//
//  MainMenuViewController.swift
//  Slickster
//
//  Created by NonGT on 10/5/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import Parse
import DrawerController

class MainMenuViewController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var myProfileButton: UIButton!
    @IBOutlet weak var agendaButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var interestsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    private var isUserProfileLoaded = false;
    private var isLoadingUserProfileData = false;
    
    private let transitionManager = TransitionManager(useScreenSize: true, duration: 0.3)
    
    convenience init() {
        
        self.init(nibName: "MainMenuViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.profileImageButton.layer.borderColor = UIColor(rgb: 0xCCCCCC).CGColor
        self.profileImageButton.layer.borderWidth = 1.0
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.bounds.size.width * 0.5
        self.profileImageButton.layer.masksToBounds = true
        self.profileImageButton.setTitle("", forState: .Normal)
        
        loadProfileData()

        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        loadProfileData()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func activateProfileImage(sender: AnyObject) {
        
        launchMyProfile()
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        let alert = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to logout?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default,
            handler: { (action: UIAlertAction) -> Void in
                
                self.isUserProfileLoaded = false

                UserManager.sharedInstance.cleanupLocalData(PFUser.currentUser()!)
                PFUser.logOut()
                
                if(self.presentingViewController != nil) {
                    
                    self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                } else {
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = appDelegate.loginViewController
                    appDelegate.window?.makeKeyAndVisible()
                    appDelegate.window?.rootViewController!.view.hidden = false
                }
                
                self.clearProfileImage()
                self.myProfileButton.setTitle("", forState: .Normal)
            }))

        alert.addAction(UIAlertAction(
            title: "No",
            style: UIAlertActionStyle.Default,
            handler: { (action: UIAlertAction) -> Void in
                
            }))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func agendaMenuActivated(sender: AnyObject) {
        
        let drawer = parentViewController as? DrawerController
        drawer?.closeDrawerAnimated(true, completion: {
            result in
        })
        
        drawer?.centerViewController!.view.hidden = true

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let button = sender as! UIButton

        if button == agendaButton {
            
            let savedAgendaViewController = SavedAgendaViewController()
            savedAgendaViewController.transitioningDelegate = self.transitionManager
            savedAgendaViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
            self.presentViewController(savedAgendaViewController, animated: true, completion: nil)
            
        } else if button == calendarButton {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let calendarViewController =
                storyboard.instantiateViewControllerWithIdentifier("CalendarViewController")

            calendarViewController.transitioningDelegate = self.transitionManager
            calendarViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
            self.presentViewController(calendarViewController, animated: true, completion: nil)
            
        } else if button == interestsButton {
            
            let interestsViewController = InterestSelectionGridViewController()
            interestsViewController.transitioningDelegate = self.transitionManager
            interestsViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
            self.presentViewController(interestsViewController, animated: true, completion: nil)
            
        } else if button == settingsButton {
            
            launchMyProfile()
        }
    }
    
    @IBAction func activateMyProfileButton(sender: AnyObject) {

        launchMyProfile()
    }
    
    private func launchMyProfile() {
        
        let drawer = parentViewController as? DrawerController
        drawer?.closeDrawerAnimated(true, completion: {
            result in
        })
        
        drawer?.centerViewController!.view.hidden = true
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let profileViewController = ProfileViewController()
        profileViewController.transitioningDelegate = self.transitionManager
        profileViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        
        self.presentViewController(profileViewController, animated: true, completion: nil)
    }
    
    private func loadProfileData() {
    
        if isUserProfileLoaded && !UserManager.sharedInstance.needUserPictureRefresh {
            
            return
        }
        
        if isLoadingUserProfileData {
         
            return
        }
        
        isLoadingUserProfileData = true
        UserManager.sharedInstance.needUserPictureRefresh = false
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.center = CGPointMake(
            profileImageButton.bounds.width / 2.0,
            profileImageButton.bounds.height / 2.0)
        
        indicator.frame = CGRectMake(0, 0,
            profileImageButton.bounds.width,
            profileImageButton.bounds.height)
        
        profileImageButton.addSubview(indicator)
        indicator.startAnimating()
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            UserManager.sharedInstance.ensureUserDetails(PFUser.currentUser()!) {
                (userDetails: UserDetails?, error: NSError?) in
                
                if userDetails == nil {
                    
                    return
                }

                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.myProfileButton.setTitle(userDetails?.displayName, forState: .Normal)
                    
                    // If userDetails.userPicture is nil, use UserManager to acquire profile image.
                    if(userDetails?.userPicture == nil) {
                        
                        UserManager.sharedInstance.resolveImage(userDetails!, callback: {
                            (image: UIImage?, error: NSError?) -> Void in
                            
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()
                            
                            if image != nil {
                                
                                let pic = RBSquareImageTo(image!, size: CGSizeMake(100, 100))
                                self.profileImageButton.setImage(pic, forState: .Normal)
                                
                            } else {
                                
                                self.clearProfileImage()
                            }
                        })
                        
                    } else {
                        
                        userDetails?.userPicture?.getDataInBackgroundWithBlock({ (data, error) in
                            
                            indicator.stopAnimating()
                            indicator.removeFromSuperview()
                            
                            if (error == nil) {
                                
                                let image = UIImage(data: data!)
                                
                                let pic = RBSquareImageTo(image!, size: CGSizeMake(100, 100))
                                self.profileImageButton.setImage(pic, forState: .Normal)
                            }
                        })
                    }
                    
                    self.isUserProfileLoaded = true
                })
                
                self.isLoadingUserProfileData = false
            }
        }
    }
    
    private func clearProfileImage() {
    
        let thumb = RBSquareImageTo(UIImage(named: "blank-user")!, size: CGSizeMake(100, 100))
        profileImageButton.setImage(thumb, forState: .Normal)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}
