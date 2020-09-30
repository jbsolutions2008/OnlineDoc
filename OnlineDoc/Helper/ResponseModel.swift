//
//  ResponseModel.swift
//  Nasty Rick
//
//  Created by JBSolutions's iMac on 30/12/19.
//

import Foundation

enum GameState:String {
    case open = "open"
    case ended = "ended"
    case active = "active"
}

enum PlayerState:String {
    case active = "active"
    case inactive = "inactive"
}

enum RoundState:String {
    
    case active = "active"
    case judging = "judging"
    case ended = "ended"
}

struct AuthUser {
   
    let Email : String
    let Mobile : String
    let Name : String
    var UserId : Int = 0
    var UserType : Int = 0
    
    
    init(dict: [String : AnyObject]) {
        self.Email = dict["Email"] as? String ?? ""
        self.Mobile = dict["Mobile"] as? String ?? ""
        self.Name = dict["Name"] as? String ?? ""
        if let userType = dict["UserType"] {
            self.UserType = userType as? Int ?? 0
        }
        
        if self.UserType == 0 {
            self.UserType = Int(dict["UserType"] as? String ?? "0")!
        }
       
        if let userId = dict["UserId"] {
            self.UserId = userId as? Int ?? 0
        }
        
        if self.UserId == 0 {
            self.UserId = Int(dict["UserId"] as? String ?? "0")!
        }
    }
}

struct Consultation {
   
    let ID : String
    let name : String
    let duration : String
    let price : String
    let note : String
    
    
    init(dict: [String : AnyObject]) {
        self.ID = dict["ID"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.duration = dict["duration"] as? String ?? ""
        self.price = dict["price"] as? String ?? ""
        self.note = dict["note"] as? String ?? ""
    }
}

struct Booking {
   
    let tbl_session_id : String
    let session_id : String
    let session_name : String
    let start_time : String
    let end_time : String
    let tbl_participant_id : String
    let client_id : String
    let entry_url : String
    let name : String
    var otherName : String
    let role : String
    let appointment_id : String
    let payment_status_id : String
    
    
    
    init(dict: [String : AnyObject]) {
        self.tbl_session_id = dict["tbl_session_id"] as? String ?? ""
        self.session_id = dict["session_id"] as? String ?? ""
        self.session_name = dict["session_name"] as? String ?? ""
        self.start_time = dict["start_time"] as? String ?? ""
        self.end_time = dict["end_time"] as? String ?? ""
        self.tbl_participant_id = dict["tbl_participant_id"] as? String ?? ""
        self.client_id = dict["client_id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.entry_url = dict["entry_url"] as? String ?? ""
        self.otherName = dict["otherName"] as? String ?? ""
        self.role = dict["role"] as? String ?? ""
        self.appointment_id = dict["appointment_id"] as? String ?? ""
        self.payment_status_id = dict["payment_status_id"] as? String ?? ""
    }
}





struct Doctor {
   
    let id : String
    let name : String
    let language : String
    let gender : String
    
    
    
    init(dict: [String : AnyObject]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.language = dict["language"] as? String ?? ""
        self.gender = dict["gender"] as? String ?? ""
        
    }
}

struct User {
    let _id : String
    let confirmed : Bool
    let blocked : Bool
    let email : String
    let username : String
    let provider : String
    var avatar : String
    var games_won : Int
    var isJudge : Bool
    var score : Int
    var winner : Bool
    var whitecards : [WhiteCard] = []
    var ownedDecks : [AnyObject] = []
    var ownedDeckIds : [AnyObject] = []
    
    
    init( dict: [String : AnyObject]) {
        let dict1 = RDGlobalFunction.removeNullFromDict(dict: dict)
        self._id = dict1["_id"] as? String ?? ""
        self.confirmed = dict1["confirmed"] as? Bool ?? false
        self.blocked = dict1["blocked"] as? Bool ?? false
        self.email = dict1["email"] as? String ?? ""
        self.username = dict1["username"] as? String ?? ""
        self.provider = dict1["provider"] as? String ?? ""
        self.avatar =  ""
        if let avatarDict = dict1["avatar"], avatarDict is [String:AnyObject] {
            self.avatar = avatarDict["url"] as! String
        }
        
        if let purchased_decks = dict1["purchased_decks"] {
            self.ownedDecks = purchased_decks as! [AnyObject]
        }
        
        if let decks = dict1["decks"] {
            ownedDeckIds = (decks as! [[String:AnyObject]]).map{$0["id"]!}
        }
        self.games_won = dict1["games_won"] as? Int ?? 0
        self.score = dict1["score"] as? Int ?? 0
        self.isJudge = dict1["isJudge"] as? Bool ?? false
        self.winner = dict1["winner"] as? Bool ?? false
        
        if let arr = dict1["whitecards"]  {
            for item in arr as! NSArray {
                let card = WhiteCard.init(dict: item as! [String:AnyObject])
                self.whitecards.append(card)
            }
        }
     }
}

struct Game {
    var state : String
    var _id : String
    var code : String
    var players : [User] = []
    var currentRound : GameRound = GameRound.init(dict: [:])
    
