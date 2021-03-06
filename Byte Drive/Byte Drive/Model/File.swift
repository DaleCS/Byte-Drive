//
//  File.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/3/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import Foundation

// This is used for displaying file cells in HomeViewController
struct File {
    var isFolder: Bool
    var title: String
    var type: String
    var size: String
    var storageRef: String
    var databaseRef: String
    var downloadURL: String
    
    init() {
        isFolder = false
        title = String()
        type = String()
        size = String()
        storageRef = String()
        databaseRef = String()
        downloadURL = String()
    }
}
