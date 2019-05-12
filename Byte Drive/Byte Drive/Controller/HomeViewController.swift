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
    @IBOutlet var newFolderView: AddNewFolderView!
    
    @IBOutlet weak var addFolderView: UIStackView!
    @IBOutlet weak var uploadFile: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var userdefault = UserDefaults()
    
    var uploadedData: [File] = [File]()
    
    var folderName: String = String()
    var currentPath: String = String()
    var currentDirectory: String = String()
    var containingPath: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add all the views
        self.navigationController?.view.addSubview(uploadView)
        self.navigationController?.view.addSubview(newFolderView)
        self.navigationController?.view.addSubview(addButtonView)
        
        // Add uploadview and add swipedown gesture
        let uploadViewSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleUploadViewSwipeDown))
        uploadViewSwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        uploadView.addGestureRecognizer(uploadViewSwipeDown)
        
        // Add newFolderView and add swipe down gesture
        let newFolderViewSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleNewFolderViewSwipeDown))
        newFolderViewSwipeDown.direction = UISwipeGestureRecognizer.Direction.down
        newFolderView.addGestureRecognizer(newFolderViewSwipeDown)
        
        // Add addButtonView and add tapGesture
        addButtonView.center = CGPoint(x: view.frame.width * 0.85,y: view.frame.height * 1.10)
        addButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddButtonTap)))
        
        // Add the tap gesture recognizer to uploadFile StackView
        uploadFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFileUpload)))
        addFolderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddFolder)))
        
        // Add tableview Delegate and data source
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
        hideNewFolderView()
    }
    
    // Handler for when the user taps the 'Add folder' stack view in UploadView
    @objc fileprivate func handleAddFolder() {
        showNewFolderTitle()
        // addNewFolder()
    }
    
    // Handler for when the user taps the 'Upload File' stack view in UploadView
    @objc fileprivate func handleFileUpload() {
        showDocumentPicker()
        hideUploadView()
    }
    
    // Handler for when the user taps on the 'Plus button' AKA 'Add button' AKA 'Circle plus button'
    @objc fileprivate func handleAddButtonTap() {
        showUploadView()
        hideAddButtonView()
    }
    
    // Handler for when the user swipes down the UploadView
    @objc fileprivate func handleUploadViewSwipeDown() {
        hideNewFolderView()
        hideUploadView()
        showAddButtonView()
    }
    
    // Handler for the when the user swipes down the AddNewFolderView
    @objc fileprivate func handleNewFolderViewSwipeDown() {
        hideNewFolderView()
        hideUploadView()
        showAddButtonView()
    }
    
    // Hides the NewFolderView
    func hideNewFolderView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.newFolderView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            (_) in
            self.newFolderView.isHidden = true
        })
    }
    
    // Adds the new folder into the user's database
    func addNewFolder() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let newDatabaseRef = Database.database().reference().child("FilePath/\(userID)").childByAutoId()
        var newDatabaseRefUrl = newDatabaseRef.url
        newDatabaseRefUrl.removeSubrange(newDatabaseRefUrl.startIndex...newDatabaseRefUrl.lastIndex(of: "/")!)
        
        let oldDatabaseRef = Database.database().reference().child(currentPath).childByAutoId()
        var oldDatabaseNewId = oldDatabaseRef.url
        oldDatabaseNewId.removeSubrange(oldDatabaseNewId.startIndex...oldDatabaseNewId.lastIndex(of: "/")!)
        let databaseUpload =
            [
                "isFolder": true,
                "title": newFolderView.titleTextField.text ?? "",
                "type": "Folder",
                "size": "0 KB",
                "storageRef": "",
                "databaseRef": "\(currentPath)/\(oldDatabaseNewId)",
                "folderPath": "FilePath/\(userID)/\(newDatabaseRefUrl)",
                "downloadURL": ""
            ] as [String : Any?]
        oldDatabaseRef.setValue(databaseUpload)
        
        let newDirectory = "\(currentDirectory)/\(newFolderView.titleTextField.text ?? "")"
        let newFolder = [
            "title": newFolderView.titleTextField.text ?? "",
            "directory": newDirectory
        ]
        newDatabaseRef.setValue(newFolder)
        
        let newHomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        newHomeVC.containingPath = "\(currentPath)/\(oldDatabaseNewId)"
        newHomeVC.currentPath = "FilePath/\(userID)/\(newDatabaseRefUrl)"
        newHomeVC.folderName = newFolderView.titleTextField.text ?? ""
        newHomeVC.currentDirectory = newDirectory
        self.navigationController?.pushViewController(newHomeVC, animated: true)
        
    }
    
    // Hides the UploadView
    func hideUploadView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.uploadView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            (_) in
            self.uploadView.isHidden = true
        })
    }
    
    // Hides the Add button
    func hideAddButtonView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.addButtonView.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: {
            (_) in
            self.addButtonView.isHidden = true
        })
    }
    
    // Shows the UploadView
    func showUploadView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.uploadView.isHidden = false
            self.uploadView.transform = CGAffineTransform(translationX: 0, y: -((self.uploadView?.frame.height ?? 0)))
        })
    }
    
    // Shows the Add button
    func showAddButtonView() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.addButtonView.isHidden = false
            self.addButtonView.transform = CGAffineTransform(translationX: 0, y: -(self.view.frame.height * 0.20))
        })
    }
    
    // Shows the AddNewFolderView
    func showNewFolderTitle() {
        self.newFolderView.isHidden = false
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.newFolderView.transform = CGAffineTransform(translationX: 0, y: -(self.uploadView.frame.height + self.newFolderView.frame.height))
        })
    }
    
    // Action for when the 'Add' button in AddNewFolderView is tapped
    @IBAction func addFolderButton(_ sender: Any) {
        addNewFolder()
    }
    
    // Action upon pressing log out button
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            self.userdefault.set(false, forKey: "usersignin")
            self.userdefault.synchronize()
            performSegue(withIdentifier: "logoutFromHome", sender: self)
        } catch {
            print("Found errors: Failed to sign out")
        }
    }
    
    @IBAction func deleteFolderTapped(_ sender: Any) {
        if let userID = Auth.auth().currentUser?.uid {
            let currentStorageDirectory = "\(userID)/\(currentDirectory)"
            
            print(currentPath)
            
            let firebaseDataRef = Database.database().reference().child(currentPath)
            let firebaseDataRefContaining = Database.database().reference().child(containingPath)
            let firebaseStorageRef = Storage.storage().reference().child(currentStorageDirectory)
            
            firebaseDataRef.removeValue()
            firebaseDataRefContaining.removeValue()
            firebaseStorageRef.delete { (error) in
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentDirectory == "root") {
            return uploadedData.count
        } else {
            return uploadedData.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (currentDirectory != "root" && indexPath.row == uploadedData.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteFolderCell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell") as! FileCell
            
            var title = uploadedData[indexPath.row].title
            if (title.lastIndex(of: ".") != nil) {
                title.removeSubrange(title.lastIndex(of: ".")!..<title.endIndex)
            }
            cell.title.text = title
            
            switch(uploadedData[indexPath.row].type) {
            case "application/pdf":
                cell.icon.image = #imageLiteral(resourceName: "pdf")
            case "text/plain":
                cell.icon.image = #imageLiteral(resourceName: "txt")
            case "audio/mpeg":
                cell.icon.image = #imageLiteral(resourceName: "mp3")
            case "Folder":
                cell.icon.image = #imageLiteral(resourceName: "folder")
            case "image/png", "image/jpeg", "image/gif":
                cell.icon.image = #imageLiteral(resourceName: "image")
            default:
                cell.icon.image = #imageLiteral(resourceName: "file")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (uploadedData[indexPath.row].isFolder == true) {
            let nextFileController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            nextFileController.containingPath = uploadedData[indexPath.row].databaseRef
            nextFileController.currentPath = uploadedData[indexPath.row].folderPath
            nextFileController.folderName = uploadedData[indexPath.row].title
            nextFileController.currentDirectory = "\(currentDirectory)/\(uploadedData[indexPath.row].title)"
            navigationController?.pushViewController(nextFileController, animated: true)
        } else {
            let fileDescriptionVC = storyboard?.instantiateViewController(withIdentifier: "DescriptionViewController") as! DescriptionViewController
            fileDescriptionVC.downloadURL = uploadedData[indexPath.row].downloadURL
            fileDescriptionVC.databaseRef = uploadedData[indexPath.row].databaseRef
            fileDescriptionVC.storageRef = uploadedData[indexPath.row].storageRef
            fileDescriptionVC.descriptionArr = [("Title ", uploadedData[indexPath.row].title), ("Type ", uploadedData[indexPath.row].type), ("Size ", "\(uploadedData[indexPath.row].size)"), ("Directory ", "\(currentDirectory)/")]
            navigationController?.pushViewController(fileDescriptionVC, animated: true)
        }
    }
    
    // Action upon pressing upload button
    func showDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc", kUTTypePDF as String, kUTTypePlainText as String, kUTTypeJPEG as String, kUTTypePNG as String, kUTTypeGIF as String, kUTTypeMP3 as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
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
                        newFile.folderPath = file["folderPath"] as! String
                        newFile.downloadURL = file["downloadURL"] as! String
                        self.uploadedData.append(newFile)
                    }
                }
            } else if (self.currentDirectory == "root") {
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
                storageRef.downloadURL(completion: {
                    (URL, Error) in
                    if (Error != nil) {
                        print(Error!.localizedDescription)
                    } else if (URL != nil){
                        let downloadURL = URL?.absoluteString
                        
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
                                "databaseRef": "\(newPathForThisFileStr)",
                                "folderPath": "",
                                "downloadURL": downloadURL
                            ] as [String : Any?]
                        newPathForThisFile.setValue(databaseUpload)
                    }
                })
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
}
