//
//  ReaderViewController.swift
//  Byte Drive
//
//  Created by Jonathan Naraja on 5/7/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//

import UIKit
import WebKit

class ReaderViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url:URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/byte-drive.appspot.com/o/N0xSSkESfYOFBiNYiQETnBfnIKz1%2Froot%2Ftext.txt?alt=media&token=c4710494-71f8-426b-b6b9-ef4e160dc7e0")!
        let urlRequest:URLRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
    }

}
