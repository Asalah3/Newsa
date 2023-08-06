//
//  MoreDetailsViewController.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import UIKit
import WebKit
class MoreDetailsViewController: UIViewController, WKNavigationDelegate {
    var link: String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        guard let url = URL(string: self.link ?? "")else{
            return
        }
        self.webView.load(URLRequest(url: url))
        
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed To Load")
    }
}

