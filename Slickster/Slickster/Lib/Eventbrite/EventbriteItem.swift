//
//  EventbriteItem.swift
//  Slickster
//
//  Created by Lucas on 9/2/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

class EventbriteItem: NSObject {
    
    var id: String?
    
    var name: String?
    var desc: String?
    var url: String?
    var vanityURL: String?
    var imageURL: NSURL?
    
    var startTime: NSDate?
    var stopTime: NSDate?
    var status: String?
    
    var currency: String?
    var isOnlineEvent: Bool?
    var isLocked: Bool?
    var isReservedSeating: Bool?
    var locale: String?
    var venuId: String?
    
    var venu:EventbriteItemVenu?
    
    /*var venueName: String?
    var venueAddress: String?
    var cityName: String?
    var regionName: String?
    var postalCode: String?
    var countryName: String?
    
    var latitude: NSNumber?
    var longitude: NSNumber?*/
    
    func asDictionary() -> [String:AnyObject] {
        
        var dict = [String:AnyObject]()
        
        dict["id"] = id
        dict["name"] = name
        dict["desc"] = desc
        dict["url"] = url
        dict["vanityURL"] = vanityURL
        
        if imageURL?.absoluteString != nil {
            
            dict["imageURL"] = imageURL!.absoluteString
        }
        
        dict["startTime"] = startTime?.timeIntervalSince1970
        dict["stopTime"] = stopTime?.timeIntervalSince1970
        dict["status"] = status
        dict["currency"] = currency
        dict["isOnlineEvent"] = isOnlineEvent
        dict["isLocked"] = isLocked
        dict["isReservedSeating"] = isReservedSeating
        dict["locale"] = locale
        dict["venuId"] = venuId
        
        return dict
    }
    
    class func fromJson(event: JSON) -> EventbriteItem {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let item = EventbriteItem()
        item.id = event["id"].stringValue
        item.name = event["name"]["text"].stringValue
        item.desc = event["description"]["text"].stringValue
        item.url = event["url"].stringValue
        
        if event["logo"] != nil {
            let imageURL = event["logo"]["url"].stringValue
            item.imageURL = NSURL(string: imageURL)
        }
        
        item.vanityURL = event["vanity_url"].stringValue
        
        item.startTime = dateFormatter.dateFromString(event["start"]["local"].stringValue)
        item.stopTime = dateFormatter.dateFromString(event["end"]["local"].stringValue)

        item.status = event["status"].stringValue
        item.currency = event["currency"].stringValue
        item.isOnlineEvent = event["online_event"].boolValue
        item.isLocked = event["is_locked"].boolValue
        item.isReservedSeating = event["is_reserved_seating"].boolValue
        item.locale = event["locale"].stringValue
        item.venuId = event["venue_id"].stringValue
        
        /*item.venueName = event["venue_name"].stringValue
        item.venueUrl = event["venue_url"].stringValue
        item.venueAddress = event["venue_address"].stringValue
        item.cityName = event["city_name"].stringValue
        item.regionName = event["region_name"].stringValue
        item.postalCode = event["postal_code"].stringValue
        item.countryName = event["country_name"].stringValue
        item.latitude = NSNumber(double: event["latitude"].doubleValue)
        item.longitude = NSNumber(double: event["longitude"].doubleValue)*/
        
        return item
    }
    
    func getVenu(completion: (EventbriteItemVenu!, NSError!)-> Void)
    {
        let url = NSURL(string: "\(Config.Eventbrite.endpoint)/venues/\(self.venuId!)/?token=\(Config.Eventbrite.appKey)")
        print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if data == nil {
                
                self.venu = nil
                completion(self.venu, nil)
                return
            }
            
            let json = JSON(data: data!)
            //print(json)
            
            self.venu = EventbriteItemVenu.fromJson(json)
            completion(self.venu, nil)
        }
        task.resume()
    }
    
    class func create(dict: [String:AnyObject]) -> EventbriteItem {
        
        let event = EventbriteItem()
        
        
        event.id = dict["id"] as? String
        event.name = dict["name"] as? String
        event.desc = dict["desc"] as? String
        event.url = dict["url"] as? String
        event.vanityURL = dict["vanityURL"] as? String
        
        if let imageURL = dict["imageURL"] {
            event.imageURL = NSURL(string: imageURL as! String)
        }
        
        if dict["startTime"] != nil {
            event.startTime = NSDate(timeIntervalSince1970: (dict["startTime"] as? NSTimeInterval)!)
        }
        
        if dict["endTime"] != nil {
            event.stopTime = NSDate(timeIntervalSince1970: (dict["stopTime"] as? NSTimeInterval)!)
        }
        
        event.status = dict["status"] as? String
        event.currency = dict["currency"] as? String
        event.isOnlineEvent = dict["isOnlineEvent"] as? Bool
        event.isLocked = dict["isLocked"] as? Bool
        event.isReservedSeating = dict["isReservedSeating"] as? Bool
        event.locale = dict["locale"] as? String
        event.venuId = dict["venuId"] as? String
        
        return event
    }

}