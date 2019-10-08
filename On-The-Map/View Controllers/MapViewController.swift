//
//  MapViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/12/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseMapViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(startMapReload), name: .startMapReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMapCompleted), name: .reloadMapCompleted, object: nil)
        
        loadUserLocation()
    }
    
    @objc func startMapReload() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 0.2
        }
    }
    
    @objc func reloadMapCompleted() {
        performUIUpdatesOnMain {
            self.mapView.alpha = 1
            self.showStudentsDetails(StudentsLocations.sharedData.studentsInformation)
        }
    }
    
    //https://www.devfright.com/mkpointannotation-tutorial/
    //http://swiftdeveloperblog.com/code-examples/drop-a-mkpointannotation-pin-on-a-mapview-at-users-current-location/
    func showStudentsDetails(_ studentsDetails: [StudentDetails]) {
        
        //mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        var annotations = [MKPointAnnotation]()
        
        for information in studentsDetails where information.latitude != 0 && information.longitude != 0 {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let center = CLLocationCoordinate2DMake(information.latitude, information.longitude)
            let region = MKCoordinateRegion(center: center, span: span)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(information.latitude, information.longitude)
            annotation.title = information.label
            annotation.subtitle = information.mediaURL
            annotations.append(annotation)
            mapView.setRegion(region, animated: true)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func loadUserLocation() {
        _ = DataClient.sharedInstance().userInformation(completionHandler: {(studentInfo, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //DataClient.sharedInstance().userName = studentInfo?.user.name ?? ""
            DataClient.sharedInstance().userName = studentInfo?.firstName ?? ""
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        })
    }
    

    @IBAction func logOut(_ sender: Any) {
        
            dismiss(animated: true, completion: nil)
            /*DataClient.sharedInstance().logoutUser { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showInfo(withTitle: "Log Out Error", withMessage: (error?.localizedDescription)!)
            }
        }*/
    }
}
