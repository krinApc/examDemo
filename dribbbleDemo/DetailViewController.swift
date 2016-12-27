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
    
    var progressView = UIProgressView()
    var webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        let url = NSURL(string: urlString)! as URL
        let request = NSURLRequest(url: url) as URLRequest
        webView.load(request)
        
        view.addSubview(webView)
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.size.height - 2, width: self.view.frame.size.width, height: 10))
        progressView.progressViewStyle = .bar
        self.navigationController?.navigationBar.addSubview(progressView)
    }
    
    deinit{
        progressView.setProgress(0.0, animated: false)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "loading")
    }
    
    @objc
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = webView.isLoading
            if webView.isLoading {
                progressView.setProgress(0.1, animated: true)
            }else{
                progressView.setProgress(0.0, animated: false)
            }
        }
    }
}
