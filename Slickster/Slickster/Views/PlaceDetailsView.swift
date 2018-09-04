//
//  PlaceDetailsViewController.swift
//  Slickster
//
//  Created by NonGT on 9/17/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import MapKit

class PlaceDetailsView: UIView, MKMapViewDelegate {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var brief: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openingHoursView: UIView!
    @IBOutlet weak var openingHoursHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var phoneIcon: UILabel!
    
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var websiteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var websiteUrl: UILabel!
    @IBOutlet weak var websiteIcon: UILabel!
    
    let MAP_PADDING = 2.0
    let MINIMUM_VISIBLE_LATITUDE = 0.01
    
    var destination: MKPointAnnotation? = nil
    
    var centerCoordinate: CLLocationCoordinate2D?
    var targetCoordinate: CLLocationCoordinate2D?
    
    override func awakeFromNib() {
        
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.userInteractionEnabled = true
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }
    
    func zoomMapToFit() {
        
        var coordinates = [CLLocationCoordinate2D]()
        
        if centerCoordinate != nil {
            
            coordinates.append(centerCoordinate!)
            
        } else {
            
            coordinates.append(UserLocation.get())
        }
        
        if(targetCoordinate != nil) {
            coordinates.append(targetCoordinate!)
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
        
        if(destination != nil) {
        
            self.mapView.removeAnnotation(destination!)
        }
        
        destination = MKPointAnnotation()
        destination!.coordinate = targetCoordinate!
        destination!.title = self.placeName.text
        destination!.subtitle = self.placeAddress.text
        
        self.mapView.addAnnotation(destination!)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "destination"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            
        } else {
            
            anView!.annotation = annotation
        }
        
        return anView
    }
    
    @IBAction func phoneLinkActivated(sender: AnyObject) {
        
        if let url = NSURL(string: "tel://\(phoneNumber.text!)") {
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func webLinkActivated(sender: AnyObject) {
        
        if let url = NSURL(string: websiteUrl.text!) {
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
}