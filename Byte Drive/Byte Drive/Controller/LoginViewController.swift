//
//  ViewController.swift
//  Byte Drive
//
//  Created by Dale Christian Seen on 3/5/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//
//  Note: Some of the code in this file are taken from
//  https://developer.apple.com/documentation/usernotifications/
//  And
//  https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SchedulingandHandlingLocalNotifications.html#//apple_ref/doc/uid/TP40008194-CH5-SW5
//  And
//  

import UIKit
import Firebase
import UserNotifications
import UserNotificationsUI
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userdefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self

        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = Auth.auth().currentUser {
            print(userdefault.bool(forKey: "usersignin") == true)
            performSegue(withIdentifier: "toHomeFromLogin", sender: self)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            textField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            textField.backgroundColor = #colorLiteral(red: 0.3053061664, green: 0.2611849308, blue: 0.6665206552, alpha: 1)
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pressLogin(_ sender: UIButton) {
        usernameField.endEditing(true)
        passwordField.endEditing(true)
        if (usernameField.text?.isEmpty ?? true && usernameField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.usernameField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.passwordField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.usernameField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.passwordField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else if (usernameField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.usernameField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.usernameField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else if (passwordField.text?.isEmpty ?? true) {
            UIView.animate(withDuration: 0.5) {
                self.passwordField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                self.passwordField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                self.view.layoutIfNeeded()
            }
        } else {
            Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) {
                (user, error) in
                if (error != nil) {
                    let errCode = AuthErrorCode(rawValue: error!._code)!
                    switch (errCode) {
                    case .wrongPassword:
                        UIView.animate(withDuration: 0.5) {
                            self.passwordField.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                            self.passwordField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    case .invalidEmail:
                        UIView.animate(withDuration: 0.5) {
                            self.usernameField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                            self.usernameField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    case .userNotFound:
                        UIView.animate(withDuration: 0.5) {
                            self.usernameField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                            self.passwordField.backgroundColor = #colorLiteral(red: 0.8790461421, green: 0.277841419, blue: 0.248211205, alpha: 1)
                            self.usernameField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.passwordField.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
                            self.view.layoutIfNeeded()
                        }
                    default:
                        print("Unhandled error: \(error!)")
                    }
                } else {
                    self.performSegue(withIdentifier: "toHomeFromLogin", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toHomeFromLogin") {
            let fileBrowsingNavController = segue.destination as! UINavigationController
            let firstHomeViewController = fileBrowsingNavController.viewControllers.first as! HomeViewController
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            firstHomeViewController.currentPath = "FilePath/\(userID)/root"
            firstHomeViewController.folderName = "root"
            firstHomeViewController.currentDirectory = "root"
        }
    }
    
}