    init(dict:[String:AnyObject]) {
        self._id = dict["_id"] as? String ?? ""
        self.code = dict["code"] as? String ?? ""
        self.state = dict["state"] as? String ?? GameState.open.rawValue
        for item in dict["players"] as! NSArray {
            let player = User.init(dict: item as! [String:AnyObject])
            self.players.append(player)
        }
        if dict["current_round"] != nil {
            self.currentRound = GameRound.init(dict: dict["current_round"] as! [String:AnyObject])
        }
    }
}

struct Player {
    var score : Int
    var inactive_rounds : Int
    var cardsdealt : Int
    var user : String
    var state : String
    
    init(dict:[String:AnyObject]) {
        self.inactive_rounds = dict["inactive_rounds"] as? Int ?? 0
        self.cardsdealt = dict["cardsdealt"] as? Int ?? 0
        self.score = dict["score"] as? Int ?? 0
        self.user = dict["user"] as? String ?? ""
        self.state = dict["state"] as? String ?? PlayerState.active.rawValue
    }
}

struct WhiteCard {
   
    let _id : String
    let is_special : Bool
    let text : String
    let deck_name : String
    
    
    init(dict: [String : AnyObject]) {
        self._id = dict["id"] as? String ?? ""
        self.is_special = dict["is_special"] as? Bool ?? false
        self.text = dict["text"] as? String ?? ""
        self.deck_name = dict["deck_name"] as? String ?? ""
     }
}

struct BlackCard {
   
    let _id : String
    let answer_count : Int
    let text : String
    
    init(dict: [String : AnyObject]) {
        self._id = dict["id"] as? String ?? ""
        self.answer_count = dict["answer_count"] as? Int ?? 0
        self.text = dict["text"] as? String ?? ""
     }
}

struct GameRound {
//   "timer": 0,
//        "start_timestamp": 1578652549687,
//        "round_number": 1,
//        "judge": "itsneel",
//        "state": "open",
//        "blackcard": {
//           "id": "5e185302076e7e454ebb431b",
//           "text": "The next ice cream flavor from Ben & Jerry's is ___.",
//           "answer_count": 1
//        }
//     }
    let start_timestamp : Double
    let timer : Int
    let round_number : Int
    let judge : String
    var state : String
    var submissions : [Submission] = []
    var blackcard : BlackCard = BlackCard.init(dict: [:])
    
    
    init(dict: [String : AnyObject]) {
        self.start_timestamp = dict["start_timestamp"] as? Double ?? 0.0
        self.timer = dict["timer"] as? Int ?? 0
        self.round_number = dict["round_number"] as? Int ?? 0
        self.judge = dict["judge"] as? String ?? ""
        self.state = dict["state"] as? String ?? ""
        
        if let blackcardDict = dict["blackcard"] {
            self.blackcard = BlackCard.init(dict: blackcardDict as! [String : AnyObject])
        }
        
        if let submissionArray = dict["submissions"] {
            for item in submissionArray as! NSArray {
                self.submissions.append(Submission.init(dict: item as! [String:AnyObject]))
            }
        }
     }
}

struct Submission {
   
    let _id : String
    var whiteCards : [WhiteCard]  = []
    let username : String
    var selectedAsWinner : Bool
    
    init(dict: [String : AnyObject]) {
        self._id = dict["id"] as? String ?? ""
        for item in dict["whitecards"] as! NSArray {
            self.whiteCards.append(WhiteCard.init(dict: item as! [String:AnyObject]))
        }
        self.username = dict["username"] as? String ?? ""
        self.selectedAsWinner = dict["selected"] as? Bool ?? false
     }
}

struct Deck {
   
    let id : String
    let deckoftheweek : Bool
    var cards : [CardInfo] = []
    var previewCards : [CardInfo] = []
    let name : String
    let description : String
  //  var cover : String
    var url : String
    
    
    init( dict: [String : AnyObject]) {
        let dict1 = RDGlobalFunction.removeNullFromDict(dict: dict)
        self.id = dict1["id"] as? String ?? ""
        self.name = dict1["name"] as? String ?? ""
        self.description = dict1["description"] as? String ?? ""
        self.url =  ""
        self.deckoftheweek = dict1["deckoftheweek"] as? Bool ?? false
        if let avatarDict = dict1["cover"], avatarDict is [String:AnyObject] {
            self.url = avatarDict["url"] as! String
        }
      
        if let arr = dict1["whitecards"]  {
            for item in arr as! NSArray {
                let card = CardInfo.init(dict: item as! [String:AnyObject])
                self.cards.append(card)
                
                if card.previewable {
                    previewCards.append(card)
                }
            }
        }
     }
}

struct CardInfo {
   
    let _id : String
    let text : String
    let previewable : Bool
    
    init(dict: [String : AnyObject]) {
        self._id = dict["id"] as? String ?? ""
        self.previewable = dict["previewable"] as? Bool ?? false
        self.text = dict["text"] as? String ?? ""
     }
}
