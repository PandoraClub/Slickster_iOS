//
//  InterestSelectionGridItemDelegate.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 5/4/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import Foundation

protocol InterestSelectionGridItemDelegate {
    
    func categorySelected(interestKey: String!, category: YelpCategory!)
    func categoryDeselected(interestKey: String!, category: YelpCategory!)
}