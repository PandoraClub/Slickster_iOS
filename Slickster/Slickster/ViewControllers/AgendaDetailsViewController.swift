//
//  SavedAgendasViewController.swift
//  Slickster
//
//  Created by NonGT on 10/17/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import FontAwesome_swift
import Parse
import SVProgressHUD
import EventKit

class AgendaDetailsViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var districtNameLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var agendaNameTextBox: UITextField!
    @IBOutlet weak var noteTextBox: UITextView!
    
    @IBOutlet weak var makePublicView: UIView!
    @IBOutlet weak var makePublicSwitch: UISwitch!
    @IBOutlet weak var createEventView: UIView!
    @IBOutlet weak var createEventSwitch: UISwitch!
    @IBOutlet weak var calendarSocialShareHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareAgendaButtonView: UIView!
    @IBOutlet weak var shareAgendaButton: UIButton!
    @IBOutlet weak var contentViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendarSwitchsView: UIView!
    
    var userAgenda: UserAgenda?
    var eventStore: EKEventStore = EKEventStore()
    var userAgendaCalendars = [UserAgendaCalendar]()
    
    override func viewDidLoad() {
        
        makePublicView.layer.cornerRadius = 5
        createEventView.layer.cornerRadius = 5
        shareAgendaButtonView.layer.cornerRadius = 5
        
        noteTextBox.backgroundColor = UIColor(rgb: 0xffffff)
        noteTextBox.layer.cornerRadius = 5
        noteTextBox.clipsToBounds = true
        
        let placeHolderAttrStr = NSAttributedString(
            string: "Enter Agenda Name",
            attributes: [NSForegroundColorAttributeName:UIColor(rgb: 0xaaaaaa)])
        
        agendaNameTextBox.attributedPlaceholder = placeHolderAttrStr
        agendaNameTextBox.textColor = UIColor(rgb: 0xcccccc)
        agendaNameTextBox.returnKeyType = .Done
        agendaNameTextBox.delegate = self
            
        noteTextBox.backgroundColor = agendaNameTextBox.backgroundColor
        noteTextBox.textColor = agendaNameTextBox.textColor
        noteTextBox.returnKeyType = .Done
        noteTextBox.delegate = self
        
        initButtonsAppearance()
        
        if userAgenda?.createCalendarEvent == nil {
         
            userAgenda?.createCalendarEvent = false
        }

        if userAgenda?.isPublic == nil {
            
            userAgenda?.isPublic = false
        }

        agendaNameTextBox.text = userAgenda?.name
        noteTextBox.text = userAgenda?.note
        districtNameLabel.text = userAgenda?.district
        createEventSwitch.on = (userAgenda?.createCalendarEvent)!
        makePublicSwitch.on = (userAgenda?.isPublic)!
        scheduledDateLabel.text = userAgenda?.date?.weekdayDayMonthTitle

        self.calendarSocialShareHeightConstraint.constant = 0
        if createEventSwitch.on {
            
            checkCalendarPermission()
        }
        
        if userAgenda!.username == nil {
            
            deleteButton.enabled = false
            userAgenda!.templateType = AgendaGenerator.templateType
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        updateScrollViewContent()
    }
    
    func initButtonsAppearance() {
     
        let deleteButtonString = String.fontAwesomeIconWithName(FontAwesome.Trash)
        let deleteButtonStringAttrNormal =
            NSMutableAttributedString(
                string: deleteButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
            
        deleteButtonStringAttrNormal.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(24),
            range: NSRange(location: 0, length: 1))
        
        deleteButtonStringAttrNormal.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: 1)
        )
        
        let deleteButtonStringAttrDisabled =
            NSMutableAttributedString(
                string: deleteButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])
        
        deleteButtonStringAttrDisabled.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(24),
            range: NSRange(location: 0, length: 1))
        
        deleteButtonStringAttrDisabled.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0x555555),
            range: NSRange(location: 0, length: 1)
        )
        
        deleteButton.setAttributedTitle(deleteButtonStringAttrNormal, forState: .Normal)
        deleteButton.setAttributedTitle(deleteButtonStringAttrDisabled, forState: .Disabled)
        
        let shareButtonString =
            "\(String.fontAwesomeIconWithName(FontAwesome.ShareAlt)) Share"
        
        let shareButtonStringAttrNormal =
            NSMutableAttributedString(
                string: shareButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 17.00)!])
        
        shareButtonStringAttrNormal.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(17),
            range: NSRange(location: 0, length: 1))
        
        shareButtonStringAttrNormal.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: 7)
        )
        
        let shareButtonStringAttrDisabled =
            NSMutableAttributedString(
                string: shareButtonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 17.00)!])
        
        shareButtonStringAttrDisabled.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(17),
            range: NSRange(location: 0, length: 1))
        
        shareButtonStringAttrDisabled.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0x555555),
            range: NSRange(location: 0, length: 7)
        )
        
        shareAgendaButton.setAttributedTitle(shareButtonStringAttrNormal, forState: .Normal)
        shareAgendaButton.setAttributedTitle(shareButtonStringAttrDisabled, forState: .Disabled)
        
        var bg = UIImage(named: "button-bg-dark")!
        let insets : UIEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        bg = bg.resizableImageWithCapInsets(insets)
        
        shareAgendaButton.setBackgroundImage(bg, forState: .Normal)
        shareAgendaButton.layer.cornerRadius = 5.0
        shareAgendaButton.clipsToBounds = true
    }
    
    func updateScrollViewContent() {
    
        let boundingBottom =
        self.shareAgendaButtonView.frame.origin.y +
            self.shareAgendaButtonView.frame.height
        
        let scrollFrameBottom = scrollView.frame.height
        var diff = boundingBottom - scrollFrameBottom
        
        if diff < 0 { diff = 0 }
        
        self.contentViewScrollConstraint.constant = diff / 2 + 10
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
            
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    @IBAction func saveActivated(sender: AnyObject) {
        
        let nameText = agendaNameTextBox.text!
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if nameText.isEmpty {
            
            let alert = UIAlertController(
                title: "Cannot Save",
                message: "Agenda Name must be specified",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(
                title: "Dismiss",
                style: UIAlertActionStyle.Default,
                handler: { (action: UIAlertAction) -> Void in
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
        SVProgressHUD.setDefaultMaskType(.Gradient)
        SVProgressHUD.showWithStatus("Saving ...")
        
        userAgenda!.prepareForSave()
        userAgenda!.username = PFUser.currentUser()?.username
        userAgenda!.name = nameText
        userAgenda!.note = noteTextBox.text
        userAgenda!.createCalendarEvent = createEventSwitch.on
        userAgenda!.isPublic = makePublicSwitch.on
        userAgenda!.dataVersion = UserAgenda.parseDataVersion()
        
        if !self.updateCalendar() {
        
            SVProgressHUD.dismiss()
            return
        }
        
        userAgenda!.saveInBackgroundWithBlock() {
            block in
            
            SVProgressHUD.dismiss()
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func checkCalendarPermission() {
     
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            
            requestAccessToCalendar()
            
        case EKAuthorizationStatus.Authorized:
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.proceedLoadCalendarSwitches()
            })
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            
            alertCalendarPermissionGuidance()
        }
    }
    
    func requestAccessToCalendar() {
     
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == false {
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.alertCalendarPermissionGuidance()
                })
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.proceedLoadCalendarSwitches()
                })
            }
        })
    }
    
    func alertCalendarPermissionGuidance() {
        
        createEventSwitch.on = false

        let alert = UIAlertController(
            title: "Permission Required",
            message: "Please allow this application to access to the calendar under settings.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: { (action: UIAlertAction) -> Void in

            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func proceedLoadCalendarSwitches() {
        
        let priority = DISPATCH_QUEUE_PRIORITY_BACKGROUND
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let query = PFQuery(className: UserAgendaCalendar.parseClassName())
            
            query.whereKey("userAgendaId", equalTo: self.userAgenda!.uuid!)
            query.findObjectsInBackground().continueWithBlock {
                (task: BFTask!) -> AnyObject in
                
                if(task.error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let alert = UIAlertController(
                            title: "Message",
                            message: "There are no calendar in this device", preferredStyle: .Alert)
                        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        
                        alert.addAction(OKAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        self.createEventSwitch.on = false
                        
                        return
                    })
                    
                    return task
                }
                
                let results = task.result as! [UserAgendaCalendar]
                self.userAgendaCalendars = results
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.proceedPrepareCalendarSwitchesWithData()
                })
                
                return task
            }
        }
    }
    
    func proceedPrepareCalendarSwitchesWithData() {
        
        // Create a lookup from userAgendaCalendars.
        var userAgendaCalendarLookup = [String:UserAgendaCalendar]()
        for userAgendaCalendar in userAgendaCalendars {
            
            userAgendaCalendarLookup[userAgendaCalendar.calendarId!] = userAgendaCalendar
        }
        
        let calendars = getAllCalendars()
        var index = 0
        var containerHeight = CGFloat(0)
        
        for calendar in calendars! {
            
            let calendarSwitcher = CalendarSwitcherView.instanceFromXib()
            var userAgendaCalendar = userAgendaCalendarLookup[calendar.calendarIdentifier]
            
            if userAgendaCalendar == nil {
                
                userAgendaCalendar = UserAgendaCalendar()
                self.userAgendaCalendars.append(userAgendaCalendar!)
            }
            
            userAgendaCalendar!.calendarId = calendar.calendarIdentifier
            userAgendaCalendar!.calendar = calendar
            userAgendaCalendar!.userAgendaId = userAgenda?.uuid

            calendarSwitcher.setData(calendar, userAgendaCalendar: userAgendaCalendar!)
            
            let y = (Double(index) * (Double(calendarSwitcher.frame.height) + 8) + 8)
            
            calendarSwitcher.frame = CGRectMake(0, CGFloat(y), calendarSwitchsView.frame.width, 40)
            calendarSwitcher.widthConstraint.constant = calendarSwitchsView.frame.width
            calendarSwitcher.heightConstraint.constant = 40
            calendarSwitcher.layer.cornerRadius = createEventView.layer.cornerRadius
            calendarSwitcher.backgroundColor = createEventView.backgroundColor
            
            calendarSwitchsView.addSubview(calendarSwitcher)
            containerHeight = CGFloat(y + Double(calendarSwitcher.frame.height) + Double(8))
            
            index = index + 1
        }

        if self.userAgendaCalendars.count == 0 {
            
            let alert = UIAlertController(
                title: "Message",
                message: "There are no calendar in this device", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(OKAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            createEventSwitch.on = false
            
            return
        }
        
        UIView.animateWithDuration(0.3,
            delay: 0.5, options: [.CurveEaseOut], animations: {
                
                self.calendarSocialShareHeightConstraint.constant = containerHeight
                self.view.layoutIfNeeded()
                
            }, completion: { (c:Bool) -> Void in
                
                self.updateScrollViewContent()
            })
    }
    
    func updateCalendar() -> Bool {
    
        if createEventSwitch.on {
            
            var foundError = false

            for userAgendaCalendar in userAgendaCalendars {
                
                if userAgendaCalendar.shared == true {
                    
                    var event: EKEvent?
                    
                    if userAgendaCalendar.eventId == nil {
                        
                        event = EKEvent(eventStore: eventStore)
                        
                    } else {
                        
                        event = eventStore.eventWithIdentifier(userAgendaCalendar.eventId!)
                        if event == nil {
                            event = EKEvent(eventStore: eventStore)
                        }
                    }
                    
                    event!.startDate = userAgenda!.date!
                    event!.endDate = event!.startDate.dateByAddingTimeInterval(12 * 60 * 60)
                    event!.allDay = true
                    event!.calendar = userAgendaCalendar.calendar!
                    event!.title = userAgenda!.name!
                    event!.notes = userAgenda!.note
                    event!.location = userAgenda!.district
                    event!.URL = NSURL(string: "http://event.slicksterapp.com/\(userAgenda!.uuid!)")
                    event!.alarms = [EKAlarm(relativeOffset: -(16 * 60 * 60))]
                    
                    do {
                    
                        try eventStore.saveEvent(event!, span: EKSpan.ThisEvent, commit: true)
                        userAgendaCalendar.eventId = event!.eventIdentifier
                        userAgendaCalendar.saveEventually()
                        
                    } catch {
                     
                        foundError = true
                    }
                    
                } else {
                    
                    if userAgendaCalendar.eventId != nil {
                        
                        let event = eventStore.eventWithIdentifier(userAgendaCalendar.eventId!)
                        if event != nil {
                            
                            do {
                                
                                try eventStore.removeEvent(event!, span: .ThisEvent)
                                userAgendaCalendar.saveEventually()
                                
                            } catch {
                                
                                foundError = true
                            }
                            
                        } else {
                            
                            userAgendaCalendar.saveEventually()
                        }
                        
                    } else {
                        
                        userAgendaCalendar.saveEventually()
                    }
                }
            }
            
            if foundError {
                
                let alert = UIAlertController(
                    title: "An error occurs",
                    message: "Some event may not saved into calendar successfully.", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alert.addAction(OKAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
        }
        
        return true
    }
    
    func getAllCalendars() -> [EKCalendar]? {
        
        let calendars = eventStore.calendarsForEntityType(.Event)
        let filteredCalendars = calendars.filter({ cal in
            
            var allow = cal.source.sourceType == .CalDAV ||
                    cal.source.sourceType == .Local
            
            allow = allow && cal.allowsContentModifications
            
            return allow
        })
        
        return filteredCalendars
    }
    
    @IBAction func deleteActivated(sender: AnyObject) {
        
        let alert = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to delete this agenda?",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Destructive,
            handler: { (action: UIAlertAction) -> Void in
                
            self.userAgenda?.deleteEventually()
            self.performSegueWithIdentifier("unwindToMainViewController", sender: self)
        }))

        alert.addAction(UIAlertAction(
            title: "No",
            style: UIAlertActionStyle.Cancel,
            handler: { (action: UIAlertAction) -> Void in
                
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func createEventToggled(sender: AnyObject) {
        
        if(createEventSwitch.on) {
         
            checkCalendarPermission()
            
        } else {
            
            calendarSwitchsView.removeAllSubviews()
            userAgendaCalendars.removeAll()
            
            UIView.animateWithDuration(0.3,
                delay: 0.5, options: [.CurveEaseOut], animations: {
                    
                    self.calendarSocialShareHeightConstraint.constant = 0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (c:Bool) -> Void in
                    
                    self.updateScrollViewContent()
                })
        }
    }
    
    @IBAction func shareActivated(sender: AnyObject) {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}