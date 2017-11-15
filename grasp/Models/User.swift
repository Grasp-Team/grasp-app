//
//  User.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-13.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import Foundation

class User {
    static let sharedInstance = User()
    
    var login_email : String
    
    var id : String
    var first_name : String
    var last_name : String
    var email : String
    var year : Int
    var program : String
    var faculty : String
    var userType : String
    var userRole : String
    var tutors : NSArray
    
    private init () {
        id = ""
        first_name = ""
        last_name = ""
        email = ""
        year = -1
        program = ""
        faculty = ""
        userType = ""
        userRole = ""
        tutors = NSArray()
        
        login_email = ""
    }
    
    func updateUser(user_data : [String: Any]) {
        id = user_data["id"] as? String ?? ""
        first_name = user_data["firstName"] as? String ?? ""
        last_name = user_data["lastName"] as? String ?? ""
        email = user_data["email"] as? String ?? ""
        year = user_data["year"] as? Int ?? -1
        program = user_data["program"] as? String ?? ""
        faculty = user_data["faculty"] as? String ?? ""
        userType = user_data["userType"] as? String ?? ""
        userRole = user_data["userRole"] as? String ?? ""
        tutors = NSArray()
    }
}
