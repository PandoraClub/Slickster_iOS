//
//  EventFulClient.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 12/15/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let eventFulAppKey = Config.eventFul.appKey

class EventFulClient {
    
    var appKey: String!
    
    class var sharedInstance : EventFulClient {
        
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : EventFulClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = EventFulClient(
                appKey: eventFulAppKey)
        }
        
        return Static.instance!
    }
    
    init(appKey key: String!) {
            
        self.appKey = key
    }
    
    func search(options: EventFulSearchOptions,
        completion: ([EventFulItem]!, NSError!) -> Void) {
            
        var parameters = [String: String]()
        
        parameters["app_key"] = Config.eventFul.appKey
        parameters["image_sizes"] = "large"
        parameters["include"] = "image"
        parameters["change_multi_day_start"] = "false"
        parameters["sort_order"] = "date"
        parameters["sort_direction"] = "asc"
        
        if(options.location != nil) {
            parameters["location"] = options.location!
        }
        
        if(options.date != nil) {
            parameters["date"] = options.date!
        }
        
        if(options.category != nil) {
            parameters["category"] = options.category!
        }
        
        if(options.within != nil) {
            parameters["within"] = options.within!.stringValue
        }

        if(options.units != nil) {
            parameters["units"] = options.units!
        }
        
        let qs = buildQueryString(fromDictionary: parameters)
        let url = NSURL(string: "\(Config.eventFul.endpoint)events/search\(qs)")
            
        print(qs)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            var items = [EventFulItem]()
            
            let json = JSON(data: data!)
            let events = json["events"]["event"].arrayValue
            
            for event in events {
                
                let item = EventFulItem.fromJson(event)
                items.append(item)
            }
            
            completion(items, nil)
        }
        
        task.resume()
    }
    
    private func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars = [String]()
        for (k, var v) in parameters {
            v = v.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            urlVars += [k + "=" + "\(v)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}