//
//  YelpSearchCondition.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class AgendaSearchCondition {

    var type: String!
    var categories: [YelpCategory]!
    var eventCategories: [EventFulCategory]!
    var eventBriteCategories: [EventbriteCategory]!
    var limit: NSNumber!
    var offset: NSNumber?
    var term: String?
    var sort: NSNumber?
    var distance: NSNumber?
    
    func asDictionary() -> [String:AnyObject]? {
        
        var categoriesDict: [[String:AnyObject]]? = nil
        if categories != nil {
        
            categoriesDict = [[String:AnyObject]]()
            for category in categories {
                
                categoriesDict!.append(category.asDictionary())
            }
        }
        
        var eventCategoriesDict: [[String:AnyObject]]? = nil
        if eventCategories != nil {
            
            eventCategoriesDict = [[String:AnyObject]]()
            for category in eventCategories {
                
                eventCategoriesDict!.append(category.asDictionary())
            }
        }
        
        var eventBriteCategoriesDict: [[String:AnyObject]]? = nil
        if eventBriteCategories != nil {
            
            eventBriteCategoriesDict = [[String:AnyObject]]()
            for category in eventBriteCategories {
                
                eventBriteCategoriesDict!.append(category.asDictionary())
            }
        }
    
        var dict = [String:AnyObject]()
        dict["type"] = type
        dict["categories"] = categoriesDict
        dict["eventCategories"] = eventCategoriesDict
        dict["eventBriteCategories"] = eventBriteCategoriesDict
        dict["limit"] = limit
        dict["offset"] = offset
        dict["term"] = term
        dict["sort"] = sort
        dict["distance"] = distance
        
        return dict
    }
    
    class func create(dict: [String:AnyObject]) -> AgendaSearchCondition {
    
        let condition = AgendaSearchCondition()
        condition.type = dict["type"] as? String
        condition.limit = dict["limit"] as? NSNumber
        condition.offset = dict["offset"] as? NSNumber
        condition.term = dict["term"] as? String
        condition.sort = dict["sort"] as? NSNumber
        condition.distance = dict["distance"] as? NSNumber
        
        let categoryArray = dict["categories"] as! NSArray
        var categories = [YelpCategory]()
        for (index, _) in categoryArray.enumerate() {
            
            let category = YelpCategory.create(categoryArray[index] as! [String:AnyObject])
            categories.append(category)
        }
        
        condition.categories = categories
        
        if dict["eventCategories"] != nil {

            let eventCategoryArray = dict["eventCategories"] as! NSArray
            var eventCategories = [EventFulCategory]()
            for (index, _) in eventCategoryArray.enumerate() {
                
                let category = EventFulCategory.create(eventCategoryArray[index] as! [String:AnyObject])
                eventCategories.append(category)
            }
            
            condition.eventCategories = eventCategories
        }
        
        if dict["eventBriteCategories"] != nil {
            
            let eventBriteCategoryArray = dict["eventBriteCategories"] as! NSArray
            var eventBtiteCategories = [EventbriteCategory]()
            for (index, _) in eventBriteCategoryArray.enumerate() {
                
                let category = EventbriteCategory.create(eventBriteCategoryArray[index] as! [String:AnyObject])
                eventBtiteCategories.append(category)
            }
            
            condition.eventBriteCategories = eventBtiteCategories
        }
        
        return condition
    }
    
    class func create(type: String? = "yelp",
        categories: [YelpCategory]! = nil,
        eventCategories: [EventFulCategory]! = nil,
        eventBriteCategories: [EventbriteCategory]! = nil,
        distance: Float! = 1,
        limit: Int! = 20,
        offset: Int? = nil,
        term: String? = nil,
        sort: YelpSortMode? = nil) -> AgendaSearchCondition {
            
        let condition = AgendaSearchCondition()
        
        condition.type = type
        condition.categories = categories
        condition.eventCategories = eventCategories
        condition.eventBriteCategories = eventBriteCategories
        condition.limit = limit
        condition.offset = offset
        condition.term = term
        condition.sort = sort?.rawValue
        condition.distance = distance
            
        return condition
    }
}