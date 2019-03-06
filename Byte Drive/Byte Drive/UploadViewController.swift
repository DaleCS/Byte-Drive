//
//  UploadViewController.swift
//  Byte Drive
//
//  Created by Jonathan Naraja on 3/6/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//
//  Some of the code in this file were taken from
//  From Youtube video by user CodeWithChris: https://www.youtube.com/watch?v=jJUm1VBnR_U

import UIKit
import Firebase

class UploadViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var ref:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func donePost(_ sender: Any) {
        
        ref?.child("Uploads").childByAutoId().setValue("Testing Firebase")
        
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trashButton(_ sender: Any) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}