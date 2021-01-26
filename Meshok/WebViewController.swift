//
//  WebViewController.swift
//  Meshok
//
//  Created by Филипп Слабодецкий on 13.09.2020.
//  Copyright © 2020 Filipp Slabodetsky. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: ViewController {
    
    var stringUrl = String()
    
    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:stringUrl)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)

        
    }
    
    

}
