//
//  EventbriteSubCategory.swift
//  Slickster
//
//  Created by Lucas on 9/13/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

class EventbriteSubCategory: NSObject {
    
    var id: String!
    var name: String!
    
    func asDictionary() -> [String:AnyObject] {
        
        var dict = [String:AnyObject]()
        dict["id"] = id
        dict["name"] = name
        
        return dict
    }

    class func create(dict: [String:AnyObject]) -> EventbriteSubCategory {
     
        let subCategory = EventbriteSubCategory()
        subCategory.id = dict["id"] as? String
        subCategory.name = dict["name"] as? String
        
        return subCategory
    }
}
