//
//  AgendaTypeCategories.swift
//  Slickster
//
//  Created by NonGT on 9/27/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

struct AgendaTypeCategories {
    
    let type: String!
    let interestPrefix: String?
    let minTime: AgendaTime?
    let maxTime: AgendaTime?
    let categories: [YelpCategory]!
    let eventCategories: [EventFulCategory]!
    
    init(type: String, minTime: AgendaTime?, maxTime: AgendaTime?, categories: [YelpCategory]?) {
        
        self.type = type
        self.interestPrefix = type.lowercaseString
        self.minTime = minTime
        self.maxTime = maxTime
        self.categories = categories
        self.eventCategories = nil
    }

    init(type: String, interestPrefix: String?,
         minTime: AgendaTime?, maxTime: AgendaTime?, categories: [YelpCategory]?) {
        
        self.type = type
        self.interestPrefix = interestPrefix
        self.minTime = minTime
        self.maxTime = maxTime
        self.categories = categories
        self.eventCategories = nil
    }

    init(type: String, minTime: AgendaTime?, maxTime: AgendaTime?,
         categories: [YelpCategory]?, eventCategories: [EventFulCategory]?) {
        
        self.type = type
        self.interestPrefix = type.lowercaseString
        self.minTime = minTime
        self.maxTime = maxTime
        self.categories = categories
        self.eventCategories = eventCategories
    }
}