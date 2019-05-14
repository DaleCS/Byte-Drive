//
//  DescriptionViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import Firebase

class DescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var descriptionTableView: UITableView!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var viewBtn: UIButton!
    
    
    var databaseRef: String = String()
    var storageRef: String = String()
    var downloadURL: String = String()
    var descriptionArr: [(String, String)] = [(String, String)]()
    var URL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        
        var title = descriptionArr[0].1
        title.removeSubrange(title.lastIndex(of: ".")!..<title.endIndex)
        navigationItem.title = title
        
        descriptionTableView.reloadData()
        
        descriptionTableView.register(UINib(nibName: "DescriptionDownloadTableViewCell",  bundle: nil  ), forCellReuseIdentifier: "DescriptionDownloadCell")
        
        viewBtn.isEnabled = false
        viewBtn.layer.cornerRadius = 5
        downloadBtn.layer.cornerRadius = 5 
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == descriptionArr.count) {
            let cell = descriptionTableView.dequeueReusableCell(withIdentifier: "DownloadCell")!
            return cell
        } else {
            let cell = descriptionTableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionTableViewCell
            
            cell.category.text = "\(descriptionArr[indexPath.row].0)"
            cell.value.text = "\(descriptionArr[indexPath.row].1)"
            return cell
        }
    }
    
//    @IBAction func downloadTapped(_ sender: Any) {
//        // TODO: Do download here
//        //viewBtn.isEnabled = true
//        //viewBtn.backgroundColor = #colorLiteral(red: 0.3045640588, green: 0.2646819353, blue: 0.664798677, alpha: 1)
//    }
//
//    @IBAction func viewTapped(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let readerVC = storyboard.instantiateViewController(withIdentifier: "ReaderViewController") as! ReaderViewController
//        readerVC.downloadURL = downloadURL
//        if let navController = self.navigationController {
//            navController.pushViewController(readerVC, animated: true)
//        }
//    }
    
    @IBAction func pressedDownload(_ sender: Any) {
        viewBtn.isEnabled = true
        viewBtn.backgroundColor = #colorLiteral(red: 0.3045640588, green: 0.2646819353, blue: 0.664798677, alpha: 1)
    }
    @IBAction func pressedView(_ sender: Any) {
        self.URL = downloadURL
        self.performSegue(withIdentifier: "toReader", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ReaderViewController
        vc.dURL = self.URL
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        let firebaseDataRef = Database.database().reference().child(databaseRef)
        let firebaseStorageRef = Storage.storage().reference().child(storageRef)
        
        firebaseDataRef.removeValue()
        firebaseStorageRef.delete { (error) in
            if (error != nil) {
                print("Error: Errors were encountered in deleting file")
            } else {
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            }
        }
    }
}
