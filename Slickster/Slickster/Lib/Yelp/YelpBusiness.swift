//
//  YelpBusiness.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class YelpBusiness: NSObject {
    
    var name: String?
    var address: String?
    var imageURL: NSURL?
    var categories: String?
    var distance: String?
    var ratingImageURL: NSURL?
    var reviewCount: NSNumber?
    var snippetText: String?
    var coordinate: CLLocationCoordinate2D?
    var phone: String?
    var url: String?
    var mobileUrl: String?
    
    func asDictionary() -> [String:AnyObject] {
    
        var dict = [String:AnyObject]()
        dict["name"] = name
        dict["address"] = address
        dict["imageURL"] = imageURL?.absoluteString
        dict["categories"] = categories
        dict["distance"] = distance
        dict["ratingImageURL"] = ratingImageURL?.absoluteString
        dict["reviewCount"] = reviewCount?.integerValue
        dict["snippetText"] = snippetText
        dict["coordinate"] = coordinate?.string
        dict["phone"] = phone
        dict["url"] = url
        dict["mobileUrl"] = mobileUrl
        
        return dict
    }
    
    class func create(dict: [String:AnyObject]) -> YelpBusiness {
        
        let business = YelpBusiness()
        business.name = dict["name"] as? String
        business.address = dict["address"] as? String
        business.imageURL = NSURL(string: (dict["imageURL"] as? String)!)
        business.categories = dict["categories"] as? String
        business.distance = dict["distance"] as? String
        business.ratingImageURL = NSURL(string: (dict["ratingImageURL"] as? String)!)
        business.reviewCount = dict["reviewCount"] as? NSNumber
        business.snippetText = dict["snippetText"] as? String
        
        let coor = dict["coordinate"] as? String
        let attrs = coor?.characters.split {$0 == ","}.map(String.init)
        
        let lat = NSString(string: attrs![0]).doubleValue
        let lng = NSString(string: attrs![1]).doubleValue

        business.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        business.phone = dict["phone"] as? String
        business.url = dict["url"] as? String
        business.mobileUrl = dict["mobileUrl"] as? String
        
        return business
    }
    
    class func from(dictionary: NSDictionary) -> YelpBusiness {
        
        let yelpBusiness = YelpBusiness()
        
        yelpBusiness.name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        let largeURLString = imageURLString?.stringByReplacingOccurrencesOfString(
            "ms.jpg", withString: "l.jpg")
        
        if imageURLString != nil {
            yelpBusiness.imageURL = NSURL(string: largeURLString!)!
        } else {
            yelpBusiness.imageURL = nil
        }
        
        if yelpBusiness.imageURL == nil {
            
            // Try to resolve with snippet image.
            let snippetImageURLString = dictionary["snippet_image_url"] as? String
            if snippetImageURLString != nil {
                yelpBusiness.imageURL = NSURL(string: snippetImageURLString!)!
            }
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var coordinate:CLLocationCoordinate2D? = nil
        if location != nil {
            
            let addressArray = location!["display_address"] as? [String]
            address = (addressArray!).joinWithSeparator(" ")
        
            let coor = location!["coordinate"] as? NSDictionary
            if(coor != nil) {
                
                let lat = coor!["latitude"] as! CLLocationDegrees
                let lng = coor!["longitude"] as! CLLocationDegrees
                
                coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
        }
        yelpBusiness.address = address
        yelpBusiness.coordinate = coordinate
        
        let categoriesArray = dictionary["categories"] as? [[String]]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                let categoryName = category[0]
                categoryNames.append(categoryName)
            }
            yelpBusiness.categories = categoryNames.joinWithSeparator("| ")
        } else {
            yelpBusiness.categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            //let milesPerMeter = 0.000621371
            yelpBusiness.distance = String(distanceMeters) //String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            yelpBusiness.distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            yelpBusiness.ratingImageURL = NSURL(string: ratingImageURLString!)
        } else {
            yelpBusiness.ratingImageURL = nil
        }
        
        yelpBusiness.snippetText = dictionary["snippet_text"] as? String
        yelpBusiness.reviewCount = dictionary["review_count"] as? NSNumber
        
        yelpBusiness.url = dictionary["url"] as? String
        yelpBusiness.mobileUrl = dictionary["mobile_url"] as? String
        yelpBusiness.phone = dictionary["display_phone"] as? String
        
        return yelpBusiness
    }
    
    class func businesses(array array: [NSDictionary]) -> [YelpBusiness] {
        
        var businesses = [YelpBusiness]()
        for dictionary in array {
            let business = YelpBusiness.from(dictionary)
            businesses.append(business)
        }
        
        return businesses
    }
}