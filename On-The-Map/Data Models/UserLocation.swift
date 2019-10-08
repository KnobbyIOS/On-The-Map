//
//  UserLocation.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/20/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
struct StudentsLocations {
    
    static var sharedData = StudentsLocations()
    
    private init() {
    }
    
    var studentsInformation = [StudentDetails]()
    
}
