//
//  AgendaGenerator.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse
import CoreLocation

class AgendaGenerator: NSObject {
    
    static var templateType: String!
    
    class func generateFromItem(
        location: CLLocationCoordinate2D!,
        userAgenda: UserAgenda!,
        agendaItem: AgendaItem!,
        completion: (NSError?, AgendaItem?) -> Void) {
            
        if agendaItem.condition.eventCategories == nil {
            
            generateYelpAgendaFromItem(location,
                userAgenda: userAgenda,
                agendaItem: agendaItem, completion: completion)
            
        } else {
            
            generateEventFulAgendaFromItem(location,
                userAgenda: userAgenda,
                agendaItem: agendaItem, completion: completion)
        }
    }
    
    private class func generateYelpAgendaFromItem(
        location: CLLocationCoordinate2D!,
        userAgenda: UserAgenda!,
        agendaItem: AgendaItem!,
        completion: (NSError?, AgendaItem?) -> Void) {
        
        var options = YelpSearchOptions()
        options.term = agendaItem.condition!.term
        options.sort = agendaItem.condition!.sort
        options.limit = agendaItem.condition!.limit
        options.offset = agendaItem.condition!.offset
        options.distance = (agendaItem.condition!.distance?.floatValue)! * 1609.344
        options.categories = [String]()
        options.ll = "\(location.latitude)" + "," + "\(location.longitude)"
        
        for cat in agendaItem.condition!.categories {
            
            options.categories!.append(cat.alias!)
        }
        
        UserInterestManager.sharedInstance.ensureUserInterests(
            PFUser.currentUser()!) { (userInterests, error) -> Void in
                
            var isInterestedBySelectionKey = [String:Bool]()
            for userInterest in userInterests! {
                
                isInterestedBySelectionKey[userInterest.selectionKey] = true
            }
            
            YelpClient.sharedInstance.search(options,
                completion: { (businesses: [YelpBusiness]!, error: NSError?) -> Void in
                    
                    var businesses = businesses
                    
                    if(error == nil) {
                        
                        businesses!.sortInPlace({ (a, b) -> Bool in
                            
                            let aCategories = a.categories!.characters
                                .split{$0 == "|"}.map(String.init)
                            
                            let bCategories = b.categories!.characters
                                .split{$0 == "|"}.map(String.init)
                            
                            for category in aCategories {
                                
                                let trimCategory = category.stringByTrimmingCharactersInSet(
                                    NSCharacterSet.whitespaceCharacterSet())
                                
                                let selectionKey = UserInterest.selectionKeyFor(
                                    agendaItem.activityType, templateType: AgendaGenerator.templateType,
                                    categoryName: trimCategory,
                                    time: agendaItem.time)
                                
                                if isInterestedBySelectionKey[selectionKey] == true {
                                    return true
                                }
                            }
                            
                            for category in bCategories {
                                
                                let trimCategory = category.stringByTrimmingCharactersInSet(
                                    NSCharacterSet.whitespaceCharacterSet())
                                
                                let selectionKey = UserInterest.selectionKeyFor(
                                    agendaItem.activityType, templateType: AgendaGenerator.templateType,
                                    categoryName: trimCategory,
                                    time: agendaItem.time)
                                
                                if isInterestedBySelectionKey[selectionKey] == true {
                                    return false
                                }
                            }
                            
                            return false
                        })
                        
                        agendaItem.businesses = [YelpBusiness]()
                        
                        for business in businesses {
                            
                            if(business.coordinate != nil) {
                                
                                agendaItem.businesses!.append(business)
                            }
                        }
                    }
                    
                    print("Error?: \(error)")
                    
                    completion(error, agendaItem)
                }
            )
        }
    }
    
