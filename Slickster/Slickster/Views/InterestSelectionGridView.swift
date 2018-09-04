//
//  InterestSelectionGridView.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 4/29/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit

class InterestSelectionGridView: UIView {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var agendaTypeCategories: [AgendaTypeCategories]?
    var selectedInterests: [String:UserInterest]?
    var delegate: InterestSelectionGridDelegate?
    var key: String?
    
    override func awakeFromNib() {
        
        let cellNib = UINib(nibName: "InterestSelectionGridItemView", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "InterestCell")
        
        let headerNib = UINib(nibName: "InterestSelectionHeaderView", bundle: nil)
        self.collectionView.registerNib(headerNib,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "InterestHeader")
    }
    
    func setData(key: String, agendaTypeCategories: [AgendaTypeCategories], selectedInterests: [String:UserInterest]) {
        
        categoryIcon.image = UIImage(named: "interest-\(key).png")
        categoryTitle.text = key.uppercaseString
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let filtered = agendaTypeCategories.filter { (agendaTypeCategories) -> Bool in
            
            return agendaTypeCategories.interestPrefix != nil
        }

        self.agendaTypeCategories = filtered
        self.selectedInterests = selectedInterests
        self.collectionView.reloadData()
        self.key = key
        
        let collectionViewLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
        
        collectionViewLayout.headerReferenceSize =
            CGSizeMake(self.collectionView.frame.size.width, 30);
    }
}

extension InterestSelectionGridView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return agendaTypeCategories!.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return agendaTypeCategories![section].categories.count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let itemView = self.collectionView.dequeueReusableCellWithReuseIdentifier(
            "InterestCell", forIndexPath: indexPath) as! InterestSelectionGridItemView
        
        let typeCategories = agendaTypeCategories![indexPath.section]
        
        let category = typeCategories.categories[indexPath.row]
        let interestKey = "\(typeCategories.interestPrefix!)-\(category.title.lowercaseString)"
        
        itemView.setData(typeCategories.categories[indexPath.row],
                         interestKey: interestKey,
                         selectedInterests: selectedInterests!)
        itemView.delegate = self
        
        return itemView;
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width = (collectionView.frame.width / 3) - 10
        let height = CGFloat(30)
        
        return CGSizeMake(width, height)
    }
    
    func collectionView(
        collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
                                          atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView
            .dequeueReusableSupplementaryViewOfKind(kind,
                                                    withReuseIdentifier: "InterestHeader",
                                                    forIndexPath: indexPath) as! InterestSelectionHeaderView
        
        let agendaTypeCategories = self.agendaTypeCategories![indexPath.section]
        var headerTitle = agendaTypeCategories.type.uppercaseString
        
        if agendaTypeCategories.interestPrefix != nil {
            
            if agendaTypeCategories.interestPrefix!.rangeOfString(":") != nil {
                
                let suffix = agendaTypeCategories.interestPrefix!.componentsSeparatedByString(":")[1]
                headerTitle = "\(headerTitle) (\(suffix.uppercaseString))"
            }
        }
        
        headerView.setTitle(headerTitle)
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView,
                        shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
}

extension InterestSelectionGridView: InterestSelectionGridItemDelegate {
    
    func categorySelected(interestKey: String!, category: YelpCategory!) {
        
        let userInterest = UserInterest()
        userInterest.interestKey = interestKey
        userInterest.categoryName = category.title
        userInterest.categoryType = "yelp"
        
        self.selectedInterests![interestKey] = userInterest
        
        delegate?.interestSelected(interestKey, interest: userInterest)
    }
    
    func categoryDeselected(interestKey: String!, category: YelpCategory!) {

        let userInterest = UserInterest()
        userInterest.interestKey = interestKey
        userInterest.categoryName = category.title
        userInterest.categoryType = "yelp"
        
        self.selectedInterests!.removeValueForKey(interestKey)

        delegate?.interestDeselected(interestKey, interest: userInterest)
    }
}
