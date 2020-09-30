//
//  PrivacyPolicyVC.swift
//  OnlineDoc
//
//
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController {

    @IBOutlet weak var webView:WKWebView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UtilityClass.isInternetConnectedWith() {
            UtilityClass.showActivityIndicator()
            
            webView.navigationDelegate = self
            let link = URL(string:"https://www.doctoronline365.com.au/privacy-policy")!
            let request = URLRequest(url: link)
            webView.load(request)
        } else {
            AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "failure", message: "Please check internet connection in your device", options: "OK") { (_) in
            }
        }

    }
    
    @IBAction func btnBAck() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
        present(menu, animated: true, completion: nil)

    }
}

extension PrivacyPolicyVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.removeActivityIndicator()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UtilityClass.removeActivityIndicator()
    }
}
