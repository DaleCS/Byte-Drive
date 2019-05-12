//
//  RegisterViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 4/9/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // Username text field
    @IBOutlet weak var usernameTextField: UITextField!
    // Password text field
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // Remove validation prompt when textfields are pressed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            textField.backgroundColor = #colorLiteral(red: 0.3053061664, green: 0.2611849308, blue: 0.6665206552, alpha: 1)
            self.view.layoutIfNeeded()
        }
    }
    
    // Register button is pressed
    @IBAction func registerPressed(_ sender: Any) {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        if (usernameTextField.text?.isEmpty ?? true && passwordTextField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.usernameTextField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.passwordTextField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.usernameTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.passwordTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else if (usernameTextField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.usernameTextField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.usernameTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else if (passwordTextField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.passwordTextField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.passwordTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else {
            Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
                (user, error) in
                if (error != nil) {
                    let errCode = AuthErrorCode(rawValue: error!._code)
                    switch (errCode!) {
                    case .invalidEmail:
                        UIView.animate(withDuration: 0.5) {
                            self.usernameTextField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.usernameTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    case .emailAlreadyInUse:
                        UIView.animate(withDuration: 0.5) {
                            self.usernameTextField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.usernameTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    case .weakPassword:
                        UIView.animate(withDuration: 0.5) {
                            self.passwordTextField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.passwordTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    default:
                        UIView.animate(withDuration: 0.5) {
                            self.usernameTextField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.usernameTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.passwordTextField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.passwordTextField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    }
                } else {
                    print("Registration Successful")
                    self.performSegue(withIdentifier: "goToHomeFromRegister", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToHomeFromRegister") {
            let fileBrowsingNavController = segue.destination as! UINavigationController
            let firstHomeViewController = fileBrowsingNavController.viewControllers.first as! HomeViewController
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            firstHomeViewController.currentPath = "FilePath/\(userID)/root"
            firstHomeViewController.folderName = "root"
            firstHomeViewController.currentDirectory = "root"
        }
    }
}
