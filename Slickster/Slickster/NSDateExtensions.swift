//
//  NSDateExtensions.swift
//  Slickster
//
//  Created by NonGT on 11/2/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

extension NSDate {

    var isBeforeToday: Bool {
        
        get {
            
            let calendar = NSCalendar.currentCalendar()
            
            let pureDate = calendar.startOfDayForDate(self)
            let today = calendar.startOfDayForDate(NSDate())
            
            return pureDate.timeIntervalSinceDate(today).isSignMinus
        }
    }
    
    var weekdayTitle: String {
    
        get {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([
                NSCalendarUnit.Day, .Month, .Year, .Weekday], fromDate: self)
            
            return "\(getWeekdayTitle(components.weekday)) \(components.day)"
        }
    }
    
    var weekdayDayMonthTitle: String {
        
        get {
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([
                NSCalendarUnit.Day, .Month, .Year, .Weekday], fromDate: self)
            
            return
                "\(getWeekdayTitle(components.weekday)) " +
                "\(components.day) \(getLongMonthName(components.month))"
        }
    }
    
    func asKey() -> String {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([
            NSCalendarUnit.Day, .Month, .Year, .Weekday], fromDate: self)
        
        return "\(components.year)-\(components.month)-\(components.day)"
    }
    
    private func getWeekdayTitle(weekday: Int) -> String {
        
        switch(weekday) {
            
            case 1: return "Sun"
            case 2: return "Mon"
            case 3: return "Tue"
            case 4: return "Wed"
            case 5: return "Thu"
            case 6: return "Fri"
            case 7: return "Sat"
            default: return ""
        }
    }
    
    private func getMonthName(monthNumber: Int) -> String {
        
        switch(monthNumber) {

            case 1: return "Jan"
            case 2: return "Feb"
            case 3: return "Mar"
            case 4: return "Apr"
            case 5: return "May"
            case 6: return "Jun"
            case 7: return "Jul"
            case 8: return "Aug"
            case 9: return "Sep"
            case 10: return "Oct"
            case 11: return "Nov"
            case 12: return "Dec"
                
            default: return ""
        }
    }
    
    private func getLongMonthName(monthNumber: Int) -> String {
        
        switch(monthNumber) {
            
            case 1: return "January"
            case 2: return "February"
            case 3: return "March"
            case 4: return "April"
            case 5: return "May"
            case 6: return "June"
            case 7: return "July"
            case 8: return "August"
            case 9: return "September"
            case 10: return "October"
            case 11: return "November"
            case 12: return "December"
                
            default: return ""
        }
    }
}