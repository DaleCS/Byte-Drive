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
        
        let url:URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/byte-drive.appspot.com/o/pExfBu02NFenXa1ISZXCWaBISvC3%2Froot%2FChapter%201.pdf?alt=media&token=443d443d-f5b2-43f0-a03f-7e1c565afe69")!
        let urlRequest:URLRequest = URLRequest(url: url)
        
        webView.load(urlRequest)
    }

}
