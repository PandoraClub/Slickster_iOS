//
//  Agenda.swift
//  Slickster
//
//  Created by NonGT on 9/14/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import Parse

class AgendaItem {

    var activityType: String!
    var eventCategory: String!
    var time: AgendaTime!
    var condition: AgendaSearchCondition!
    var eventBriteCondition: EventbriteSearchOptions!
    var selectedPlaceIndex: Int! = 0
    var sourceInstance: AgendaItem?
    var businesses: [YelpBusiness]?
    var events: [EventFulItem]?
    var eventBrites: [EventbriteItem]?
    
    convenience init(activityType: String!, time: AgendaTime,
                     condition: AgendaSearchCondition!) {
        
            self.init(
                activityType: activityType,
                time: time,
                condition: condition,
                sourceInstance: nil)
    }
    
    convenience init(activityType: String!, eventCategory: String!, time: AgendaTime,
                     condition: AgendaSearchCondition!) {
        
        self.init()
        self.activityType = activityType
        self.eventCategory = eventCategory
        self.time = time
        self.condition = condition
        
    }

    convenience init(activityType: String!, time: AgendaTime,
        condition: AgendaSearchCondition!, sourceInstance: AgendaItem?) {
            
        self.init()
            
        self.activityType = activityType
        self.time = time
        self.condition = condition
        self.sourceInstance = sourceInstance
    }
    
    init() {
        
    }
    
    func asAnotherInstance() -> AgendaItem {
        
        if(self.activityType == "Eventbrite")
        {
            return AgendaItem(activityType: self.activityType, eventCategory: self.eventCategory,
                              time: self.time, condition: self.condition)
        }
        else {
            let condition = AgendaSearchCondition.create()
            
            condition.distance = self.condition!.distance
            condition.sort = self.condition!.sort
            
            if self.condition!.categories != nil {
                
                condition.categories = [YelpCategory]()
                
                for c in self.condition!.categories {
                    condition.categories.append(c)
                }
            }
            
            if self.condition!.eventCategories != nil {
                
                condition.eventCategories = [EventFulCategory]()
                
                for c in self.condition!.eventCategories {
                    condition.eventCategories.append(c)
                }
            }
            
            return AgendaItem(
                activityType: self.activityType,
                time: self.time!,
                condition: condition,
                sourceInstance: self)
        }
    }
    
    func asDictionary() -> [String:AnyObject] {
     
        var dict = [String:AnyObject]()
        dict["activityType"] = activityType
        dict["time"] = time.format()
        
        
        dict["condition"] = condition.asDictionary()
        dict["selectedPlaceIndex"] = selectedPlaceIndex
        
        var places = [[String:AnyObject]]()
        var events = [[String:AnyObject]]()
        var eventBrites = [[String:AnyObject]]()
        
        if self.businesses != nil {
            
            for business in self.businesses! {
             
                places.append(business.asDictionary())
            }
        }
        
        if self.events != nil {
            
            for event in self.events! {
                
                events.append(event.asDictionary())
            }
        }
        
        if self.eventBrites != nil {
            for eventBrite in self.eventBrites! {
                
                eventBrites.append(eventBrite.asDictionary())
            }
        }
        
        dict["places"] = places
        dict["events"] = events
        dict["eventBrites"] = eventBrites
        
        return dict
    }
    
    func commitChangesToSourceInstance() {
        
        if sourceInstance != nil {
            
            sourceInstance!.activityType = self.activityType
            sourceInstance!.time = self.time
            sourceInstance!.condition = self.condition
        }
    }
    
    class func create(dict: [String:AnyObject]) -> AgendaItem {
        
        let agendaItem = AgendaItem()
    
        agendaItem.activityType = dict["activityType"] as? String
        agendaItem.time = AgendaTime.parse(dict["time"] as! String)
        agendaItem.condition = AgendaSearchCondition.create(dict["condition"] as! [String:AnyObject])
        agendaItem.selectedPlaceIndex = dict["selectedPlaceIndex"] as! Int
        
        let placeDict = dict["places"] as? NSArray
        let eventDict = dict["events"] as? NSArray
        
        if(placeDict != nil && placeDict!.count > 0) {
            
            agendaItem.businesses = [YelpBusiness]()
            for (index, _) in placeDict!.enumerate() {
                
                let business = YelpBusiness.create(placeDict![index] as! [String:AnyObject])
                agendaItem.businesses!.append(business)
            }
        }
        
        if(eventDict != nil && eventDict!.count > 0) {
            
            agendaItem.events = [EventFulItem]()
            for (index, _) in eventDict!.enumerate() {
                
                let event = EventFulItem.create(eventDict![index] as! [String:AnyObject])
                agendaItem.events!.append(event)
            }
        }
        
        return agendaItem
    }
}