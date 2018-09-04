//
//  ScheduledAgendaTableViewCell.swift
//  Slickster
//
//  Created by NonGT on 10/28/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class ScheduledAgendaTableViewCell : UITableViewCell {

    @IBOutlet weak var dayHeadLabel: UILabel!
    @IBOutlet weak var templateTypeLabel: UILabel!
    @IBOutlet weak var agendaTitleLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!

    let calendar = NSCalendar.currentCalendar()

    func setData(userAgenda: UserAgenda) {
        
        if userAgenda.date != nil {
    
            let components = calendar.components([
                NSCalendarUnit.Day, .Month, .Year, .Weekday], fromDate: userAgenda.date!)
            
            dayHeadLabel.text = "\(components.day)"
            
            let weekdayTitle = getWeekdayTitle(components.weekday)
            let monthTitle = getMonthTitle(components.month)
            
            scheduledDateLabel.text = "\(weekdayTitle) \(components.day) \(monthTitle)"
        }
        
        templateTypeLabel.text = "\(userAgenda.templateType!.capitalizedString) Agenda"
        agendaTitleLabel.text = "\(userAgenda.name!)"
        
        if userAgenda.isPublic == false {
        
            dayHeadLabel.backgroundColor = UIColor(rgb: 0xf00082)
            templateTypeLabel.textColor = UIColor(rgb: 0xf00082)
            
        } else {
            
            dayHeadLabel.backgroundColor = UIColor(rgb: 0x01D3CA)
            templateTypeLabel.textColor = UIColor(rgb: 0x01D3CA)
        }
    }
    
    private func getWeekdayTitle(weekday: Int) -> String {
     
        switch(weekday) {
            
            case 1: return "Sun"
            case 2: return "Mon"
            case 3: return "Tue"
            case 4: return "Wed"
            case 5: return "Thu"
            case 6: return "Fri"
            case 7: return "Sat"
            default: return ""
        }
    }
    
    private func getMonthTitle(month: Int) -> String {
        
        switch(month) {
            
            case 1: return "Jan"
            case 2: return "Feb"
            case 3: return "Mar"
            case 4: return "Apr"
            case 5: return "May"
            case 6: return "Jun"
            case 7: return "Jul"
            case 8: return "Aug"
            case 9: return "Sep"
            case 10: return "Oct"
            case 11: return "Nov"
            case 12: return "Dec"
            default: return ""
        }
    }
}