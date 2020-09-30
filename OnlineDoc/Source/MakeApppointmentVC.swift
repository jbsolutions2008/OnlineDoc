//
//  MakeApppointmentVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 19/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialTextFields
 

struct TimeSlot {
    var slot : String = ""
    var isSelected : Bool = false
    
}

class MakeApppointmentVC: UIViewController {

    
    @IBOutlet weak var txtConsultation: MDCTextField!
    var consultController: MDCTextInputControllerOutlined!
    @IBOutlet weak var bottomToConsultation: NSLayoutConstraint!
    
    @IBOutlet weak var txtType: MDCTextField!
    var typeController: MDCTextInputControllerOutlined!
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var btnClick: UIButton!
    
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var txtDate: MDCTextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collHeight: NSLayoutConstraint!
    @IBOutlet weak var vwSlots: UIView!
    @IBOutlet weak var bottomToSlots: NSLayoutConstraint!
    var dateController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var txtDoc: MDCTextField!
    @IBOutlet weak var vwDoc: UIView!
    @IBOutlet weak var bottomToDoc : NSLayoutConstraint!
    var doctorController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var btnAppointment: UIButton!
    @IBOutlet weak var bottomToAppointment: NSLayoutConstraint!
    
    @IBOutlet weak var vwBookingDetail: UIView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblConsultation: UILabel!
    @IBOutlet weak var lblBookingPrice: UILabel!
    @IBOutlet weak var lblBookingTime: UILabel!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var lblBookingDoc: UILabel!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    var arrConsultation : [Consultation] = []
    var arrDoctors : [Doctor] = []
    var currentConsultation : Consultation!
    var selectedDate : Date!
    var selectedDoctor : Doctor!
    
    var openingTime = "08:00 AM"
    var closingTime = "10:00 PM"
    var arrTimeSlot : [TimeSlot] = []
    var selectedIndex = 0
    var startDate : Date!
    var endDate : Date!
    
    var currentSelection = selectionType.consultation.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getConsultationType()
        consultController = MDCTextInputControllerOutlined(textInput: txtConsultation)
        RDGlobalFunction.setGrayColorsToInput(input:consultController)
        txtConsultation.clearButtonMode = .never
        
        typeController = MDCTextInputControllerOutlined(textInput: txtType)
        RDGlobalFunction.setGrayColorsToInput(input:typeController)
        txtType.clearButtonMode = .never
        
        doctorController = MDCTextInputControllerOutlined(textInput: txtDoc)
        RDGlobalFunction.setGrayColorsToInput(input:doctorController)
        txtDoc.clearButtonMode = .never
        
