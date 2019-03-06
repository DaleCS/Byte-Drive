//
//  HomeViewController.swift
//  Byte Drive
//
//  Created by Jonathan Naraja on 3/6/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var uploadedData = ["Document1", "Document2", "Document3"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uploadedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        cell?.textLabel?.text = uploadedData[indexPath.row]
        return cell!
    }
    
}
