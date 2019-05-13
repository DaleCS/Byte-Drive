//
//  SharingViewController.swift
//  Byte Drive
//
//  Created by Sterling Gamble on 5/10/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import Firebase

class SharingViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {
    var ref: DatabaseReference!
    var results = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // search the database
    // add to array
    // add to table view
    func search(userID: String) {
        var ref = Database.database().reference()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
    }
    
    // plan:
    // search users with mathcing email
    // get the matching user's bucket/userID
    // add the current file to matching user'sbucket
}

class User {
    let name: String
    
    
    init(name: String) {
        self.name = name
    }
}
