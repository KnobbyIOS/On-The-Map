//
//  MapPinDetailViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/12/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPinDetailViewController: BaseMapViewController {
    
 
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentDetails : StudentDetails?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        if let studentLocation = studentDetails {
            let location = StudentLocationDetails (
                objectId: "",
                uniqueKey: nil,
                firstName: studentLocation.firstName,
                surname: studentLocation.surname,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: "",
                updateTime: ""
            )
            showStudentLocations(location: location)
        }
    }
    
    @IBAction func postButton(_ sender: Any) {
        postNewLocaton()
    }
    
    private func showStudentLocations(location: StudentLocationDetails) {
        mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        if let studentCoordinate = extractStudentCoordinates(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.locationDetailLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = studentCoordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            
        }
    }
    
    private func postNewLocaton() {
        if let newLocation = studentDetails {
            if newLocation.locationID != nil {
                DataClient.sharedInstance().updateUserLocation(newInformation: newLocation, completionHandler: {(success, error) in
                    print(error?.localizedDescription as Any)
                })
            } else {
                DataClient.sharedInstance().postUserLocation(information: newLocation, completionHandler: {(success, error) in
                    print(error?.localizedDescription as Any)
                })
            }
        }
    }
    
    private func extractStudentCoordinates(location: StudentLocationDetails) -> CLLocationCoordinate2D? {
        if let latitude = location.latitude, let longitude = location.longitude {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        return nil
    }


}