        dateController = MDCTextInputControllerOutlined(textInput: txtDate)
        RDGlobalFunction.setGrayColorsToInput(input:dateController)
        txtDate.clearButtonMode = .never
        
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: vwBookingDetail, cornerRad: 0.0, borderWidth: 4.0, borderColor: .white)
    }
    
    //MARK:Webservice
    func getConsultationType() {
       
        UtilityClass.showActivityIndicator()
        let params : Parameters = ["Userid":RDGlobalFunction.authUser.UserId]

        WebServiceManager.sharedInstance.getConsultation(selectedVC: self, parameters: params, getPlanAPI: PLANSAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {

                let response = responseObject as! [String:AnyObject]

                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    let arr = response["Data"] as! NSArray
                    for item in arr {
                        self.arrConsultation.append(Consultation.init(dict: item as! [String: AnyObject]))
                    }
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "No data available", options: "OK") { (_) in }
            }
        }
    }
    
    func getDoctorList() {
       
        //selected date and 
        UtilityClass.showActivityIndicator()
        
        let dfm = DateFormatter()
        dfm.dateFormat = "yyyy-MM-dd"
        dfm.timeZone = .current
        
        let selectedStartDate = "\(dfm.string(from: selectedDate)) \(arrTimeSlot[selectedIndex].slot)"
        var selectedEndDate = ""
        if selectedIndex == arrTimeSlot.count-1 {
           selectedEndDate = "\(dfm.string(from: selectedDate)) \(closingTime)"
        } else {
           selectedEndDate  = "\(dfm.string(from: selectedDate)) \(arrTimeSlot[selectedIndex+1].slot)"
        }
        
        
        let dfm1 = DateFormatter()
        dfm1.dateFormat = "yyyy-MM-dd hh:mm a"
        startDate = dfm1.date(from: selectedStartDate)
        endDate = dfm1.date(from: selectedEndDate)
        dfm1.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dfm1.timeZone = TimeZone.init(abbreviation: "GMT")
        
        
        let params : Parameters = ["userid":RDGlobalFunction.authUser.UserId,"start_time":dfm1.string(from: startDate!),"end_time":dfm1.string(from: endDate!)]

        WebServiceManager.sharedInstance.getDoctors(selectedVC: self, parameters: params, getDoctorsAPI: DOCTORSAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {

                let response = responseObject as! [String:AnyObject]

                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    
                    let arr = response["Data"] as! NSArray
                    self.arrDoctors.removeAll()
                    for item in arr {
                        self.arrDoctors.append(Doctor.init(dict: item as! [String: AnyObject]))
                    }
                    self.vwDoc.isHidden = false
                    self.btnAppointment.isHidden = true
                    self.setBottomOfScroll()
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "Couldn't fetch data", options: "OK") { (_) in }
            }
        }
    }
    
    
    func createSession() {
       
        UtilityClass.showActivityIndicator()
        
        let dfm1 = DateFormatter()
        dfm1.dateFormat = "EEE, d MMM yyyy HH:mm:ss Z"
        dfm1.timeZone = TimeZone.init(abbreviation: "GMT")
        
        let params : Parameters = ["session_name":currentConsultation.name,"start_time":dfm1.string(from: startDate),"end_time":dfm1.string(from: endDate),"picture":"https:/images.dog.ceo/breeds/springer-english/n02102040_4644.jpg","payment_status":2,"plan_name":"\(currentConsultation.name) - \(txtType.text!)","plan_id":"\(currentConsultation.ID)","participants":[["display_name":selectedDoctor.name,"role":"host","picture":"http:/fillmurray.com/200/300","state":"\(selectedDoctor.id)"],["display_name":RDGlobalFunction.authUser.Name,"role":"guest","picture":"http:/fillmurray.com/200/300","state":"\(RDGlobalFunction.authUser.UserId)"]]]

        WebServiceManager.sharedInstance.createSession(selectedVC: self, createSessionParameters: params, createSessionAPI: CREATESESSIONAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {

                let response = responseObject as! [String:AnyObject]

                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Doctor Online 365", message: "Great! Your appointment is booked. Please call 1300 290 600 if you have any questions", options: "OK") { (_) in
                        if Double(self.currentConsultation.price) == 0.0 {
                            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
                            
                            self.navigationController?.pushViewController(vc, animated:true)
                        } else {
                            let  vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
                            let dict = (response["Data"] as! NSArray)[0] as! [String:AnyObject]
                            vc.appointment_id = dict["appointment_id"] as! Int
                            vc.amount = self.currentConsultation.price
                            self.navigationController?.pushViewController(vc, animated:true)
                        }
                    }
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "couldn't create session", options: "OK") { (_) in }
            }
        }
    }
   
    
    //MARK:Other Methods
    func setBottomOfScroll() {
        if !btnAppointment.isHidden && !vwDoc.isHidden && !vwSlots.isHidden {
            bottomToAppointment.priority = .defaultHigh
            bottomToSlots.priority = .defaultLow
            bottomToConsultation.priority = .defaultLow
            bottomToDoc.priority = .defaultLow
            
            scrlView.layoutIfNeeded()
            if scrlView.contentSize.height - scrlView.bounds.size.height > 0 {
                let bottomOffset = CGPoint(x: 0, y: scrlView.contentSize.height - scrlView.bounds.size.height)
                scrlView.setContentOffset(bottomOffset, animated: true)
            }
        } else if !vwDoc.isHidden && !vwSlots.isHidden {
            bottomToAppointment.priority = .defaultLow
            bottomToSlots.priority = .defaultLow
            bottomToConsultation.priority = .defaultLow
            bottomToDoc.priority = .defaultHigh
            
            scrlView.layoutIfNeeded()
            if scrlView.contentSize.height - scrlView.bounds.size.height > 0 {
                let bottomOffset = CGPoint(x: 0, y: scrlView.contentSize.height - scrlView.bounds.size.height)
                scrlView.setContentOffset(bottomOffset, animated: true)
            }
        } else if  !vwSlots.isHidden {
            bottomToAppointment.priority = .defaultLow
            bottomToSlots.priority = .defaultHigh
            bottomToConsultation.priority = .defaultLow
            bottomToDoc.priority = .defaultLow
        } else {
            bottomToAppointment.priority = .defaultLow
            bottomToSlots.priority = .defaultLow
            bottomToConsultation.priority = .defaultHigh
            bottomToDoc.priority = .defaultLow
        }
        
    }
    
    func getSlots() {
        arrTimeSlot.removeAll()
        
        let formatter = DateFormatter()
        //        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "hh:mm a"
        
        let dfm = DateFormatter()
        dfm.dateFormat = "dd/MM/yyyy"
        let today = dfm.date(from: dfm.string(from: Date()))
        let  isLaterDate = dfm.date(from: dfm.string(from: selectedDate))! > today!
        
        let date1 = formatter.date(from: openingTime)
        if !isLaterDate {
            if date1! > formatter.date(from: formatter.string(from: Date()))! {
                arrTimeSlot.append(TimeSlot.init(slot: openingTime, isSelected: false))
            }
        } else {
            arrTimeSlot.append(TimeSlot.init(slot: openingTime, isSelected: false))
        }
        
        let date2 = formatter.date(from: closingTime)
        var i = 1
        
        while true {
            let date = date1?.addingTimeInterval(TimeInterval(i*Int(currentConsultation.duration)!/1000))
            let string = formatter.string(from: date!)
            if date! >= date2! {break}
            i = i + 1
            if !isLaterDate {
                if date! > formatter.date(from: formatter.string(from: Date()))! {
                    arrTimeSlot.append(TimeSlot.init(slot: string, isSelected: false))
                }
            } else {
                arrTimeSlot.append(TimeSlot.init(slot: string, isSelected: false))
            }
        }
        print(arrTimeSlot)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnConsultationClicked() {
        currentSelection = selectionType.consultation.rawValue
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.consultation, datasource: self.arrConsultation)
    }
    
    @IBAction func btnConsultationTypeClicked() {
        currentSelection = selectionType.type.rawValue
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.type, datasource: [])
    }
    
    @IBAction func btnDocClicked() {
        currentSelection = selectionType.doctor.rawValue
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.doctor, datasource: self.arrDoctors)
    }
    @IBAction func btnBack() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
        
        present(menu, animated: true, completion: nil)
    }
    
    @IBAction func btnDateClicked() {
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.date, datasource: [])
        currentSelection = selectionType.date.rawValue
    }
    
    @IBAction func btnAppointmentClicked() {
        vwBookingDetail.isHidden = false
        vwContainer.isHidden = false
        
        lblBookingDoc.text = selectedDoctor.name
        lblConsultation.text = currentConsultation.name
        
        if Double(self.currentConsultation.price) == 0.0 {
            lblBookingPrice.text = "$\(currentConsultation.price) \(currentConsultation.note)"
        } else {
            lblBookingPrice.text = "$\(currentConsultation.price)"
        }
        
       
        let dfm1 = DateFormatter()
        dfm1.dateFormat = "hh:mm a EEEE, dd MMMM"
        dfm1.timeZone = .current
       
        lblBookingTime.text = dfm1.string(from:startDate )
    }
    
    @IBAction func btnConfirmClicked() {
        vwBookingDetail.isHidden = true
        vwContainer.isHidden = true
        createSession()
    }
    
    @IBAction func btnChangeClicked() {
        vwBookingDetail.isHidden = true
        vwContainer.isHidden = true
    }
  }

