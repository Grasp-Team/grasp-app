//
//  Constants.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-20.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class Constants {
    // ACCEPTED, REJECTED or PENDING
    enum RelationshipStatus: String {
        case accepted = "ACCEPTED"
        case rejected = "REJECTED"
        case pending = "PENDING"
    }
    
    struct Colors {
        static let blueTheme = UIColor(red:0.36, green:0.44, blue:1.0, alpha:1.0)
    }
    
}
