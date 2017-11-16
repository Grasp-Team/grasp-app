//
//  APIManager.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import Alamofire

class APIManager {
    static let sharedInstance = APIManager()
    let baseURL = "https://grasp-uwaterloo.herokuapp.com"
    
    func isEmailAddressInUse (email_address: String, success: @escaping (_ in_use: Bool) -> Void) {
        
        let requestURL: String = baseURL + "/public/user/email/" + email_address
        
        Alamofire.request(requestURL).responseJSON {
            response in
            var is_email_in_use = true
            if let json = response.result.value as? NSDictionary {
                if let in_use = json["inUse"] as? Bool {
                    is_email_in_use = in_use
                    success(is_email_in_use)
                }
            }
            success(is_email_in_use)
        }
    }
    
    func registerUser (user_info: [String: Any], success: @escaping (_ user_data: [String: Any]) -> Void) {
        
        let requestURL: String = baseURL + "/user/signup"
        
        Alamofire.request(requestURL, method: .post, parameters: user_info, encoding: JSONEncoding.default).responseJSON {
            response in
            if let json = response.result.value as? [String: Any] {
                success(json)
            } else {
                success([String : Any]())
            }
        }
        
    }
    
    func getToken(username: String, password: String, success: @escaping (_ token: String) -> Void) {
        
        let requestURL: String = baseURL + "/authenticate"
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if let json = response.result.value as? [String: String] {
                if let token = json["apiToken"] as? String {
                    success(token)
                }
            } else {
                success("")
            }
        }
    }
    
    func getUserInfoFrom(email_address: String, success: @escaping (_ user_data: [String: Any]) -> Void) {
        
        let requestURL: String = baseURL + "/user/email/" + email_address
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                success(json)
            } else {
                success([String : Any]())
            }
        }
        
    }
    
    func retrieveTutors (success: @escaping (_ tutors: [Tutor]) -> Void) {
        
        let userId = User.sharedInstance.id
        let requestURL: String = baseURL + "/search/" + userId
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers).responseJSON { response in
            if let json = response.result.value as? NSDictionary {
                if let tutorsJSON = json["users"] as? NSArray {
                    var listOfTutors = [Tutor]()
                    for case let tutorJson as Dictionary<String, Any> in tutorsJSON {
                        let tutor = Tutor(jsonDict: tutorJson)
                        listOfTutors.append(tutor)
                    }
                    success(listOfTutors)
                }
            }
        }
    }
    
    func searchTutors (query: String, success: @escaping (_ tutors: [Tutor]) -> Void) {
        
        let requestURL: String = baseURL + "/search"
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        let parameters = [
            "query": query
        ]
        
        Alamofire.request(requestURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            
            if let json = response.result.value as? NSDictionary {
                if let tutorsJSON = json["users"] as? NSArray {
                    var listOfTutors = [Tutor]()
                    for case let tutorJson as Dictionary<String, Any> in tutorsJSON {
                        let tutor = Tutor(jsonDict: tutorJson)
                        listOfTutors.append(tutor)
                    }
                    success(listOfTutors)
                }
            }
        }
    }
    
    func updateUserInfo(updated_info: [String: Any], success: @escaping (_ user_data: [String: Any]) -> Void) {
        
        let requestURL: String = baseURL + "/user/" + User.sharedInstance.id
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: updated_info, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if let json = response.result.value as? [String: Any] {
                success(json)
            } else {
                success([String : Any]())
            }
        }
    }
    
    func getCourseInfo(course_code: String, success: @escaping (_ success: Bool, _ course_data: [String: Any]) -> Void) {
    
        let requestURL: String = baseURL + "/courseCatalog/code/" + course_code
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers).responseJSON { response in
            if let json = response.result.value as? NSDictionary {
                if let code = json["code"] {
                    let course_data : [String: Any] = [
                        "code": code,
                        "courseName": json["courseName"],
                        "description": json["description"]
                    ]
                    success(true, course_data)
                } else {
                    success(false, [String: Any]())
                }
            }
        }
    }
    
    func convertToTutor(tutoringInfo: [String: Any], success: @escaping (_ user_data: [String: Any]) -> Void) {
        
        let requestURL: String = baseURL + "/tutor"
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: tutoringInfo, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if let json = response.result.value as? [String: Any] {
                success(json)
            } else {
                success([String : Any]())
            }
        }
        
    }
    
}
