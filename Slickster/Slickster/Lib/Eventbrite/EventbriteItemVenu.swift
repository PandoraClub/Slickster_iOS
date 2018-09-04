//
//  EventbriteItemVenu.swift
//  Slickster
//
//  Created by Lucas on 9/2/16.
//  Copyright © 2016 Glass Hat Productions LLC. All rights reserved.
//

import Foundation

class EventbriteItemVenu: NSObject {
    
    var id: String?
    var name: String?
    var address: String?
    var fullAddress: String?
    var city: String?
    var region: String?
    var country: String?
    var postalCode: String?
    var coordinate: CLLocationCoordinate2D?
    
    class func fromJson(json:JSON) -> EventbriteItemVenu {
        let venu = EventbriteItemVenu()
        venu.id = json["id"].stringValue
        venu.name = json["name"].stringValue
        venu.address = json["address"]["address_1"].stringValue
        venu.fullAddress = json["address"]["localized_address_display"].stringValue
        venu.city = json["address"]["city"].stringValue
        venu.region = json["address"]["region"].stringValue
        venu.country = json["address"]["country"].stringValue
        venu.postalCode = json["address"]["postal_code"].stringValue
        venu.coordinate = CLLocationCoordinate2DMake(json["latitude"].doubleValue, json["longitude"].doubleValue)
        
        return venu
    }
}