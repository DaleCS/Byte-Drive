//
//  FileInfoViewController.swift
//  Byte Drive
//
//  Created by Sterling Gamble on 5/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import Foundation
import Firebase

class FileInfoViewController: UIViewController {
    
    func getMetaData(_ fileName: String, userID: String) {
        let storageRef = Storage.storage().reference().child("\(userID)/\(fileName)")
        storageRef.getMetadata { metadata, error in
            if let error = error {
                print(error)
            } else {
                // Metadata now contains the metadata for 'bucket/fileName'
                // metadata.contentType returns file type
                // metadata.size returns file size
            }
            // to display metadata contents must be done within closure
            // ie print(metadata)
        }
    }
}
