//
//  LocationManager.swift
//  Slickster
//
//  Created by NonGT on 10/19/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class LocationManager {

    class func getDistrict(location: String, callback: (String?, NSError?) -> Void) {
    
        var clLocation: CLLocation
        
        if location == "" {
            
            callback("Unknown District", nil)
            return
        }
        
        let attrs = location.characters.split {$0 == ","}.map(String.init)
        
        let lat = NSString(string: attrs[0]).doubleValue
        let lng = NSString(string: attrs[1]).doubleValue
        
        clLocation = CLLocation(latitude: lat, longitude: lng)
        
        getDistrict(clLocation, callback: callback)
    }
    
    class func getDistrict(location: CLLocation?, callback: (String?, NSError?) -> Void) {
        
        if location == nil {
            
            callback("Unknown District", nil)
            return
        }
        
        if !CLLocationCoordinate2DIsValid(location!.coordinate) {
            
            callback("Unknown District", nil)
            return
        }
        
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(location!, completionHandler: {
            (placemarks, error) -> Void in
            
            if error == nil {
                
                if placemarks!.count > 0 {
                    
                    let placemark = placemarks![0]
                    callback(placemark.locality, error)
                }
                
            } else {
                
                callback("Unknown District", nil)
            }
        })
    }
}