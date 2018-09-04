//
//  EventCategorySelectionViewControllerDelegate.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 12/7/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

protocol EventCategorySelectionViewControllerDelegate {
    
    func eventCategorySelectionViewController(sender: AnyObject!, didSelectCategory eventFulCategory: EventFulCategory!)
}