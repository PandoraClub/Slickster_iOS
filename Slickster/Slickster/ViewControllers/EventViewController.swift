//
//  EventViewController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 12/17/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView
import FontAwesome_swift

class EventViewController: UIViewController, SwipeViewDelegate, SwipeViewDataSource {
    
    let dateFormatter = NSDateFormatter()

    var agendaItem: AgendaItem!
    var currentPlaceIndex: Int!
    var useCurrentPlaceIndex: Bool! = false
    var centerCoordinate: CLLocationCoordinate2D?
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var swipeView: SwipeView!
    @IBOutlet weak var selectButton: UIButton!
    
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
        
        useCurrentPlaceIndex = false
        
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a";
        
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
        
        return agendaItem.events!.count
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        self.currentPlaceIndex = swipeView.currentItemIndex
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, swipeView.bounds.height)
    }
    
    func swipeView(swipeView: SwipeView,
        viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
            
            if view == nil {
                
                let newView:EventDetailsView! =
                NSBundle.mainBundle().loadNibNamed("EventDetailsView", owner: self, options: nil)[0] as! EventDetailsView
                
                fillData(newView, index: index)
                
                return newView
            }
            
            let placeView: EventDetailsView = view as! EventDetailsView
            fillData(placeView, index: index)
            
            return view!
    }
    
    private func fillData(placeView: EventDetailsView, index: Int) {
        
        let event = self.agendaItem.events![index]
        
        if event.imageURL != nil {
            
            let url = event.imageURL
            placeView.placeImage.setImageWithURL(url!)
            
        } else {

            var categoryCode = agendaItem.condition.eventCategories[0].id
            if agendaItem.condition.eventCategories[0].parent != nil {
                
                categoryCode = agendaItem.condition.eventCategories[0].parent
            }

            let image = UIImage(named: "event-\(categoryCode).jpg")
            placeView.placeImage.image = image
        }
        
        placeView.placeName.text = event.title
        placeView.placeAddress.text =
            "\(event.venueAddress!), \(event.cityName!), " +
            "\(event.regionName!), \(event.postalCode!), \(event.countryName!)"
        
        let encodedData = event.desc!.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        
        let attributedString = try? NSAttributedString(
            data: encodedData, options: attributedOptions,
            documentAttributes: nil)
        
        let decodedString = attributedString?.string
        
        placeView.brief.text = decodedString
        
        placeView.centerCoordinate = centerCoordinate
        placeView.targetCoordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(event.latitude!),
            longitude: CLLocationDegrees(event.longitude!))
        
        placeView.zoomMapToFit()
        placeView.updateAnnotations()
        
        eventName.text = event.venueName
        
        placeView.openingHoursView.hidden = true
        placeView.openingHoursHeightConstraint.constant = 0
        
        placeView.phoneView.hidden = true
        placeView.phoneHeightConstraint.constant = 0
        
        if(event.url != nil) {
            
            placeView.websiteView.hidden = false
            placeView.websiteHeightConstraint.constant = 60
            
            placeView.websiteUrl.text = event.url
            
        } else {
            
            placeView.websiteView.hidden = true
            placeView.websiteHeightConstraint.constant = 0
        }
        
        if event.startTime != nil {
            
            placeView.eventTime.hidden = false

            placeView.eventTime.text =
                "\(dateFormatter.stringFromDate(event.startTime!))"
            
            if event.stopTime != nil {
                
                placeView.eventTime.text = "\(placeView.eventTime.text!)" +
                    " - \(dateFormatter.stringFromDate(event.stopTime!))"
            } else {
                
                placeView.eventTime.text = "\(placeView.eventTime.text!)"
            }
            
        } else {
            
            placeView.eventTime.hidden = true
        }
            
        placeView.phoneIcon.font = UIFont.fontAwesomeOfSize(32)
        placeView.phoneIcon.text = String.fontAwesomeIconWithName(FontAwesome.Phone)
        
        placeView.websiteIcon.font = UIFont.fontAwesomeOfSize(32)
        placeView.websiteIcon.text = String.fontAwesomeIconWithName(FontAwesome.Globe)
        
        NSTimer.scheduledTimerWithTimeInterval(
            0.5, target: self,
            selector: #selector(EventViewController.updateScrollHeight(_:)),
            userInfo: placeView, repeats: false)
    }
    
    func updateScrollHeight(timer: NSTimer) {
        
        let placeView = timer.userInfo as! EventDetailsView
        
        let overflowHeight = (
            placeView.websiteView.frame.origin.y +
                placeView.websiteView.frame.size.height)
        
        placeView.scrollView.contentSize = CGSize(
            width: placeView.scrollView.frame.width, height: overflowHeight)
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