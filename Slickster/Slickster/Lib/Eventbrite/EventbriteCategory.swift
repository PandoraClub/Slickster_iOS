//
//  EventbriteCategory.swift
//  Slickster
//
//  Created by Lucas on 9/13/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//


import Foundation

class EventbriteCategory : NSObject {
    
    var id: String!
    var name: String!
    var shortName: String!
    var subCategories: [EventbriteSubCategory]!
    
    func asDictionary() -> [String:AnyObject] {
        
        var dict = [String:AnyObject]()
        dict["id"] = id
        dict["name"] = name
        dict["shortName"] = shortName
        
        var subCategoryDicts = [[String:AnyObject]]()
        for subCategory in subCategories {
            subCategoryDicts.append(subCategory.asDictionary())
        }
        
        dict["subCategories"] = subCategoryDicts
                
        return dict
    }
    
    class func from(title: String!) -> EventbriteCategory? {
        return EventbriteCategories.sharedInstance.find(title)
    }
    
    class func create(dict: [String:AnyObject]) -> EventbriteCategory {
        
        let category = EventbriteCategory()
        category.id = dict["id"] as? String
        category.name = dict["name"] as? String
        category.shortName = dict["shortName"] as? String
        
        var subCategories = [EventbriteSubCategory]()
        for subCategoryDict in dict["subCategories"] as! [[String:AnyObject]] {
            
            let subCategory = EventbriteSubCategory.create(subCategoryDict)
            subCategories.append(subCategory)
        }
        
        category.subCategories = subCategories
        
        return category
    }
}