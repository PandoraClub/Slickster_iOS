//
//  CountrySelectionControllerDelegate.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/16/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation

protocol CountrySelectionViewControllerDelegate {
    
    func countrySelectionViewController(sender: AnyObject!, didSelectCountry countryCode: String!)
}