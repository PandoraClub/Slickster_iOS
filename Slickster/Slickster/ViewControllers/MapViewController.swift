//
//  MapViewController.swift
//  Slickster
//
//  Created by NonGT on 9/21/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import FontAwesome_swift
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var districtName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scheduleDate: UILabel!
    @IBOutlet weak var myLocationButton: UIButton!
    
    let MAP_PADDING = 1.5
    let MINIMUM_VISIBLE_LATITUDE = 0.01
    
    let locationManager = CLLocationManager()
    let transitionManager: TransitionManager = TransitionManager()
    
    var userAgenda: UserAgenda?
    var centerCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        
        zoomMapToFit()
        updateAnnotations()
        
        districtName.text = "\(userAgenda!.templateType!.capitalizedString) Plan"
        scheduleDate.text = userAgenda!.district
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let myLocationButtonString = String.fontAwesomeIconWithName(FontAwesome.LocationArrow)
        let myLocationButtonStringAttrNormal =
            NSMutableAttributedString(
                string: myLocationButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
        
        myLocationButtonStringAttrNormal.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(24),
            range: NSRange(location: 0, length: 1))
        
        myLocationButtonStringAttrNormal.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: 1)
        )

        let myLocationButtonStringAttrPressed =
        NSMutableAttributedString(
            string: myLocationButtonString,
            attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
        
        myLocationButtonStringAttrPressed.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(24),
            range: NSRange(location: 0, length: 1))
        
        myLocationButtonStringAttrPressed.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xefefef),
            range: NSRange(location: 0, length: 1)
        )

        myLocationButton.setAttributedTitle(myLocationButtonStringAttrNormal, forState: .Normal)
        myLocationButton.setAttributedTitle(myLocationButtonStringAttrPressed, forState: .Highlighted)
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    private func zoomMapToFit() {
        
        var coordinates = [CLLocationCoordinate2D]()
        
        let userCoordinate = UserLocation.get()
        if userCoordinate != nil {
            coordinates.append(userCoordinate)
        }
        
        if(userAgenda!.agendaItems != nil) {
            
            for agendaItem in userAgenda!.agendaItems! {
            
                let selectedPlaceIndex = agendaItem.selectedPlaceIndex
                
                if(selectedPlaceIndex != nil && agendaItem.businesses != nil) {
                    
                    let place = agendaItem.businesses![selectedPlaceIndex!]
                    
                    if(place.coordinate != nil) {
                        
                        coordinates.append(place.coordinate!)
                    }
                }
            }
        }
        
        var minLat:CLLocationDegrees = coordinates[0].latitude
        var maxLat:CLLocationDegrees = coordinates[0].latitude
        var minLng:CLLocationDegrees = coordinates[0].longitude
        var maxLng:CLLocationDegrees = coordinates[0].longitude
        
        for coor in coordinates {
            
            if(coor.latitude < minLat) {
                minLat = coor.latitude
            }
            
            if(coor.latitude > maxLat) {
                maxLat = coor.latitude
            }
            
            if(coor.longitude < minLng) {
                minLng = coor.longitude
            }
            
            if(coor.longitude > maxLng) {
                maxLng = coor.longitude
            }
        }
        
        var region = MKCoordinateRegion()
        
        region.center.latitude = (minLat + maxLat) / 2;
        region.center.longitude = (minLng + maxLng) / 2;
        
        region.span.latitudeDelta = (maxLat - minLat) * MAP_PADDING;
        
        region.span.latitudeDelta = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE)
            ? MINIMUM_VISIBLE_LATITUDE
            : region.span.latitudeDelta;
        
        region.span.longitudeDelta = (maxLng - minLng) * MAP_PADDING;
        
        let scaledRegion = mapView.regionThatFits(region)
        mapView.setRegion(scaledRegion, animated:false)
    }
    
    func updateAnnotations() {
        
        print(userAgenda!.agendaItems)
        
        if(userAgenda!.agendaItems != nil) {
            
            var i = 0
            var prevCoordinate: CLLocationCoordinate2D? = nil
            
            for agendaItem in userAgenda!.agendaItems! {
                
                let place = agendaItem.businesses![agendaItem.selectedPlaceIndex!]
                
                if(place.coordinate != nil) {
                    
                    let annotation = MapCustomAnnotation(
                        title: place.name!,
                        subtitle: place.address!,
                        coordinate: place.coordinate!
                    )
                    
                    let categories = place.categories!.characters.split {$0 == "|"}.map(String.init)
                    annotation.category = categories.first!.capitalizedString
                    annotation.time = agendaItem.time.format()
                    annotation.agendaItemIndex = i
                    
                    self.mapView.addAnnotation(annotation)
                    
                    // Drawing route.
                    if prevCoordinate != nil {
                        
                        let sourcePlaceMark = MKPlacemark(coordinate: prevCoordinate!, addressDictionary: nil)
                        let destPlaceMark = MKPlacemark(coordinate: place.coordinate!, addressDictionary: nil)
                        
                        let source = MKMapItem(placemark: sourcePlaceMark)
                        let destination = MKMapItem(placemark: destPlaceMark)
                        
                        let directionRequest = MKDirectionsRequest()
                        directionRequest.source = source
                        directionRequest.destination = destination
                        
                        let directions = MKDirections(request: directionRequest)
                        directions.calculateDirectionsWithCompletionHandler({
                            (response: MKDirectionsResponse?, error: NSError?) in
                            
                            if error != nil {
                                
                                return
                            }
                            
                            let route = response!.routes.first
                            
                            //self.mapView.setVisibleMapRect(route!.polyline.boundingMapRect, animated: false)
                            self.mapView.addOverlay(route!.polyline)
                        })
                    }
                    
                    prevCoordinate = place.coordinate!
                }
                
                i = i + 1
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "destination"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)

        if anView == nil {
            
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.image = UIImage(named:"map-marker-banner.png")
            anView!.centerOffset = CGPointMake(0, -32);
            anView!.sizeToFit()
            
            let titleLabel = UILabel(frame: CGRectMake(8, 8, 52, 20))
            titleLabel.text = (annotation as! MapCustomAnnotation).category
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.lineBreakMode = .ByClipping
            titleLabel.minimumScaleFactor = 0.8
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.textAlignment = .Center
            
            anView?.addSubview(titleLabel)

            let timeLabel = UILabel(frame: CGRectMake(22, 22, 24, 20))
            timeLabel.text = (annotation as! MapCustomAnnotation).time
            timeLabel.adjustsFontSizeToFitWidth = true
            timeLabel.textColor = UIColor.lightGrayColor()
            timeLabel.textAlignment = .Center
            
            anView?.addSubview(timeLabel)
            anView?.rightCalloutAccessoryView = createViewButton(annotation as! MapCustomAnnotation)

        } else {
            
            anView!.annotation = annotation
            anView?.rightCalloutAccessoryView = createViewButton(annotation as! MapCustomAnnotation)
            
            (anView!.subviews[0] as! UILabel).text = (annotation as! MapCustomAnnotation).category
            (anView!.subviews[1] as! UILabel).text = (annotation as! MapCustomAnnotation).time
        }
        
        return anView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
     
        if overlay is MKPolyline {
            
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(rgb: 0x675771)
            renderer.lineWidth = 3
            
            return renderer
        }
        
        return MKPolylineRenderer()
    }
    
    func createViewButton(annotation: MapCustomAnnotation) -> UIButton {
        
        let button = UIButton(type: .InfoDark)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.addTarget(self,
            action: #selector(MapViewController.viewDetailsActivated(_:)),
            forControlEvents: UIControlEvents.TouchUpInside)
        button.tag = annotation.agendaItemIndex!
        
        return button
    }
    
    func viewDetailsActivated(sender: UIButton) {

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let placeViewController =
            storyBoard.instantiateViewControllerWithIdentifier(
                "PlaceViewController") as! PlaceViewController
        
        let agendaItem = userAgenda!.agendaItems![sender.tag]
        
        placeViewController.centerCoordinate = agendaItem.businesses![agendaItem.selectedPlaceIndex].coordinate
        placeViewController.transitioningDelegate = transitionManager
        placeViewController.setAgendaItem(agendaItem, placeIndex: agendaItem.selectedPlaceIndex)
        
        self.presentViewController(placeViewController, animated: true, completion: nil)
    }
    
    @IBAction func myLocationActivated(sender: AnyObject) {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.centerCoordinate = locValue
        
        print("got locations = \(locValue.latitude), \(locValue.longitude)")
        
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

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}