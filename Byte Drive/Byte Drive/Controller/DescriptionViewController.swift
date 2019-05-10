//
//  DescriptionViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var descriptionTableView: UITableView!
    
    var downloadURL: String = String()
    var descriptionArr: [(String, String)] = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        
        var title = descriptionArr[0].1
        title.removeSubrange(title.lastIndex(of: ".")!..<title.endIndex)
        navigationItem.title = title
        
        descriptionTableView.reloadData()
        
        descriptionTableView.register(UINib(nibName: "DescriptionDownloadTableViewCell",  bundle: nil  ), forCellReuseIdentifier: "DescriptionDownloadCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == descriptionArr.count) {
            let cell = descriptionTableView.dequeueReusableCell(withIdentifier: "DescriptionDownloadCell") as! DescriptionDownloadTableViewCell
            cell.downloadURL = downloadURL
            return cell
        } else {
            let cell = descriptionTableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionTableViewCell
            
            cell.category.text = "\(descriptionArr[indexPath.row].0)"
            cell.value.text = "\(descriptionArr[indexPath.row].1)"
            return cell
        }
    }
}
