//
//  SlideNavController.swift
//  OnlineDoc
//
//  
//  Copyright © 2020 JBSolutions's iMac. All rights reserved.
//

import UIKit
import SideMenu


class SlideNavController: SideMenuNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationStyle = .menuSlideIn
        self.menuWidth = RDGlobalFunction.MainScreenBounds.width/1.4

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
