//
//  CategoriesViewController.swift
//  Slickster
//
//  Created by NonGT on 9/7/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
import ParseUI
import DrawerController
import FontAwesome_swift
import SVProgressHUD

class MainViewController: UIViewController, GooglePlacesAutocompleteDelegate {

    @IBOutlet weak var casualButton: UIButton!
    @IBOutlet weak var romanticButton: UIButton!
    @IBOutlet weak var outdoorButton: UIButton!
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mainBg: UIImageView!
    @IBOutlet weak var logoText: UIImageView!
    @IBOutlet weak var topBarView: UIView!
    
    enum CategoryIdiom : Int {
        
        case Unspecified = 0
        case Casual = 1
        case Romantic = 2
        case Family = 3
        case Outdoor = 4
    }
    
    enum UIUserInterfaceIdiom : Int {
        
        case Unspecified
        case Phone // iPhone and iPod touch style UI
        case Pad // iPad style UI
    }
    
    let transitionManager = TransitionManager()
    let gpaViewController: GooglePlacesAutocomplete = GooglePlacesAutocomplete(
        
            apiKey: Config.google.apiKey,
            placeType: .All
        )
    
    var selectedPlace: Place?
    var menuActivated: Bool! = false
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        gpaViewController.placeDelegate = self
        gpaViewController.navigationBar.frame =
            CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90)
        
        gpaViewController.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        gpaViewController.navigationBar.translucent = false
        gpaViewController.navigationBar.barTintColor = UIColor.blackColor()
        gpaViewController.navigationBar.tintColor = UIColor.whiteColor()
        gpaViewController.navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "BigNoodleTitling", size: 28.0)!
        ]
        
        casualButton.setImage(
            UIImage(named: "icon-casual-active"), forState: .Highlighted)
        
        familyButton.setImage(
            UIImage(named: "icon-family-active"), forState: .Highlighted)
        
        romanticButton.setImage(
            UIImage(named: "icon-romantic-active"), forState: .Highlighted)
        
        outdoorButton.setImage(
            UIImage(named: "icon-outdoor-active"), forState: .Highlighted)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        setMenuButtonNormal()
        
        // Location Manager Authorization.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            if UserLocation.placeOverridden == nil {
                locationManager.startUpdatingLocation()
            }
        }
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        if appDelegate.autoOpenAgendaId != nil {
            
            showSharedAgenda(appDelegate.autoOpenAgendaId!)
            appDelegate.autoOpenAgendaId = nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.view.hidden = false
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        appDelegate.bgRootImage!.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        
        toggleMainBg(true)
        topBarView.hidden = false;
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        if appDelegate.topBarView != nil {
            appDelegate.topBarView!.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        toViewController.transitioningDelegate = self.transitionManager
        
        let loadView = toViewController as! LoadAgendaViewController
        loadView.agendaCategory = segue.identifier
        
        toggleMainBg(false)
        topBarView.hidden = true;
        
        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        if appDelegate.topBarView != nil {
            appDelegate.topBarView!.hidden = false
        }
    }
    
    func placeViewClosed() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func placeViewCommit() {
        
        if selectedPlace != nil {
         
            selectedPlace?.getDetails({ details in
            
                UserLocation.placeOverridden = details
                self.refreshUI()
            })
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func placeViewReset() {
        
        selectedPlace = nil
        UserLocation.placeOverridden = nil
     
        dismissViewControllerAnimated(true, completion: nil)
        
        refreshUI()
    }
    
    func placeSelected(place: Place) {
     
        selectedPlace = place;
        
        placeViewCommit()
    }
    
    func refreshUI() {
     
        if UserLocation.placeOverridden != nil {
         
            self.locationLabel.text = selectedPlace!.desc
            
        } else {
            
            self.locationLabel.text = "Refreshing ..."
            locationManager.startUpdatingLocation()
        }
    }
    
    func setMenuButtonNormal() {
     
        let menuButtonString = String.fontAwesomeIconWithName(FontAwesome.Bars)
        
        let normalStateAttributed =
            NSMutableAttributedString(
                string: menuButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
        
        normalStateAttributed.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(32),
            range: NSRange(location: 0, length: 1))
        
        normalStateAttributed.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: 1)
        )
        
        menuButton.setAttributedTitle(normalStateAttributed, forState: .Normal)
    }
    
    func showSharedAgenda(id: String) {
        
        var parentViewController = self.parentViewController
        var drawerController: DrawerController? = nil
        
        while parentViewController != nil {
            
            if parentViewController!.isKindOfClass(DrawerController) {
                drawerController = parentViewController as? DrawerController
            }
            
            parentViewController = parentViewController!.parentViewController
        }
        
        if drawerController != nil {

            drawerController?
                .leftDrawerViewController?
                .presentedViewController?
                .dismissViewControllerAnimated(true, completion: nil)
            
            drawerController?
                .centerViewController?
                .presentedViewController?
                .dismissViewControllerAnimated(true, completion: nil)
        }
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Loading ...")
        
        AgendaManager.sharedInstance.getSharedAgenda(id, callback: {
            (userAgenda: UserAgenda?, error: NSError?) in
            
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
            
            if userAgenda!.uuid == nil {
             
                let alert = UIAlertController(
                    title: "Agenda Not Found",
                    message: "Agenda is no longer exists on the server",
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
            
            userAgenda?.ensureAgendaItems()

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let agendaViewController =
            storyBoard.instantiateViewControllerWithIdentifier(
                "AgendaViewController") as! AgendaViewController
            
            agendaViewController.transitioningDelegate = self.transitionManager
            agendaViewController.userAgenda = userAgenda
            agendaViewController.sourceViewController = self
            
            self.presentViewController(agendaViewController, animated: true, completion: nil)
        })
    }
    
    @IBAction func activateMenu(sender: AnyObject) {
        
        var parentViewController = self.parentViewController
        var drawerController: DrawerController? = nil
        
        while parentViewController != nil {
            
            if parentViewController!.isKindOfClass(DrawerController) {
                drawerController = parentViewController as? DrawerController
            }
            
            parentViewController = parentViewController!.parentViewController
        }
        
        if drawerController != nil {
         
            drawerController!.toggleDrawerSide(.Left, animated: true, completion: nil)
            menuActivated = !menuActivated
        }
    }
    
    @IBAction func placeSelectionRequest(sender: AnyObject) {
        
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue) {

        let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        if appDelegate.topBarView != nil {
            appDelegate.topBarView!.hidden = false
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    
    func updateBackgroundConstraint(drawerController: DrawerController, percent: CGFloat) {
        
        let offset = percent * drawerController.maximumLeftDrawerWidth
        
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, -offset, 0.0, 0.0)
        mainBg.layer.transform = transform
        
        if offset == 0 {
            
            mainBg.layer.transform = CATransform3DIdentity
        }
    }
    
    func toggleMainBg(isShowing: Bool) {
        
        mainBg.hidden = !isShowing
        
        var parentViewController = self.parentViewController
        var drawerController: DrawerController? = nil
        
        while parentViewController != nil {
            
            if parentViewController!.isKindOfClass(DrawerController) {
                drawerController = parentViewController as? DrawerController
            }
            
            parentViewController = parentViewController!.parentViewController
        }
        
        if drawerController != nil {
            
            drawerController!.view.backgroundColor = UIColor(white: 1, alpha: 0)
            
            for view in drawerController!.view.subviews {
                
                if view.isKindOfClass(UIImageView) {
                    view.hidden = !isShowing
                }
            }
        }
    }
}

extension MainViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        LocationManager.getDistrict(manager.location) { (district: String?, error: NSError?) -> Void in
            if error != nil {
                
                self.locationLabel.text = "UNKNOWN DISTRICT"
                return
            }
            
            self.locationLabel.text = district?.uppercaseString
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        self.locationLabel.text = "UNKNOWN LOCATION"
    }
}

