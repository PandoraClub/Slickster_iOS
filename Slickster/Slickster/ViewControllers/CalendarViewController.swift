//
//  CalendarViewController.swift
//  Slickster
//
//  Created by NonGT on 10/26/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import CVCalendar
import SVProgressHUD
import FontAwesome_swift
import Parse

class CalendarViewController : UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var calendarMenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var agendaTable: UITableView!
    @IBOutlet weak var noAgendaView: UIView!
    @IBOutlet weak var publicLegendView: UIView!
    @IBOutlet weak var privateLegendView: UIView!
    @IBOutlet weak var backDateWarning: UIView!
    @IBOutlet weak var backDateWarningConstraint: NSLayoutConstraint!
    @IBOutlet weak var backToAgendaButton: UIButton!
    
    private var animationFinished: Bool = true
    
    var selectedDate: NSDate?
    var commitSelectedDate: Bool = false
    var calendarMode: String?
    
    var userAgendas: [UserAgenda]?
    var userAgendasTypeLookup: [String:Bool]?
    var isLoaded: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        commitSelectedDate = false
        
        if calendarMode == "selection" {
        
            titleLabel.text = "Schedule"
            doneButton.hidden = false
            
        } else {
            
            titleLabel.text = "Calendar"
            doneButton.hidden = true
        }
        
        let nib = UINib(nibName: "ScheduledAgendaTableViewCell", bundle: nil)
        agendaTable.registerNib(nib, forCellReuseIdentifier: "scheduledCell")
        
        agendaTable.separatorColor = UIColor.darkGrayColor()
        agendaTable.backgroundColor = UIColor.blackColor()
        
        publicLegendView.layer.cornerRadius = 11
        privateLegendView.layer.cornerRadius = 11
        
        backDateWarningConstraint.constant = 0
        
        if userAgendas != nil {
        
            initData(userAgendas)
            
        } else {
            
            AgendaManager.sharedInstance.getUserAgendas(PFUser.currentUser()!, callback: {
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
                
                self.userAgendas = userAgendas
                self.initData(self.userAgendas)
            })
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if self.userAgendas == nil {
            
            if !AgendaManager.sharedInstance.isPresentAgendasCacheExists() {
                
                SVProgressHUD.setBackgroundColor(UIColor.blackColor())
                SVProgressHUD.setForegroundColor(UIColor(rgb: 0x2BC2B3))
                SVProgressHUD.setDefaultMaskType(.Gradient)
                SVProgressHUD.showWithStatus("Loading ...")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if isLoaded {
            
            calendarView.commitCalendarViewUpdate()
            calendarMenuView.commitMenuViewUpdate()
        }
    }
    
    @IBAction func nextMonthActivated(sender: AnyObject) {
    
        calendarView.loadNextView()
    }
    
    @IBAction func prevMonthActivated(sender: AnyObject) {
        
        calendarView.loadPreviousView()
    }
    
    @IBAction func dateSelected(sender: AnyObject) {
        
        selectedDate = calendarView.presentedDate.convertedDate()
        commitSelectedDate = true
        
        self.performSegueWithIdentifier("unwindToAgendaViewController", sender: self)
    }
    
    @IBAction func backToAgendaButtonPress(sender: AnyObject) {
        
        if calendarMode != "selection" {
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func updateCalendarButtons(date: Date) {
        
        var prevMonth = date.month - 1
        var nextMonth = date.month + 1
        
        if(prevMonth < 1) {
            
            prevMonth = 12
        }
        
        if(nextMonth > 12) {
            
            nextMonth = 1
        }
        
        let buttonLabels = ["", ""]
        let buttonElements = [prevMonthButton, nextMonthButton]
        let buttonIcons = [FontAwesome.AngleLeft, .AngleRight]
        
        for (index, _) in buttonLabels.enumerate() {
            
            let icon = buttonIcons[index]
            let label = buttonLabels[index]
            let elem = buttonElements[index]
            
            let menuButtonString = String.fontAwesomeIconWithName(icon)
            
            if(index == 0) {
                
                let text = "\(menuButtonString) \(label)"
                
                let normalStateAttributed =
                NSMutableAttributedString(
                    string: text,
                    attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 15.00)!])
                
                normalStateAttributed.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.fontAwesomeOfSize(30),
                    range: NSRange(location: 0, length: 1))
                
                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0x00D4CC),
                    range: NSRange(location: 0, length: 1))

                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0xffffff),
                    range: NSRange(location: 2, length: label.characters.count))

                elem?.setAttributedTitle(normalStateAttributed, forState: .Normal)
            }

            if(index == 1) {
             
                let text = "\(label) \(menuButtonString)"
                
                let normalStateAttributed =
                NSMutableAttributedString(
                    string: text,
                    attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 15.00)!])
                
                normalStateAttributed.addAttribute(
                    NSFontAttributeName,
                    value: UIFont.fontAwesomeOfSize(30),
                    range: NSRange(location: label.characters.count + 1, length: 1))
                
                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0xffffff),
                    range: NSRange(location: 0, length: label.characters.count)
                )
                
                normalStateAttributed.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor(rgb: 0x00D4CC),
                    range: NSRange(location: label.characters.count + 1, length: 1)
                )
                
                elem?.setAttributedTitle(normalStateAttributed, forState: .Normal)
            }
            
            elem.contentVerticalAlignment = .Center
            elem.titleLabel?.baselineAdjustment = .AlignCenters
        }
    }
    
    private func refreshDateTitle() {
     
        todayLabel.text = selectedDate!.weekdayTitle
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}

