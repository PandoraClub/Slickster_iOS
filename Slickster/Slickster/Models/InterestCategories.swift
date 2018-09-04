//
//  InterestCategories.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/24/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

class InterestCategories {
    
    var key: String!
    var matchAnyOfActivityType: (String -> Bool)!
    var templateType: String?
    var iconSuffix: String?
    var isDayTime: Bool?
    var categories: [YelpCategory]!
}