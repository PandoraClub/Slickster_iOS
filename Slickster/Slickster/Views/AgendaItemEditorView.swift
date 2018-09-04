//
//  AgendaItemEditorView.swift
//  Slickster
//
//  Created by NonGT on 9/27/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import SwipeView

class AgendaItemEditorView : UIView,
    SwipeViewDelegate, SwipeViewDataSource, AgendaItemEditorHeaderDelegate {
    
    @IBOutlet weak var swipeView: SwipeView!
    
    private var templateType: String!
    private var agendaItem: AgendaItem?
    private var initialSelectedCategory: String?
    private var initialSelectedEventCategory: String?
    private var initialSelectedEventbriteCategory: String?
    
    var delegate: AgendaItemEditorDelegate?
    
    func setData(templateType: String!, agendaItem: AgendaItem) {
        
        let activityType = agendaItem.activityType
        
        if activityType.lowercaseString == "eventbrite"
        {
            initialSelectedEventbriteCategory = agendaItem.eventCategory
        }
        else if activityType.lowercaseString != "event" {
            
            if agendaItem.condition!.categories != nil &&
                agendaItem.condition!.categories.count > 0 {
                    
                initialSelectedCategory = agendaItem.condition!.categories!.first?.title
            }
            
        } else {
            
            if agendaItem.condition!.eventCategories != nil &&
                agendaItem.condition!.eventCategories.count > 0 {
                    
                initialSelectedEventCategory = agendaItem.condition!.eventCategories!.first?.name
            }
        }
        
        self.templateType = templateType
        self.agendaItem = agendaItem
        
        if self.templateType == nil {
        
            self.templateType = AgendaGenerator.templateType
        }

        swipeView.alignment = SwipeViewAlignment.Edge
        swipeView.pagingEnabled = true
        swipeView.itemsPerPage = 1
        swipeView.truncateFinalPage = true
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.scrollOffset = 0
        
        // Find the index of activityType on selectableCategories
        
        if activityType.lowercaseString == "eventbrite"
        {
            let eventBriteCategoriesList = EventbriteCategories.sharedInstance.getCategories()
            var index = 0
            
            for eventCategory in eventBriteCategoriesList {
                
                if(eventCategory.name.lowercaseString == initialSelectedEventbriteCategory?.lowercaseString) {
                    break
                }
                
                index = index + 1
            }
            
            swipeView.currentItemIndex = index
        }
        else {
            let agendaTypeCategoriesList = getSelectableActivityTypes()
            var index = 0
            
            for typeCategories in agendaTypeCategoriesList {
                
                if(typeCategories.type == activityType) {
                    break
                }
                
                index = index + 1
            }
            
            swipeView.currentItemIndex = index
        }
        
        
        swipeView.reloadData()
    }
    
    func getSelectableActivityTypes() -> [AgendaTypeCategories] {
        
        let time = self.agendaItem!.time!
        
        return AgendaDefault.selectableCategories[self.templateType]!.filter{ ac in
            
            if time.hour < 0 {
                
                return true
            }
            
            if ac.minTime != nil && time < ac.minTime! {
                
                return false
            }
            
            if ac.maxTime != nil && time > ac.maxTime! {
             
                return false
            }
            
            return true
        }
    }
    
    func numberOfItemsInSwipeView(swipeView: SwipeView) -> Int {
        if agendaItem!.activityType.lowercaseString == "eventbrite"
        {
            return EventbriteCategories.sharedInstance.getCategories().count
        }
        return getSelectableActivityTypes().count
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        if agendaItem!.activityType.lowercaseString == "eventbrite"
        {
            //let eventBriteCategoriesList = EventbriteCategories.sharedInstance.getCategories()
            //let selectedEventbriteCategory = eventBriteCategoriesList[swipeView.currentItemIndex]
            
        }
        else
        {
            let agendaTypeCategoriesList = getSelectableActivityTypes()
            let typeCategories = agendaTypeCategoriesList[swipeView.currentItemIndex]
            
            agendaItem!.activityType = typeCategories.type
            
            if agendaItem!.activityType!.lowercaseString != "event" {
                
                agendaItem!.condition!.eventCategories = nil
                
                let currentCategory:YelpCategory? = typeCategories.categories.first!
                
                agendaItem!.condition!.categories.removeAll()
                agendaItem!.condition!.categories.append(currentCategory!)
                
            } else {
                
                let currentCategory:EventFulCategory? = typeCategories.eventCategories.first!
                
                if agendaItem!.condition!.eventCategories == nil {
                    agendaItem!.condition!.eventCategories = [EventFulCategory]()
                }
                
                agendaItem!.condition!.eventCategories.removeAll()
                agendaItem!.condition!.eventCategories.append(currentCategory!)
            }
            
            // Also reset search term
            agendaItem!.condition!.term = nil
            
        }
        
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(screenSize.width, 120)
    }
    
    func swipeView(swipeView: SwipeView,
        viewForItemAtIndex index: Int,
        reusingView view: UIView?) -> UIView {
        
        if view == nil {
            
            let newView:AgendaItemEditorHeaderView! =
            NSBundle.mainBundle().loadNibNamed("AgendaItemEditorHeaderView", owner: self, options: nil)[0] as! AgendaItemEditorHeaderView
            
            newView.delegate = self
            fillData(newView, index: index)
            
            return newView
        }
        
        let headerView: AgendaItemEditorHeaderView = view as! AgendaItemEditorHeaderView

        fillData(headerView, index: index)

        return view!
    }
    
    func agendaItemEditorCategoryActivated(
        editorHeader: AgendaItemEditorHeaderView,
        typeCategories: AgendaTypeCategories!,
        eventBriteCategories: [EventbriteCategory]!,
        selectedCategory: AnyObject?,
        parentCategory: AnyObject?) {
        
        initialSelectedCategory = nil
        initialSelectedEventCategory = nil
        initialSelectedEventbriteCategory = nil
        
        if delegate != nil {
            
            delegate!.agendaItemEditorCategoryActivated(
                self, editorHeader: editorHeader,
                templateType: self.templateType,
                activityType: self.agendaItem!.activityType!,
                typeCategories: typeCategories,
                eventBriteCategories: eventBriteCategories,
                selectedCategory: selectedCategory,
                parentCategory: parentCategory)
        }
    }

    
    func agendaItemEditorTimeActivated(
        editorHeader: AgendaItemEditorHeaderView,
        selectedTime: AgendaTime) {
            
        if delegate != nil {
            
            delegate!.agendaItemEditorTimeActivated(
                self,
                editorHeader: editorHeader,
                selectedTime: selectedTime)
        }
    }

    func agendaItemEditorSortModeChanged(
        editorHeader: AgendaItemEditorHeaderView,
        sortMode: String) {
            
        if delegate != nil {
            
            delegate!.agendaItemEditorSortModeChanged(
                self,
                editorHeader: editorHeader,
                sortMode: sortMode)
        }
    }

    func agendaItemEditorDistanceChanged(
        editorHeader: AgendaItemEditorHeaderView,
        distance: Float) {
            
        if delegate != nil {
            
            delegate!.agendaItemEditorDistanceChanged(
                self,
                editorHeader: editorHeader,
                distance: distance)
        }
    }

    func fillData(view: AgendaItemEditorHeaderView, index: Int) {
        
        if agendaItem!.activityType.lowercaseString == "eventbrite"
        {
            let eventBriteCategories = EventbriteCategories.sharedInstance.getCategories()
            let currentEventBriteCategory = eventBriteCategories[index]
            
            view.activityTypeLabel!.text = currentEventBriteCategory.name
            view.timeButton.setTitle(agendaItem!.time!.format(), forState: .Normal)
            view.distanceSlider.value = agendaItem!.condition!.distance!.floatValue
            view.sortModeButton.setTitle("NEAR BY", forState: .Normal)
            
            // Find if the category of the agendaItem match any of item in the certain list of categories
            
            let eventSubCategories = currentEventBriteCategory.subCategories
            
            view.selectCategoryButton.setTitle( currentEventBriteCategory.name, forState: .Normal)
            
            if eventSubCategories.count == 0 {
                view.selectSubCategoryButton.hidden = true
            }
            else {
                view.selectSubCategoryButton.hidden = false
                view.selectSubCategoryButton.setTitle(eventSubCategories.first?.name, forState: .Normal)
            }
            
            view.setEventbriteCategories(eventBriteCategories, isEventBrite: true)
            
        }
        else {
            var agendaTypeCategories = getSelectableActivityTypes()
            let typeName = agendaTypeCategories[index].type
            
            view.activityTypeLabel!.text = typeName
            view.timeButton.setTitle(agendaItem!.time!.format(), forState: .Normal)
            
            view.distanceSlider.value = agendaItem!.condition!.distance!.floatValue
            
            if(agendaItem!.condition!.sort == YelpSortMode.HighestRated.rawValue) {
                view.sortModeButton.setTitle("RATING", forState: .Normal)
            } else {
                view.sortModeButton.setTitle("NEAR BY", forState: .Normal)
            }
            
            // Find if the category of the agendaItem match any of item in the certain list of categories
            let typeCategories = agendaTypeCategories[index]
            
            if typeName.lowercaseString != "event" {
                
                view.selectSubCategoryButton.hidden = true
                
                var matchCategory: YelpCategory? = nil
                
                if self.agendaItem!.condition!.categories.count > 0 {
                    
                    matchCategory = typeCategories.categories?.lazy.filter {
                        c in
                        
                        let agendaItemCategoryTitle =
                            self.agendaItem!.condition!.categories.first!.title
                        
                        return c.title == agendaItemCategoryTitle
                        
                        }.first
                }
                
                var currentCategory:YelpCategory? = nil
                
                if matchCategory != nil {
                    
                    currentCategory = matchCategory
                    
                } else {
                    
                    currentCategory = typeCategories.categories?.first!
                }
                
                view.setTypeCategories(typeCategories,isEventBrite: false)
                view.selectCategoryButton.setTitle(
                    currentCategory?.title!, forState: .Normal)
                
            } else {
                
                view.selectSubCategoryButton.hidden = false
                
                var currentCategory:EventFulCategory? = nil
                
                // If initial category is not nil, select it by default.
                if initialSelectedEventCategory != nil {
                    
                    currentCategory = EventFulCategories
                        .sharedInstance.find(initialSelectedEventCategory)
                }
                
                // If currentCategory is still nil, get from the selected eventCategories if possible.
                if currentCategory == nil && self.agendaItem!.condition!.eventCategories != nil {
                    
                    currentCategory = self.agendaItem!.condition!.eventCategories.first!
                }
                
                // If currentCategory is stil nil, use first default categories.
                if currentCategory == nil {
                    
                    currentCategory = typeCategories.eventCategories.first
                }
                
                view.setTypeCategories(typeCategories, isEventBrite: false)
                
                if currentCategory?.parent == nil {
                    
                    view.selectCategoryButton.setTitle(
                        currentCategory?.name!, forState: .Normal)
                    
                    let subCategories = EventFulCategories.sharedInstance.getSubCategories(currentCategory!)
                    if subCategories.count == 0 {
                        
                        view.selectSubCategoryButton.hidden = true
                        
                    } else {
                        
                        view.selectSubCategoryButton.hidden = false
                    }
                    
                } else {
                    
                    let parentCategory = EventFulCategories.sharedInstance.findById(currentCategory!.parent)
                    
                    let index: String.Index = currentCategory!.name.startIndex.advancedBy(
                        parentCategory!.name.characters.count + 2)
                    let subCategoryName = currentCategory?.name!.substringFromIndex(index)
                    
                    view.selectCategoryButton.setTitle(
                        parentCategory?.name!, forState: .Normal)
                    
                    view.selectSubCategoryButton.setTitle(
                        subCategoryName, forState: .Normal)
                }
            }
        }
        
    }
    
    func refreshUI() {
        
        let editorView = swipeView.itemViewAtIndex(
            swipeView.currentItemIndex) as? AgendaItemEditorHeaderView
        
        let activityType = agendaItem?.activityType
        
        if activityType != nil {
            
            if activityType!.lowercaseString == "eventbrite"
            {
                if agendaItem != nil && agendaItem!.condition != nil &&
                    agendaItem!.condition!.categories != nil &&
                    agendaItem!.condition!.categories.first != nil {
                    
                    editorView?.selectCategoryButton.setTitle(
                        EventbriteCategories.sharedInstance.getCategories().first?.name, forState: .Normal)
                    
                } else {
                    
                    editorView?.selectCategoryButton.setTitle("Select", forState: .Normal)
                }
            }
            else if activityType!.lowercaseString != "event" {
                
                if agendaItem != nil && agendaItem!.condition != nil &&
                    agendaItem!.condition!.categories != nil &&
                    agendaItem!.condition!.categories.first != nil {
                
                    editorView?.selectCategoryButton.setTitle(
                        agendaItem!.condition!.categories!.first!.title, forState: .Normal)
                    
                } else {

                    editorView?.selectCategoryButton.setTitle("Select", forState: .Normal)
                }
            }
        }
        
        swipeView.reloadData()
    }
}