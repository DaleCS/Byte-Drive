//
//  DescriptionDownloadTableViewCell.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class DescriptionDownloadTableViewCell: UITableViewCell {
    
    var downloadURL: String = String()
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func pressedDownload(_ sender: Any) {
        print("Downloading File")
    }
}
