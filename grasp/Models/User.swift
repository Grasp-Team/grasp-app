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
    var courses : [Course]
    
    //userType: "TUTOR"
    
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
        courses = [Course]()
        
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
        
        self.courses = [Course]()
        if let courses = user_data["tutors"] as? NSArray {
            for case let course as NSDictionary in courses {
                if let courseCatalogDict = course["courseCatalog"] as? [String: Any] {
                    let course = Course(jsonDict: courseCatalogDict)
                    self.courses.append(course)
                }
            }
        }
    }
    
    func updateUserExceptCourses(user_data : [String: Any]) {
        id = user_data["id"] as? String ?? ""
        first_name = user_data["firstName"] as? String ?? ""
        last_name = user_data["lastName"] as? String ?? ""
        email = user_data["email"] as? String ?? ""
        year = user_data["year"] as? Int ?? -1
        program = user_data["program"] as? String ?? ""
        faculty = user_data["faculty"] as? String ?? ""
        userType = user_data["userType"] as? String ?? ""
        userRole = user_data["userRole"] as? String ?? ""
    }
    
    func updateUserCourses(user_data: [String: Any]) {
        self.courses = [Course]()
        if let courses = user_data["tutors"] as? NSArray {
            for case let course as NSDictionary in courses {
                if let courseCatalogDict = course["courseCatalog"] as? [String: Any] {
                    let course = Course(jsonDict: courseCatalogDict)
                    self.courses.append(course)
                }
            }
        }
    }
    
    func isTutor() -> Bool {
        if userType == "TUTOR" {
            return true
        } else {
            return false
        }
    }
    
    func unregisterAsTutor() {
        userType = "STANDARD"
    }
    
    func alreadyTutoring(course: Course) -> Bool {
        for course_tutoring in courses {
            if course_tutoring.code == course.code {
                return true
            }
        }
        return false
    }
    
    func addCourse(course: Course) {
        courses.append(course)
    }
    
    func removeCourse(courseCode: String) {
        for (index, course_tutoring) in courses.enumerated() {
            if course_tutoring.code == courseCode {
                self.courses.remove(at: index)
            }
        }
    }
}
