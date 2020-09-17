//
//  Users.swift
//  M.M.Fayik-COBSCCOMP191P-035
//
//  Created by Fayik Muzammil on 8/26/20.
//  Copyright © 2020 Fayik Muzammil. All rights reserved.
//

import CoreLocation

enum AccountType: Int {
    case Student
    case Staff
}

struct Users {
    let fullName: String
    let email: String
    let address: String
    var accountType: AccountType!
    var location: CLLocation?
    let uid: String
  //  let temp: Int
    let survey: Int
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.address = dictionary["address"] as? String ?? ""
       // self.temp = dictionary["bodyTemperature"] as? Int ?? 0
        self.survey = dictionary["surveyWeight"] as? Int ?? 0
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
