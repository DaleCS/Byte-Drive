//
//  File.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/3/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import Foundation

struct File {
    var isFolder: Bool
    var title: String
    var type: String
    var storageRef: String
    
    init() {
        isFolder = false
        title = ""
        type = ""
        storageRef = ""
    }
}
