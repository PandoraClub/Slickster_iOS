//
//  CalendarSwitcherView.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 11/17/15.
//  Copyright © 2015 Donoma Solutions. All rights reserved.
//

import Foundation
import EventKit

class CalendarSwitcherView : UIView {
    
    @IBOutlet weak var calendarNameLabel: UILabel!
    @IBOutlet weak var calendarSubNameLabel: UILabel!
    @IBOutlet weak var calendarSwitch: UISwitch!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    private var calendar: EKCalendar?
    private var userAgendaCalendar: UserAgendaCalendar?
    
    func setData(calendar: EKCalendar, userAgendaCalendar: UserAgendaCalendar) {
        
        self.calendar = calendar
        self.userAgendaCalendar = userAgendaCalendar
        
        self.calendarNameLabel.text = calendar.source.title
        self.calendarSubNameLabel.text = calendar.title
        
        if userAgendaCalendar.shared != nil {
            self.calendarSwitch.on = userAgendaCalendar.shared!
        } else {
            self.calendarSwitch.on = false
        }
    }
    
    @IBAction func toggleSwitch(sender: AnyObject) {
        
        self.userAgendaCalendar?.shared = calendarSwitch.on
    }
    
    class func instanceFromXib() -> CalendarSwitcherView {
        
        return UINib(nibName: "CalendarSwitcherView", bundle: nil)
            .instantiateWithOwner(nil, options: nil)[0] as! CalendarSwitcherView
    }
}