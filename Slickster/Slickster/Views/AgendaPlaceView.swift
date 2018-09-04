//
//  AgendaPlaceView.swift
//  Slickster
//
//  Created by NonGT on 9/15/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView

class AgendaPlaceView: UIView {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var activityType: UILabel!
    @IBOutlet weak var activityTime: UILabel!
    @IBOutlet weak var backgroundDarken: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var noResultBlock: UIView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var delegate: AgendaPlaceViewDelegate?
    var isTouchedDown: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func touchDown(sender: AnyObject) {
        
        isTouchedDown = true
    }
    
    @IBAction func touchDragInside(sender: AnyObject) {
   
        isTouchedDown = false
    }
    
    @IBAction func activated(sender: AnyObject) {
        
        if(!isTouchedDown) {
            return
        }
        
        if(delegate != nil) {
            
            delegate!.placeActivate(self)
        }
    }
    
    @IBAction func edit(sender: AnyObject) {

        if(delegate != nil) {
            
            delegate!.activityEdit(self)
        }
    }
    
    func setNoResultMode(hasNoResult: Bool, message: String) {

        if hasNoResult {
            
            if let image = UIImage(named: "down-button-no-results.png") {
                downButton.setImage(image, forState: .Normal)
            }
            self.noResultLabel.text = message
            noResultBlock.hidden = false
            
        } else {
            
            if let image = UIImage(named: "down-button") {
                downButton.setImage(image, forState: .Normal)
            }
            
            noResultBlock.hidden = true
        }
    }
    
    func setReadOnlyMode(readOnly: Bool) {
        
        if readOnly {
            
            downButton.hidden = true
            
        } else {
            
            downButton.hidden = false
        }
    }
}