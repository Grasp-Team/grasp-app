//
//  CourseTutorCell.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-16.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

protocol CourseTutorCellDelegate {
    func courseRemoved()
}

class CourseTutorCell: UITableViewCell {
    
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate : CourseTutorCellDelegate?
    var courseCode: String = ""
    
    @IBAction func removeCourse(_ sender: UIButton) {
        if let delegate = delegate {
            User.sharedInstance.removeCourse(courseCode: courseCode)
            delegate.courseRemoved()
        }
    }
}
