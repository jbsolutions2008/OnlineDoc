//
//  SignupVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 18/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

struct signupParams {
    var name : String
    var surname : String
    var email : String
    var gender : String
    var password : String
    var phone : String
    var country : String
    var address : String
    var state : String
    var city : String
    var zip : String
    var medicareNo : String
    var refNo : String
    var medicareExp: String
    var pensionerNo: String
    var pensionerExp: String
    var healthCareNo: String
    var healthCareExp: String
    
    
    init( dict: [String : AnyObject]) {
        let dict1 = RDGlobalFunction.removeNullFromDict(dict: dict)
        self.name = dict1["name"] as? String ?? ""
        self.surname = dict1["surname"] as? String ?? ""
        self.gender = dict1["gender"] as? String ?? ""
        self.email = dict1["email"] as? String ?? ""
        self.password = dict1["password"] as? String ?? ""
        self.phone = dict1["phone"] as? String ?? ""
        
        self.country = dict1["country"] as? String ?? ""
        self.address = dict1["address"] as? String ?? ""
        self.state = dict1["state"] as? String ?? ""
        self.city = dict1["city"] as? String ?? ""
        self.zip = dict1["zip"] as? String ?? ""
        self.medicareNo = dict1["medicareNo"] as? String ?? ""
        self.refNo = dict1["refNo"] as? String ?? ""
        self.medicareExp = dict1["medicareExp"] as? String ?? ""
        self.pensionerNo = dict1["pensionerNo"] as? String ?? ""
        self.pensionerExp = dict1["pensionerExp"] as? String ?? ""
        self.healthCareNo = dict1["healthCareNo"] as? String ?? ""
        self.healthCareExp = dict1["healthCareExp"] as? String ?? ""
        
        
     }
}

class SignupVC: UIViewController {
    
    @IBOutlet weak var txtEmail: MDCTextField!
    @IBOutlet weak var txtPassword: MDCTextField!
    @IBOutlet weak var txtName: MDCTextField!
    @IBOutlet weak var txtGender: MDCTextField!
    @IBOutlet weak var txtCity: MDCTextField!
    @IBOutlet weak var txtState: MDCTextField!
    @IBOutlet weak var txtCountry: MDCTextField!
    @IBOutlet weak var txtZip: MDCTextField!
    @IBOutlet weak var txtAddress: MDCTextField!
    @IBOutlet weak var txtPhone: MDCTextField!
    @IBOutlet weak var txtSurname: MDCTextField!
    
    @IBOutlet weak var btnGender : UIButton!
    @IBOutlet weak var btnCountry : UIButton!
    
    
    var emailController: MDCTextInputControllerOutlined!
    var passController: MDCTextInputControllerOutlined!
    var nameController: MDCTextInputControllerOutlined!
    var genderController: MDCTextInputControllerOutlined!
    var cityController: MDCTextInputControllerOutlined!
    var stateController: MDCTextInputControllerOutlined!
    var countryController: MDCTextInputControllerOutlined!
    var zipController: MDCTextInputControllerOutlined!
    var addressController: MDCTextInputControllerOutlined!
    var phoneController: MDCTextInputControllerOutlined!
    var surnameController: MDCTextInputControllerOutlined!
    
    var currentSelection = selectionType.country.rawValue
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailController = MDCTextInputControllerOutlined(textInput: txtEmail)
        RDGlobalFunction.setColorsToInput(input: emailController)
        
        passController = MDCTextInputControllerOutlined(textInput: txtPassword)
        RDGlobalFunction.setColorsToInput(input: passController)
        
        nameController = MDCTextInputControllerOutlined(textInput: txtName)
        RDGlobalFunction.setColorsToInput(input: nameController)
        
        genderController = MDCTextInputControllerOutlined(textInput: txtGender)
        RDGlobalFunction.setColorsToInput(input: genderController)
        genderController.disabledColor = .white
        
