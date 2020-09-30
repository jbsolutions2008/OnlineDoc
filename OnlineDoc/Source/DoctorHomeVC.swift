//
//  DoctorHomeVC.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

class DoctorHomeVC: UIViewController {
    
    @IBOutlet weak var lblName : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = "Welcome \(RDGlobalFunction.authUser.Name)"

        // Do any additional setup after loading the view.
    }
    
    //MARK:UIButton Actions
    @IBAction func btnAppoitmentPressed() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnLogoutPressed() {
        RDGlobalFunction.setBoolValueInUserDefault(iSDefaultValue: false, iSDefaultKey: RDDataEngineClass.iSUerActivated)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSetLeavePressed() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SetLeaveVC") as! SetLeaveVC
        self.navigationController?.pushViewController(vc, animated: true)
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
