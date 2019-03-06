//
//  ViewController.swift
//  Byte Drive
//
//  Created by Byte-Me Team on 3/5/19.
//  Copyright © 2019 Byte-Me. All rights reserved.
//
//  Note: Some of the code in this file are taken from
//  https://developer.apple.com/documentation/usernotifications/
//  And
//  https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/SchedulingandHandlingLocalNotifications.html#//apple_ref/doc/uid/TP40008194-CH5-SW5

import UIKit
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var usernameInput: String = String()
    var passwordInput: String = String()
    
    
    @IBAction func pressLogin(_ sender: UIButton) {
        // Demonstrate UIKit is used and is working.
        usernameInput = usernameField.text!
        passwordInput = passwordField.text!
        print(usernameInput)
        print(passwordInput)
    }
    
    @IBAction func pressNotifications(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            if (granted) {
                print("User has granted notifications.")
                
                let notificationContent = UNMutableNotificationContent()
                notificationContent.title = "Test Notification"
                notificationContent.body = "This is a test notification from Byte Drive!"
                notificationContent.sound = UNNotificationSound.default
                
                // Use local trigger that is triggered 2 seconds after user grants notifications
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                let notificationRequest = UNNotificationRequest(identifier: "identifier", content: notificationContent, trigger: notificationTrigger)
                center.add(notificationRequest)
                
                print("Local notification added")
            } else {
                print("User has denied notifications.")
            }
        }
    }
}
