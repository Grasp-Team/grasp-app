//
//  TutorProfileViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class TutorProfileViewController: UIViewController {

    @IBOutlet weak var tutorProfileImageView: UIImageView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    var tutor: Tutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tutor = self.tutor {
            self.navigationItem.title = tutor.firstName + " " + tutor.lastName
            self.yearLabel.text = "Year " + String(tutor.year)
            self.programLabel.text = tutor.program
            self.emailLabel.text = tutor.email
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
