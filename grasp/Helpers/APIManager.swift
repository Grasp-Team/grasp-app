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
            "query": query,
            "exclude": User.sharedInstance.id
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
    
    func updateTutorCourses(tutoringInfo: [String: Any], success: @escaping (_ user_data: [String: Any]) -> Void) {
    
        let requestURL: String = baseURL + "/tutor/course/" + User.sharedInstance.id
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
    
    func unregisterAsTutor(success: @escaping (_ user_data: [String: Any]) -> Void) {
    
        let requestURL: String = baseURL + "/tutor/" + User.sharedInstance.id
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, method: .delete, headers: headers)
    }
    
    func initiateContactRequest(tutorId: String, success: @escaping (_ relationship: String) -> Void) {
    
        let requestURL: String = baseURL + "/relationship"
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        let parameters : [String: String] = [
            "tutorId": tutorId,
            "userId": User.sharedInstance.id,
            "relationshipStatus": Constants.RelationshipStatus.pending.rawValue
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value as? NSDictionary {
                let relationshipStatus = json["relationshipStatus"] as? String ?? ""
                success(relationshipStatus)
                return
            }
        }
        
    }
    
    func checkTutorRelationship(tutorId: String, success: @escaping (_ relationship: String) -> Void) {
    
        let requestURL: String = baseURL + "/relationship/status"
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "tutorId": tutorId,
            "userId": User.sharedInstance.id
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if (statusCode == 404) {
                    success("")
                    return
                }
            }
            if let json = response.result.value as? NSDictionary {
                let relationshipStatus = json["relationshipStatus"] as? String ?? ""
                success(relationshipStatus)
                return
            }
        }
    }
    
    func retrieveRelationshipsFor(status: String, success: @escaping (_ relationships: [Relationship]) -> Void) {
        
        let requestURL: String = baseURL + "/relationship/tutor/" + User.sharedInstance.id
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                if let relationshipJSON = json["userRelationshipList"] as? NSArray {
                    var relationships = [Relationship]()
                    for case let relationship as [String: Any] in relationshipJSON {
                        if relationship["relationshipStatus"] as? String == status {
                            let relationshipModel = Relationship(jsonDict: relationship)
                            relationships.append(relationshipModel)
                        }
                    }
                    success(relationships)
                }
            }
        }
    }
    
    func retrieveUsersFromRelationships(relationships: [Relationship], success: @escaping (_ success: Bool, _ tutors: [Tutor]) -> Void) {
    
        var userIds = [String]()
        for relationship in relationships {
            userIds.append(relationship.userId)
        }
        
        let requestURL: String = baseURL + "/user"
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        let parameters : [String: [String]] = [
            "users": userIds
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let json = response.result.value as? NSDictionary {
                if let tutorsJSON = json["users"] as? NSArray {
                    var listOfTutors = [Tutor]()
                    for case let tutorJson as Dictionary<String, Any> in tutorsJSON {
                        let tutor = Tutor(jsonDict: tutorJson)
                        listOfTutors.append(tutor)
                    }
                    success(true, listOfTutors)
                }
            }
        }
    }
    
    func relationshipAccepted(relationshipId: Int, success: @escaping (_ success: Bool) -> Void) {
    
        let requestURL: String = baseURL + "/relationship/" + String(relationshipId)
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        let parameters : [String: String] = [
            "relationshipStatus": Constants.RelationshipStatus.accepted.rawValue
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            if let _ = response.result.value {
                success(true)
            }
        }
    }
    
    func deleteRelationship(relationshipId: Int, success: @escaping (_ success: Bool) -> Void) {
    
        let requestURL: String = baseURL + "/relationship/" + String(relationshipId)
        let apiToken = KeyChainManager.sharedInstance.retrieveValueFor("token")
        let headers: HTTPHeaders = [
            "API-TOKEN": apiToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(requestURL, method: .delete, headers: headers).responseJSON {
            response in
            success(true)
        }
    }
    
}
