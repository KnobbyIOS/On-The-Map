//
//  UserDetailViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/12/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class UserDetailViewController: UIViewController, UITextFieldDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userURL: UITextField!
    
    @IBOutlet weak var findMeButton: UIButton!
    var geoCoder = CLGeocoder()
    var locationID: String?
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
          self.userLocation.delegate =  self
       }

    @IBAction func findMeButton(_ sender: Any) {
        
        let newLocation = userLocation.text!
        let newWebsite = userURL.text!
        
        if newLocation.isEmpty || newWebsite.isEmpty {
            showInfo(withMessage: "All fields need to be filled.")
            return
        } else {
            userLocation.resignFirstResponder()
        }
        
        guard let newURL = URL(string: newWebsite), UIApplication.shared.canOpenURL(newURL) else {
            showInfo(withMessage: "Link invalid!")
            return
        }
        print (newLocation)
        geocodePosition(newLocation: newLocation)
        
    }
    
       private func geocodePosition(newLocation: String) {
           geoCoder.geocodeAddressString(newLocation) { (newMarker, error) in
               
               if let error = error {
                   self.showInfo(withTitle: "Error", withMessage: "Unable to find location: \(error)")
               } else {
                   var location: CLLocation?
                   
                   if let marker = newMarker, marker.count > 0 {
                    location = (marker.first?.location)!
                    print ("1")
                    print (marker)
                    print (marker.first?.location)
                    print (location)
                    print(location?.coordinate)
                    
                   }
                   
                if let location: CLLocationCoordinate2D = location?.coordinate {
                    print ("2")
                    print(location)
                    DispatchQueue.main.async {
                    
                    self.loadNewLocation(location)
                    }
                    return
                   } else {
    
                   }
                print ("3")
                print(location)
                   self.showInfo(withMessage: "No Matching Location Found")
                   }
               }
           }
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        
        print("loadNewLocation is getting called.")
        print(coordinate)
        let showNewLocation = storyboard?.instantiateViewController(withIdentifier: "MapPinDetailViewController") as! MapPinDetailViewController
        showNewLocation.studentDetails = buildStudentDetails(coordinate)
        //self.performSegue(withIdentifier: "MapPinDetailViewController", sender: nil)
        navigationController?.pushViewController(showNewLocation, animated: true)
        print("You should see map view")
    }
    
    private func buildStudentDetails(_ coordinates: CLLocationCoordinate2D) -> StudentDetails {
        print(coordinates)
        let nameComponents = DataClient.sharedInstance().userName.components(separatedBy: " ")
        let firstName = nameComponents.first ?? ""
        let surname = nameComponents.last ?? ""
        
        var studentInfo = [
            "uniqueKey": DataClient.sharedInstance().userKey,
            "firstName": firstName,
            "lastName": surname,
            "mapString": userLocation.text!,
            "mediaURL": userURL.text!,
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
            ] as [String: AnyObject]
        print(studentInfo)
        if let locationID = locationID {
            studentInfo["objectId"] = locationID as AnyObject
        }
    
        return StudentDetails(studentInfo)
    }
   
}
