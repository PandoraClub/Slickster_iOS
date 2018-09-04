//
//  AgendaViewController.swift
//  Slickster
//
//  Created by NonGT on 9/12/2558 BE.
//  Copyright (c) 2558 Donoma Solutions. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation
import FontAwesome_swift
import Parse

class AgendaViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource, AgendaItemTableViewCellDelegate,
    UIPopoverPresentationControllerDelegate, DatePickerViewControllerDelegate {
    
    @IBOutlet weak var unwindButton: UIButton!
    @IBOutlet weak var backToSavedButton: UIButton!
    @IBOutlet weak var cancelEditButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var doneEditButton: UIButton!
    @IBOutlet weak var agendaTableView: UITableView!
    @IBOutlet weak var agendaTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var agendaItemEditorContainer: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var districtNameLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!
    
    let transitionManager: TransitionManager = TransitionManager()
    
    var userAgenda: UserAgenda?
    var presentUserAgendas: [UserAgenda]?
    var itemTintPatterns: [UIColor]! = [UIColor]()
    var selectedItem: AgendaItem?
    var selectedItemCell: AgendaItemTableViewCell?
    var agendaItemEditorView: AgendaItemEditorDetailsView?
    
    var editingItemIndexPath: NSIndexPath?
    var editingItemViewCell: AgendaItemTableViewCell?
    var sourceViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
         self,
         selector: #selector(self.pullingEventsFinished),
         name: "pullingEventBritesFinished",
         object: nil)
        
        
        if userAgenda != nil {
        
            userAgenda?.ensureAgendaItems()
            
        } else {
            
            userAgenda = UserAgenda()
        }
        
        if(userAgenda!.templateType == nil) {
            userAgenda!.templateType = AgendaGenerator.templateType
        }
        
        let nib = UINib(nibName: "AgendaItemTableViewCell", bundle: nil)
        agendaTableView.registerNib(nib, forCellReuseIdentifier: "agendaCell")
        
        itemTintPatterns.append(UIColor(rgb: 0x834A17))
        itemTintPatterns.append(UIColor(rgb: 0x006c26))
        itemTintPatterns.append(UIColor(rgb: 0x834A17))
        itemTintPatterns.append(UIColor(rgb: 0x99A32E))
        itemTintPatterns.append(UIColor(rgb: 0x241505))
        itemTintPatterns.append(UIColor(rgb: 0x6E1F75))
        
        loadAgendaItemEditor()
        //initButtonAppearances()
        
        self.scheduledDateLabel.text = "..."
        
        if userAgenda != nil && userAgenda!.location != nil {
            
            // Non: Show location instead
            self.scheduledDateLabel.text = userAgenda!.district
            
        } else {
            
            userAgenda!.location = UserLocation.get().string
            LocationManager.getDistrict(userAgenda!.location!) {
                (district: String?, error: NSError?) in
                
                if error == nil {
                    
                    self.userAgenda!.district = district
                    
                    // Non: Show location instead
                    self.scheduledDateLabel.text = self.userAgenda!.district
                }
            }
        }
        
        // Non: Show the template type instead
        if userAgenda?.templateType == nil {
            
            if AgendaGenerator.templateType == nil {
                self.districtNameLabel.text = "Unknown Plan"
            } else {
                
                let templateType = AgendaGenerator.templateType
                    .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                self.districtNameLabel.text = "\(templateType.capitalizedString)"
            }
            
        } else {
            
            let templateType = userAgenda!.templateType!
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            self.districtNameLabel.text = "\(templateType.capitalizedString) Plan"
        }
        
        // Show general back button instead if there is sourceViewController.
        if sourceViewController != nil {
        
            self.unwindButton.hidden = true
            self.backToSavedButton.hidden = false
            
        } else {
            
            self.unwindButton.hidden = false
            self.backToSavedButton.hidden = true
        }

        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        verifyDirtyState()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).topBarView!.hidden = true
        (UIApplication.sharedApplication().delegate as! AppDelegate).bgRootImage!.hidden = true
    }
    
    @objc func pullingEventsFinished(notification: NSNotification){
        //do stuff
        
        let arrayAgendaItems =  notification.object as! [AgendaItem]
            
        userAgenda?.agendaItems?.removeAll();
        userAgenda?.agendaItems = arrayAgendaItems
        agendaTableView.reloadData()
    }
    
    func loadAgendaItemEditor() {
        
        let nib = UINib(nibName: "AgendaItemEditorDetailsView", bundle: nil)
        let views = nib.instantiateWithOwner(self, options: nil) as! [UIView]
        let agendaItemEditorView = views[0] as! AgendaItemEditorDetailsView
        
        agendaItemEditorView.centerCoordinate = getAgendaLocation()
        
        agendaItemEditorContainer.addSubview(agendaItemEditorView)
        agendaItemEditorView.frame = CGRectMake(
            0, 0, agendaItemEditorContainer.frame.width, agendaItemEditorContainer.frame.height)

        self.agendaItemEditorView = agendaItemEditorView
        self.agendaItemEditorView!.initData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(userAgenda?.agendaItems != nil) {
        
            return self.userAgenda!.agendaItems!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let c: AnyObject? = self.agendaTableView.dequeueReusableCellWithIdentifier("agendaCell")
        let cell:AgendaItemTableViewCell = c as! AgendaItemTableViewCell
        
        let agendaItem:AgendaItem = self.userAgenda!.agendaItems![indexPath.row]
        
        var tintIndex = 0
        if(indexPath.row < itemTintPatterns.count) {
            tintIndex = indexPath.row
        } else {
            tintIndex = indexPath.row % itemTintPatterns.count
        }
        
        cell.delegate = self
        cell.setAgendaItem(userAgenda?.templateType,
            agendaItem: agendaItem, tint: itemTintPatterns[tintIndex])
        
        cell.refreshUI()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
    
    func agendaItemPlaceDidSelect(agendaItemCell: AgendaItemTableViewCell, agendaItem: AgendaItem, placeIndex: Int) {
        selectedItem = agendaItem
        selectedItemCell = agendaItemCell
        
        if agendaItem.events == nil {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let placeViewController =
                storyBoard.instantiateViewControllerWithIdentifier(
                    "PlaceViewController") as! PlaceViewController
            
            placeViewController.centerCoordinate = getAgendaLocation()
            placeViewController.transitioningDelegate = transitionManager
            placeViewController.setAgendaItem(agendaItem, placeIndex: placeIndex)
            
            self.presentViewController(placeViewController, animated: true, completion: nil)
            
        } else {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let eventViewController =
                storyBoard.instantiateViewControllerWithIdentifier(
                    "EventViewController") as! EventViewController
            
            eventViewController.centerCoordinate = getAgendaLocation()
            eventViewController.transitioningDelegate = transitionManager
            eventViewController.setAgendaItem(agendaItem, placeIndex: placeIndex)
            
            self.presentViewController(eventViewController, animated: true, completion: nil)
        }
    }

    func agendaItemActivityDidEdit(agendaItemCell: AgendaItemTableViewCell, agendaItem: AgendaItem, placeIndex: Int) {
        
        selectedItem = agendaItem
        selectedItemCell = agendaItemCell
        
        cancelEditButton.hidden = false
        doneEditButton.hidden = false
        
        unwindButton.hidden = true
        mapButton.hidden = true
        backToSavedButton.hidden = true
        
        agendaItemEditorContainer.hidden = false
    
        let indexPath = self.agendaTableView.indexPathForCell(agendaItemCell)

        let size = agendaTableView.bounds.height - 120
        agendaTableViewBottomConstraint.constant = size
        
        self.agendaItemEditorView!.clearDistance()
        
        UIView.animateWithDuration(0.3,
            delay: 0.5, options: [.CurveEaseOut], animations: {

            self.view.layoutIfNeeded()
            self.agendaTableView.selectRowAtIndexPath(
                indexPath, animated: false, scrollPosition: .Top)
            self.footerView.alpha = 0
            
        }, completion: { (c:Bool) -> Void in
            
            self.agendaTableView.scrollEnabled = false
            self.agendaItemEditorView!.setDistance(agendaItem.condition!.distance!.floatValue)
        })
        
        editingItemIndexPath = indexPath
        editingItemViewCell = agendaItemCell
    }
    
    func returnToListState() {
        
        agendaTableView.scrollEnabled = true
        
        selectedItem = nil
        selectedItemCell = nil
        
        cancelEditButton.hidden = true;
        doneEditButton.hidden = true;
        
        unwindButton.hidden = false;
        mapButton.hidden = false;
        
        agendaTableViewBottomConstraint.constant = 0
        editingItemViewCell!.toViewState()
        
        // Show general back button instead if there is sourceViewController.
        if sourceViewController != nil {
            
            self.unwindButton.hidden = true
            self.backToSavedButton.hidden = false
            
        } else {
            
            self.unwindButton.hidden = false
            self.backToSavedButton.hidden = true
        }
        
        UIView.animateWithDuration(0.3,
            delay: 0.0, options: [.CurveEaseOut], animations: {
                
                self.view.layoutIfNeeded()
                self.footerView.alpha = 1
                
            }, completion: { (c:Bool) -> Void in
                
                self.agendaItemEditorContainer.hidden = true
                self.editingItemIndexPath = nil
                self.editingItemViewCell = nil
            })
        
        self.verifyDirtyState()
    }

    func agendaItemActivityCategoryDidEdit(
        agendaItemCell: AgendaItemTableViewCell,
        agendaItemEditorView: AgendaItemEditorView,
        agendaItemEditorHeaderView: AgendaItemEditorHeaderView,
        templateType: String,
        activityType: String,
        typeCategories: AgendaTypeCategories!,
        eventBriteCategories: [EventbriteCategory]!,
        selectedCategory: AnyObject?,
        parentCategory: AnyObject?) {
        
        if activityType.lowercaseString == "eventbrite" {
            
            if eventBriteCategories != nil {
                
                let eventBriteCategory = selectedCategory as! EventbriteCategory
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let eventBriteCategorySelectionViewController =
                    storyBoard.instantiateViewControllerWithIdentifier(
                        "EventbriteCategorySelectionViewController") as! EventbriteCategorySelectionViewController
                
                eventBriteCategorySelectionViewController.templateType = templateType
                eventBriteCategorySelectionViewController.activityType = activityType
                eventBriteCategorySelectionViewController.selectedCategory = eventBriteCategory
                eventBriteCategorySelectionViewController.selectableCategories = eventBriteCategories
                eventBriteCategorySelectionViewController.delegate = self
                
                self.presentViewController(eventBriteCategorySelectionViewController, animated: true, completion: nil)
                
            } else {
                
                let eventBriteCategory = selectedCategory as! EventbriteCategory
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let eventBriteSubCategorySelectionViewController =
                    storyBoard.instantiateViewControllerWithIdentifier(
                        "EventbriteSubCategorySelectionViewController") as! EventbriteSubCategorySelectionViewController
                
                eventBriteSubCategorySelectionViewController.templateType = templateType
                eventBriteSubCategorySelectionViewController.activityType = activityType
                eventBriteSubCategorySelectionViewController.selectedCategory = eventBriteCategory.subCategories.first
                eventBriteSubCategorySelectionViewController.selectableCategories = eventBriteCategory.subCategories
                eventBriteSubCategorySelectionViewController.delegate = self
                
                self.presentViewController(eventBriteSubCategorySelectionViewController, animated: true, completion: nil)
                
            }
        }
            
        else if activityType.lowercaseString != "event" {
            
            let yelpCategory = selectedCategory as! YelpCategory
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let categorySelectionViewController =
                storyBoard.instantiateViewControllerWithIdentifier(
                    "CategorySelectionViewController") as! CategorySelectionViewController
                
            categorySelectionViewController.templateType = templateType
            categorySelectionViewController.activityType = activityType
            categorySelectionViewController.selectedCategory = yelpCategory
            categorySelectionViewController.selectableCategories = typeCategories.categories
            categorySelectionViewController.delegate = self
                
            self.presentViewController(categorySelectionViewController, animated: true, completion: nil)
            
        } else {
            
            let eventCategory = selectedCategory as? EventFulCategory
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let categorySelectionViewController =
                storyBoard.instantiateViewControllerWithIdentifier(
                    "EventCategorySelectionViewController") as! EventCategorySelectionViewController
            
            categorySelectionViewController.templateType = templateType
            categorySelectionViewController.activityType = activityType
            categorySelectionViewController.selectedCategory = eventCategory
            
            if parentCategory == nil {
                
                categorySelectionViewController.selectableCategories =
                    EventFulCategories.sharedInstance.getRootCategories()
                
            } else {
                
                let parentEventCategory = parentCategory as! EventFulCategory
                
                categorySelectionViewController.selectableCategories =
                    EventFulCategories.sharedInstance.getSubCategories(parentEventCategory)
            }
            
            categorySelectionViewController.delegate = self
            
            self.presentViewController(categorySelectionViewController, animated: true, completion: nil)
        }
    }
    
    func agendaItemActivityTimeDidEdit(
        agendaItemCell: AgendaItemTableViewCell,
        agendaItemEditorView: AgendaItemEditorView,
        agendaItemEditorHeaderView: AgendaItemEditorHeaderView,
        selectedTime: AgendaTime) {
            
        let timePicker = DatePickerViewController()
            
        timePicker.setTime(selectedTime.format())
        timePicker.delegate = self
            
        timePicker.modalPresentationStyle = UIModalPresentationStyle.Popover
        timePicker.preferredContentSize = CGSizeMake(self.view.bounds.width, 300)
        
        let popover = timePicker.popoverPresentationController
        if let _popover = popover {
            
            let field = agendaItemEditorHeaderView.timeButton
            
            _popover.sourceView = field
            _popover.sourceRect = CGRectMake(field.bounds.size.width - 10, field.bounds.size.height, 0, 0)
            _popover.delegate = self
            
            self.presentViewController(timePicker, animated: true, completion: nil)
        }
    }
    
    func agendaItemActivitySortModeDidChanged(
        agendaItemCell: AgendaItemTableViewCell,
        agendaItemEditorView: AgendaItemEditorView,
        agendaItemEditorHeaderView: AgendaItemEditorHeaderView,
        sortMode: String) {
        
        if(selectedItem != nil) {
            
            if(sortMode == "rating") {
                selectedItem!.condition!.sort = YelpSortMode.HighestRated.rawValue
            } else {
                selectedItem!.condition!.sort = YelpSortMode.Distance.rawValue
            }
        }
            
        selectedItemCell?.refreshUI()
    }
    
    func agendaItemActivityDistanceDidChanged(
        agendaItemCell: AgendaItemTableViewCell,
        agendaItemEditorView: AgendaItemEditorView,
        agendaItemEditorHeaderView: AgendaItemEditorHeaderView,
        distance: Float) {
            
        if(selectedItem != nil) {
            
            selectedItem!.condition!.distance = distance
        }
            
        self.agendaItemEditorView!.setDistance(distance)
    }

    func agendaItemPlaceDidChanged(agendaItemCell: AgendaItemTableViewCell, agendaItem: AgendaItem, placeIndex: Int) {
        
        userAgenda!.prepareForSave()
        verifyDirtyState()
    }

    func datePickerCommit(date: NSDate) {
        
        if(selectedItem != nil) {
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute], fromDate: date)
            
            let hour = comp.hour
            let minute = comp.minute
            
            selectedItem!.time = AgendaTime.create(hour, minute: minute)
        }
        
        selectedItemCell?.refreshUI()
    }
    
    func initButtonAppearances() {
        
        let buttonLabels = ["Save", "Friends", "Calendar"]
        let buttonElements = [saveButton, friendsButton, calendarButton]
        let buttonIcons = [FontAwesome.ArrowCircleODown, .Users, .Calendar]
        
        for (index, _) in buttonLabels.enumerate() {
            
            let icon = buttonIcons[index]
            let label = buttonLabels[index]
            let elem = buttonElements[index]
        
            let menuButtonString = String.fontAwesomeIconWithName(icon)
            
            let normalStateAttributed =
            NSMutableAttributedString(
                string: "\(menuButtonString)\n\(label)",
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
            
            normalStateAttributed.addAttribute(
                NSFontAttributeName,
                value: UIFont.fontAwesomeOfSize(24),
                range: NSRange(location: 0, length: 1))
            
            if elem! == saveButton && userAgenda!.objectId != nil && userAgenda!.dirty {
                
                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0xFF6376),
                    range: NSRange(location: 0, length: 6)
                )
                
            } else {
                
                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0xffffff),
                    range: NSRange(location: 0, length: 6)
                )
            }
            
            elem?.setAttributedTitle(normalStateAttributed, forState: .Normal)
        }
    }
    
    func verifyDirtyState() {
        
        if userAgenda!.objectId != nil && userAgenda!.dirty {
        
            //TODO: Do something
        }
        
        // initButtonAppearances()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let toViewController = segue.destinationViewController 
        if(toViewController.isKindOfClass(MapViewController)) {
            
            let mapViewController = toViewController as! MapViewController
            mapViewController.userAgenda = userAgenda
        }
        
        if(toViewController.isKindOfClass(AgendaDetailsViewController)) {
            
            let detailsViewController = toViewController as! AgendaDetailsViewController
            detailsViewController.userAgenda = userAgenda
        }
        
        if(toViewController.isKindOfClass(CalendarViewController)) {
         
            let calendarViewController = toViewController as! CalendarViewController
            calendarViewController.selectedDate = userAgenda!.date
            calendarViewController.calendarMode = "selection"
            calendarViewController.userAgendas = presentUserAgendas
        }
    }

    @IBAction func unwindToAgendaViewController (sender: UIStoryboardSegue) {
        
        if(sender.sourceViewController.isKindOfClass(PlaceViewController)) {
            
            let placeViewController = sender.sourceViewController as! PlaceViewController
            
            if(placeViewController.useCurrentPlaceIndex == true) {
                
                if(selectedItemCell != nil) {
                    
                    // Set index of SwipeView to the chosen index
                    selectedItemCell!.swipeView.scrollToItemAtIndex(
                        placeViewController.currentPlaceIndex, duration: 0.3)
                }
                
                if(selectedItem != nil) {
                    
                    selectedItem!.selectedPlaceIndex = placeViewController.currentPlaceIndex
                }
                
                userAgenda!.prepareForSave()
                verifyDirtyState()
            }
        }

        if(sender.sourceViewController.isKindOfClass(EventViewController)) {
            
            let eventViewController = sender.sourceViewController as! EventViewController
            
            if(eventViewController.useCurrentPlaceIndex == true) {
                
                if(selectedItemCell != nil) {
                    
                    // Set index of SwipeView to the chosen index
                    selectedItemCell!.swipeView.scrollToItemAtIndex(
                        eventViewController.currentPlaceIndex, duration: 0.3)
                }
                
                if(selectedItem != nil) {
                    
                    selectedItem!.selectedPlaceIndex = eventViewController.currentPlaceIndex
                }
                
                userAgenda!.prepareForSave()
                verifyDirtyState()
            }
        }

        // When category selection commit.
        if(sender.sourceViewController.isKindOfClass(CategorySelectionViewController)) {
            
            let categorySelectionViewController = sender.sourceViewController as! CategorySelectionViewController
            
            if(categorySelectionViewController.commitSelectedCategory == true) {
                
                if(selectedItem != nil) {
                    
                    selectedItem!.condition!.categories.removeAll()
                    selectedItem!.condition!.categories.append(
                        categorySelectionViewController.selectedCategory!)
                }
                
                selectedItemCell?.refreshUI()
            }
        }
        
        // When date commit.
        if(sender.sourceViewController.isKindOfClass(CalendarViewController)) {
        
            let calendarViewController = sender.sourceViewController as! CalendarViewController
            
            if(calendarViewController.commitSelectedDate == true) {
             
                userAgenda!.date = calendarViewController.selectedDate
                
                // Non: Show the district instead
                // self.scheduledDateLabel.text = userAgenda!.date!.weekdayDayMonthTitle
                self.scheduledDateLabel.text = userAgenda!.district
                
                verifyDirtyState();
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func refreshAgendaItem(agendaItem: AgendaItem!) {
        
        refreshAgendaItem(agendaItem, forceDirty: false)
    }
    
    func refreshAgendaItem(agendaItem: AgendaItem!, forceDirty: Bool) {
        
        //TODO: Allow user to select search from prev agenda location or current location.
        //let location = getPrevAgendaLocation()
        
        let location = getAgendaLocation()
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Refreshing ...")
        
        AgendaGenerator.generateFromItem(
            location,
            userAgenda: userAgenda,
            agendaItem: agendaItem,
            completion: { (err: NSError?, result: AgendaItem?) -> Void in
                
            if(err == nil) {
                
                self.selectedItemCell?.refreshUI()
                self.selectedItemCell?.resetSwipe()
                
                SVProgressHUD.dismiss()
                
                if forceDirty {
                    
                    if self.userAgenda!.objectId != nil {
                        
                        self.userAgenda?.prepareForSave()
                    }
                }
                
                self.returnToListState()
            }
        })
    }
    
    func getPrevAgendaLocation() -> CLLocationCoordinate2D {
        
        // Find the current agenda index.
        var resultIndex = 0
        
        for item in userAgenda!.agendaItems! {
            
            if item === selectedItem {
                
                break
            }
            
            resultIndex = resultIndex + 1
        }
        
        var resultLocation: CLLocationCoordinate2D?
        
        while resultIndex > 0 {
            
            resultIndex = resultIndex - 1
            
            let item = userAgenda!.agendaItems![resultIndex]
            
            if item.businesses != nil && item.businesses!.count > 0 {
                    
                resultLocation = item.businesses![item.selectedPlaceIndex].coordinate
                break
            }
        }
        
        if resultLocation == nil {

            return getAgendaLocation()
        }
        
        return resultLocation!
    }
    
    func getAgendaLocation() -> CLLocationCoordinate2D {
        
        var location = UserLocation.get()
        if userAgenda!.location != nil {
            
            let attrs = userAgenda!.location!.characters.split {$0 == ","}.map(String.init)
            
            let lat = NSString(string: attrs[0]).doubleValue
            let lng = NSString(string: attrs[1]).doubleValue
            
            location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
        
        return location
    }
    
    func imageWithAgendaTable() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(agendaTableView.bounds.size, agendaTableView.opaque, 0.0)
        agendaTableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return img;
    }
    
    @IBAction func commitEditAgenda(sender: AnyObject) {

        if selectedItem != nil && selectedItem!.sourceInstance != nil {

            selectedItem!.commitChangesToSourceInstance()
            refreshAgendaItem(selectedItem!.sourceInstance, forceDirty: true)

            return;
        }
        
        returnToListState()
    }
    
    @IBAction func cancelEditAgenda(sender: AnyObject) {
        
        returnToListState()
    }
    
    @IBAction func backToSavedActivated(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareActivated(sender: AnyObject) {
        
        let originalHeight = agendaTableView.frame.height
        var frame = agendaTableView.frame;
        frame.size.height = agendaTableView.contentSize.height;
        agendaTableView.frame = frame;

        NSTimer.scheduledTimerWithTimeInterval(
            0.1, target: self,
            selector: #selector(AgendaViewController.shareContinue(_:)),
            userInfo: originalHeight, repeats: false)
    }
    
    func shareContinue(timer: NSTimer) {
        
        let img = imageWithAgendaTable()
        let agendaUrl = Config.slickster.agendaUrl
        let agendaId = userAgenda!.uuid!
        let link = "\(agendaUrl)/shared/\(agendaId)"
        
        let textToShare =
            "Hi! I have an agenda to share with you. " +
            "Please visit:"
        
        if let myWebsite = NSURL(string: link) {
            
            let objectsToShare = [textToShare, myWebsite, img]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            //Also save this Agenda
            userAgenda!.prepareForSave()
            userAgenda!.username = PFUser.currentUser()?.username
            
            if AgendaGenerator.templateType != nil {
                userAgenda!.templateType = AgendaGenerator.templateType
            }
            
            if userAgenda!.name == nil {
                userAgenda!.name = "\(userAgenda!.district!) Agenda"
            }
            
            userAgenda!.dataVersion = UserAgenda.parseDataVersion()
            userAgenda!.saveEventually()
        }
        
        let originalHeight = timer.userInfo as! CGFloat
        
        var frame = agendaTableView.frame;
        frame.size.height = originalHeight;
        agendaTableView.frame = frame;
    }
    
    @IBAction func scheduleActivated(sender: AnyObject) {
        
        if !AgendaManager.sharedInstance.isPresentAgendasCacheExists() {
            
            SVProgressHUD.setBackgroundColor(UIColor.blackColor())
            SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
            SVProgressHUD.setDefaultMaskType(.Gradient)
            SVProgressHUD.showWithStatus("Loading ...")
        }
        
        AgendaManager.sharedInstance.getPresentUserAgendas(PFUser.currentUser()!, callback: {
            (userAgendas: [UserAgenda]?, error: NSError?) in
            
            SVProgressHUD.dismiss()
            
            if error != nil {
                
                let alert = UIAlertController(
                    title: "Error",
                    message: error?.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: UIAlertActionStyle.Default,
                    handler: { (action: UIAlertAction) -> Void in
                        
                        self.presentingViewController?
                            .dismissViewControllerAnimated(true, completion: nil)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
                return
            }
            
            self.presentUserAgendas = userAgendas
            self.performSegueWithIdentifier("openCalendarSegue", sender: self)
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}

extension AgendaViewController : CategorySelectionViewControllerDelegate {
    
    func categorySelectionViewController(sender: AnyObject!, didSelectCategory yelpCategory: YelpCategory!) {
        
        let categorySelectionViewController = sender as! CategorySelectionViewController
        
        if(selectedItem != nil) {
            
            selectedItem!.condition!.categories.removeAll()
            selectedItem!.condition!.categories.append(yelpCategory)
            
            categorySelectionViewController.dismissViewControllerAnimated(true, completion: {})
        }
        
        selectedItemCell?.refreshUI()
    }
}

extension AgendaViewController : EventbriteCategorySelectionViewControllerDelegate {
    
    func eventBriteCategorySelectionViewController(sender: AnyObject!, didSelectCategory eventBriteCategory: EventbriteCategory!) {
        
        let eventBriteCategorySelectionViewController = sender as! EventbriteCategorySelectionViewController
        if(selectedItem != nil) {
            eventBriteCategorySelectionViewController.dismissViewControllerAnimated(true, completion: {})
        }
        
        selectedItemCell?.refreshUI()
    }
}

extension AgendaViewController : EventbriteSubCategorySelectionViewControllerDelegate {
    
    func eventBriteSubCategorySelectionViewController(sender: AnyObject!, didSelectCategory eventBriteSubCategory: EventbriteSubCategory!) {
        
        let eventBriteSubCategorySelectionViewController = sender as! EventbriteSubCategorySelectionViewController
        if(selectedItem != nil) {
            eventBriteSubCategorySelectionViewController.dismissViewControllerAnimated(true, completion: {})
        }
        
        selectedItemCell?.refreshUI()
    }
}

extension AgendaViewController : EventCategorySelectionViewControllerDelegate {
    
    func eventCategorySelectionViewController(sender: AnyObject!,
        didSelectCategory eventFulCategory: EventFulCategory!) {
        
        let categorySelectionViewController = sender as! EventCategorySelectionViewController
        
        if(selectedItem != nil) {
            
            if selectedItem!.condition!.eventCategories == nil {
                
                selectedItem!.condition!.eventCategories = [EventFulCategory]()
            }
            
            selectedItem!.condition!.eventCategories.removeAll()
            selectedItem!.condition!.eventCategories.append(eventFulCategory)
            
            categorySelectionViewController.dismissViewControllerAnimated(true, completion: {})
        }
        
        selectedItemCell?.refreshUI()
    }
}