//
//  LoginVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 17/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialTextFields

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmail: MDCTextField!
    @IBOutlet weak var txtPassword: MDCTextField!
    @IBOutlet weak var btnSignup: UIButton!
  
    var emailController: MDCTextInputControllerOutlined!
    var passController: MDCTextInputControllerOutlined!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fontSize = 17.0
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 22.0
        }
        
        emailController = MDCTextInputControllerOutlined(textInput: txtEmail)
        RDGlobalFunction.setColorsToInput(input: emailController)
       // txtEmail.font = UIFont.systemFont(ofSize: 17.0)
        txtEmail.clearButtonMode = .never
        
        passController = MDCTextInputControllerOutlined(textInput: txtPassword)
        RDGlobalFunction.setColorsToInput(input: passController)
        txtPassword.clearButtonMode = .never
        
        let rightButton = UIButton.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        rightButton.setBackgroundImage(UIImage.init(imageLiteralResourceName: "hide"), for: .normal)
        rightButton.setBackgroundImage(UIImage.init(imageLiteralResourceName: "show"), for: .selected)
        rightButton.addTarget(self, action: #selector(showPassword(sender:)), for: .touchUpInside)
        txtPassword.rightView = rightButton
        txtPassword.rightViewMode = .always
        
        let attributedString = NSMutableAttributedString(string:"NEW USER? SIGN UP")
        
        
        let range = (attributedString.string as NSString).range(of: "SIGN UP")
        let range1 = (attributedString.string as NSString).range(of: "NEW USER?")
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: RDDataEngineClass.SecondaryColorBlue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(fontSize)) ], range: range)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: CGFloat(fontSize))], range: range1)
        
        btnSignup.setAttributedTitle(attributedString, for: .normal)
    }
    
    //MARK: UIButton Actions
    @IBAction func btnSignupPressed() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLoginPressed() {
        if !RDGlobalFunction.isValidEmail(self.txtEmail.text!) {
            
            emailController.setErrorText("Invalid Email",
                                         errorAccessibilityValue: nil)
            self.txtEmail.becomeFirstResponder()
        }else if !(RDGlobalFunction.checkPasswordHasSufficientComplexity(text: self.txtPassword.text!))  {
            
            passController.setErrorText("Password must be 8 characters long",
                                         errorAccessibilityValue: nil)
            self.txtPassword.becomeFirstResponder()
            
        }  else {
            self.view.endEditing(true)
            callLoginAPI()
            
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
    
    //MARK:WebService
    func callLoginAPI() {
        
        UtilityClass.showActivityIndicator()
        let params : Parameters = ["email":txtEmail.text!, "password":txtPassword.text!]
        
        WebServiceManager.sharedInstance.doSignInWith(selectedVC: self, signInParameters: params, userLoginAPI: LOGINAPI) { (responseObject, success) in

            UtilityClass.removeActivityIndicator()
            if success {
                 
                var response = responseObject as! [String:AnyObject]
                
                if response["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: response["ErrorSuccessMsg"] as! String, options: "OK") { (_) in
                    }
                } else {
                    let dict = RDGlobalFunction.removeNullFromDict(dict: (response["Data"] as! NSArray)[0] as! [String:AnyObject])
                    response = dict
                    RDGlobalFunction.setObjectInUserDefault(iSDefaultValue: response as NSDictionary, iSDefaultKey: RDDataEngineClass.userProfileInfoDef)
                    RDGlobalFunction.setBoolValueInUserDefault(iSDefaultValue: true, iSDefaultKey: RDDataEngineClass.iSUerActivated)
                    RDGlobalFunction.authUser = AuthUser.init(dict: response)
                    
                    if  RDGlobalFunction.authUser.UserType == 1{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DoctorHomeVC") as! DoctorHomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "Couldn't login", options: "OK") { (_) in
                }
            }
        }
    }
}
