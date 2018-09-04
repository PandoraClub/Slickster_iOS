//
//  UserInterest.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/26/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

import Foundation
import Parse

class UserInterest : PFObject, PFSubclassing {
    
    static func interestPrefixFor(activityType: String, templateType: String, time: AgendaTime) -> String {
        
        var activity = activityType.lowercaseString
        if activity == "activity" {
            
            if(templateType == "casual" || templateType == "family" || templateType == "romantic") {
                
                activity = activity + (time.isMorning ? ":morning" : ":afternoon")
            }
        }
        
        let prefix = "\(templateType.lowercaseString)-\(activity)"
        
        return prefix
    }
    
    static func selectionKeyFor(
        activityType: String, templateType: String,
        categoryName: String, time: AgendaTime) -> String {
            
        let prefix = interestPrefixFor(activityType, templateType: templateType, time: time)
        
        return "\(prefix)-\(categoryName.lowercaseString)"
    }
    
    var selectionKey: String {
        
        get {
            
            return "\(interestKey!)"
        }
    }
    
    // Version 1
    var username: String? {
        
        get { return self["username"] as? String }
        set { self["username"] = newValue }
    }
    
    // Version 1
    var interestKey: String? {
        
        get { return self["interestKey"] as? String }
        set { self["interestKey"] = newValue }
    }
    
    // Version 1
    var categoryName: String? {
        
        get { return self["categoryName"] as? String }
        set { self["categoryName"] = newValue }
    }

    // Version 1
    var categoryType: String? {
        
        get { return self["categoryType"] as? String }
        set { self["categoryType"] = newValue }
    }
    
    // Version 1
    var dataVersion: Int? {
        
        get { return self["dataVersion"] as? Int }
        set { self["dataVersion"] = newValue }
    }
    
    class func parseClassName() -> String {
        
        return "UserInterest"
    }
    
    class func parseDataVersion() -> Int {
        
        return 1
    }
}
