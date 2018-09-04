//
//  AgendaItemCellTableViewCell.swift
//  Slickster
//
//  Created by NonGT on 9/13/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import SwipeView

class AgendaItemTableViewCell: UITableViewCell,
    SwipeViewDelegate, SwipeViewDataSource, AgendaPlaceViewDelegate,
    AgendaItemEditorDelegate {

    @IBOutlet weak var swipeView: SwipeView!
    @IBOutlet weak var editorView: UIView!
    @IBOutlet weak var swipeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editorViewTopConstraint: NSLayoutConstraint!
    
    private var templateType: String!
    private var agendaItem: AgendaItem!
    private var tint: UIColor!
    private var currentPlaceIndex: Int = 0
    
    var agendaItemEditorView: AgendaItemEditorView?
    var delegate: AgendaItemTableViewCellDelegate?
    var noResultMode = false
    var readOnlyMode = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        
        loadAgendaItemEditor()
    }
    
    func loadAgendaItemEditor() {
        
        let nib = UINib(nibName: "AgendaItemEditorView", bundle: nil)
        let views = nib.instantiateWithOwner(self, options: nil) as! [UIView]
        let agendaItemEditorView = views[0] as! AgendaItemEditorView
        
        editorView.addSubview(agendaItemEditorView)        
        self.agendaItemEditorView = agendaItemEditorView
        self.agendaItemEditorView!.delegate = self
    }

    func setAgendaItem(templateType: String!, agendaItem: AgendaItem!, tint: UIColor) {
        
        self.templateType = templateType
        self.agendaItem = agendaItem
        self.tint = tint
        
        swipeView.alignment = SwipeViewAlignment.Edge
        swipeView.pagingEnabled = true
        swipeView.itemsPerPage = 1
        swipeView.truncateFinalPage = true
        swipeView.delegate = self
        swipeView.dataSource = self
        swipeView.currentItemIndex = self.agendaItem.selectedPlaceIndex
        
        if self.agendaItem.selectedPlaceIndex == 0 {
            
            swipeView.scrollOffset = 0
        }
        
        currentPlaceIndex = swipeView.currentItemIndex
        
        swipeViewBottomConstraint.constant = 0
        editorViewTopConstraint.constant = self.bounds.height
    }

    func numberOfItemsInSwipeView(swipeView: SwipeView) -> Int {
        
        var itemCount = 0;
        noResultMode = false
        
        if agendaItem.activityType.lowercaseString == "eventbrite"
        {
            itemCount = agendaItem.eventBrites!.count
        }
        else if agendaItem.events == nil {
        
            itemCount = agendaItem.businesses!.count
            
        } else {
            
            itemCount = agendaItem.events!.count
        }
        
        if itemCount == 0 {
            
            itemCount = 1
            noResultMode = true
        }
        
        if readOnlyMode {
            
            itemCount = 1
        }
        
        return itemCount
    }
    
    func swipeViewCurrentItemIndexDidChange(swipeView: SwipeView) -> Void {
        
        self.currentPlaceIndex = swipeView.currentItemIndex
        self.agendaItem.selectedPlaceIndex = self.currentPlaceIndex
        
        delegate?.agendaItemPlaceDidChanged(
            self,
            agendaItem: agendaItem, placeIndex: currentPlaceIndex)
    }
    
    func swipeViewItemSize(swipeView: SwipeView) -> CGSize {
        
        let containerSize: CGRect = self.bounds
        return CGSizeMake(containerSize.width, 120)
    }
    
    func swipeView(swipeView: SwipeView,
        viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        if view == nil {
            
            let newView:AgendaPlaceView! =
                NSBundle.mainBundle().loadNibNamed(
                    "AgendaPlaceView", owner: self, options: nil)[0] as! AgendaPlaceView

            fillData(newView, index: index)
            newView.delegate = self
            
            return newView
        }
        
        let placeView: AgendaPlaceView = view as! AgendaPlaceView
        fillData(placeView, index: index)
        
        return view!
    }
    
    func fillData(view: AgendaPlaceView, index: Int) {
        
        view.setReadOnlyMode(self.readOnlyMode)
        
        if !noResultMode {

            if view.activityType == nil || agendaItem == nil || agendaItem.activityType == nil {
                
                // TODO: Set to some blank screen with error.
                
                if agendaItem.activityType.lowercaseString == "eventbrite"
                {
                    view.setNoResultMode(true, message: "(No events, tap the arrow to select category you want)")

                }
                else {
                    view.setNoResultMode(true, message: "(No results, tap the arrow)")
                }
                return
            }

            view.setNoResultMode(false,message: "")
            

            let placeHolderImage = UIImage(named: "agenda-edit-bg")
            view.backgroundImage.image = placeHolderImage

            view.activityTime.text = agendaItem.time!.format()

            if agendaItem.activityType.lowercaseString == "eventbrite"
            {
                if agendaItem.eventCategory.lowercaseString == "arts"
                {
                    view.activityType.text = "ART EVENT"
                }
                else
                {
                    view.activityType.text = agendaItem.eventCategory.uppercaseStringWithLocale(NSLocale.currentLocale()) + " EVENT"
                }

                if index <= agendaItem.eventBrites!.count - 1 {
                    
                    let url = agendaItem.eventBrites![index].imageURL
                    
                    if url != nil {
                        let urlRequest = NSURLRequest(URL: url!)
                        
                        view.backgroundImage.setImageWithURLRequest(
                            urlRequest,
                            placeholderImage: placeHolderImage,
                            success: { (req, res, image) in
                                
                                UIView.transitionWithView(view,
                                    duration: 0.3, options: .TransitionCrossDissolve, animations: {
                                        
                                        view.backgroundImage.image = image
                                        
                                    }, completion: nil)
                                
                            }, failure: nil)
                    }
                    
                    view.placeName.text = agendaItem.eventBrites![index].venu!.name
                    
                    // Override activity type with actual category name if it is activity
                    /*if agendaItem.activityType == "Activity" {
                        
                        let categories = agendaItem.businesses![index]
                            .categories!.characters.split{$0 == "|"}.map(String.init)
                        
                        view.activityType.text = categories.first!
                            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            .uppercaseString
                    }*/
                }
            }
            else if agendaItem.events == nil {
                view.activityType.text = agendaItem.activityType.uppercaseStringWithLocale(NSLocale.currentLocale())

                if index <= agendaItem.businesses!.count - 1 {
                    
                    let url = agendaItem.businesses![index].imageURL
                    let urlRequest = NSURLRequest(URL: url!)
                    
                    view.backgroundImage.setImageWithURLRequest(
                        urlRequest,
                        placeholderImage: placeHolderImage,
                        success: { (req, res, image) in
                            
                            UIView.transitionWithView(view,
                                duration: 0.3, options: .TransitionCrossDissolve, animations: {
                                    
                                    view.backgroundImage.image = image
                                
                                }, completion: nil)
                          
                        }, failure: nil)
                    
                    view.placeName.text = agendaItem.businesses![index].name
                    
                    // Override activity type with actual category name if it is activity
                    if agendaItem.activityType == "Activity" {
                        
                        let categories = agendaItem.businesses![index]
                            .categories!.characters.split{$0 == "|"}.map(String.init)
                        
                        view.activityType.text = categories.first!
                            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            .uppercaseString
                    }
                }
                
            } else {
                view.activityType.text = agendaItem.activityType.uppercaseStringWithLocale(NSLocale.currentLocale())
                
                if index <= agendaItem.events!.count - 1 {
                    
                    let event = agendaItem.events![index]
                    let url = event.imageURL
                    if url != nil {
                        
                        view.backgroundImage.setImageWithURL(url!)
                        
                    } else {
                        
                        var categoryCode = agendaItem.condition.eventCategories[0].id
                        if agendaItem.condition.eventCategories[0].parent != nil {
                            
                            categoryCode = agendaItem.condition.eventCategories[0].parent
                        }
                        
                        let image = UIImage(named: "event-\(categoryCode).jpg")
                        view.backgroundImage.image = image
                    }
                    
                    view.placeName.text = agendaItem.events![index].title
                }
            }
            
        } else {
            
            if agendaItem.activityType.lowercaseString == "eventbrite"
            {
                view.setNoResultMode(true, message: "(No events, tap the arrow to select category you want)")
                
            }
            else {
                view.setNoResultMode(true, message: "(No results, tap the arrow)")
            }
        }
    }
    
    func placeActivate(placeView: AgendaPlaceView) {
        
        if(self.delegate != nil) {
            
            self.delegate?.agendaItemPlaceDidSelect(
                self,
                agendaItem: agendaItem, placeIndex: currentPlaceIndex)
        }
    }
    
    func activityEdit(placeView: AgendaPlaceView) {
        
        //if agendaItem.activityType == "Eventbrite"
        //{
        //    return
        //}
        
        let dataToEdit = agendaItem.asAnotherInstance()
        
        self.agendaItemEditorView!.setData(templateType, agendaItem: dataToEdit)
        
        editorViewTopConstraint.constant = 0
        swipeViewBottomConstraint.constant = self.bounds.height
        
        UIView.animateWithDuration(0.3,
            delay: 0.0, options: [.CurveEaseOut], animations: {
                
                self.contentView.layoutIfNeeded()
                
            }, completion: { (c:Bool) -> Void in
                
            })

        if(self.delegate != nil) {
            
            self.delegate?.agendaItemActivityDidEdit(
                self,
                agendaItem: dataToEdit,
                placeIndex: currentPlaceIndex)
        }
    }
    
    func toViewState() {
        
        editorViewTopConstraint.constant = self.bounds.height
        swipeViewBottomConstraint.constant = 0
        
        UIView.animateWithDuration(0.3,
            delay: 0.0, options: [.CurveEaseOut], animations: {
                
                self.contentView.layoutIfNeeded()
                
            }, completion: { (c:Bool) -> Void in
                
            })
    }
    
    func agendaItemEditorCategoryActivated(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        templateType: String,
        activityType: String,
        typeCategories: AgendaTypeCategories!,
        eventBriteCategories: [EventbriteCategory]!,
        selectedCategory: AnyObject?,
        parentCategory: AnyObject?) {
            
        delegate?.agendaItemActivityCategoryDidEdit(self,
            agendaItemEditorView: editor,
            agendaItemEditorHeaderView: editorHeader,
            templateType: templateType,
            activityType: activityType,
            typeCategories: typeCategories,
            eventBriteCategories: eventBriteCategories,
            selectedCategory: selectedCategory,
            parentCategory: parentCategory)
    }
    
    func agendaItemEditorTimeActivated(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        selectedTime: AgendaTime) {
            
        delegate?.agendaItemActivityTimeDidEdit(self,
            agendaItemEditorView: editor,
            agendaItemEditorHeaderView: editorHeader,
            selectedTime: selectedTime)
    }
    
    func agendaItemEditorSortModeChanged(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        sortMode: String) {
            
        delegate?.agendaItemActivitySortModeDidChanged(self,
            agendaItemEditorView: editor,
            agendaItemEditorHeaderView: editorHeader,
            sortMode: sortMode)
    }
    
    func agendaItemEditorDistanceChanged(
        editor: AgendaItemEditorView,
        editorHeader: AgendaItemEditorHeaderView,
        distance: Float) {
            
        delegate?.agendaItemActivityDistanceDidChanged(self,
            agendaItemEditorView: editor,
            agendaItemEditorHeaderView: editorHeader,
            distance: distance)
    }
    
    func refreshUI() {
        
        agendaItemEditorView!.refreshUI()
        swipeView.reloadItemAtIndex(agendaItem.selectedPlaceIndex)
    }
    
    func resetSwipe() {
        
        swipeView.currentItemIndex = 0
    }
}
