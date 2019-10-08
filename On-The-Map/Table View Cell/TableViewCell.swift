//
//  TableViewCell.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/20/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit

class LocationViewCell: UITableViewCell {
    
    static let cellIdentifier = "LocatonViewCell"
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    
    func configureCell(_ info: StudentDetails) {
        labelName.text = info.label
        labelURL.text = info.mediaURL
        
    }
    
}

