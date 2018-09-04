//
//  SavedAgendaList.swift
//  Slickster
//
//  Created by NonGT on 10/16/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import CoreLocation
import Parse
import SwiftyJSON

class UserAgenda : PFObject, PFSubclassing {
    
    var agendaItems: [AgendaItem]?
    
    // Version 1
    var uuid: String? {
    
        get { return self["uuid"] as? String }
        set { self["uuid"] = newValue }
    }

    // Version 1
    var username: String? {
     
        get { return self["username"] as? String }
        set { self["username"] = newValue }
    }
    
    // Version 1
    var templateType: String? {
    
        get { return self["templateType"] as? String }
        set { self["templateType"] = newValue }
    }
    
    // Version 1
    var name: String? {
    
        get { return self["name"] as? String }
        set { self["name"] = newValue }
    }
    
    // Version 1
    var note: String? {
        
        get { return self["note"] as? String }
        set { self["note"] = newValue }
    }
    
    // Version 1
    var location: String? {
    
        get { return self["location"] as? String }
        set { self["location"] = (newValue == nil ? NSNull() : newValue) }
    }
    
    // Version 1
    var district: String? {
        
        get { return self["district"] as? String }
        set { self["district"] = (newValue == nil ? NSNull() : newValue) }
    }
    
    // Version 1
    var date: NSDate? {
    
        get { return self["date"] as? NSDate }
        set { self["date"] = (newValue == nil ? NSNull() : newValue) }
    }
    
    // Version 1
    var createCalendarEvent: Bool? {
     
        get { return self["createCalendarEvent"] as? Bool }
        set { self["createCalendarEvent"] = newValue }
    }
    
    // Version 1
    var isPublic: Bool? {
        
        get { return self["isPublic"] as? Bool }
        set { self["isPublic"] = newValue }
    }
    
    // Version 1
    var calendarEventId: String? {
     
        get { return self["calendarEventId"] as? String }
        set { self["calendarEventId"] = newValue }
    }
    
    // Version 1
    var shareOnGoogleCalendar: Bool? {
    
        get { return self["shareOnGoogleCalendar"] as? Bool }
        set { self["shareOnGoogleCalendar"] = newValue }
    }

    // Version 1
    var shareOnFacebookEvent: Bool? {
        
        get { return self["shareOnFacebookEvent"] as? Bool }
        set { self["shareOnFacebookEvent"] = newValue }
    }

    // Version 1
    var dataVersion: Int? {
        
        get { return self["dataVersion"] as? Int }
        set { self["dataVersion"] = newValue }
    }
    
    func prepareForSave() {
        
        var agendaItemsDict = [[String:AnyObject]]()
        for agendaItem in agendaItems! {
        
            agendaItemsDict.append(agendaItem.asDictionary())
        }
        
        let json = JSON(agendaItemsDict)
        let str = json.rawString()
        
        print(str)
        
        self["agendaItems"] = json.rawString()
    }
    
    func ensureAgendaItems() {
        
        if(agendaItems != nil) {
         
            return
        }
        
        let raw = self["agendaItems"] as! String
        let data = raw.dataUsingEncoding(NSUTF8StringEncoding)!
        let array = JSON(data: data).arrayValue
        
        agendaItems = [AgendaItem]()
        for (index, _) in array.enumerate() {
            
            let agendaItem = AgendaItem.create(array[index].dictionaryObject!)
            agendaItems!.append(agendaItem)
        }
    }
        
    class func parseClassName() -> String {
        
        return "UserAgenda"
    }
    
    class func parseDataVersion() -> Int {
        
        return 1
    }
}