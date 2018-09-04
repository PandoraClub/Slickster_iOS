//
//  CLLocationCoordinate2DExtensions.swift
//  Slickster
//
//  Created by NonGT on 10/18/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import UIKit

extension CLLocationCoordinate2D {
    
    var string: String {
    
        get {
            
            return "\(self.latitude),\(self.longitude)"
        }
    }
}