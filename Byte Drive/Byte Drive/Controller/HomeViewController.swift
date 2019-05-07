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
    
    @IBOutlet var addButtonView: addButtonView!
    @IBOutlet var uploadView: UploadView!
    
    @IBOutlet weak var uploadFile: UIStackView!
    
    var uploadedData: [File] = [File]()
    
    var folderName: String = String()
    var currentPath: String = String()
    var currentDirectory: String = String()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.addSubview(uploadView)
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleUploadViewSwipeDown))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        uploadView.addGestureRecognizer(swipeDownGesture)
        
        self.navigationController?.view.addSubview(addButtonView)
        addButtonView.center = CGPoint(x: view.frame.width * 0.85,y: view.frame.height * 1.10)
        addButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddButtonTap)))
        
        uploadFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFileUpload)))
        
        // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+ New", style: .done, target: self, action: #selector(uploadButton))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FileCell",  bundle: nil  ), forCellReuseIdentifier: "FileCell")
        tableView.separatorStyle = .none
        
        readFilesInCurrentPath()
        
        showAddButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAddButtonView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hideUploadView()
        hideAddButtonView()
    }
    
    @objc fileprivate func handleFileUpload() {
        showDocumentPicker()
    }
    
    @objc fileprivate func handleAddButtonTap() {
        showUploadView()
        hideAddButtonView()
    }
    
    @objc fileprivate func handleUploadViewSwipeDown() {
        hideUploadView()
        showAddButtonView()
    }
    
    func hideUploadView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.uploadView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            (_) in
            self.uploadView.isHidden = true
        })
    }
    
    func hideAddButtonView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.addButtonView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            (_) in
            self.addButtonView.isHidden = true
        })
    }
    
    func showUploadView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.uploadView.isHidden = false
            self.uploadView.transform = CGAffineTransform(translationX: 0, y: -((self.uploadView?.frame.height ?? 0)))
        })
    }
    
    func showAddButtonView() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.addButtonView.isHidden = false
            self.addButtonView.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height * 0.20))
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
        
        var title = uploadedData[indexPath.row].title
        title.removeSubrange(title.lastIndex(of: ".")!..<title.endIndex)
        cell.title.text = title
        
        switch(uploadedData[indexPath.row].type) {
        case "application/pdf":
            cell.icon.image = #imageLiteral(resourceName: "pdf")
        case "text/plain":
            cell.icon.image = #imageLiteral(resourceName: "txt")
        case "Folder":
            cell.icon.image = #imageLiteral(resourceName: "folder")
        default:
            cell.icon.image = #imageLiteral(resourceName: "file")
        }
        return cell
    }
    
    // Action upon pressing upload button
    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", kUTTypePDF as String, kUTTypePlainText as String, kUTTypeJPEG as String, kUTTypePNG as String, kUTTypeGIF as String, kUTTypeMP3 as String], in: .import)
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
                self.folderName = filesDictionary["title"] as! String
                self.uploadedData = [File]()
                for file in filesDictionary.values {
                    if (file["isFolder"] != nil) {
                        var newFile: File = File()
                        newFile.isFolder = file["isFolder"] as! Bool
                        newFile.title = file["title"] as! String
                        newFile.type = file["type"] as! String
                        newFile.size = file["size"] as! String
                        newFile.storageRef = file["storageRef"] as! String
                        newFile.databaseRef = file["databaseRef"] as! String
                        self.uploadedData.append(newFile)
                    }
                }
            } else {
                databaseRef.setValue([
                    "title": "\(self.folderName)",
                    "directory": "\(self.currentDirectory)"
                ])
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
            
            var currentFolder = self.currentPath
            currentFolder.removeSubrange(currentFolder.startIndex...currentFolder.lastIndex(of: "/")!)
            let storageRef = Storage.storage().reference().child("\(userID)/\(self.currentDirectory)/\(fileName)")
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
                
                let databaseUpload =
                    [
                        "isFolder": false,
                        "title": fileName,
                        "type": "\(metaData!.contentType ?? "")",
                        "size": "\(String(format: "%.2f", Double(metaData!.size)/1000)) KB",
                        "storageRef": "\(userID)/\(self.currentDirectory)/\(fileName)",
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
            nextFileController.folderName = uploadedData[indexPath.row].title
            nextFileController.currentDirectory = "\(currentDirectory)/\(uploadedData[indexPath.row].title)"
            navigationController?.pushViewController(nextFileController, animated: true)
        } else {
            let fileDescriptionVC = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
            fileDescriptionVC.storageRef = uploadedData[indexPath.row].storageRef
            fileDescriptionVC.descriptionArr = [("Title ", uploadedData[indexPath.row].title), ("Type ", uploadedData[indexPath.row].type), ("Size ", "\(uploadedData[indexPath.row].size)"), ("Directory ", "\(currentDirectory)/")]
            navigationController?.pushViewController(fileDescriptionVC, animated: true)
        }
    }
}

// What is user research
