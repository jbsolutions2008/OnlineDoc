//
//  RDDataEngineClass.swift
//  RhythmCor
//
//  Created by Renish Dadhaniya on 10/10/18.
//  Copyright © 2018 GlobeSyncTechnologies - Renish Dadhaniya. All rights reserved.
//

import UIKit


let APPDEVELOPMENTURL = "https://www.doctoronline365.com.au/coviu_api/v1/"
let APPPRODUCTIONRL = "" //PRODUCTION

let APPDEVELOPMENTIMAGEURL = "http://api.nastyrick.com"
let APPDPRODUCTIONIMAGEURL = "http://weatheracco.web808.discountasp.net/api/"

let API_PREFIX = "https://weatheraccommodation.com/"

//App iTunes URl
let APPSTOREURL = "https://apps.apple.com/us/app/nasty-rick/id1467712163"

let APPFULLNAME = "ONLINE DOCTOR"
let APPSHORTNAME = "ONLINE DOCTOR"

let SUCCESSCODE = 1
let NOTVERIFIEDCODE = 2


class RDDataEngineClass: NSObject {
    
    static let ApplicationBaseURL = APPDEVELOPMENTURL
    static let ApplicationImageBaseURL = APPDEVELOPMENTIMAGEURL
    
    static let Stripe_Publishkey = "pk_live_txXnFS256T5orfTCaFia4dAm00dInCOmR2"
    
    //Response Status Value
    static let iSSuccssValue : NSInteger = 1

    //APP ENVIRONMENT
    static let sandbox = "sandbox"
    static let production = "production"
    
    //FONT NAME
    static let proximaFontDefault : String = "Roboto-Regular"
    static let proximaFontBold : String = "ProximaNova-Bold"
    static let proximaFontBlack : String = "ProximaNova-Black"
    static let proximaFontLight : String = "Roboto-Italic"
    static let proximaFontMedium : String = "Roboto-Medium"
    
    static let bebasFontDefault : String = "Bebas"
    static let montserratFontLight : String = "Montserrat-Light"
    static let montserratFontMedium : String = "Montserrat-Medium"
    static let montserratFontSemiBold : String = "Montserrat-SemiBold"
    static let montserratFontBold : String = "MontserratAlternates-Bold"

    
    //APP THEME COLOR
    static let primaryColorGreen : UIColor = UIColor(named: "PrimaryColorGreen")!
    static let SecondaryColorBlue : UIColor = UIColor(named: "SecondaryColorBlue")!
    static let primaryColorDark : UIColor = UIColor(named: "PrimaryColorDark")!
   // static let primaryTextColor : UIColor = UIColor(named: "PrimaryTextColor")!
   // static let primarySuccessColor : UIColor = UIColor(named: "PrimarySuccessColor")!
   // static let primaryErrorColor : UIColor = UIColor(named: "PrimaryErrorColor")!
    
    //App Identity Key
    static let deviceAppUUID : String = "DeviceAppUUID"
    
    //USER FLAG
    static let userProfileInfoDef : String = "UserProfileInfoAppDefault" //Store User Info
    static let iSUerActivated : String = "iSUserSuccessfullyActivatedInAppDef"
    static let iSIntroLaunched : String = "introLaunched"
    static let hasPlayedWithPremium : String = "premiumdeck"
    
    static let userEmailDef : String = "UserEmail"
    static let userInfoDef : String = "StoreUserInfoInDefault"
    
    
    //Predifine Contents
    static let shareTextHeader = "Use this code in the Nasty Rick App to join a game - "
    
    static let loadingStr = "Loading..."
    static let syncingStr = "  Syncing...  "
    static let blanckDataStr = "---"
    
    static let BTAError = "OOPS!"
    
    //validator length
    static let minUsernameLength = 3
    static let maxUsernameLength = 20
    static let minPasswordLength = 5
    
    
    //Store Bool Key and Value in Default for User Active - REMEMBER USER
    class func setBoolValueInUserDefaultForUserActiveInDevice(iSDefaultValue : Bool) -> Bool {
        UserDefaults.standard.set(iSDefaultValue, forKey: self.iSUerActivated)
        UserDefaults.standard.synchronize()
        
        return UserDefaults.standard.value(forKey: self.iSUerActivated) as? Bool ?? false
    }
  
}//Class End

class UserProfileKey {
    static let Email = "Email"
    static let ProviderId = "ProviderId"
    static let ClientId = "ClientId"
    static let Phone = "MobileNumber"
    static let Name = "Name"
}

struct Trip_Status {
    static let Accepted = "trip_accepted"
    static let cancelled = "trip_cancelled"
    
}

struct Request_Status {
    static let Requested = "requested"
    static let Cancelled = "cancelled"
    static let Reached = "reached"
    static let Started = "Trip_Started"
    static let Ended = "Trip_Ended"
}

struct Numeric_TripStatus {
    static let started = "7"
    static let ended = "8"
}

struct Numeric_Usercode {
    static let client = "14"
    static let provider = "15"
}

struct NotificationType {
    static let ProviderRequstReceived = "Request Received" //show request UI in provider
    static let ClientAcceptRequest = "Request Accpted" //show bottomsheet in client
    static let ClientReachRequest = "Request Reached" //navigate to trip UI
}

struct CancellationReasonCode {
    static let NoReason = "0"
    static let NoShow = "16"
    static let NoReply = "17"
}