extension MakeApppointmentVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTimeSlot.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SlotCollectionCell
        cell.lblSlot.text = arrTimeSlot[indexPath.row].slot
        if !arrTimeSlot[indexPath.row].isSelected {
            cell.contentView.backgroundColor = .lightGray
        } else {
            cell.contentView.backgroundColor = RDDataEngineClass.primaryColorGreen
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //call API to get doc list
        arrTimeSlot = arrTimeSlot.map { slot1 in
           var slot = slot1
            slot.isSelected = false
           return slot
        }
        txtDoc.text = ""
        selectedDoctor = nil
        selectedIndex = indexPath.row
        var slot = arrTimeSlot[indexPath.row]
        slot.isSelected = true
        arrTimeSlot[indexPath.row] = slot
        collView.reloadData()
        
        getDoctorList()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (collectionView.frame.size.width-15)/4, height: 35)
    }
}

extension MakeApppointmentVC : selectionDelegate {
    func cancelled() {
        
    }
    
    func doneSelection(with Value: Any) {
        if currentSelection == selectionType.consultation.rawValue {
            currentConsultation = Value as? Consultation
            txtConsultation.text = currentConsultation.name
            
            txtType.text = ""
            txtType.isHidden = false
            btnClick.isHidden = false
            btnDrop.isHidden = false
            
            vwSlots.isHidden = true
            vwDoc.isHidden = true
            btnAppointment.isHidden = true
            setBottomOfScroll()
        } else if currentSelection == selectionType.type.rawValue {
            txtType.text = Value as? String
            RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.date, datasource: [])
            currentSelection = selectionType.date.rawValue
        }
        else if currentSelection == selectionType.date.rawValue {
            selectedDate = Value as? Date
            let dfm = DateFormatter()
            dfm.locale = .current
            dfm.dateFormat = "dd-MMM-yyyy"
            txtDate.text = dfm.string(from: selectedDate)
            
            if Double(self.currentConsultation.price) == 0.0 {
                lblPrice.text = "$\(currentConsultation.price) \(currentConsultation.note)"
            } else {
                lblPrice.text = "$\(currentConsultation.price)"
            }
            
            dfm.dateFormat = "EEEE, dd MMMM"
            lblDate.text = "Available appointments for \(dfm.string(from: selectedDate))"
         
            vwSlots.isHidden = false
            vwDoc.isHidden = true
            btnAppointment.isHidden = true
            getSlots()
            collView.reloadData()
            collView.layoutIfNeeded()
            if arrTimeSlot.count == 0 {
                collHeight.constant = 25.0
                collView.isHidden = true
                lblNoData.isHidden = false
            } else {
                collHeight.constant = collView.contentSize.height
                collView.isHidden = false
                lblNoData.isHidden = true
            }
            
            collView.reloadData()
            setBottomOfScroll()
        } else if  currentSelection == selectionType.doctor.rawValue {
            selectedDoctor = Value as? Doctor
            txtDoc.text = selectedDoctor.name
            btnAppointment.isHidden = false
            setBottomOfScroll()
        }
    }
}
