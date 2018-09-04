//
//  EventFulSearchResult.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 12/15/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

class EventFulItem: NSObject {
    
    var id: String?
    
    var title: String?
    var desc: String?
    var url: String?
    var imageURL: NSURL?
    
    var venueName: String?
    var venueUrl: String?
    var startTime: NSDate?
    var stopTime: NSDate?
    
    var venueAddress: String?
    var cityName: String?
    var regionName: String?
    var postalCode: String?
    var countryName: String?
    
    var latitude: NSNumber?
    var longitude: NSNumber?
    
    func asDictionary() -> [String:AnyObject] {
        
        var dict = [String:AnyObject]()
        dict["id"] = id
        dict["title"] = title
        dict["desc"] = desc
        dict["url"] = url
        
        if imageURL?.absoluteString != nil {
            
            dict["imageURL"] = imageURL!.absoluteString
        }

        dict["venueName"] = venueName
        dict["venueUrl"] = venueUrl
        dict["startTime"] = startTime?.timeIntervalSince1970
        dict["stopTime"] = stopTime?.timeIntervalSince1970
        dict["venueAddress"] = venueAddress
        dict["cityName"] = cityName
        dict["regionName"] = regionName
        dict["postalCode"] = postalCode
        dict["countryName"] = countryName
        dict["latitude"] = latitude
        dict["longitude"] = longitude
        
        return dict
    }
    
    class func create(dict: [String:AnyObject]) -> EventFulItem {
        
        let event = EventFulItem()
        event.id = dict["id"] as? String
        event.title = dict["title"] as? String
        event.desc = dict["desc"] as? String
        
        if let imageURL = dict["imageURL"] {
            
            event.imageURL = NSURL(string: imageURL as! String)
        }
        
        event.url = dict["url"] as? String
        event.venueName = dict["venueName"] as? String
        event.venueUrl = dict["venueUrl"] as? String
        
        if dict["startTime"] != nil {
            event.startTime = NSDate(timeIntervalSince1970: (dict["startTime"] as? NSTimeInterval)!)
        }
        
        if dict["endTime"] != nil {
            event.stopTime = NSDate(timeIntervalSince1970: (dict["stopTime"] as? NSTimeInterval)!)
        }
        
        event.venueAddress = dict["venueAddress"] as? String
        event.cityName = dict["cityName"] as? String
        event.regionName = dict["regionName"] as? String
        event.postalCode = dict["postalCode"] as? String
        event.countryName = dict["countryName"] as? String
        event.latitude = dict["latitude"] as? NSNumber
        event.longitude = dict["longitude"] as? NSNumber
        
        return event
    }
    
    class func fromJson(event: JSON) -> EventFulItem {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        
        let item = EventFulItem()
        item.id = event["id"].stringValue
        item.title = event["title"].stringValue
        item.desc = event["description"].stringValue
        
        if event["image"] != nil {
        
            var imageURL = event["image"]["large"]["url"].stringValue;
            imageURL = imageURL.stringByReplacingOccurrencesOfString("medium", withString: "large")
            
            item.imageURL = NSURL(string: imageURL)
        }
        
        item.url = event["url"].stringValue
        item.venueName = event["venue_name"].stringValue
        item.venueUrl = event["venue_url"].stringValue
        item.startTime = dateFormatter.dateFromString(event["start_time"].stringValue)
        item.stopTime = dateFormatter.dateFromString(event["stop_time"].stringValue)
        item.venueAddress = event["venue_address"].stringValue
        item.cityName = event["city_name"].stringValue
        item.regionName = event["region_name"].stringValue
        item.postalCode = event["postal_code"].stringValue
        item.countryName = event["country_name"].stringValue
        item.latitude = NSNumber(double: event["latitude"].doubleValue)
        item.longitude = NSNumber(double: event["longitude"].doubleValue)
        
        print(item.startTime)
        
        return item
    }
}