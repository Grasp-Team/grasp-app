//
//  Relationship.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import Foundation

class Relationship {
    
    var relationshipId : Int
    var tutorId: String
    var userId: String
    var relationshipStatus: String
    
    init(jsonDict: Dictionary<String, Any>) {
        self.relationshipId = jsonDict["id"] as? Int ?? -1
        self.tutorId = jsonDict["tutorId"] as? String ?? ""
        self.userId = jsonDict["userId"] as? String ?? ""
        self.relationshipStatus = jsonDict["relationshipStatus"] as? String ?? ""
    }
}
