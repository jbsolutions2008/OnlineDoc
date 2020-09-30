//
//  DefaultWhiteButton.swift
//  Nasty Rick
//
//  Created by JBSolutions's iMac on 23/12/19.
//

import UIKit

class DefaultPrimaryBgButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        RDGlobalFunction.setCornerRadius(any: self, cornerRad: 5.0, borderWidth: 0.0, borderColor: .clear)
    }
    
    
    func setUp() {
        self.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(RDGlobalFunction.fontSizeAccordingToDeviceResolution()-4.0), weight: .medium)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.backgroundColor = RDDataEngineClass.SecondaryColorBlue
    }
}
