//
//  EventbriteCategorySelectionViewControllerDelegate.swift
//  Slickster
//
//  Created by Lucas on 9/13/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

protocol EventbriteSubCategorySelectionViewControllerDelegate {
    
    func eventBriteSubCategorySelectionViewController(sender: AnyObject!, didSelectCategory eventBriteSubCategory: EventbriteSubCategory!)
}