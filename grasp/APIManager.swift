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
    
    func retrieveTutors (success: @escaping (_ tutors: [Tutor]) -> Void) {
        Alamofire.request("https://pure-mountain-47946.herokuapp.com/tutor").responseJSON { response in
            if let json = response.result.value as? NSArray {
                var listOfTutors = [Tutor]()
                for case let tutorJson as Dictionary<String, Any> in json {
                    let tutor = Tutor(jsonDict: tutorJson)
                    listOfTutors.append(tutor)
                }
                success(listOfTutors)
            }
        }
    }
}
