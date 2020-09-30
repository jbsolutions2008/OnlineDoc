//
//  HomeVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 18/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    //MARK: UIButon Actions
    @IBAction func btnLogoutPressed() {
        RDGlobalFunction.setBoolValueInUserDefault(iSDefaultValue: false, iSDefaultKey: RDDataEngineClass.iSUerActivated)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    @IBAction func btnBack() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
        present(menu, animated: true, completion: nil)
    }
    
  
    @IBAction func btnGoToSelection(sender:UIButton) {
        RDGlobalFunction.appDelegate.selectedIndex = sender.tag
        if  sender.tag == 1 {
            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeApppointmentVC") as! MakeApppointmentVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if  sender.tag == 2 {
            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 3 {
            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplicationFeesVC") as! ApplicationFeesVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if sender.tag == 4 {
          //  AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "", message: "Under development", options: "OK") { (_) in
                
            //}
              let  vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if sender.tag == 5 {
            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
