//
//  EventFulCattegories.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 12/6/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import UIKit

class EventFulCategories: NSObject {
    
    static let sharedInstance = EventFulCategories()
    
    private var categories:[EventFulCategory] = [EventFulCategory]()
    private var categoryDict:Dictionary<String, EventFulCategory> = Dictionary<String, EventFulCategory>()
    private var categoryByIdDict:Dictionary<String, EventFulCategory> = Dictionary<String, EventFulCategory>()
    
    func getCategories() -> [EventFulCategory] {
        
        if(categories.count == 0) {
            
            let path = NSBundle.mainBundle().pathForResource("eventful-categories", ofType: "json")
            let content = try? String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
            let dataFromString = content?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let json = JSON(data: dataFromString!)
            
            for item in json.arrayValue {
                
                let category:EventFulCategory = EventFulCategory();
                category.id = item["id"].string
                category.name = item["name"].string
                category.parent = item["parent"].string
                category.visible = item["visible"].bool
                
                categories.append(category)
                categoryDict[category.name!] = category
                categoryByIdDict[category.id!] = category
            }
        }
        
        return categories
    }
    
    func find(name: String!) -> EventFulCategory? {
        
        getCategories();
        
        let category = self.categoryDict[name]
        if category != nil {
            
            return self.categoryDict[name]!
        }
        
        return nil
    }
    
    func findById(id: String!) -> EventFulCategory? {
        
        getCategories();
        
        let category = self.categoryByIdDict[id]
        if category != nil {
            
            return self.categoryByIdDict[id]!
        }
        
        return nil
    }
    
    func getRootCategories() -> [EventFulCategory] {
        
        let categories = getCategories()
        
        return categories.filter({category in
            
            return category.visible == true && category.parent == nil
        })
    }
    
    func getSubCategories(parent: EventFulCategory) -> [EventFulCategory] {
        
        let categories = getCategories()
        
        return categories.filter({category in
            
            return category.visible == true && category.parent == parent.id
        })
    }
}