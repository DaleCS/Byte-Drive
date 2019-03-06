//
//  ViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 3/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var usernameInput: String = String()
    var passwordInput: String = String()
    
    
    @IBAction func pressLogin(_ sender: UIButton) {
        // Demonstrate UIKit is used
        usernameInput = usernameField.text!
        passwordInput = passwordField.text!
        print(usernameInput)
        print(passwordInput)
    }
}

