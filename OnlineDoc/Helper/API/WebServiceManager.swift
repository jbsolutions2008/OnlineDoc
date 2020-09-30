//
//  WebServiceManager.swift
//  W.A.S.
//
//  Created by Renish Dadhaniya on 25/07/19.
//  Copyright © 2019 GlobeSync Technologies - Renish Dadhaniya. All rights reserved.
//

import UIKit
import Alamofire

//response callback
typealias responseHandler = (_ responseObject: AnyObject, _ success: Bool) -> Void


// - - - - - - - - - - -  - - - - - - - - - - - API LIST  - - - - - - - - - - - - - - - - - - - - - -

//login user API
let LOGINAPI = "login.php"
let REGISTERAPI = "register_user.php"
let PLANSAPI = "consult_plans.php"
let DOCTORSAPI = "get_available_doctors.php"
let CREATESESSIONAPI = "create_session.php"
let BOOKINGHISTORYAPI = "get_booking_history.php"
let PAYMENT = "process_payment.php"
let UNAVAILABILITY = "update_unavailability.php"
let DECKLIST = "decks?_sort=position:asc"


//API MANAGER IMPLEMENTATION
class WebServiceManager: NSObject {
    
    override init() {
        super.init()
    }
    
    class var sharedInstance: WebServiceManager {
        
        struct Static {
            static let instance = WebServiceManager()
        }
        return Static.instance
    }
    
    //MARK: For Normal API Calling
    func getResponse(currentVC : UIViewController, urlPostfixStr: String, method : HTTPMethod,  parameter : [String : AnyObject], Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        print("url :\(urlPostfixStr)")
        
        if !UtilityClass.isInternetConnectedWith() {
            AlertUtility.sharedInstance.presentAlertWithTitle(onVC: currentVC, title: "Failure", message: "Please check internet connection in your device", options: "OK") { (_) in }
            UtilityClass.removeActivityIndicator()
            return
        }
        
        
        
            
            let encoding:ParameterEncoding = JSONEncoding.default
//            if urlPostfixStr == LOGINAPI {
//                encoding = URLEncoding()
//            }
            
            
            Alamofire.request((RDDataEngineClass.ApplicationBaseURL+urlPostfixStr), method: method, parameters: parameter, encoding: encoding, headers: setHeadersCheckingAPIKey()).validate().responseJSON { response in
                
                //Error Code
                _ = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        if result is [String:Any] {
                            let JSON = result as! [String : Any]
                            print("Success: \(JSON as AnyObject)")
                            callback(JSON as AnyObject, true)
                        } else {
                            let JSON = result as! NSArray
                            callback(JSON as AnyObject,true)
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    if response.result.value == nil {
                        callback(["ErrorSuccessMsg":"Server Error"] as AnyObject, false)
                    } else {
                        callback(response.result.value as AnyObject, false)
                        AlertUtility.sharedInstance.presentAlertWithTitle(onVC: currentVC, title: "Error!", message: error.localizedDescription, options: "OK") { (_) in}
                    }
                    
                    
                    //                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405) {
                    //
                    //                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                    //
                    //                            if isConfirm {
                    //                                //Redirect to Home Screen
                    //                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                    //                            }
                    //
                    //                        })
                    //
                    //                    }else{
                    
                    
                    //  }
                    UtilityClass.removeActivityIndicator()
                }
            }
        
    }
    
