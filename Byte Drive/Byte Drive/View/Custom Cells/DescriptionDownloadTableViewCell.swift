//
//  DescriptionDownloadTableViewCell.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class DescriptionDownloadTableViewCell: UITableViewCell {
    
    var fileStorageRef: String = String()
    @IBOutlet weak var downloadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        downloadButton.layer.cornerRadius = 5
        downloadButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        downloadButton.layer.backgroundColor = #colorLiteral(red: 0.4235294118, green: 0.3607843137, blue: 0.9058823529, alpha: 1)
        downloadButton.layer.borderColor = #colorLiteral(red: 0.3053061664, green: 0.2611849308, blue: 0.6665206552, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressedDownload(_ sender: Any) {
        // TODO: Do download here:
        // fileStorageRef contains the reference path of the file in firebase storage
    }
}
