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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate {
    
    var uploadedData = [AnyObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Action upon pressing log out button
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        guard let userID = Auth.auth().currentUser?.uid else { return cell! }
        let databaseRef = Database.database().reference().child("FilePath/\(userID)/")
        
        let _ = databaseRef.observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            self.uploadedData = Array(data.values)
        })
        
        // The code below doesn't work (Doesn't display the file name)
        cell?.textLabel?.text = uploadedData[indexPath.row]["title"] as? String ?? ""
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
            let databaseRef = Database.database().reference().child("FilePath/\(userID)/")
            
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
            let databaseUpload =
            [
                "title": String(fileName),
                "type": "PDF"
            ] as [String : Any?]
            databaseRef.childByAutoId().setValue(databaseUpload)
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

// What is user research
