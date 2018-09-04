//
//  YelpCategory.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit

class YelpCategory : NSObject {

    var alias: String!
    var country_whitelist: [String]!
    var country_blacklist: [String]!
    var parents: [String]!
    var title: String!
    
    func asDictionary() -> [String:AnyObject] {
    
        var dict = [String:AnyObject]()
        dict["alias"] = alias
        dict["country_whitelist"] = country_whitelist
        dict["country_blacklist"] = country_blacklist
        dict["parents"] = parents
        dict["title"] = title
        
        return dict
    }
    
    class func from(title: String!) -> YelpCategory {
        
        return YelpCategories.sharedInstance.find(title)
    }
    
    class func create(dict: [String:AnyObject]) -> YelpCategory {
        
        let category = YelpCategory()
        category.alias = dict["alias"] as? String
        category.country_whitelist = dict["country_whitelist"] as? [String]
        category.country_blacklist = dict["country_blacklist"] as? [String]
        category.parents = dict["parents"] as? [String]
        category.title = dict["title"] as! String
        
        return category
    }
}