//
//  BookingHistoryVC.swift
//  OnlineDoc
//
//
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class BookingHistoryVC: UIViewController{

    var arrBooking : [Booking] = []
    
    var dfmGMT : DateFormatter!
    var dfmCurrent : DateFormatter!
    var dfmDate : DateFormatter!
    var today : Date! = Date()
    
  
    @IBOutlet weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dfmGMT = DateFormatter()
        dfmGMT.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dfmGMT.timeZone = TimeZone.init(abbreviation: "GMT")
        
        dfmCurrent = DateFormatter()
        dfmCurrent.dateFormat = "yyyy-MM-dd HH:mm"
        dfmCurrent.timeZone = .current
        
        dfmDate = DateFormatter()
        dfmDate.dateFormat = "yyyy-MM-dd"
        dfmDate.timeZone = .current
        
        today = dfmDate.date(from: dfmDate.string(from: today))
        
        getBookingHistory()
    }
    
    //MARK:UIButton Actions
    @IBAction func btnJoinSession(sender:UIButton) {
      //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoSessionVC") as! VideoSessionVC
       // vc.url = arrBooking[sender.tag].entry_url
       // self.navigationController?.pushViewController(vc, animated: true)
        
        let vc = SFSafariViewController(url: NSURL.init(string: arrBooking[sender.tag].entry_url)! as URL)
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    @IBAction func btnBackSession() {
            let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
            present(menu, animated: true, completion: nil)
    }
    
    //MARK: WebService
    func getBookingHistory() {
       
        UtilityClass.showActivityIndicator()
        let params : Parameters = ["userId":RDGlobalFunction.authUser.UserId,"page":0, "records":100]

        WebServiceManager.sharedInstance.getBookings(selectedVC: self, parameters: params, historyAPI: BOOKINGHISTORYAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {

                let response = responseObject as! [String:AnyObject]

                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    let arr = response["Data"] as! NSArray
                    var arrAllBooking:[Booking] = []
                    var arrPatientBooking:[Booking] = []
                    var arrDoctorBooking:[Booking] = []
                    
                    for item in arr {
                        arrAllBooking.append(Booking.init(dict: item as! [String: AnyObject]))
                    }
                    arrPatientBooking = arrAllBooking.filter{$0.role == "GUEST"}
                    arrDoctorBooking = arrAllBooking.filter{$0.role == "HOST"}
                   
                    if  RDGlobalFunction.authUser.UserType == 1 {
                        for (index,var item) in arrDoctorBooking.enumerated() {
                            item.otherName = arrPatientBooking[index].name
                            arrDoctorBooking[index] = item
                        }
                        self.arrBooking = arrDoctorBooking
                    } else {
                        for (index,var item) in arrPatientBooking.enumerated() {
                            item.otherName = arrDoctorBooking[index].name
                            arrPatientBooking[index] = item
                        }
                        self.arrBooking = arrPatientBooking
                    }
                    
                    self.tableView.reloadData()
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "Couldn't get data", options: "OK") { (_) in }
            }
        }
    }
}

extension BookingHistoryVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBooking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppointmentTableCell
        cell.lblConsultationName.text = self.arrBooking[indexPath.row].session_name
        if RDGlobalFunction.authUser.UserType == 1 {
            cell.lblDocName.text = "Patient Name: \(self.arrBooking[indexPath.row].otherName)"
        } else {
            cell.lblDocName.text = "Dr.Name: \(self.arrBooking[indexPath.row].otherName)"
        }
        if dfmDate.date(from:dfmDate.string(from: dfmGMT.date(from: self.arrBooking[indexPath.row].start_time)!)) == today {
            cell.lblStart.textColor = .red
        } else {
            cell.lblStart.textColor = .black
        }
        
        cell.lblStart.text = "Start: \(dfmCurrent.string(from: dfmGMT.date(from: self.arrBooking[indexPath.row].start_time)!))"
        cell.lblDuration.text = "Duration: \(dfmGMT.date(from: arrBooking[indexPath.row].start_time)?.getMinuteIntervalDifferenceBetweenTwoDate(startDate: (dfmGMT.date(from: arrBooking[indexPath.row].start_time))!, endDate: (dfmGMT.date(from: arrBooking[indexPath.row].end_time))!) ?? 0) Minutes"
        
        if arrBooking[indexPath.row].payment_status_id == "3" {
            cell.lblNum.text = "Payment: Completed"
        }
        
        cell.btnJoin.tag = indexPath.row
        
        if RDGlobalFunction.authUser.UserType == 1 {
            cell.btnJoin.setTitle("JOIN DOCTOR", for: .normal)
        }
        
        cell.shadowView.addShadowWithRoundCorners(radius: 5.0)
        return cell
    }
}

extension BookingHistoryVC : SFSafariViewControllerDelegate {
    
}
