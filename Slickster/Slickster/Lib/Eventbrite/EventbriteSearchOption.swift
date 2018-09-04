//
//  EventbriteSearchOption.swift
//  Slickster
//
//  Created by Lucas on 9/2/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation
struct EventbriteSearchOptions {
    var q: String? // keyword search
    var sortBy: String? //sort by - options are “date”, “distance” and “best”. Prefix with a hyphen to reverse the order, e.g. “-date”.
    var location: String?
    var distance: String?//This should be an integer followed by “mi” or “km”.
    var latitude: String?
    var longitude: String?
    var categories: String?
    var subCategories: String?
    var price: String?//Only return events that are “free” or “paid”
    var startDate: NSDate?
    var stopDate: NSDate?
    var dateKeyword: String? //return events with start dates within the given keyword date range. Keyword options are “this_week”, “next_week”, “this_weekend”, “next_month”, “this_month”, “tomorrow”, “today”
    var dateModifiedStart: NSDate?
    var dateModifiedEnd: NSDate?
    var dateModifiedKeyword: String?
    var searchType: String? //preconfigured settings for this type of search - Current option is “promoted”
}