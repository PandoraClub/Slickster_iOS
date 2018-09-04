//
//  AgendaTime.swift
//  Slickster
//
//  Created by NonGT on 9/29/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class AgendaTime : NSObject {
    
    var hour: Int!
    var minute: Int!
    
    class func create(hour: Int, minute: Int) -> AgendaTime {
        
        let time = AgendaTime()
        
        time.hour = hour
        time.minute = minute
        
        return time
    }
    
    class func createEmpty() -> AgendaTime {
        
        let time = AgendaTime()
        time.hour = -1
        time.minute = -1
        
        return time
    }
    
    func format() -> String {
    
        var timeHour = self.hour
        var ampm = "AM"
        
        if(timeHour == 12) {
            
            ampm = "PM"
            
        } else if(timeHour > 12) {
            
            ampm = "PM"
            timeHour = timeHour - 12
        }
        
        if(timeHour < 0) {
            
            return ""
        }
        
        if(self.minute > 0) {
            
            return
                String(format: "%02d", timeHour) + ":" +
                String(format: "%02d", self.minute) + " " + ampm
        } else {
            
            return String(format: "%01d", timeHour) + ampm
        }
    }
    
    var isDayTime: Bool {
        
        get {
            
            return self.hour >= 6 && self.hour <= 18
        }
    }
    
    var isAfternoon: Bool {
        
        get {
            
            return self.hour >= 12
        }
    }

    var isMorning: Bool {
        
        get {
            
            return self.hour >= 6 && self.hour < 12
        }
    }

    class func parse(time: String) -> AgendaTime {
        
        var parts = time.characters.split(" ")
        if parts.count == 1 {
            
            var processed = String(parts[0]).stringByReplacingOccurrencesOfString("AM", withString: "")
            processed = String(processed).stringByReplacingOccurrencesOfString("PM", withString: "")
            
            parts = String(processed).characters.split(":")
            
            var hour = Int(String(parts[0]))
            var minute = 0
            
            if(parts.count > 1) {
                
                minute = Int(String(parts[1]))!
            }
            
            if hour == nil {
                hour = 0
            }
            
            return AgendaTime.create(hour!, minute: minute)
        }
        
        if parts.count == 2 {
            
            let ampm = String(parts[1]);
            parts = String(parts[0]).characters.split(":")
            
            var hour = Int(String(parts[0]))
            let minute = Int(String(parts[1]))
            
            if(ampm == "PM") {
                
                if(hour < 12) {
                    
                    hour = hour! + 12
                    
                } else if(hour > 12) {
                    
                    hour = 12
                }
                
                return AgendaTime.create(hour!, minute: minute!)
                
            } else {
                
                if(hour > 12) {
                    hour = 12
                }
                
                if(hour == 12) {
                    hour = 0
                }
                
                return AgendaTime.create(hour!, minute: minute!)
            }
        }
        
        return AgendaTime.create(0, minute: 0)
    }
}

func <(left: AgendaTime, right: AgendaTime) -> Bool {
    
    if left.hour == right.hour {
     
        return left.minute < right.minute
    }
    
    return left.hour < right.hour
}

func <=(left: AgendaTime, right: AgendaTime) -> Bool {
    
    if left.hour == right.hour {
        
        return left.minute <= right.minute
    }
    
    return left.hour <= right.hour
}

func >(left: AgendaTime, right: AgendaTime) -> Bool {
    
    if left.hour == right.hour {
        
        return left.minute > right.minute
    }
    
    return left.hour > right.hour
}

func >=(left: AgendaTime, right: AgendaTime) -> Bool {
    
    if left.hour == right.hour {
        
        return left.minute >= right.minute
    }
    
    return left.hour >= right.hour
}