    func callFormDataRequest(currentVC : UIViewController, urlPostfixStr: String, method : HTTPMethod,  parameter : [String : String], Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        print("url :\(urlPostfixStr)")
       
        if (UtilityClass.isInternetConnectedWith()){

            Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameter {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                } //Optional for extra parameters
            }, usingThreshold: UInt64.init(), to: RDDataEngineClass.ApplicationBaseURL+urlPostfixStr, method: .post, headers: setHeadersCheckingAPIKey()) { (result) in
              
                switch result {
                case .success(let upload, _, _):
                    
                    
                    upload.responseJSON { response in
                        if let result = response.result.value {
                            if response.response?.statusCode == 200 {
                                if result is [String:Any] {
                                    let JSON = result as! [String : Any]
                                    print("Success: \(JSON as AnyObject)")
                                    callback(JSON as AnyObject, true)
                                } else {
                                    let JSON = result as! NSArray
                                    callback(JSON as AnyObject,true)
                                }
                            } else {
                                callback([:] as AnyObject,false)
                                UtilityClass.removeActivityIndicator()
                                AlertUtility.sharedInstance.presentAlertWithTitle(onVC: currentVC, title: "Error!", message: (result as! [String:Any])["error"] as! String, options: "OK") { (_) in}
                            }
                            
                        }
                    }
                    
                case .failure(let error):
                    
                    print("Error Localized Description : \(error.localizedDescription) ")
                    
                    callback([:] as AnyObject, false)
                    
                    AlertUtility.sharedInstance.presentAlertWithTitle(onVC: currentVC, title: "Error!", message: error.localizedDescription, options: "OK") { (_) in}
                    UtilityClass.removeActivityIndicator()
                }
            }
          }
        }
    
    
    //MARK: Encoding API Calling
    func getResponseWithEncoding(currentVC : UIViewController, url: String, method : HTTPMethod,  parameter : [String : AnyObject], headers: HTTPHeaders, encodingStr : ParameterEncoding, Alert : Bool,  callback: @escaping responseHandler) -> Void {
        
        print("Encoding url :\(url)")
        
        if (UtilityClass.isInternetConnectedWith()){
            
            Alamofire.request(url, method: method, parameters: parameter, encoding: encodingStr, headers: headers).validate().responseJSON { response in
                
                //Error Code
                let responseCode = response.response?.statusCode
                
                switch response.result {
                    
                case .success:
                    
                    if let result = response.result.value {
                        
                        let JSON = result as! [String : Any]
                        print("Success: \(JSON as AnyObject)")
                        callback(JSON as AnyObject, true)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Error: \(error)")
                    print("Error Localised Description : \(error.localizedDescription) ")
                    
                    callback({} as AnyObject, false)
                    
                    if (responseCode == 400 || responseCode == 401 || responseCode == 402 || responseCode == 403 || responseCode == 404 || responseCode == 405){
                        
                        UtilityClass.showAlertWithMessage(message: "\(APPFULLNAME) only allow one device to login at a time.", title: "Your account has been logout.", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            
                            if isConfirm {
                                //Redirect to Home Screen
                                RDGlobalFunction.goBackToMainViewController(currentVC: currentVC)
                            }
                            
                        })
                    }else{
                        UtilityClass.showAlertWithMessage(message: error.localizedDescription, title: "Error", confirmButtonTitle: "OK", notConfirmButtonTitle: "", alertType: .alert, isShowCancel: false, callback: { (isConfirm) -> (Void) in
                            if isConfirm {
                                
                            }
                        })
                        
                    }
                    UtilityClass.removeActivityIndicator()
                }
            }
        }
    }
    
    // Check for headers
    func setHeadersCheckingAPIKey() -> HTTPHeaders? {
//        if RDGlobalFunction.getBoolValueFromUserDefault(iSDefaultKey: RDDataEngineClass.iSUerActivated) {
//            let headers = ["Authorization" : "Bearer \(RDGlobalFunction.authUser.apiKey)"]
//            return headers
//
//        }
     //        return nil
        return  ["Content-Type" : "application/json"]
    }
    
    
   //Register Screen
    func doSignUpWith(selectedVC : UIViewController, signupParameters: Parameters, userRegisterAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: userRegisterAPI, method: .post , parameter: signupParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    //SIGN IN SCREEN
    func doSignInWith(selectedVC : UIViewController, signInParameters: Parameters, userLoginAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: userLoginAPI, method: .post , parameter: signInParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    //CONSULTATION TYPE
    func getConsultation(selectedVC : UIViewController, parameters: Parameters, getPlanAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getPlanAPI, method: .post , parameter: parameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    func getDoctors(selectedVC : UIViewController, parameters: Parameters, getDoctorsAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getDoctorsAPI, method: .post , parameter: parameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    
    //CREATE SESSION SCREEN
    func createSession(selectedVC : UIViewController, createSessionParameters: Parameters, createSessionAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: createSessionAPI, method: .post , parameter: createSessionParameters as [String : AnyObject], Alert : true, callback: callback)
    }
    
    func setUnavailability(selectedVC : UIViewController, parameters: Parameters, unavailabilityAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: unavailabilityAPI, method: .post , parameter: parameters as [String : AnyObject], Alert : true, callback: callback)
    }

    
    //BOOKING HISTORY
    func getBookings(selectedVC : UIViewController, parameters: Parameters, historyAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: historyAPI, method: .post , parameter: parameters as [String : AnyObject], Alert : true, callback: callback)
    }
    
    //PROCESS PAYMENT
    func payment(selectedVC : UIViewController, parameters: Parameters, paymentAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: paymentAPI, method: .post , parameter: parameters as [String : AnyObject], Alert : true, callback: callback)
    }
    
    //JOIN GAME
    func joinGame(selectedVC : UIViewController, joinGameParameters: Parameters, joinGameAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: joinGameAPI, method: .post , parameter: joinGameParameters as [String : AnyObject], Alert : true, callback: callback)
    }
    
    //FORGOT PASSWORD SCREEN
    func forgotPassword(selectedVC : UIViewController, forgotPasswordParameters: Parameters, forgotPAsswordAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: forgotPAsswordAPI, method: .post , parameter: forgotPasswordParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    //Get Deck
    func getDecks(selectedVC : UIViewController, getDecksParams: Parameters, getDeckAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getDeckAPI, method: .get , parameter: getDecksParams as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    
    //RESET PASSWORD
    func resetPassword(selectedVC : UIViewController, resetPasswordParameters: Parameters, resetPasswordAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: resetPasswordAPI, method: .post , parameter: resetPasswordParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    
    //GET - Client Details
    func getClientProfileDetailInformation(selectedVC : UIViewController, clientProfileParameters: Parameters, getClientProfileAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getClientProfileAPI, method: .get , parameter: clientProfileParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    
    //GET - Online Provider List
    func getOnlineProviderList(selectedVC : UIViewController, getOnlineProviderListAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: getOnlineProviderListAPI, method: .get , parameter: [:] as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    //POSt - Request
    func postRequest(selectedVC : UIViewController, requestParameters: Parameters, postRequestAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC,urlPostfixStr: postRequestAPI, method: .post , parameter: requestParameters as [String : AnyObject], Alert : true, callback: callback)
        
    }
    
    //POST - Card List
    func getStripeCardList(selectedVC : UIViewController, requestParameters: Parameters, cardListAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: cardListAPI, method: .post, parameter: requestParameters as [String : AnyObject], Alert : true, callback: callback)
    }
    
    //POST -
    func addCardToCustomer(selectedVC : UIViewController, requestParameters: Parameters, addCardAPI : String,callback: @escaping responseHandler) -> Void {
        
        self.getResponse(currentVC: selectedVC, urlPostfixStr: addCardAPI, method: .post, parameter: requestParameters as [String : AnyObject], Alert : true, callback: callback)
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
