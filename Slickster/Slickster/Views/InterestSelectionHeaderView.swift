//
//  InterestSelectionHeaderView.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 5/22/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import Foundation

class InterestSelectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var headerTitle: UILabel!
 
    func setTitle(text: String) {
        
        headerTitle.text = text
    }
}