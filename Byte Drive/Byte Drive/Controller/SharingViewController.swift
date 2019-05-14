//
//  SharingViewController.swift
//  Byte Drive
//
//  Created by Sterling Gamble on 5/13/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import Firebase

class SharingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchUsers() {
        
    }
    
//    func fetchUsers() {
//        let dbRef = Database.database().reference().child("FilePath")
////        let query = dbRef.child("FilePath")
//
//        dbRef.observe(.value) { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                if let value = child.value as? NSDictionary {
//                    let user = User()
////                    let name = value["name"] as? String ?? "Name not found"
//                    let email = value["email"] as? String ?? "Email not found"
////                    user.name = name
//                    user.email = email
//                    self.users.append(user)
//                    DispatchQueue.main.async { self.tableView.reloadData() }
//                }
//            print(snapshot)
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ShareViewCell
            else {
                return UITableViewCell()
        }
        let user = users[indexPath.row]
        cell.nameLabel.text = user.email
        return cell
    }
    
}

class User {
    var email: String? = nil
//    let userID: String? = nil
    
//    init(email: String, userID: String) {
//        self.name = email
//        self.id = userID
//    }
}

