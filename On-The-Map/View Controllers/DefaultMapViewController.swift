//
//  DefaultMapViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/20/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class BaseMapViewController: UIViewController, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reusablePin = "pin"
        
        var placedPins = mapView.dequeueReusableAnnotationView(withIdentifier: reusablePin) as? MKPinAnnotationView
        
        if placedPins == nil {
            placedPins = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusablePin)
            placedPins?.canShowCallout = true
            placedPins?.pinTintColor = .red
            placedPins?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            placedPins?.annotation = annotation
        }
        
        return placedPins
        
    }
    
    //https://developer.apple.com/documentation/mapkit/mkannotationview
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped controls: UIControl) {
        if controls == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {
                print("No links")
                return
            }
            guard let link = subtitle else {
                print("No links")
                return
            }
            openLink(link)
        }
    }
    
}

