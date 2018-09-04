//
//  DatePickerViewController.swift
//  Slickster
//
//  Created by NonGT on 9/29/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    private var date: NSDate?
    var delegate:DatePickerViewControllerDelegate?
    
    func setTime(time: String) {
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "es_US_POSIX")
        formatter.dateFormat = "hh:mm a"
        
        date = formatter.dateFromString(time)
        
        if timePicker != nil {
            
            timePicker.date = date!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if date != nil {
            timePicker.date = date!
        }
    }

    @IBAction func commit(sender: AnyObject) {
     
        self.dismissViewControllerAnimated(true) {
            
            let date = self.timePicker.date
            self.delegate?.datePickerCommit(date)
        }
    }
}
