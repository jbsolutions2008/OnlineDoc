//
//  RegisterStep1VC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 18/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialTextFields

class RegisterStep1VC: UIViewController {

    @IBOutlet weak var txtMedicareNo: MDCTextField!
    @IBOutlet weak var txtIRN: MDCTextField!
    @IBOutlet weak var txtMedicareExpiry: MDCTextField!
    
    @IBOutlet weak var txtPensionerNo: MDCTextField!
    @IBOutlet weak var txtPensionerExpiry: MDCTextField!
  
    @IBOutlet weak var txtHealthCareNo: MDCTextField!
    @IBOutlet weak var txtHealthCareExpiry: MDCTextField!
    
    
    var medicareController: MDCTextInputControllerOutlined!
    var medicareExpController: MDCTextInputControllerOutlined!
    var IRNController: MDCTextInputControllerOutlined!
   
    var pensionerController: MDCTextInputControllerOutlined!
    var pensionerExpController: MDCTextInputControllerOutlined!
   
    var healthCareController: MDCTextInputControllerOutlined!
    var healthcareExpController: MDCTextInputControllerOutlined!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        medicareController = MDCTextInputControllerOutlined(textInput: txtMedicareNo)
        RDGlobalFunction.setColorsToInput(input: medicareController)
        
        IRNController = MDCTextInputControllerOutlined(textInput: txtIRN)
        RDGlobalFunction.setColorsToInput(input: IRNController)
        
        pensionerController = MDCTextInputControllerOutlined(textInput: txtPensionerNo)
        RDGlobalFunction.setColorsToInput(input: pensionerController)
        
        pensionerExpController = MDCTextInputControllerOutlined(textInput: txtPensionerExpiry)
        RDGlobalFunction.setColorsToInput(input: pensionerExpController)
        
        healthCareController = MDCTextInputControllerOutlined(textInput: txtHealthCareNo)
        RDGlobalFunction.setColorsToInput(input: healthCareController)
        
        healthcareExpController = MDCTextInputControllerOutlined(textInput: txtHealthCareExpiry)
        RDGlobalFunction.setColorsToInput(input: healthcareExpController)
        
        medicareExpController = MDCTextInputControllerOutlined(textInput: txtMedicareExpiry)
        RDGlobalFunction.setColorsToInput(input: medicareExpController)
        
        
        txtHealthCareExpiry.clearButtonMode = .never
        txtHealthCareNo.clearButtonMode = .never
        txtPensionerExpiry.clearButtonMode = .never
        txtPensionerNo.clearButtonMode = .never
        txtMedicareExpiry.clearButtonMode = .never
        txtIRN.clearButtonMode = .never
        txtMedicareNo.clearButtonMode = .never
        
        txtMedicareNo.text = RDGlobalFunction.appDelegate.signupParams.medicareNo
        txtIRN.text = RDGlobalFunction.appDelegate.signupParams.refNo
        txtMedicareExpiry.text = RDGlobalFunction.appDelegate.signupParams.medicareExp
        txtHealthCareNo.text = RDGlobalFunction.appDelegate.signupParams.healthCareNo
        txtHealthCareExpiry.text = RDGlobalFunction.appDelegate.signupParams.healthCareExp
        txtPensionerExpiry.text = RDGlobalFunction.appDelegate.signupParams.pensionerExp
        txtPensionerNo.text = RDGlobalFunction.appDelegate.signupParams.pensionerNo
        
    }
    
    //MARK:UIButton Actions
    @IBAction func btnBack() {
        RDGlobalFunction.appDelegate.signupParams.medicareNo = txtMedicareNo.text!
        RDGlobalFunction.appDelegate.signupParams.refNo = txtIRN.text!
        RDGlobalFunction.appDelegate.signupParams.medicareExp = txtMedicareExpiry.text!
        RDGlobalFunction.appDelegate.signupParams.healthCareNo = txtHealthCareNo.text!
        RDGlobalFunction.appDelegate.signupParams.healthCareExp = txtHealthCareExpiry.text!
        RDGlobalFunction.appDelegate.signupParams.pensionerExp = txtPensionerExpiry.text!
        RDGlobalFunction.appDelegate.signupParams.pensionerNo = txtPensionerNo.text!
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit() {
        callSignupAPI()
    }
    
    func callSignupAPI() {
        
        UtilityClass.showActivityIndicator()
        
        let params : Parameters = ["email":RDGlobalFunction.appDelegate.signupParams.email,
                                   "password":RDGlobalFunction.appDelegate.signupParams.password,
                                   "mobile":RDGlobalFunction.appDelegate.signupParams.phone,
                                   "name":RDGlobalFunction.appDelegate.signupParams.name,
                                   "usertype":"2",
                                   "status":"3",
                                   "gender":RDGlobalFunction.appDelegate.signupParams.gender,
                                   "country":RDGlobalFunction.appDelegate.signupParams.country,
                                   "state":RDGlobalFunction.appDelegate.signupParams.state,
                                   "city":RDGlobalFunction.appDelegate.signupParams.city,
                                   "street_address_1":RDGlobalFunction.appDelegate.signupParams.address,
                                   "postcode":RDGlobalFunction.appDelegate.signupParams.zip,
                                   "medical_card_number":txtMedicareNo.text!,
                                   "medical_ref_number":txtIRN.text!,
                                   "medical_expiry":txtMedicareExpiry.text!,
                                   "pensioner_card_number":txtPensionerNo.text!,
                                   "pensioner_expiry":txtPensionerExpiry.text!,
                                   "healthcare_card_number":txtHealthCareNo.text!,
                                   "healthcare_card_expiry":txtPensionerExpiry.text!,
                                   "private_health_fund_name":"",
                                   "private_health_fund_membership_number":""]
        
        WebServiceManager.sharedInstance.doSignUpWith(selectedVC: self, signupParameters: params, userRegisterAPI: REGISTERAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {
                 
                var response = responseObject as! [String:AnyObject]
                
                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in
                    }
                } else {
                    let dict = RDGlobalFunction.removeNullFromDict(dict: response)
                    response = dict
                    RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: response as NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    RDGlobalFunction.setBoolValueInUserDefault(iSDefaultValue: true, iSDefaultKey: RDDataEngineClass.iSUerActivated)
                    RDGlobalFunction.authUser = AuthUser.init(dict: response)
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "Couldn't ", options: "OK") { (_) in
                }
            }
        }
    }
}

extension RegisterStep1VC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.count + string.count - range.length
        
        if textField == self.txtHealthCareNo || textField == self.txtPensionerNo || textField == txtMedicareNo  {
            return newLength <= 12
            
        } else if textField == txtIRN {
            return newLength <= 2
        } else {
            if textField.text!.count == 2 {
                if newLength == 1 {
                    return true
                } else {
                    textField.text?.append("/")
                }
            }
            if textField.text?.count == 3 && newLength == 2 {
                return true
            }
            
            if newLength == 1 && Int((textField.text! as NSString).replacingCharacters(in: range, with: string))! <= 9 && Int((textField.text! as NSString).replacingCharacters(in: range, with: string))! != 1 && string != "0" {
                textField.text = "0"
            }
            
            if newLength == 2 && Int((textField.text! as NSString).replacingCharacters(in: range, with: string))! > 12 {
                return false
            }
            
            return newLength <= 5
        }
        
    }
}
