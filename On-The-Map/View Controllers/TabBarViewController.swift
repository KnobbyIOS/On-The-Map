//
//  TabBarViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/13/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadStudentsInformation), name: .reload, object: nil)
        loadStudentsInformation()
    }
    
    @objc private func loadStudentsInformation() {
        DataClient.sharedInstance().studentsDetails {
            (studentDetails, error) in
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
                NotificationCenter.default.post(name: .reloadMapCompleted, object: nil)
                return
            }
            if let studentDetails = studentDetails {
                StudentsLocations.sharedData.studentsInformation = studentDetails
                NotificationCenter.default.post(name: .reloadMapCompleted, object: nil)
            }
        }
    }


}

