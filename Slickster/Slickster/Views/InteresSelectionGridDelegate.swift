//
//  InteresSelectionGridDelegate.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 5/4/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import Foundation

protocol InterestSelectionGridDelegate {
    
    func interestSelected(interestKey: String!, interest: UserInterest!)
    func interestDeselected(interestKey: String!, interest: UserInterest!)
}