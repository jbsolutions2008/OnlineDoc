//
//  AppointmentTableCell.swift
//  OnlineDoc
//
//
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit

class AppointmentTableCell: UITableViewCell {
    
    @IBOutlet weak var lblConsultationName : UILabel!
    @IBOutlet weak var lblDocName : UILabel!
    @IBOutlet weak var lblStart : UILabel!
    @IBOutlet weak var lblDuration : UILabel!
    @IBOutlet weak var lblNum : UILabel!
    @IBOutlet weak var shadowView : UIView!
    @IBOutlet weak var btnJoin : UIButton!
    

   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
