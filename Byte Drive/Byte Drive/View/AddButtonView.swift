//
//  addButtonView.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 5/6/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class addButtonView: UIView {
    
    override func draw(_ rect: CGRect) {
        setupUIView()
        drawPlus()
    }
    
    // Shape the UIView to a purple circle with border color of darker purple
    func setupUIView() {
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
        layer.borderColor = #colorLiteral(red: 0.3053061664, green: 0.2611849308, blue: 0.6665206552, alpha: 1)
        layer.borderWidth = 2
    }
    
    // Draws the plus symbol on the UIView
    func drawPlus() {
        if let context = UIGraphicsGetCurrentContext() {
            context.saveGState()
            context.setStrokeColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            context.setLineWidth(5)
            context.move(to: CGPoint(x: frame.width/2,y: frame.height/4))
            context.addLine(to: CGPoint(x: frame.width/2, y: frame.height * 3/4))
            context.move(to: CGPoint(x: frame.width/4,y: frame.height/2))
            context.addLine(to: CGPoint(x: frame.width * 3/4, y: frame.height/2))
            context.strokePath()
            context.restoreGState()
        }
    }
}
