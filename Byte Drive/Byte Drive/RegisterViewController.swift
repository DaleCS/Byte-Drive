//
//  RegisterViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 4/9/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    // Username text field
    @IBOutlet weak var usernameTextField: UITextField!
    // Password text field
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Register button is pressed
    @IBAction func registerPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
            (user, error) in
                if (error != nil) {
                    print("Errors found: \(error)")
                } else {
                    print("Registration Successful")
                    self.performSegue(withIdentifier: "goToHomeFromRegister", sender: self)
                }
        }
    }
}
