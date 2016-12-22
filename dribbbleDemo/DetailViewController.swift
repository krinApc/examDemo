//
//  DetailViewController.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var urlString:String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: urlString)! as URL
        let request = NSURLRequest(url: url) as URLRequest
        webView.loadRequest(request)
    }
    
}
