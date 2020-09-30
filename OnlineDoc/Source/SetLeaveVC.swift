//
//  SetLeaveVC.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialTextFields

class SetLeaveVC: UIViewController {

    @IBOutlet weak var txtStart: MDCTextField!
    var startController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var lblSelected: UILabel!
    
    @IBOutlet weak var txtEnd: MDCTextField!
    var endController: MDCTextInputControllerOutlined!
    
    var currentSelection = selectionType.consultation.rawValue
    var currentTime = "start"
    var selectedStartDate : Date!
    var selectedEndDate : Date!
    
    var selectedStartTime : Date!
    var selectedEndTime : Date!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startController = MDCTextInputControllerOutlined(textInput: txtStart)
        RDGlobalFunction.setGrayColorsToInput(input:startController)
        txtStart.clearButtonMode = .never
        
        endController = MDCTextInputControllerOutlined(textInput: txtEnd)
        RDGlobalFunction.setGrayColorsToInput(input:endController)
        txtEnd.clearButtonMode = .never
    }
    
    @IBAction func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartClicked() {
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.date, datasource: [])
        currentSelection = selectionType.date.rawValue
        currentTime = "start"
        
    }
    
    @IBAction func btnEndClicked() {
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.date, datasource: [])
        currentSelection = selectionType.date.rawValue
        currentTime = "end"
    }
    
    @IBAction func btnSubmitClicked() {
        if txtStart.text == "" {
            AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title:"" , message: "Please select start date", options: "OK") { (_) in
                
            }
        } else if txtEnd.text == "" {
            AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title:"" , message: "Please select end date", options: "OK") { (_) in
                
            }
        } else {
            submit()
        }
    }
    
    //MARK:Webservice methods
    func submit() {
       
        UtilityClass.showActivityIndicator()
        
       let dfm1 = DateFormatter()
       dfm1.dateFormat = "yyyy-MM-dd HH:mm"
        let startDate = dfm1.date(from: txtStart.text!)
        let endDate = dfm1.date(from:txtEnd.text!)
       dfm1.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
       dfm1.timeZone = TimeZone.init(abbreviation: "GMT")
        
        
        let params : Parameters = ["start_time":dfm1.string(from: startDate!),"end_time":dfm1.string(from: endDate!),"doctor_id":"\(RDGlobalFunction.authUser.UserId)"]

        WebServiceManager.sharedInstance.setUnavailability(selectedVC: self, parameters: params, unavailabilityAPI: UNAVAILABILITY) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {

                let response = responseObject as! [String:AnyObject]

                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Success", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in
                                self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "couldn't set availability", options: "OK") { (_) in }
            }
        }
    }
}

extension SetLeaveVC : selectionDelegate {
    func cancelled() {
        
    }
    
    func doneSelection(with Value: Any) {
         if currentSelection == selectionType.date.rawValue {
          
            if currentTime == "start" {
              selectedStartDate = Value as? Date
            } else {
                selectedEndDate = Value as? Date
            }
            RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.time, datasource: [])
            currentSelection = selectionType.time.rawValue
        } else if  currentSelection == selectionType.time.rawValue {
            let dfm = DateFormatter()
            dfm.locale = .current
            dfm.dateFormat = "yyyy-MM-dd"
            
            let dfm1 = DateFormatter()
            dfm1.locale = .current
            dfm1.dateFormat = "HH:mm"
           
            if currentTime == "start" {
              selectedStartTime = Value as? Date
                
                txtStart.text = "\(dfm.string(from: selectedStartDate)) \(dfm1.string(from: selectedStartTime))"
                
            } else {
                selectedEndTime = Value as? Date
                
                txtEnd.text = "\(dfm.string(from: selectedEndDate)) \(dfm1.string(from: selectedEndTime))"
            }
            
            if selectedStartTime != nil && selectedEndTime != nil {
                lblSelected.isHidden = false
                lblSelected.text = "You have selected Start Time: \(dfm.string(from: selectedStartDate)) \(dfm1.string(from: selectedStartTime)) & End Time: \(dfm.string(from: selectedEndDate)) \(dfm1.string(from: selectedEndTime))"
            }
        }
    }
}
