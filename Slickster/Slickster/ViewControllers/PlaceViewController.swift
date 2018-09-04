//
//  PlaceViewController.swift
//  Slickster
//
//  Created by NonGT on 9/17/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView
import FontAwesome_swift

class PlaceViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource {
    
    var agendaItem: AgendaItem!
    var currentPlaceIndex: Int!
    var useCurrentPlaceIndex: Bool! = false
    var centerCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var swipeView: SwipeView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var backSegueButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeView.alignment = SwipeViewAlignment.Edge
        swipeView.pagingEnabled = true
        swipeView.itemsPerPage = 1
        swipeView.truncateFinalPage = true
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.scrollOffset = 0
        swipeView.currentItemIndex = currentPlaceIndex
        
        if presentingViewController == nil || presentingViewController is AgendaViewController {
            
            selectButton.hidden = false
            backSegueButton.hidden = false
            backButton.hidden = true
            
        } else {
            
            selectButton.hidden = true
            backSegueButton.hidden = true
            backButton.hidden = false
        }
        
        useCurrentPlaceIndex = false
        
        self.currentPlaceIndex = swipeView.currentItemIndex
        
        let place:AnyObject!
        if agendaItem.activityType == "Eventbrite"
        {
            place = self.agendaItem.eventBrites![swipeView.currentItemIndex].venu
        }
        else {
            place = self.agendaItem.businesses![swipeView.currentItemIndex]
        }
        placeName.text = place.name
        
        self.setNeedsStatusBarAppearanceUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setAgendaItem(agendaItem: AgendaItem, placeIndex: Int) {
        
        self.agendaItem = agendaItem
        self.currentPlaceIndex = placeIndex
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView) -> Int {
        
        if agendaItem.activityType == "Eventbrite"
        {
            return agendaItem.eventBrites!.count;
        }
        
        return agendaItem.businesses!.count
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        self.currentPlaceIndex = swipeView.currentItemIndex
        
        let place:AnyObject!
        if agendaItem.activityType == "Eventbrite"
        {
            place = self.agendaItem.eventBrites![swipeView.currentItemIndex].venu
        }
        else {
            place = self.agendaItem.businesses![swipeView.currentItemIndex]
        }
        placeName.text = place.name
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, swipeView.bounds.height)
    }
    
    func swipeView(swipeView: SwipeView,
        viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        if view == nil {
            
            let newView:PlaceDetailsView! =
            NSBundle.mainBundle().loadNibNamed("PlaceDetailsView", owner: self, options: nil)[0] as! PlaceDetailsView
            
            fillData(newView, index: index)
            
            return newView
        }
        
        let placeView: PlaceDetailsView = view as! PlaceDetailsView
        fillData(placeView, index: index)
        
        return view!
    }
    
    private func fillData(placeView: PlaceDetailsView, index: Int) {
        
        if agendaItem.activityType == "Eventbrite"
        {
            if self.agendaItem.eventBrites != nil &&
                self.agendaItem.eventBrites!.count <= index {
                
                // TODO: This may results unexpected behavior but no crash.
                
                return
            }
        }
        else {
            if self.agendaItem.businesses != nil &&
                self.agendaItem.businesses!.count <= index {
                
                // TODO: This may results unexpected behavior but no crash.
                
                return
            }
        }
        
        let placeHolderImage = UIImage(named: "agenda-edit-bg")
        placeView.placeImage.image = placeHolderImage

        
        if agendaItem.activityType == "Eventbrite"
        {
            let place = self.agendaItem.eventBrites![index]
            let url = place.imageURL
            if (url != nil) {
                let urlRequest = NSURLRequest(URL: url!)
                
                placeView.placeImage.setImageWithURL(url!)
                placeView.placeImage.setImageWithURLRequest(
                    urlRequest,
                    placeholderImage: placeHolderImage,
                    success: { (req, res, image) in
                        
                        UIView.transitionWithView(placeView,
                            duration: 0.3, options: .TransitionCrossDissolve, animations: {
                                
                                placeView.placeImage.image = image
                                
                            }, completion: nil)
                        
                    }, failure: nil)
            }
            
            placeView.brief.text = place.desc
            placeView.placeName.text = place.name

            if (place.venu != nil) {
                placeView.placeAddress.text = place.venu?.fullAddress
                
                if(place.venu!.coordinate != nil) {
                    
                    placeView.centerCoordinate = self.centerCoordinate
                    placeView.targetCoordinate = place.venu!.coordinate
                    placeView.zoomMapToFit()
                    placeView.updateAnnotations()
                }
            }
            
            
            placeView.ratingImage.hidden = true
            placeView.phoneView.hidden = true
            
            placeView.openingHoursView.hidden = true
            placeView.openingHoursHeightConstraint.constant = 0
            
            
            if(place.url != nil) {
                placeView.websiteView.hidden = false
                placeView.websiteHeightConstraint.constant = 60
                placeView.websiteUrl.text = place.url
                
            } else {
                
                placeView.websiteView.hidden = true
                placeView.websiteHeightConstraint.constant = 0
            }
            
        }
        else {
            let place = self.agendaItem.businesses![index]
            
            let url = place.imageURL
            let urlRequest = NSURLRequest(URL: url!)
            
            placeView.placeImage.setImageWithURL(url!)
            
            placeView.placeImage.setImageWithURLRequest(
                urlRequest,
                placeholderImage: placeHolderImage,
                success: { (req, res, image) in
                    
                    UIView.transitionWithView(placeView,
                        duration: 0.3, options: .TransitionCrossDissolve, animations: {
                            
                            placeView.placeImage.image = image
                            
                        }, completion: nil)
                    
                }, failure: nil)
            
            placeView.placeName.text = place.name
            placeView.placeAddress.text = place.address
            placeView.brief.text = place.snippetText
            
            if(place.coordinate != nil) {
                
                placeView.centerCoordinate = centerCoordinate
                placeView.targetCoordinate = place.coordinate!
                placeView.zoomMapToFit()
                placeView.updateAnnotations()
            }
            
            let ratingURL = place.ratingImageURL
            
            if(ratingURL != nil) {
                placeView.ratingImage.setImageWithURL(ratingURL!)
            }
            
            placeView.openingHoursView.hidden = true
            placeView.openingHoursHeightConstraint.constant = 0
            
            if(place.phone != nil) {
                
                placeView.phoneNumber.text = place.phone
                placeView.phoneView.hidden = false
                placeView.phoneHeightConstraint.constant = 60
                
            } else {
                
                placeView.phoneView.hidden = true
                placeView.phoneHeightConstraint.constant = 0
            }
            
            if(place.url != nil || place.mobileUrl != nil) {
                
                placeView.websiteView.hidden = false
                placeView.websiteHeightConstraint.constant = 60
                
                if(place.mobileUrl != nil) {
                    placeView.websiteUrl.text = place.mobileUrl
                } else {
                    placeView.websiteUrl.text = place.url
                }
                
            } else {
                
                placeView.websiteView.hidden = true
                placeView.websiteHeightConstraint.constant = 0
            }
        }
        
        
        
        placeView.phoneIcon.font = UIFont.fontAwesomeOfSize(32)
        placeView.phoneIcon.text = String.fontAwesomeIconWithName(FontAwesome.Phone)
        
        placeView.websiteIcon.font = UIFont.fontAwesomeOfSize(32)
        placeView.websiteIcon.text = String.fontAwesomeIconWithName(FontAwesome.Globe)
    }
    
    @IBAction func closeActivated(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(sender!.isKindOfClass(UIButton)) {
            
            let button = sender as! UIButton
            if(button == selectButton) {
                
                useCurrentPlaceIndex = true
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}
