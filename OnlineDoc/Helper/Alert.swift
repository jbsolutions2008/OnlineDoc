//
//  File.swift
//
//
//
//

import Foundation
import UIKit

struct AlertStrings {
   
    static let LOGINREQUIREDTITLE = "Sorry!"
    
    static let LOGINREQUIREDMESSAGE = "You must be logged in to app."
    
    static let INSUFFICIENTPLAYERALERTMESSAGE = "You didn't start a game with at least four players in time."
    
    static let INVALIDCODEALERTITLE = "Invalid code entered!"
    
    static let ENTERCODEALERTMESSAGE = "Please enter an active game code"
    
    static let INSUFFICIENT_PLAYER_STARTGAME_ALERTMESSAGE = "At least four players must be present to start game. Share the game with some friends!"
    
    static let STRANGER_INSUFFICIENT_PLAYER_STARTGAME_ALERTMESSAGE = "Game couldn't find sufficient players to start game. Share the game with some friends!"
    
    static let NEED_THREE_ACTIVE_PLAYERS_ALERTMESSAGE = "Game must have at least 3 active player at all times."
    
    static let GAME_OVER_ALERTTITLE = "Game over!"
}

class AlertUtility:NSObject  {
    
    override init() {
        super.init()
    }
    
    
    class var sharedInstance: AlertUtility {
        struct Static {
            static let instance = AlertUtility()
        }
        return Static.instance
    }
   
    func presentAlertWithTitle(onVC:UIViewController, title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        onVC.present(alertController, animated: true, completion: nil)
    }
    
    func presentActionsheetWithTitle(onVC:UIViewController, title: String!, message: String!, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        
        alertController.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        onVC.present(alertController, animated: true, completion: nil)
    }
    
    func showLoginRequiredAlert(onVC:UIViewController) {
        self.presentAlertWithTitle(onVC: onVC, title: AlertStrings.LOGINREQUIREDTITLE, message: AlertStrings.LOGINREQUIREDMESSAGE, options: "OK") { (_) in}
    }
    
    func presentAlertWithTextField(onVC:UIViewController, title: String, message: String, options: String..., completion: @escaping (Int, String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                let firstTextField = alertController.textFields![0] as UITextField
                completion(index,firstTextField.text!)
            }))
        }
        
        alertController.addTextField { (textField) -> Void in
            textField.autocorrectionType = .no
            textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            textField.placeholder = "enter code here"
        }
        onVC.present(alertController, animated: true, completion: nil)
    }
}
