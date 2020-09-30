//
//  SelectionPickerVC.swift
//  OnlineDoc
//
//  Created by JBSolutions's iMac on 19/03/20.
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

protocol selectionDelegate  {
    func cancelled()
    func doneSelection(with Value : Any)
}

enum selectionType : String {
    case country = "country"
    case gender = "gender"
    case consultation = "consultation"
    case date = "date"
    case doctor = "doctor"
    case time = "time"
    case type = "type"
}

class SelectionPickerVC: UIViewController {

    @IBOutlet weak var btnDone:UIButton!
    @IBOutlet weak var btnCancel:UIButton!
    
    @IBOutlet weak var pickerView:UIPickerView!
    @IBOutlet weak var datePicker:UIDatePicker!
    
    var delegate : selectionDelegate!
    var currentType : selectionType!
    
    var datasource : [Any] = []
    var gender = ["Male","Female","Prefer not to say"]
    var type = ["Video Consultation","Phone Consultation(Audio only)"]
    
    var fontSize = 17.0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 22.0
        }
        if currentType!.rawValue == selectionType.country.rawValue {
            datasource = RDGlobalFunction.allCountries
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        } else if currentType!.rawValue == selectionType.gender.rawValue {
            datasource = self.gender
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        } else if currentType!.rawValue == selectionType.consultation.rawValue {
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        } else if currentType!.rawValue == selectionType.date.rawValue {
            datePicker.minimumDate = Date()
            datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            datePicker.isHidden = false
            datePicker.datePickerMode = .date
        } else if currentType!.rawValue == selectionType.doctor.rawValue {
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        } else if currentType!.rawValue == selectionType.time.rawValue {
            datePicker.minimumDate = Date()
            datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
            datePicker.isHidden = false
            datePicker.datePickerMode = .time
        } else if currentType!.rawValue == selectionType.type.rawValue {
            datasource = self.type
            pickerView.isHidden = false
            pickerView.reloadAllComponents()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        RDGlobalFunction.setCornerRadius(any: btnDone, cornerRad: 5.0, borderWidth: 0, borderColor: .clear)
        RDGlobalFunction.setCornerRadius(any: btnCancel, cornerRad: 5.0, borderWidth: 0, borderColor: .clear)
    }
    
    //MARK:UIButton Actions
    @IBAction func btnDonePressed() {
        self.dismiss(animated: true, completion: nil)
        
        if currentType!.rawValue == selectionType.date.rawValue ||  currentType!.rawValue == selectionType.time.rawValue {
            delegate.doneSelection(with: datePicker.date)
        } else {
            if datasource.count > 0 {
                if currentType!.rawValue == selectionType.country.rawValue {
                    delegate.doneSelection(with: RDGlobalFunction.allCountries[pickerView.selectedRow(inComponent: 0)][1])
                } else if currentType!.rawValue == selectionType.gender.rawValue {
                    delegate.doneSelection(with: gender[pickerView.selectedRow(inComponent: 0)])
                } else if currentType!.rawValue == selectionType.consultation.rawValue {
                    delegate.doneSelection(with: datasource[pickerView.selectedRow(inComponent: 0)])
                }  else if currentType!.rawValue == selectionType.doctor.rawValue {
                    delegate.doneSelection(with: datasource[pickerView.selectedRow(inComponent: 0)])
                }  else if currentType!.rawValue == selectionType.type.rawValue {
                    delegate.doneSelection(with: type[pickerView.selectedRow(inComponent: 0)])
                }
            }
        }
    }
    
    @IBAction func btnCancelPressed() {
        self.dismiss(animated: true, completion: nil)
        delegate.cancelled()
    }
}

extension SelectionPickerVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        if currentType!.rawValue == selectionType.country.rawValue {
            label.text = (datasource as! [[String]])[row][1]
        } else if currentType!.rawValue == selectionType.gender.rawValue {
            label.text = (datasource as! [String])[row]
        } else if currentType!.rawValue == selectionType.consultation.rawValue {
            label.text = (datasource as![Consultation])[row].name
        } else if currentType!.rawValue == selectionType.doctor.rawValue {
            label.text = (datasource as![Doctor])[row].name
        } else if currentType!.rawValue == selectionType.type.rawValue {
            label.text = (datasource as! [String])[row]
        }
        return label

    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
         return 44
        }
         return 30
    }
}
