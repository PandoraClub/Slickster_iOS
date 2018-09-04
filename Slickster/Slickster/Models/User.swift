//
//  User.swift
//  Slickster
//
//  Created by NonGT on 10/14/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse

class UserDetails : PFObject, PFSubclassing {

    // Version 1
    var username: String? {
    
        get { return self["username"] as? String }
        set { self["username"] = newValue }
    }
    
    // Version 1
    var userPicture: PFFile? {
        
        get { return self["userPicture"] as? PFFile }
        set { self["userPicture"] = newValue }
    }
    
    // Version 1
    var pictureUrl: String? {
        
        get { return self["pictureUrl"] as? String }
        set { self["pictureUrl"] = newValue }
    }
    
    // Version 1
    var displayName: String? {
    
        get { return self["displayName"] as? String }
        set { self["displayName"] = newValue != nil ? newValue : NSNull() }
    }

    // Version 1
    var addressLine1: String? {
        
        get { return self["addressLine1"] as? String }
        set { self["addressLine1"] = newValue != nil ? newValue : NSNull() }
    }
    
    // Version 1
    var addressLine2: String? {
        
        get { return self["addressLine2"] as? String }
        set { self["addressLine2"] = newValue != nil ? newValue : NSNull() }
    }

    // Version 1
    var city: String? {
        
        get { return self["city"] as? String }
        set { self["city"] = newValue != nil ? newValue : NSNull() }
    }

    // Version 1
    var state: String? {
        
        get { return self["state"] as? String }
        set { self["state"] = newValue != nil ? newValue : NSNull() }
    }
    
    // Version 1
    var zipCode: String? {
        
        get { return self["zipCode"] as? String }
        set { self["zipCode"] = newValue != nil ? newValue : NSNull() }
    }
    
    // Version 1
    var country: String? {
        
        get { return self["country"] as? String }
        set { self["country"] = newValue != nil ? newValue : NSNull() }
    }

    // Version 1
    var type: String? {
     
        get { return self["type"] as? String }
        set { self["type"] = newValue }
    }
    
    // Version 1
    var linkedAccounts: [UserAccount]? {
        
        get { return self["userAccount"] as? [UserAccount] }
        set { self["userAccount"] = newValue }
    }
    
    // Version 1
    var dataVersion: Int? {
    
        get { return self["dataVersion"] as? Int }
        set { self["dataVersion"] = newValue }
    }
    
    class func parseClassName() -> String {
        
        return "UserDetails"
    }
    
    class func parseDataVersion() -> Int {
    
        return 1
    }
}