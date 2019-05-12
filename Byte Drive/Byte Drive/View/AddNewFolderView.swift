//
//  AddNewFolderView.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/10/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class AddNewFolderView: UIView {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addFolderButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        setupView()
    }
    
    func setupView() {
        if let superView = self.superview {
            self.frame = CGRect(x: 0, y: superView.frame.height, width: superView.frame.width, height: 100)
        }
        self.isHidden = true
    }
}
