//
//  StudentLocationDelegate.swift
//  On-The-Map
//
//  Created by Brian Leding on 10/1/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import UIKit

protocol SelectStudentLocationDelegate: class {
    func didSelectStudentLocation(information: StudentDetails)
}

class DataProvider: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    weak var delegate: SelectStudentLocationDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocations.sharedData.studentsInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentCell = tableView.dequeueReusableCell(withIdentifier: LocationViewCell.cellIdentifier, for: indexPath) as! LocationViewCell
        studentCell.configureCell(StudentsLocations.sharedData.studentsInformation[indexPath.row])
        return studentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectStudentLocation(information: StudentsLocations.sharedData.studentsInformation[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}
