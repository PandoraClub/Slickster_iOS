//
//  UserAgendaCalendarSharing.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/17/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse
import EventKit

class UserAgendaCalendar : PFObject, PFSubclassing {
    
    var calendar: EKCalendar?

    // Version 1
    var userAgendaId: String? {
        
        get { return self["userAgendaId"] as? String }
        set { self["userAgendaId"] = newValue }
    }

    // Version 1
    var calendarId: String? {
        
        get { return self["calendarId"] as? String }
        set { self["calendarId"] = newValue }
    }
    
    // Version 1
    var shared: Bool? {
        
        get { return self["shared"] as? Bool }
        set { self["shared"] = newValue }
    }
    
    // Version 1
    var eventId: String? {
        
        get { return self["eventId"] as? String }
        set { self["eventId"] = newValue }
    }
    
    class func parseClassName() -> String {
        
        return "UserAgendaCalendar"
    }
    
    class func parseDataVersion() -> Int {
        
        return 1
    }
}