//
//  UserDetails.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/17/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation

struct StudentDetails {
    
    let locationID: String?
    let studentKey: String
    let firstName: String
    let surname: String
    let mapString: String
    let mediaURL: String
    let longitude: Double
    let latitude: Double
    
    init(_ studentDictionary : [String : AnyObject]) {
        self.locationID = studentDictionary["objectID"] as? String
        self.studentKey = studentDictionary["studentKey"] as? String ?? ""
        self.firstName = studentDictionary["firstName"] as? String ?? ""
        self.surname = studentDictionary["surname"] as? String ?? ""
        self.mapString = studentDictionary["mapString"] as? String ?? ""
        self.mediaURL = studentDictionary["mediaURL"] as? String ?? ""
        self.longitude = studentDictionary["longitude"] as? Double ?? 0.0
        self.latitude = studentDictionary["latitude"] as? Double ?? 0.0
    }
    
    var label: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !surname.isEmpty {
            if name.isEmpty {
                name = surname
            } else {
                name += " \(surname)"
            }
        }
        if name.isEmpty {
            name = "User did not enter a name"
        }
        return name
    }
}
