//
//  UserLocationDetails.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/29/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation

struct StudentLocationDetails: Codable {
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let surname: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updateTime: String
    
    var locationDetailLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let surname = surname {
            if name.isEmpty {
                name = surname
            } else {
                name += " \(surname)"
            }
        }
        if name.isEmpty {
            name = "No name provided"
        }
        return name
    }
    
}
