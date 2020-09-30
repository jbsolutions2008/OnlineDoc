//
//  SplashVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 17/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if RDGlobalFunction.getBoolValueFromUserDefault(iSDefaultKey: RDDataEngineClass.iSUerActivated) {
            RDGlobalFunction.authUser = AuthUser.init(dict:RDGlobalFunction.getObjectFromUserDefault(iSDefaultKey: RDDataEngineClass.userProfileInfoDef) as! [String : AnyObject])
            if RDGlobalFunction.authUser.UserType == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorHomeVC") as! DoctorHomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
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

}
