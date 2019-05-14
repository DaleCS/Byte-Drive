//
//  ReaderViewController.swift
//  Byte Drive
//
//  Created by Jonathan Naraja on 5/7/19.
//  Copyright © 2019 Dale Christian Seen. All rights reserved.
//
//  Note: Some of the code in this file are taken from
//  https://www.youtube.com/watch?v=xQmZSKxOYvs&t=358s

import UIKit
import WebKit

class ReaderViewController: UIViewController {
    
    var dURL = ""

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let url:URL = URL(string: dURL)!
        let urlRequest:URLRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
    }

}
