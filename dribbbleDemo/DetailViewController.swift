//
//  DetailViewController.swift
//  dribbbleDemo
//
//  Created by rin on 2016/12/21.
//  Copyright © 2016年 rin. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController,WKNavigationDelegate{
    
    var urlString:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let url = NSURL(string: urlString)! as URL
        let request = NSURLRequest(url: url) as URLRequest
        webView.load(request)
        
        view.addSubview(webView)
    }
    
}
