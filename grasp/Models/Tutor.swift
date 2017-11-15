//
//  Tutor.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import Foundation

class Tutor {
 
    var id : String
    var firstName : String
    var lastName : String
    var email : String
    var program: String
    var year: Int
    
    init(jsonDict: Dictionary<String, Any>) {
        self.id = jsonDict["id"] as? String ?? ""
        self.firstName = jsonDict["firstName"] as? String ?? "ERROR"
        self.lastName = jsonDict["lastName"] as? String ?? "ERROR"
        self.email = jsonDict["email"] as? String ?? "ERROR"
        self.program = jsonDict["program"] as? String ?? "ERROR"
        self.year = jsonDict["year"] as? Int ?? -1
    }
}
