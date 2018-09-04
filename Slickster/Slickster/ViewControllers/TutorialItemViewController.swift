//
//  PageItemController.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 1/12/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit

class TutorialItemViewController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        contentImageView!.contentMode = .ScaleAspectFill
    }
}
