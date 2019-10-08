//
//  UserInfo.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/13/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name = "nickname"
    }
}
