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
    
    let downloadView: UIView  = {
        let downloadView: UIView = UIView()
        let nameTextView: UITextView = UITextView();
        nameTextView.text = "User1 File"
        downloadView.addSubview(nameTextView)
        return downloadView
    }()
    
    var uploadedData = ["Document1", "Document2", "Document3"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        cell?.textLabel?.text = uploadedData[indexPath.row]
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
            let databaseRef = Database.database().reference().child("FilePath/\(userID)/\(fileName.hashValue)")
            
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
                "name": String(fileName),
                "type": "PDF",
                "isFolder": false,
                "contents": nil
            ] as [String : Any?]
            databaseRef.setValue(databaseUpload)
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
