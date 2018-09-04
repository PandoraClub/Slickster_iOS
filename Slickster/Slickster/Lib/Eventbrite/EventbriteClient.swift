//
//  EventbriteClient.swift
//  Slickster
//
//  Created by Lucas on 9/2/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import Foundation

let EventbriteAppKey = Config.Eventbrite.appKey

class EventbriteClient {
    
    var appKey: String!
    var arrCategories:[JSON]!
    
    class var sharedInstance : EventbriteClient {
        
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : EventbriteClient? = nil
        }
        
        dispatch_once(&Static.token) {
            Static.instance = EventbriteClient(
                appKey: EventbriteAppKey)
        }
        
        return Static.instance!
    }
    
    init(appKey key: String!) {
        
        self.appKey = key
    }
    
    func getCategories(completion:([JSON], NSError!)->Void)
    {
        let url = NSURL(string: "\(Config.Eventbrite.endpoint)/categories/?token=\(self.appKey)")
        print(url)

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            let json = JSON(data: data!)
            //print(json)
            completion(json["categories"].arrayValue, nil)
        }
        task.resume()
    }
    
    func getCategoryIdByName(categoryName:String, categories:[JSON]) -> String
    {
        var categoryIdSelected:String = ""
        for category in categories
        {
            if category["name_localized"].string?.lowercaseString == categoryName.lowercaseString
            {
                categoryIdSelected = String(category["id"])
                break
            }
        }
        
        return categoryIdSelected
    }
    
    func getEventVenu(event:EventbriteItem, group: dispatch_group_t) {
        event.getVenu { (eventVenu, error) in
            
            // request finished
            print("Event \(event.name) venu pulled.")
            
            // let's parse response in different queue, because we don't want to hold main UI queue
            let db_queue = dispatch_queue_create("db_queue", nil)
            dispatch_async(db_queue, {
                event.venu = eventVenu
                
                // leave group
                dispatch_group_leave(group)
            })
        }
    }
    
    func searchEventWithCategoryName(location: CLLocationCoordinate2D!, categoryName:String!, time: AgendaTime!, completion:([EventbriteItem]!, NSError!) -> Void)
    {
        
        let eventBriteCategory = EventbriteCategories.sharedInstance.find(categoryName)
        
        var searchOptions = EventbriteSearchOptions()
        searchOptions.categories = eventBriteCategory?.id
        searchOptions.latitude = location.latitude.description
        searchOptions.longitude = location.longitude.description
        searchOptions.distance = "1mi"
        searchOptions.sortBy = "date"
        
        //searchOptions.dateKeyword = "this_week"
        // Making Agenda Time of Today
        /*let today = NSDate()
         let dateFormatter = NSDateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         let dateString = /*dateFormatter.stringFromDate(today)*/"2016-09-03" + " \(String(format: "%02d", time.hour)):\(String(format: "%02d", time.minute)):00"
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         searchOptions.startDate = dateFormatter.dateFromString(dateString)*/
        
        self.searchEvent(searchOptions, completion: { (events, error) in
            
            let dispatchGroup: dispatch_group_t = dispatch_group_create()
            
            for event in events {
                // enter group and run request
                dispatch_group_enter(dispatchGroup)
                self.getEventVenu(event, group: dispatchGroup)
            }
            
            dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), {
                completion(events, error)
            });
        })
            
    }
    
    func searchEvent(options: EventbriteSearchOptions, completion: ([EventbriteItem]!, NSError!) -> Void)
    {
        var parameters = [String: String]()
        
        parameters["token"] = Config.Eventbrite.appKey

        if(options.q != nil) {
            parameters["q"] = options.q!
        }
        if(options.categories != nil) {
            parameters["categories"] = options.categories!
        }
        if(options.subCategories != nil) {
            parameters["subcategories"] = options.subCategories!
        }
        if(options.sortBy != nil) {
            parameters["sort_by"] = options.sortBy!
        }
        if(options.location != nil) {
            parameters["location.address"] = options.location!
        }
        if(options.distance != nil) {
            parameters["location.within"] = options.distance!
        }
        if(options.latitude != nil) {
            parameters["location.latitude"] = options.latitude!
        }
        if(options.longitude != nil) {
            parameters["location.longitude"] = options.longitude!
        }
        if(options.price != nil) {
            parameters["price"] = options.price!
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ss"
        
        if(options.startDate != nil) {
            parameters["start_date.range_start"] = dateFormatter.stringFromDate(options.startDate!);
        }
        if(options.stopDate != nil) {
            parameters["start_date.range_end"] = dateFormatter.stringFromDate(options.stopDate!);
        }
        if(options.dateKeyword != nil) {
            parameters["start_date.keyword"] = options.dateKeyword!
        }
        if(options.dateModifiedStart != nil) {
            parameters["date_modified.range_start"] = dateFormatter.stringFromDate(options.dateModifiedStart!);
        }
        if(options.dateModifiedEnd != nil) {
            parameters["date_modified.range_end"] = dateFormatter.stringFromDate(options.dateModifiedEnd!);
        }
        if(options.dateModifiedKeyword != nil) {
            parameters["date_modified.keyword"] = options.dateModifiedKeyword!
        }
        
        if(options.searchType != nil) {
            parameters["search_type"] = options.searchType!
        }
        
        
        let qs = buildQueryString(fromDictionary: parameters)
        
        let url = NSURL(string: "\(Config.Eventbrite.endpoint)/events/search/\(qs)")
        //print(url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if data == nil {
                
                completion([EventbriteItem](), nil)
                return
            }
            
            let json = JSON(data: data!)
            //print(json)
            
            var items = [EventbriteItem]()
            let events = json["events"].arrayValue
            
            for event in events {
                let item = EventbriteItem.fromJson(event)
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
