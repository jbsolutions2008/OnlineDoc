//
//  VideoSessionVC.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import WebKit

class VideoSessionVC: UIViewController {
    
  //  var coviu: CoviuSDKiOS?
    var url = ""
 //   @IBOutlet weak var containerView:UIView!
    
    
    @IBOutlet weak var webView:WKWebView!
      
        override func viewDidLoad() {
            super.viewDidLoad()
            
            UtilityClass.showActivityIndicator()
            
            webView.navigationDelegate = self
            let link = URL(string:url)!
            let request = URLRequest(url: link)
            webView.load(request)

        }
        
        @IBAction func btnBAck() {
            self.navigationController?.popViewController(animated: true)

        }
    }


    extension VideoSessionVC : WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            UtilityClass.removeActivityIndicator()
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            UtilityClass.removeActivityIndicator()
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


