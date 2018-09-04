//
//  AgendaItemEditorView.swift
//  Slickster
//
//  Created by NonGT on 9/27/2558 BE.
//  Copyright © 2558 Donoma Solutions. All rights reserved.
//

import Foundation
import MapKit
import FontAwesome_swift

class AgendaItemEditorDetailsView : UIView, MKMapViewDelegate {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var radiusCircle: MKCircle?
    var distanceMile: Float! = 1
    var centerCoordinate: CLLocationCoordinate2D?
    
    override func awakeFromNib() {
        
        let buttonString = String.fontAwesomeIconWithName(FontAwesome.Trash)
        let buttonStringAttributed =
            NSMutableAttributedString(
                string: buttonString,
                attributes: [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 11.00)!])

        buttonStringAttributed.addAttribute(
            NSFontAttributeName,
            value: UIFont.fontAwesomeOfSize(24),
            range: NSRange(location: 0, length: 1))

        buttonStringAttributed.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor(rgb: 0xffffff),
            range: NSRange(location: 0, length: 1)
        )
        
        deleteButton.setAttributedTitle(buttonStringAttributed, forState: .Normal)
        
        mapView.showsUserLocation = true
    }
    
    func initData() {
        
        if centerCoordinate != nil {
            
            mapView.centerCoordinate = self.centerCoordinate!
            
        } else {
            
            mapView.centerCoordinate = UserLocation.get()
        }
        
        mapView.delegate = self
        mapView.scrollEnabled = false
    }
    
    func clearDistance() {
        
        distanceLabel.text = "..."
        distanceMile = 1
        
        if(radiusCircle != nil) {
            
            mapView.removeOverlay(radiusCircle!)
        }
    }
    
    func setDistance(mile: Float) {
        
        distanceMile = mile
        let distance = Double(mile * 1609.344)
        
        if(radiusCircle != nil) {
            
            mapView.removeOverlay(radiusCircle!)
        }
        
        radiusCircle = MKCircle(
            centerCoordinate: mapView.centerCoordinate,
            radius: Double(distance) as CLLocationDistance)
        
        mapView.addOverlay(radiusCircle!)
        
        let fit = distance * Double(2.5)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(
            mapView.centerCoordinate, fit, fit)
        
        let adjustedRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        
        if(mile > 1) {
            distanceLabel.text = "\(mile) miles"
        } else {
            distanceLabel.text = "\(mile) mile"
        }
    }
    
    func getDistance() -> Float {
        
        return distanceMile
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            
            return circle
            
        } else {
            
            return MKOverlayRenderer()
        }
    }
}