//
//  YelpSearchOption.swift
//  Slickster
//
//  Created by NonGT on 9/15/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import Foundation

struct YelpSearchOptions {
    
    var ll: String?
    var term: String?
    var sort: NSNumber?
    var categories: [String]?
    var deals: Bool?
    var radius: NSNumber?
    var limit: NSNumber?
    var offset: NSNumber?
    var distance: NSNumber?
}