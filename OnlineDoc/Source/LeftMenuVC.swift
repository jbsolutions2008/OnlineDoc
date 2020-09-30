//
//  LeftMenuVC.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

class LeftMenuVC: UIViewController {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    
    @IBOutlet weak var tableView : UITableView!

    
    var arr = ["Home", "Make Appointment", "My Appointments", "Appointment Fees", "Contact Us", "Privacy Policy", "Logout"]
    


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        lblName.text = RDGlobalFunction.authUser.Name
        lblEmail.text = RDGlobalFunction.authUser.Email

        // Do any additional setup after loading the view.
    }

}

extension LeftMenuVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppointmentTableCell
        if indexPath.row == RDGlobalFunction.appDelegate.selectedIndex {
            cell.lblDocName.textColor = RDDataEngineClass.primaryColorGreen
        } else {
            cell.lblDocName.textColor = .black
        }
        cell.lblDocName.text = arr[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RDGlobalFunction.appDelegate.selectedIndex = indexPath.row
        tableView.reloadData()
       
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeApppointmentVC") as! MakeApppointmentVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ApplicationFeesVC") as! ApplicationFeesVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let presentingVC = self.presentingViewController
            
            self.dismiss(animated: true, completion: nil)
            AlertUtility.sharedInstance.presentAlertWithTitle(onVC: presentingVC!, title: "Logout", message: "Do you want to Logout?", options: "NO","LOGOUT") { (option) in
                if option == 0 {
                    self.dismiss(animated: true, completion: nil)
                } else if option == 1 {
                    RDGlobalFunction.appDelegate.selectedIndex = 0
                    RDGlobalFunction.setBoolValueInUserDefault(iSDefaultValue: false, iSDefaultKey: RDDataEngineClass.iSUerActivated)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                    (presentingVC as! UINavigationController).pushViewController(vc, animated: true)
                }
            }
        }
    }
}
