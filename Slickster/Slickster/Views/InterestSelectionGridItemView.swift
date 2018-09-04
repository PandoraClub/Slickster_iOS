//
//  InterestSelectionGridItemView.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 4/29/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit

class InterestSelectionGridItemView: UICollectionViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var toggleButton: UIButton!
    
    var delegate: InterestSelectionGridItemDelegate?
    var isSelected: Bool?
    var selectedInterests: [String:UserInterest]?
    var interestKey: String?
    var category: YelpCategory?
    
    override func awakeFromNib() {
        
        bringSubviewToFront(toggleButton)
    }

    func setData(category: YelpCategory, interestKey: String!, selectedInterests: [String:UserInterest]) {

        categoryName.text = category.title
        
        self.interestKey = interestKey
        self.category = category
        self.selectedInterests = selectedInterests
        
        isSelected = (selectedInterests[interestKey] != nil)
        
        if isSelected == true {
            
            self.backgroundColor = UIColor(rgb: 0x16AAAC)
            
        } else {
            
            self.backgroundColor = UIColor(rgb: 0x2C2F34)
        }
    }
    
    @IBAction func toggleAction(sender: AnyObject) {
        
        
        if isSelected != true {
        
            delegate?.categorySelected(self.interestKey!, category: self.category!)
            
            isSelected = true
            self.backgroundColor = UIColor(rgb: 0x16AAAC)
            
        } else {
            
            delegate?.categoryDeselected(self.interestKey!, category: self.category!)
            
            isSelected = false
            self.backgroundColor = UIColor(rgb: 0x2C2F34)
        }
    }
}
