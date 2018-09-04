//
//  ActivityItemCategoryView.swift
//  Slickster
//
//  Created by NonGT on 9/27/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import FontAwesome_swift

class AgendaItemEditorHeaderView : UIView {
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var activityTypeLabel: UILabel!
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var selectSubCategoryButton: UIButton!
    
    @IBOutlet weak var sortModeButton: UIButton!
    @IBOutlet weak var distanceSlider: UISlider!
    
    var delegate: AgendaItemEditorHeaderDelegate?
    var isEventBrite: Bool = false
    var typeCategories: AgendaTypeCategories?
    var eventBriteCategories: [EventbriteCategory]!
    
    override func awakeFromNib() {
        
        var bg = UIImage(named: "button-bg-dark")!
        let insets : UIEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        bg = bg.resizableImageWithCapInsets(insets)
        
        selectCategoryButton.setBackgroundImage(bg, forState: .Normal)
        selectCategoryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        selectCategoryButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        selectCategoryButton.titleLabel!.minimumScaleFactor = 0.5
        
        selectSubCategoryButton.setBackgroundImage(bg, forState: .Normal)
        selectSubCategoryButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)

        timeButton.setBackgroundImage(bg, forState: .Normal)
        timeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
        
        sortModeButton.setBackgroundImage(bg, forState: .Normal)
        sortModeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
        
        let thumb = RBSquareImageTo(UIImage(named: "map-marker-icon")!, size: CGSizeMake(25, 25))
        distanceSlider.setThumbImage(thumb, forState: .Normal)
        
        distanceSlider.minimumValue = 0.1
        distanceSlider.maximumValue = 20
    }
    
    func setTypeCategories(typeCategories: AgendaTypeCategories, isEventBrite: Bool) {
     
        self.isEventBrite = false
        self.typeCategories = typeCategories
    }
    
    func setEventbriteCategories(eventBriteCategories: [EventbriteCategory], isEventBrite: Bool) {
        self.isEventBrite = true
        self.eventBriteCategories = eventBriteCategories
    }
    
    @IBAction func selectCategory(sender: AnyObject) {
        
        if delegate != nil {
            
            if isEventBrite {
                
                let selectedCategory = EventbriteCategories.sharedInstance.find(
                    selectCategoryButton.titleLabel!.text)
                    
                delegate!.agendaItemEditorCategoryActivated(
                    self, typeCategories: nil,
                    eventBriteCategories: eventBriteCategories!,
                    selectedCategory: selectedCategory,
                    parentCategory: nil)
            }
            else
            {
                if activityTypeLabel.text!.lowercaseString != "event" {
                    
                    let selectedCategory = YelpCategories.sharedInstance.find(
                        selectCategoryButton.titleLabel!.text)
                    
                    delegate!.agendaItemEditorCategoryActivated(
                        self, typeCategories: typeCategories!,
                        eventBriteCategories: nil,
                        selectedCategory: selectedCategory,
                        parentCategory: nil)
                    
                } else {
                    
                    let selectedCategory = EventFulCategories.sharedInstance.find(
                        selectCategoryButton.titleLabel!.text)
                    
                    delegate!.agendaItemEditorCategoryActivated(
                        self, typeCategories: typeCategories!,
                        eventBriteCategories: nil,
                        selectedCategory: selectedCategory!,
                        parentCategory: nil)
                }
            }
            
        }
    }
    
    @IBAction func selectSubCategory(sender: AnyObject) {
        
        if delegate != nil {
            
            if isEventBrite {
                
                let selectedCategory = EventbriteCategories.sharedInstance.find(
                    selectCategoryButton.titleLabel!.text)
                
                delegate!.agendaItemEditorCategoryActivated(
                    self, typeCategories: nil,
                    eventBriteCategories: nil,
                    selectedCategory: selectedCategory,
                    parentCategory: nil)
            }
            else
            {
                let parentCategory = EventFulCategories.sharedInstance.find(
                    selectCategoryButton.titleLabel!.text)
                
                let name = "\(parentCategory!.name): \(selectSubCategoryButton.titleLabel!.text!)"
                let selectedCategory = EventFulCategories.sharedInstance.find(name)
                
                delegate!.agendaItemEditorCategoryActivated(
                    self, typeCategories: typeCategories!,
                    eventBriteCategories: nil,
                    selectedCategory: selectedCategory,
                    parentCategory: parentCategory)
            }
        }
    }
    
    @IBAction func selectTime(sender: AnyObject) {
        
        if delegate != nil {
            
            if timeButton.titleLabel!.text == nil {
                
                let selectedTime = AgendaTime.createEmpty()
                delegate!.agendaItemEditorTimeActivated(self, selectedTime: selectedTime)
                
            } else {
                
                let selectedTime = AgendaTime.parse(timeButton.titleLabel!.text!)
                delegate!.agendaItemEditorTimeActivated(self, selectedTime: selectedTime)
            }
        }
    }
    
    @IBAction func toggleSortMode(sender: AnyObject) {
        
        if delegate != nil {
            
            var sortMode = "rating"
            let sortTitle = sortModeButton.titleLabel!.text
            
            if(sortTitle == "RATING") {
                sortMode = "distance"
            }
            
            delegate!.agendaItemEditorSortModeChanged(self, sortMode: sortMode)
        }
    }
    
    @IBAction func distanceSliderValueChanged(sender: AnyObject) {
        
        if delegate != nil {
            
            delegate!.agendaItemEditorDistanceChanged(self, distance: self.distanceSlider.value)
        }
    }
}