        cityController = MDCTextInputControllerOutlined(textInput: txtCity)
        RDGlobalFunction.setColorsToInput(input: cityController)
        
        stateController = MDCTextInputControllerOutlined(textInput: txtState)
        RDGlobalFunction.setColorsToInput(input: stateController)
        
        countryController = MDCTextInputControllerOutlined(textInput: txtCountry)
        RDGlobalFunction.setColorsToInput(input: countryController)
        countryController.disabledColor = .white
        
        zipController = MDCTextInputControllerOutlined(textInput: txtZip)
        RDGlobalFunction.setColorsToInput(input: zipController)
        
        addressController = MDCTextInputControllerOutlined(textInput: txtAddress)
        RDGlobalFunction.setColorsToInput(input: addressController)
        
        phoneController = MDCTextInputControllerOutlined(textInput: txtPhone)
        RDGlobalFunction.setColorsToInput(input: phoneController)
        
        surnameController = MDCTextInputControllerOutlined(textInput: txtSurname)
        RDGlobalFunction.setColorsToInput(input: surnameController)
        
        txtEmail.clearButtonMode = .never
        txtPassword.clearButtonMode = .never
        txtName.clearButtonMode = .never
        txtPhone.clearButtonMode = .never
        txtZip.clearButtonMode = .never
        txtCity.clearButtonMode = .never
        txtAddress.clearButtonMode = .never
        txtCountry.clearButtonMode = .never
        txtCity.clearButtonMode = .never
        txtSurname.clearButtonMode = .never
        txtState.clearButtonMode = .never
        
        let rightButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        rightButton.setBackgroundImage(UIImage.init(imageLiteralResourceName: "hide"), for: .normal)
        rightButton.setBackgroundImage(UIImage.init(imageLiteralResourceName: "show"), for: .selected)
        rightButton.addTarget(self, action: #selector(showPassword(sender:)), for: .touchUpInside)
        txtPassword.rightView = rightButton
        txtPassword.rightViewMode = .always
        
//        let rightButton1 = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
//        rightButton1.setBackgroundImage(UIImage.init(imageLiteralResourceName: "down"), for: .normal)
//        rightButton1.setBackgroundImage(UIImage.init(imageLiteralResourceName: "up"), for: .selected)
//        rightButton1.addTarget(self, action: #selector(showPassword(sender:)), for: .touchUpInside)
//        txtGender.rightView = rightButton1
//        txtGender.rightViewMode = .always
//
//        let rightButton2 = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
//        rightButton2.setBackgroundImage(UIImage.init(imageLiteralResourceName: "down"), for: .normal)
//        rightButton2.setBackgroundImage(UIImage.init(imageLiteralResourceName: "up"), for: .selected)
//        rightButton2.addTarget(self, action: #selector(showPassword(sender:)), for: .touchUpInside)
//        txtCountry.rightView = rightButton2
//        txtCountry.rightViewMode = .always
    }
    
