//
//  MapCustomAnnotation.swift
//  Slickster
//
//  Created by Chonnarong Hanyawongse on 1/5/16.
//  Copyright © 2016 Donoma Solutions. All rights reserved.
//

import UIKit
import MapKit

class MapCustomAnnotation: NSObject, MKAnnotation {

    private var _title: String
    private var _subtitle: String
    private var _coordinate: CLLocationCoordinate2D
    
    internal var title: String? { get { return _title } }
    internal var subtitle: String? { get { return _subtitle } }
    internal var coordinate: CLLocationCoordinate2D { get { return _coordinate } }
    
    var category: String?
    var time: String?
    var agendaItemIndex: Int?
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
       
        self._title = title
        self._subtitle = subtitle
        self._coordinate = coordinate
    }
}
