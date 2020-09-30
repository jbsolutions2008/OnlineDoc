//
//  AddCardViewController.swift
//  Weather Accommodation
//
//  Created by macmini-1 on 21/09/19.
//  Copyright © 2019 JBSoluions - Renish Dadhaniya. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var paymentCardTextField : STPPaymentCardTextField!
    @IBOutlet weak var lblAmount : UILabel!
    var appointment_id = 0
    var amount = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup payment card text field
        paymentCardTextField.delegate = self
        paymentCardTextField.postalCodeEntryEnabled = false
        paymentCardTextField.cvcPlaceholder = "CVC"
        paymentCardTextField.numberPlaceholder = "1234 1234 1234 1234"
        paymentCardTextField.expirationPlaceholder = "MM/YY"
        lblAmount.text = "You will get charged $\(self.amount)"
        
        // Add payment card text field to view
        view.addSubview(paymentCardTextField)
    }
    
    // MARK: STPPaymentCardTextFieldDelegate
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        
        //self.navigationItem.rightBarButtonItem!.isEnabled = textField.isValid
    }
    
    @IBAction func btnBackPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDonePressed() {
        
        if paymentCardTextField.isValid {
            let cardParams = STPCardParams()
            cardParams.number = paymentCardTextField.cardNumber
            cardParams.expMonth = paymentCardTextField.expirationMonth
            cardParams.expYear = paymentCardTextField.expirationYear
            cardParams.cvc = paymentCardTextField.cvc
            
            UtilityClass.showActivityIndicator()
            
            STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
                guard let token = token else {
                    
                    UtilityClass.removeActivityIndicator()
                    UtilityClass.showAlertWithMessage(message: error?.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                        if isConfirm {
                          //  RDGlobalFunction.setIntInUserDefault(iSDefaultValue: 1, iSDefaultKey: RDDataEngineClass.userCardCount)
                        }
                    })
                    return
                }
                self.processPayment(token: token.tokenId)
            }
        }
    }
    
    func processPayment(token : String)  {
        
       
        let param = ["appointment_id" : appointment_id, "token" : token, "amount":"\(self.amount)", "currency":"AUD"] as [String : Any]

        WebServiceManager.sharedInstance.payment(selectedVC: self, parameters: param, paymentAPI: PAYMENT) { (responseOject, success) in
            
            if success {
                if responseOject["Success"] as! Int == 0 {
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: responseOject["ErrorSuccessMsg"] as! String, options: "OK") { (_) in}
                } else {
                    UtilityClass.removeActivityIndicator()
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "DoctorOnline", message:"Great! Your payment is successfully completed.", options: "OK") { (_) in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookingHistoryVC") as! BookingHistoryVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
}
