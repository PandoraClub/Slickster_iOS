//
//  SavedAgendaItemView.swift
//  Slickster
//
//  Created by NonGT on 10/18/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation

class SavedAgendaItemView : UIView {

    @IBOutlet weak var districtNameLabel: UILabel!
    @IBOutlet weak var agendaNameLabel: UILabel!
    @IBOutlet weak var agendaNote: UITextView!
    @IBOutlet weak var templateTypeLabel: UILabel!
    @IBOutlet weak var lastModifiedLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewScrollConstraint: NSLayoutConstraint!
    @IBOutlet weak var agendaTableView: UITableView!
    
    private var itemTintPatterns: [UIColor]! = [UIColor]()
    private var userAgenda: UserAgenda? = nil
    
    override func awakeFromNib() {
        
        agendaNameLabel.layer.cornerRadius = 5
        agendaNote.layer.cornerRadius = 5
        
        itemTintPatterns.append(UIColor(rgb: 0x834A17))
        itemTintPatterns.append(UIColor(rgb: 0x006c26))
        itemTintPatterns.append(UIColor(rgb: 0x834A17))
        itemTintPatterns.append(UIColor(rgb: 0x99A32E))
        itemTintPatterns.append(UIColor(rgb: 0x241505))
        itemTintPatterns.append(UIColor(rgb: 0x6E1F75))
        
        let nib = UINib(nibName: "AgendaItemTableViewCell", bundle: nil)
        agendaTableView.registerNib(nib, forCellReuseIdentifier: "agendaCell")
    }
    
    func setUserAgenda(userAgenda: UserAgenda) {
        
        self.userAgenda = userAgenda

        agendaNameLabel.text = userAgenda.name
        districtNameLabel.text = userAgenda.district
        
        if userAgenda.templateType != nil {
            templateTypeLabel.text = "\(userAgenda.templateType!.capitalizedString) Plan"
        } else {
            templateTypeLabel.text = "Unknown Plan"
        }
        
        lastModifiedLabel.text = "Last Modified: \(userAgenda.updatedAt!)"
        
        agendaNote.text = userAgenda.note
        agendaNote.textColor = UIColor(rgb: 0xcccccc)
        
        updateUserAgendaTable()
        updateScrollViewContent()
    }
    
    func updateUserAgendaTable() {
        
        if userAgenda != nil {
            
            userAgenda?.ensureAgendaItems()
            
        } else {
            
            userAgenda = UserAgenda()
        }
        
        agendaTableView.delegate = self
        agendaTableView.dataSource = self
        agendaTableView.reloadData()
    }
    
    func updateScrollViewContent() {
        
        var frame = agendaTableView.frame;
        frame.size.height = agendaTableView.contentSize.height;
        agendaTableView.frame = frame;
        
        let boundingBottom =
            self.agendaTableView.frame.origin.y +
                self.agendaTableView.frame.height
        
        let scrollFrameBottom = scrollView.frame.height
        var diff = boundingBottom - scrollFrameBottom
        
        if diff < 0 { diff = 0 }
        
        self.contentViewScrollConstraint.constant = diff / 2 + 14
    }
}

extension SavedAgendaItemView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(userAgenda?.agendaItems != nil) {
            
            return self.userAgenda!.agendaItems!.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let c: AnyObject? = self.agendaTableView.dequeueReusableCellWithIdentifier("agendaCell")
        let cell:AgendaItemTableViewCell = c as! AgendaItemTableViewCell
        cell.readOnlyMode = true
        
        let agendaItem:AgendaItem = self.userAgenda!.agendaItems![indexPath.row]
        
        var tintIndex = 0
        if(indexPath.row < itemTintPatterns.count) {
            tintIndex = indexPath.row
        } else {
            tintIndex = indexPath.row % itemTintPatterns.count
        }
        
        cell.setAgendaItem(userAgenda?.templateType,
                           agendaItem: agendaItem, tint: itemTintPatterns[tintIndex])
        
        cell.refreshUI()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 120
    }
}