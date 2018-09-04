//
//  EventbriteCategories.swift
//  Slickster
//
//  Created by Lucas on 9/2/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

class EventbriteCategories: NSObject {
    
    static let sharedInstance = EventbriteCategories()
    
    private var categories:[EventbriteCategory] = [EventbriteCategory]()
    private var categoryDict:Dictionary<String, EventbriteCategory> = Dictionary<String, EventbriteCategory>()
    private var categoryByIdDict:Dictionary<String, EventbriteCategory> = Dictionary<String, EventbriteCategory>()
    
    func getCategories() -> [EventbriteCategory] {
        
        if(categories.count == 0) {
            
            let path = NSBundle.mainBundle().pathForResource("eventbrite-categories", ofType: "json")
            let content = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let dataFromString = content?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            
            for item in json.arrayValue {
                
                let category:EventbriteCategory = EventbriteCategory()
                category.id = item["id"].string
                category.name = item["name_localized"].string
                category.shortName = item["short_name_localized"].string
                category.subCategories = [EventbriteSubCategory]()
                
                for subItem in item["subcategories"].arrayValue {
                    let subCategory:EventbriteSubCategory = EventbriteSubCategory()
                    subCategory.id = subItem["id"].string
                    subCategory.name = subItem["name"].string
                    category.subCategories.append(subCategory)
                }
                
                categories.append(category)
                categoryDict[category.name!] = category
                categoryByIdDict[category.id!] = category
            }
        }
        
        return categories
    }
    
    func find(name: String!) -> EventbriteCategory? {
        
        getCategories();
        
        let category = self.categoryDict[name]
        if category != nil {
            
            return self.categoryDict[name]!
        }
        
        return nil
    }
    
    func findById(id: String!) -> EventbriteCategory? {
        
        getCategories();
        
        let category = self.categoryByIdDict[id]
        if category != nil {
            
            return self.categoryByIdDict[id]!
        }
        
        return nil
    }
    
}