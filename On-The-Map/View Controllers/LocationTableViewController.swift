//
//  LocationTableViewController.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/12/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation
import UIKit

class LocationTableViewController: UITableViewController, SelectStudentLocationDelegate {

@IBOutlet var locationTableView: UITableView!
@IBOutlet weak var dataProvider: DataProvider!
@IBOutlet weak var reloadIndicator: UIActivityIndicatorView!

override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(startMapReload), name: .startMapReload, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reloadMapCompleted), name: .reloadMapCompleted, object: nil)
    
    dataProvider.delegate = self
    locationTableView.dataSource = dataProvider
    locationTableView.delegate = dataProvider
    
    reloadMapCompleted()
}

@objc func startMapReload() {
    performUIUpdatesOnMain {
        self.reloadIndicator.startAnimating()
        
    }
}

@objc func reloadMapCompleted() {
    performUIUpdatesOnMain {
        self.reloadIndicator.stopAnimating()
        self.tableView.reloadData()
    }
}

func didSelectStudentLocation(information: StudentDetails) {
    openLink(information.mediaURL)
}
    @IBAction func logOutButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
