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
    
    var descriptionArr: [(String, String)] = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        
        navigationItem.title = descriptionArr[0].1
        
        descriptionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return descriptionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionableViewCell
        
        cell.category.text = "\(descriptionArr[indexPath.row].0)"
        cell.value.text = "\(descriptionArr[indexPath.row].1)"
        
        return cell
    }
}
