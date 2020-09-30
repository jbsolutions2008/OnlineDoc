//
//  ApplicationFeesVC.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents.MaterialTextFields

class ApplicationFeesVC: UIViewController {

    
    var currentConsultation : Consultation!
    var arrConsultation : [Consultation] = []
    var currentSelection = selectionType.consultation.rawValue
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    @IBOutlet weak var txtConsultation: MDCTextField!
    var consultController: MDCTextInputControllerOutlined!
    @IBOutlet weak var bottomToConsultation: NSLayoutConstraint!
    @IBOutlet weak var bottomToDetail: NSLayoutConstraint!
    
    @IBOutlet weak var lblTopConsultation:UILabel!
    @IBOutlet weak var lblBottomConsultation:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var vwDetail:UIView!
    @IBOutlet weak var scrlview:UIScrollView!
    
  
    var arrLabels = [["UPTO FIVE MINS", "ONE MEDICAL CERTIFICATE", "ONE PRESENTING COMPLAINT"],
                     ["UPTO TEN MINS","ONE MEDICAL CERTIFICATE","ONE REFERAL","ONE PRESENTING COMPLAINT"],
                     ["UPTO TWENTY MINS","ONE MEDICAL CERTIFICATE","ONE REFERAL","TWO PRESENTING COMPLAINT"],
                     ["TWO ADULTS, ONE CHILD","UPTO THIRTY MINS","TWO REFERAL","THREE MEDICAL COMPLAINT","TWO MEDICAL CERTIFICATE","PRESCRIPTIONS"],
                     ["VIDEO AND PHONE CONSULTATION AVAILABLE","LONG CONSULTATION AVAILABLE", "MEDICAL CERTIFICATE","PRESCRIPTION", "SPECIALIST REFERRAL LETTER","PATHOLOGY OR IMAGING REQUEST"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        consultController = MDCTextInputControllerOutlined(textInput: txtConsultation)
        RDGlobalFunction.setGrayColorsToInput(input:consultController)
        txtConsultation.clearButtonMode = .never
        getConsultationType()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: vwDetail, cornerRad: 8.0, borderWidth: 0, borderColor: .clear)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnConsultationClicked() {
        currentSelection = selectionType.consultation.rawValue
        RDGlobalFunction.showPickerSelection(delegate: self, type: selectionType.consultation, datasource: self.arrConsultation)
    }
    
    @IBAction func btnBookClicked() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakeApppointmentVC") as! MakeApppointmentVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnBackClicked() {
        
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "SlideNavController") as! SlideNavController
        present(menu, animated: true, completion: nil)
        
    }
    
    //MARK:Other Methods
    func setBottomScroll() {
        self.bottomToDetail.priority = .defaultHigh
        self.bottomToConsultation.priority = .defaultLow
        self.vwDetail.layoutIfNeeded()
        scrlview.layoutIfNeeded()
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
                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: self, title: "Error!", message: "No Data Available", options: "OK") { (_) in }
            }
        }
    }
}

extension ApplicationFeesVC : selectionDelegate {
    func cancelled() {
        
    }
    
    func doneSelection(with Value: Any) {
        if currentSelection == selectionType.consultation.rawValue {
            scrlview.isHidden = false
            currentConsultation = Value as? Consultation
            txtConsultation.text = currentConsultation.name
            lblTopConsultation.text = currentConsultation.name
            lblBottomConsultation.text = currentConsultation.name
            if Double(self.currentConsultation.price) == 0.0 {
                  lblPrice.text = "Bulk-Billing"
            } else {
                lblPrice.text = "$ \(currentConsultation.price)"
            }
            
            tableHeight.constant = 600
            tableView.reloadData()
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableHeight.constant = tableView.contentSize.height
            tableView.reloadData()
            self.setBottomScroll()
        }
    }
}

extension ApplicationFeesVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  currentConsultation != nil {
            return arrLabels[4].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AppointmentTableCell
        if  currentConsultation != nil {
            cell.lblDocName.text = arrLabels[4][indexPath.row]
        }
        return cell
        
    }
}
