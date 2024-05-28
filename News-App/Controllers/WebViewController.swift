//
//  WebViewController.swift
//  News-App
//
//  Created by DB-MBP-023 on 27/05/24.
//

import UIKit
import WebKit
import SVProgressHUD

class WebViewController: UIViewController {
    var link = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        SVProgressHUD.show()
        let url = URL(string: link)
        let request = URLRequest(url: url!)
        
        webView.load(request)
        self.view = webView
    }
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

}

//MARK: - WKWebViewNavigationDelegate
extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SVProgressHUD.dismiss()
        print(error.localizedDescription)
    }
}
