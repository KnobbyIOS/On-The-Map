//
//  BlackBox.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/17/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