    //MARK:UIButton Actions
    @IBAction func btnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext() {
        if txtName.text == "" {
            nameController.setErrorText("Enter your name",
            errorAccessibilityValue: nil)
            self.txtName.becomeFirstResponder()
        } else if txtSurname.text == "" {
            surnameController.setErrorText("Enter your surname",
            errorAccessibilityValue: nil)
            self.txtSurname.becomeFirstResponder()
        } else if txtGender.text == "" {
            genderController.setErrorText("Select your gender",
            errorAccessibilityValue: nil)
        } else if !RDGlobalFunction.isValidEmail(self.txtEmail.text!) {
            
            emailController.setErrorText("Invalid Email",
                                         errorAccessibilityValue: nil)
            self.txtEmail.becomeFirstResponder()
        }else if txtPhone.text == "" {
            phoneController.setErrorText("Enter your phone number",
            errorAccessibilityValue: nil)
            self.txtPhone.becomeFirstResponder()
        }else if !(RDGlobalFunction.checkPasswordHasSufficientComplexity(text: self.txtPassword.text!))  {
            
            passController.setErrorText("Password must be 8 characters long",
                                         errorAccessibilityValue: nil)
            self.txtPassword.becomeFirstResponder()
            
        } else if txtCountry.text == "" {
            countryController.setErrorText("Select your country",
            errorAccessibilityValue: nil)
        } else if txtAddress.text == "" {
            addressController.setErrorText("Enter your address",
            errorAccessibilityValue: nil)
            self.txtAddress.becomeFirstResponder()
        } else if txtCity.text == "" {
            cityController.setErrorText("Enter your city",
            errorAccessibilityValue: nil)
            self.txtCity.becomeFirstResponder()
        }
        else if txtState.text == "" {
            stateController.setErrorText("Enter your state",
            errorAccessibilityValue: nil)
            self.txtState.becomeFirstResponder()
        } else if txtZip.text == "" {
            zipController.setErrorText("Enter your zipcode",
            errorAccessibilityValue: nil)
            self.txtZip.becomeFirstResponder()
        } else {
            
            if RDGlobalFunction.appDelegate.signupParams == nil {
                var dict : [String : String] = [:]
                dict["name"] = "\(txtName.text!) \(txtSurname.text)"
                dict["surname"] = txtSurname.text!
                dict["gender"] = txtGender.text!
                dict["email"] = txtEmail.text!
                dict["phone"] = txtPhone.text!
                dict["password"] = txtPassword.text!
                dict["country"] = txtCountry.text!
                dict["state"] = txtState.text!
                dict["city"] = txtCity.text!
                dict["zip"] = txtZip.text!
                dict["address"] = txtAddress.text!
                
                RDGlobalFunction.appDelegate.signupParams = signupParams.init(dict: dict as [String : AnyObject])
            } else {
                RDGlobalFunction.appDelegate.signupParams.name = txtName.text!
                RDGlobalFunction.appDelegate.signupParams.surname = txtSurname.text!
                RDGlobalFunction.appDelegate.signupParams.gender = txtGender.text!
                RDGlobalFunction.appDelegate.signupParams.email = txtEmail.text!
                RDGlobalFunction.appDelegate.signupParams.phone = txtPhone.text!
                RDGlobalFunction.appDelegate.signupParams.password = txtPassword.text!
                RDGlobalFunction.appDelegate.signupParams.country = txtCountry.text!
                RDGlobalFunction.appDelegate.signupParams.state = txtState.text!
                RDGlobalFunction.appDelegate.signupParams.city = txtCity.text!
                RDGlobalFunction.appDelegate.signupParams.zip = txtZip.text!
                RDGlobalFunction.appDelegate.signupParams.address = txtAddress.text!
            }
            
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStep1VC") as! RegisterStep1VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func showPassword(sender:UIButton) {
        if !sender.isSelected {
            txtPassword.isSecureTextEntry = false
        } else {
            txtPassword.isSecureTextEntry = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func showPickers(sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 10 {
            btnCountry.isSelected = true
            currentSelection = selectionType.country.rawValue
            RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.country, datasource: [])
        } else {
            currentSelection = selectionType.gender.rawValue
            btnGender.isSelected = true
            RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.gender, datasource: [])
        }
    }
}

extension SignupVC : selectionDelegate {
    func cancelled() {
        if currentSelection == selectionType.country.rawValue {
            btnCountry.isSelected = false
        } else {
            btnGender.isSelected = false
        }
    }
    
    func doneSelection(with Value: Any) {
        if currentSelection == selectionType.country.rawValue {
            btnCountry.isSelected = false
            txtCountry.text = Value as? String
        } else {
            btnGender.isSelected = false
            txtGender.text = Value as? String
        }
    }
}

extension SignupVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = textField.text!.count + string.count - range.length
        
        if textField == self.txtPhone {
            return newLength <= 12
            
        } else if textField == txtZip {
            return newLength <= 5
        }
        return true
    }
}
