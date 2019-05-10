//
//  UploadView.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/6/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class UploadView: UIView {
    
    override func draw(_ rect: CGRect) {
        setUpUploadView()
    }

    func setUpUploadView() {
        backgroundColor = #colorLiteral(red: 0.4235294118, green: 0.3607843137, blue: 0.9058823529, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0.3053061664, green: 0.2611849308, blue: 0.6665206552, alpha: 1)
        // Set the view to have the same width and height as its superview, if superview exists
        if let superView = self.superview {
            self.frame = CGRect(x: 0, y: superView.frame.height, width: superView.frame.width, height: 200)
        }
    }
}
