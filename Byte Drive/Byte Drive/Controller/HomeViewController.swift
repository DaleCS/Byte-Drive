//
//  HomeViewController.swift
//  Byte Drive
//
//  Created by Jonathan Naraja on 3/6/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//
//  Some of the code in this file were taken from
//  From Youtube video by user CodeWithChris: https://www.youtube.com/watch?v=jJUm1VBnR_U

import UIKit
import Firebase
import GoogleSignIn
import MobileCoreServices

struct fileStruct {
    let title : String!
    let type : String!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
    
    var uploadedData = [fileStruct]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let dRef = Database.database().reference()
/*
        dRef.child("FilePath/\(userID)").queryOrderedByKey().observeSingleEvent(of: .childAdded) { (snapshot) in
         
            let value = snapshot.value as? [String: AnyObject]
            let name = value!["name"] as? String
            
            
            self.uploadedData.insert(fileStruct(title: name, type: "PDF"), at: 0)
            self.tableView.reloadData()
        }
*/
        dRef.child("FilePath/\(userID)").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            let name = value!["name"] as? String
            
            
            self.uploadedData.insert(fileStruct(title: name, type: "PDF"), at: 0)
            self.tableView.reloadData()
        }
        
        /*
        ref = Database.database().reference()
        ref?.child("FilePath/\(userID)/-6120651490687548386/name").observe(.childAdded, with: { (snapshot) in
            let name = snapshot.value as? String
            
            if let actualName = name {
                self.uploadedData.append(actualName)
                self.tableView.reloadData()
            }
        })
        */
    }
    
    // Action upon pressing log out button
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            try GIDSignIn.sharedInstance()?.signOut()
            performSegue(withIdentifier: "logoutFromHome", sender: self)
        } catch {
            print("Found errors: Failed to sign out")
        }
    }
    
    // Action upon pressing upload button
    @IBAction func uploadButton(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", kUTTypePDF as String, kUTTypePlainText as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func downloadPressed(_ sender: Any) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = uploadedData[indexPath.row].title
        return cell!
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first else {
            return
        }
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let fileName = fileURL.lastPathComponent
        
        let verifyUploadAlertController = UIAlertController(title: "Upload \(fileName) to this directory?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
            (handler) in
            let storageRef = Storage.storage().reference().child("\(userID)/\(fileName)")
            let databaseRef = Database.database().reference()
            let _ = storageRef.putFile(from: fileURL, metadata: nil) {
                (metaData, error) in
                if (error != nil) {
                    print("Error: \(String(describing: error))")
                    return
                }
                if (metaData == nil) {
                    print("Error: Meta data was nil")
                    return
                }
            }
            
            let databaseUpload : [String : Any] = [
                "name": fileName,
                "type": "PDF",
                "isFolder": false,
            ]
            databaseRef.child("FilePath/\(userID)/").childByAutoId().setValue(databaseUpload)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            handler in
            // Do nothing
        }
        
        verifyUploadAlertController.addAction(confirmAction)
        verifyUploadAlertController.addAction(cancelAction)
        self.present(verifyUploadAlertController, animated: true)
    }
}
