//
//  CategorySelectionViewControllerDelegate.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/16/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

protocol CategorySelectionViewControllerDelegate {
    
    func categorySelectionViewController(sender: AnyObject!, didSelectCategory yelpCategory: YelpCategory!)
}