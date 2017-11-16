//
//  Course.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import Foundation

class Course {
    
    var code: String
    var course_name: String
    var description: String
    
    init(jsonDict: Dictionary<String, Any>) {
        self.code = jsonDict["code"] as? String ?? ""
        self.course_name = jsonDict["courseName"] as? String ?? ""
        self.description = jsonDict["description"] as? String ?? ""
    }
}
