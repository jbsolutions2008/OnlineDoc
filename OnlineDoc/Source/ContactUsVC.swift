//
//  ContactUsVC.swift
//  OnlineDoc
//
//
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class ContactUsVC: UIViewController {

    @IBOutlet weak var txtName: MDCTextField!
    var nameController: MDCTextInputControllerOutlined!
    
    @IBOutlet weak var txtSubject: MDCTextField!
    var subjectController: MDCTextInputControllerOutlined!
    
    
    @IBOutlet weak var txtMessage: MDCMultilineTextField!
    var messageController: MDCTextInputControllerOutlinedTextArea!
    
    @IBOutlet weak var topOfSubmit: NSLayoutConstraint!
    
    //info@doctoronline365.com.au
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameController = MDCTextInputControllerOutlined(textInput: txtName)
        RDGlobalFunction.setGrayColorsToInput(input: nameController)
        
        subjectController = MDCTextInputControllerOutlined(textInput: txtSubject)
        RDGlobalFunction.setGrayColorsToInput(input: subjectController)
        
        messageController = MDCTextInputControllerOutlinedTextArea(textInput: txtMessage)
        RDGlobalFunction.setColorsToMultilineInput(input: messageController)
        
        
        txtSubject.clearButtonMode = .never
        txtMessage.clearButtonMode = .never
        txtName.clearButtonMode = .never
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            topOfSubmit.constant = 65.0
        } else {
            topOfSubmit.constant = 25.0
        }

    }
    
    //MARK:UIbutton Actions
    @IBAction func btnSubmitPressed() {
        
        if txtName.text == "" {
            
            nameController.setErrorText("Enter Name",
                                         errorAccessibilityValue: nil)
            self.txtName.becomeFirstResponder()
        }else if txtSubject.text == ""  {
            
            subjectController.setErrorText("Enter Subject",
                                         errorAccessibilityValue: nil)
            self.txtSubject.becomeFirstResponder()
            
        }else if txtMessage.text == ""  {
            
            messageController.setErrorText("Enter Message",
                                         errorAccessibilityValue: nil)
            self.txtMessage.becomeFirstResponder()
            
        }  else {
            self.view.endEditing(true)
            let title = txtSubject.text
            let content = "\(txtMessage.text!)\n\n\nFrom,\n\(txtName.text!)"
            let objectsToShare = [content]

            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.title = "Select Email sending App:"
            activityVC.setValue(title, forKey: "Subject")
            self.present(activityVC, animated: true, completion: nil)
                       
        }
    }

    
    @IBAction func btnCallPressed() {
        if UIDevice.current.userInterfaceIdiom != .pad {
             RDGlobalFunction.makeCall(phoneNumber: "1300290600")
        }
       
    }
    
    @IBAction func btnLinksPressed(sender:UIButton) {
        var urlString = ""
        
        if sender.tag == 1 {
            urlString = "https://www.facebook.com/Doctor-Online-106355301061270/?modal=admin_todo_tour"
        } else if sender.tag == 2 {
            urlString = "https://twitter.com/DoctorOnline12"
        } else {
            urlString = "https://www.instagram.com/DoctorOnline365/"
        }
        
        
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
        }
       
    }
    
    @IBAction func btnBackPressed() {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
        present(menu, animated: true, completion: nil)

    }
}