extension CalendarViewController : CVCalendarViewDelegate {
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return true
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: DayView) {
        
        refreshDateTitle()

        if calendarMode != "selection" {
            
            return
        }
    
        selectedDate = calendarView.presentedDate.convertedDate()
        
        if selectedDate != nil && selectedDate!.isBeforeToday {
            
            doneButton.enabled = false
            doneButton.alpha = 0.5
            
            UIView.animateWithDuration(0.3,
                delay: 0.0, options: [.CurveEaseOut], animations: {

                    self.backDateWarningConstraint.constant = 20.0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (c:Bool) -> Void in
                    
                })
            
        } else {
        
            doneButton.enabled = true
            doneButton.alpha = 1
            
            UIView.animateWithDuration(0.3,
                delay: 0.0, options: [.CurveEaseOut], animations: {
                    
                    self.backDateWarningConstraint.constant = 0.0
                    self.view.layoutIfNeeded()
                    
                }, completion: { (c:Bool) -> Void in
                    
                })
        }
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
     
        return true
    }
    
    func presentedDateUpdated(date: Date) {
        
        currentMonthLabel.text = date.globalDescription
        updateCalendarButtons(date)
        
        selectedDate = calendarView.presentedDate.convertedDate()
        
        refreshDateTitle()
    }

    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
    
        return false
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        
        let flag = self.userAgendasTypeLookup?[dayView.date.asKey()]
        return flag != nil
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    
        let flag = self.userAgendasTypeLookup?[dayView.date.asKey()]
        
        if flag != nil {
        
            return flag! ? [UIColor(rgb: 0x91D0D7)] : [UIColor(rgb: 0xF00082)]
            
        } else {
            
            return [UIColor(rgb: 0xF00082)]
        }
    }
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
     
        return 12
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
     
        return 15
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
    
        return false
    }
}

extension CalendarViewController : CVCalendarMenuViewDelegate {

    func dayOfWeekTextColor() -> UIColor {
    
        return UIColor(rgb: 0x12ADA9)
    }
    
    func dayOfWeekTextUppercase() -> Bool {
        
        return true
    }
    
    func weekdaySymbolType() -> WeekdaySymbolType {
     
        return .VeryShort
    }
    
    func dayOfWeekFont() -> UIFont {
     
        return UIFont(name: "Avenir", size: 18)!
    }
}

extension CalendarViewController : CVCalendarViewAppearanceDelegate {

    func dayLabelWeekdayInTextColor() -> UIColor {
    
        return UIColor(rgb: 0xffffff)
    }
    
    func dayLabelWeekdayOutTextColor() -> UIColor {
        
        return UIColor(rgb: 0x999999)
    }
    
    func dayLabelWeekdayHighlightedTextColor() -> UIColor {
    
        return UIColor(rgb: 0x00D4CC)
    }
    
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        
        return UIColor(rgb: 0xffffff)
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor {
        
        return UIColor(rgb: 0x00D4CC)
    }
    
    func dayLabelPresentWeekdayHighlightedTextColor() -> UIColor {
    
        return UIColor(rgb: 0xffffff)
    }
    
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor {
    
        return UIColor(rgb: 0xffffff)
    }
    
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        
        return UIColor(rgb: 0x00D4CC)
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        
        return UIColor(rgb: 0x00D4CC)
    }
}

extension CalendarViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.userAgendas!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let c: AnyObject? = self.agendaTable.dequeueReusableCellWithIdentifier("scheduledCell")
        let cell:ScheduledAgendaTableViewCell = c as! ScheduledAgendaTableViewCell
        
        let userAgenda:UserAgenda = self.userAgendas![indexPath.row]
        cell.setData(userAgenda)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor(rgb: 0x000000)
            cell.contentView.backgroundColor = UIColor(rgb: 0x000000)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            
            let userAgenda:UserAgenda = self.userAgendas![indexPath.row]
            calendarView.presentedDate = Date(date: userAgenda.date!)
            
            calendarView.toggleViewWithDate(calendarView.presentedDate.convertedDate()!)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let testCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(testCell != nil) {
            
            let cell:UITableViewCell = testCell!
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
        if(cell.selected) {
            
            cell.backgroundColor = UIColor.blackColor() // UIColor(rgb: 0x51e2d4)
            cell.contentView.backgroundColor = UIColor.blackColor() // UIColor(rgb: 0x51e2d4)
            
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.accessibilityTraits = UIAccessibilityTraitSelected
            
        } else {
            
            cell.backgroundColor = UIColor.blackColor()
            cell.contentView.backgroundColor = UIColor.blackColor()
            
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.accessibilityTraits = 0
        }
    }
    
    func initData(userAgendas: [UserAgenda]?) {
        
        self.userAgendas = userAgendas
        
        if userAgendas == nil || userAgendas!.count == 0 {
            
            noAgendaView.hidden = false
            
        } else {
         
            noAgendaView.hidden = true
        }

        self.userAgendasTypeLookup = [String: Bool]()
        
        if self.userAgendas != nil {
            for ua in self.userAgendas! {
                
                if ua.date == nil {
                
                    continue
                }
                
                let key = CVDate(date: ua.date!).asKey()
                self.userAgendasTypeLookup![key] = ua.isPublic
            }
        }
        
        agendaTable.delegate = self
        agendaTable.dataSource = self
        agendaTable.reloadData()

        // Initialize calendar
        if selectedDate != nil {
            
            selectedDate = calendarView.presentedDate.convertedDate()
            refreshDateTitle()
        }
        
        calendarView.calendarDelegate = self
        calendarView.calendarAppearanceDelegate = self
        
        calendarMenuView.delegate = self
        
        self.isLoaded = true
    }
}

extension CVDate {
    
    func asKey() -> String {
    
        return "\(self.year)-\(self.month)-\(self.day)"
    }
}