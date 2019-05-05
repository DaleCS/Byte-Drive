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
    
    var uploadedData: [File] = [File]()
    
    var currentPath: String = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ Upload", style: .done, target: self, action: #selector(uploadButton))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        readFilesInCurrentPath()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        cell?.textLabel?.text = uploadedData[indexPath.row].title
        return cell!
    }
    
    // Action upon pressing upload button
    @IBAction func uploadButton(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", kUTTypePDF as String, kUTTypePlainText as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
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
    
    // Fetches the entries in current path
    func readFilesInCurrentPath() {
        let databaseRef = Database.database().reference().child(currentPath)
        
        let _ = databaseRef.observe(.value, with: { (snapshot) in
            if (snapshot.exists() != false) {
                let filesDictionary = snapshot.value as! [String: AnyObject]
                self.uploadedData = [File]()
                for file in filesDictionary.values {
                    var newFile: File = File()
                    newFile.isFolder = file["isFolder"] as! Bool
                    newFile.title = file["title"] as! String
                    newFile.type = file["type"] as! String
                    newFile.storageRef = file["storageRef"] as! String
                    self.uploadedData.append(newFile)
                }
            }
            self.tableView.reloadData()
        })
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
            let storageRef = Storage.storage().reference().child("\(userID)/\(fileName)/")
            let databaseRef = Database.database().reference().child("\(self.currentPath)")
            
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
                
                let newPathForThisFile = databaseRef.childByAutoId()
                var newPathForThisFileStr = newPathForThisFile.url
                newPathForThisFileStr.removeSubrange(newPathForThisFileStr.startIndex..<newPathForThisFileStr.index(newPathForThisFileStr.startIndex, offsetBy: 34))
                var storagePathForThisFile = newPathForThisFileStr
                storagePathForThisFile.removeSubrange(storagePathForThisFile.lastIndex(of: "/")!..<storagePathForThisFile.endIndex)
                storagePathForThisFile.removeSubrange(storagePathForThisFile.startIndex...storagePathForThisFile.firstIndex(of: "/")!)
                storagePathForThisFile.insert(contentsOf: "/\(fileName)", at: storagePathForThisFile.endIndex)
                
                let databaseUpload =
                    [
                        "isFolder": false,
                        "title": String(fileName),
                        "storageRef": "\(storagePathForThisFile)",
                        "type": "\(metaData!.contentType ?? "")",
                        "databaseRef": "\(newPathForThisFileStr)"
                    ] as [String : Any?]
                databaseRef.childByAutoId().setValue(databaseUpload)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            handler in
            // Do nothing as DocumentPicker closes
        }
        
        verifyUploadAlertController.addAction(confirmAction)
        verifyUploadAlertController.addAction(cancelAction)
        self.present(verifyUploadAlertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (uploadedData[indexPath.row].isFolder == true) {
            let nextFileController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            nextFileController.currentPath = uploadedData[indexPath.row].databaseRef
            navigationController?.pushViewController(nextFileController, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var nextHomeViewController = segue.destination as! HomeViewController
//        nextHomeViewController.currentPath =
    }
}

// What is user research