    private class func generateEventFulAgendaFromItem(
        location: CLLocationCoordinate2D!,
        userAgenda: UserAgenda!,
        agendaItem: AgendaItem!,
        completion: (NSError?, AgendaItem?) -> Void) {
            
        var options = EventFulSearchOptions()
        options.category = agendaItem.condition!.eventCategories.first!.id
        options.date = "Future"
        options.location = "\(location.latitude)" + "," + "\(location.longitude)"
        options.units = "km"
        options.within = agendaItem.condition.distance
        
        UserInterestManager.sharedInstance.ensureUserInterests(
            PFUser.currentUser()!) { (userInterests, error) -> Void in
                
            EventFulClient.sharedInstance.search(options,
                completion: { (events: [EventFulItem]!, error: NSError!) -> Void in
                    
                if(error == nil) {
                    
                    agendaItem.events = [EventFulItem]()
                
                    for event in events {
                        
                        if(event.latitude != nil && event.longitude != nil) {
                            
                            agendaItem.events!.append(event)
                        }
                    }
                }
                    
                dispatch_async(dispatch_get_main_queue(), {

                    completion(error, agendaItem)
                })
            })
        }
    }
    
    class func generateFromItems(
        location: CLLocationCoordinate2D!,
        agendaItems: [AgendaItem]!,
        completion: (NSError?, [AgendaItem]!) -> Void) {
        
            
        var currentLocation = location
            
        UserInterestManager.sharedInstance.ensureUserInterests(
            PFUser.currentUser()!) { (userInterests, error) -> Void in
                
            if userInterests == nil {
                
                completion(error, nil)
                return
            }
                
            var isInterestedBySelectionKey = [String:Bool]()
            for userInterest in userInterests! {
                
                isInterestedBySelectionKey[userInterest.selectionKey] = true
            }
    
            let seq = Sequence()
            
            for item in agendaItems {
                let action = SequenceAction(fn: { (callback: (NSError?) -> Void) -> Void in
                    
                    // Also append categories from the selected interests
                    let prefix = UserInterest.interestPrefixFor(
                        item.activityType, templateType: AgendaGenerator.templateType,
                        time: item.time)
                    
                    print("Interest prefix: \(prefix)")
                    
                    let selectedInterests = userInterests!.filter({ elem in
                        
                        return elem.selectionKey.hasPrefix(prefix)
                    })
                    
                    var options = YelpSearchOptions()
                    options.term = item.condition!.term
                    options.sort = item.condition!.sort
                    options.limit = item.condition!.limit
                    options.offset = item.condition!.offset
                    options.distance = item.condition!.distance!.floatValue * 1609.344
                    options.categories = [String]()
                    options.ll = "\(currentLocation.latitude)" + "," + "\(currentLocation.longitude)"
                    
                    print("Searching for type: \(item.activityType)")
                    
                    for userInterest in selectedInterests {
                        
                        let yelpCategory = YelpCategories
                            .sharedInstance.find(userInterest.categoryName)
                        
                        options.categories!.append(yelpCategory.alias!)
                        print("Interest added: \(yelpCategory.alias)")
                    }
                    
                    for cat in item.condition!.categories {
                        
                        options.categories!.append(cat.alias!)
                    }
                    
                    print("Final categories search: \(options.categories!)")
                    
                    searchUntilFoundWithAttemptLimits(options,
                        item: item,
                        attemptLimits: 5,
                        completion: { ( item: AgendaItem, businesses: [YelpBusiness]!, error: NSError?) -> Void in
                            
                            if(error == nil) {
                                
                                item.businesses = [YelpBusiness]()
                                
                                // Clear for further overriden with found categories.
                                item.condition.categories.removeAll()
                                
                                for business in businesses {
                                    
                                    if(business.coordinate == nil) { continue }
                                    
                                    item.businesses!.append(business)
                                    
                                    if(item.condition.categories.count > 0) { continue }
                                    
                                    // Overriden with found categories.
                                    let categories = business.categories!.characters
                                        .split{$0 == "|"}.map(String.init)
                                    
                                    for category in categories {
                                        
                                        let yelpCategory = YelpCategories
                                            .sharedInstance.find(
                                                category.stringByTrimmingCharactersInSet(
                                                    NSCharacterSet.whitespaceCharacterSet()))
                                        
                                        item.condition.categories.append(yelpCategory)
                                    }
                                }
                                
                                item.businesses!.sortInPlace({ (a, b) -> Bool in
                                    
                                    let aCategories = a.categories!.characters
                                        .split{$0 == "|"}.map(String.init)
                                    
                                    let bCategories = b.categories!.characters
                                        .split{$0 == "|"}.map(String.init)
                                    
                                    for category in aCategories {
                                        
                                        let trimCategory = category.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceCharacterSet())
                                        
                                        let selectionKey = UserInterest.selectionKeyFor(
                                            item.activityType, templateType: AgendaGenerator.templateType,
                                            categoryName: trimCategory,
                                            time: item.time)
                                        
                                        if isInterestedBySelectionKey[selectionKey] == true {
                                            return true
                                        }
                                    }
                                    
                                    for category in bCategories {
                                        
                                        let trimCategory = category.stringByTrimmingCharactersInSet(
                                            NSCharacterSet.whitespaceCharacterSet())
                                        
                                        let selectionKey = UserInterest.selectionKeyFor(
                                            item.activityType, templateType: AgendaGenerator.templateType,
                                            categoryName: trimCategory,
                                            time: item.time)
                                        
                                        if isInterestedBySelectionKey[selectionKey] == true {
                                            return false
                                        }
                                    }
                                    
                                    return false
                                })
                                
                                if item.businesses!.count > 0 {
                                    
                                    currentLocation = item.businesses!.first!.coordinate
                                    print("next location: \(currentLocation)")
                                }
                                
                                for business in businesses {
                                    
                                    print("\(business.name): \(business.distance)")
                                }
                            }
                            
                            callback(error)
                        }
                    )
                })
                
                seq.appendTask(action)
            }
            
            seq.run { (err: NSError?) -> Void in
                
                completion(err, agendaItems)
            }
        }
    }
    
    private class func searchUntilFoundWithAttemptLimits(
        options: YelpSearchOptions,
        item: AgendaItem, attemptLimits: Int,
        completion: (AgendaItem, [YelpBusiness]!, NSError!) -> Void) -> AFHTTPRequestOperation {
        
        var options = options
        var attemptLimits = attemptLimits
        
        let opt = YelpClient.sharedInstance.search(options,
            completion: { (businesses: [YelpBusiness]!, error: NSError?) -> Void in
                
                if(error == nil) {
                    
                    if(businesses.count == 0 && attemptLimits > 0) {
                        
                        // Try more search with other categories.
                        options.categories!.removeAll()
                        options.term = nil
                        
                        let group =
                            AgendaDefault.selectableCategories[templateType]
                        
                        let agendaTypeCategories = group!.filter {
                            atc in
                            return atc.type == item.activityType
                            
                        }.first
                        
                        if agendaTypeCategories != nil {
                            
                            if attemptLimits > agendaTypeCategories!.categories!.count - 1 {
                                
                                attemptLimits = agendaTypeCategories!.categories!.count - 1
                            }
                            
                            let category = agendaTypeCategories!
                                .categories![attemptLimits].alias!
                            
                            options.categories!.append(category)
                            
                            searchUntilFoundWithAttemptLimits(
                                options, item: item,
                                attemptLimits: attemptLimits - 1,
                                completion: completion)
                            
                        } else {
                            
                            completion(item, businesses, nil)
                        }
                        
                    } else {
                        
                        completion(item, businesses, nil)
                    }
                    
                } else {
                    
                    if(attemptLimits > 0) {

                        searchUntilFoundWithAttemptLimits(
                            options, item: item,
                            attemptLimits: attemptLimits - 1,
                            completion: completion)

                    } else {
                    
                        completion(item, [], nil)
                    }
                }
            }
        )
            
        return opt
    }
}