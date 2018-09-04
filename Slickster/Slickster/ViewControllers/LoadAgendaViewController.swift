//
//  LoadAgendaViewController.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class LoadAgendaViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var pin01: UIImageView!
    @IBOutlet weak var dot01: UIImageView!
    @IBOutlet weak var pin02: UIImageView!
    @IBOutlet weak var dot02: UIImageView!
    @IBOutlet weak var pin03: UIImageView!
    @IBOutlet weak var generatingPlanText: UILabel!
    
    var agendaItems: [AgendaItem]! = nil
    var agendaCategory:String? = ""
    var animatableList:[UIImageView] = [UIImageView]()
    
    let locationManager = CLLocationManager()
    let transitionManager = TransitionManager()
    
    var currentLocation:CLLocationCoordinate2D? = nil;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        self.pin01.alpha = 0
        self.pin02.alpha = 0
        self.pin03.alpha = 0
        self.dot01.alpha = 0
        self.dot02.alpha = 0
        
        animatableList.append(self.pin01)
        animatableList.append(self.dot01)
        animatableList.append(self.pin02)
        animatableList.append(self.dot02)
        animatableList.append(self.pin03)
        
        self.generateData()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            if UserLocation.placeOverridden == nil {
                
                locationManager.startUpdatingLocation()
                
            } else {
                
                self.currentLocation = UserLocation.get()
                self.generateData()
            }
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        var i:Int = 0
        for animatable in animatableList {
            
            let delay = Double(i) * 0.3
            
            UIView.animateWithDuration(1.0,
                delay: delay,
                options: [.Repeat, .Autoreverse],
                animations: {
                
                    animatable.alpha = 1
                
                }, completion: nil)
            
            i += 1
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        toViewController.transitioningDelegate = self.transitionManager
    }
 
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        UserLocation.current = locValue
        
        print("got locations = \(locValue.latitude), \(locValue.longitude)")
        
        // Only generate data when first got the location.
        if(self.currentLocation == nil) {
            
            self.currentLocation = locValue
            self.generateData()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alert = UIAlertController(
            title: "Unknown Location",
            message: "Cannot obtain your current location, please turn on location services",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: UIAlertActionStyle.Default,
            handler: { (action: UIAlertAction) -> Void in
                
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func generateData() {
        
        if(agendaCategory == "casual") {
            
            agendaItems = AgendaDefault.casual
            
        } else if(agendaCategory == "family") {
            
            agendaItems = AgendaDefault.family
            
        } else if(agendaCategory == "romantic") {
            
            agendaItems = AgendaDefault.romantic
            
        } else {
            
            agendaItems = AgendaDefault.outdoor
        }
        
        generatingPlanText.text = "Generating \(agendaCategory!.capitalizedString) Plan..."
        
        AgendaGenerator.templateType = agendaCategory
        
        if(self.currentLocation != nil) {
        
            var agendaItemEventbrite:AgendaItem!
            var eventBriteIdx = -1
            var i:Int = 0
            for item in self.agendaItems
            {
                if item.activityType == "Eventbrite"
                {
                    eventBriteIdx = i
                    agendaItemEventbrite = item
                    self.agendaItems.removeAtIndex(i)
                    break
                    
                }
                i += 1
            }
            
            AgendaGenerator.generateFromItems(self.currentLocation!,
                agendaItems: agendaItems,
                completion: { (err: NSError?, agendaItems: [AgendaItem]!) -> Void in
                    
                    if(err != nil) {
                        
                        let alert = UIAlertController(
                            title: "Service Not Available",
                            message: "Could not find any local place around your location",
                            preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alert.addAction(UIAlertAction(
                            title: "Dismiss",
                            style: UIAlertActionStyle.Default,
                            handler: { (action: UIAlertAction) -> Void in
                                
                                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                    self.showAgenda(self.agendaItems)

                    EventbriteClient.sharedInstance.searchEventWithCategoryName(self.currentLocation, categoryName:
                        agendaItemEventbrite.eventCategory,time:agendaItemEventbrite.time, completion: { (events, error) in
                        agendaItemEventbrite.eventBrites = events//Array(events[0...10])
                        
                        self.agendaItems.insert(agendaItemEventbrite, atIndex: eventBriteIdx)
                            
                        NSNotificationCenter.defaultCenter().postNotificationName("pullingEventBritesFinished", object: self.agendaItems)
                    
                    })

                })
        }
    }
    
    
    
    private func showAgenda(agendaItems: [AgendaItem]!) {
        
        let userAgenda = UserAgenda()
        userAgenda.uuid = NSUUID().UUIDString
        userAgenda.date = NSDate()
        userAgenda.agendaItems = agendaItems
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let agendaViewController =
            storyBoard.instantiateViewControllerWithIdentifier("AgendaViewController") as! AgendaViewController
        
        agendaViewController.transitioningDelegate = transitionManager
        agendaViewController.userAgenda = userAgenda
        
        // Reset selectedPlaceIndex to 0
        for agendaItem in userAgenda.agendaItems! {
            
            agendaItem.selectedPlaceIndex = 0
        }

        self.presentViewController(agendaViewController, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}