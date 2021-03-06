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
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var coursesTableView: UITableView!
    @IBOutlet weak var connectButton: UIButton!
    var tutor: Tutor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tutor = self.tutor {
            self.navigationItem.title = tutor.firstName + " " + tutor.lastName
            self.userInfoLabel.text = tutor.program + " Year \(tutor.year)"
            checkRelationship(tutor: tutor)
            self.coursesTableView.delegate = self
            self.coursesTableView.dataSource = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func checkRelationship(tutor: Tutor) {
        APIManager.sharedInstance.checkTutorRelationship(tutorId: tutor.id) {
            relationship in
            switch (relationship) {
            case Constants.RelationshipStatus.accepted.rawValue:
                self.emailLabel.text = tutor.email
                self.connectButton.isHidden = true
                self.connectButton.isUserInteractionEnabled = false
                break
            case Constants.RelationshipStatus.pending.rawValue:
                self.emailLabel.text = "Request to Connect"
                self.connectButton.titleLabel?.textColor = UIColor.darkGray
                self.connectButton.titleLabel?.text = "Pending"
                self.connectButton.isUserInteractionEnabled = false
                self.connectButton.isHidden = false
                break
            default:
                self.emailLabel.text = "Request to Connect"
                self.connectButton.titleLabel?.textColor = .white
                self.connectButton.titleLabel?.text = "Connect"
                self.connectButton.isUserInteractionEnabled = true
                self.connectButton.isHidden = false
                break
            }
        }
    }
    
    @IBAction func contactRequest(_ sender: UIButton) {
        if let tutor = self.tutor {
            APIManager.sharedInstance.initiateContactRequest(tutorId: tutor.id) {
                relationship in
                switch (relationship) {
                case Constants.RelationshipStatus.accepted.rawValue:
                    self.emailLabel.text = tutor.email
                    self.connectButton.isHidden = true
                    self.connectButton.isUserInteractionEnabled = false
                    break
                case Constants.RelationshipStatus.pending.rawValue:
                    self.emailLabel.text = "Request to Connect"
                    self.connectButton.titleLabel?.textColor = UIColor.darkGray
                    self.connectButton.titleLabel?.text = "Pending"
                    self.connectButton.isUserInteractionEnabled = false
                    self.connectButton.isHidden = false
                    break
                default:
                    self.emailLabel.text = "Request to Connect"
                    self.connectButton.titleLabel?.textColor = .white
                    self.connectButton.titleLabel?.text = "Connect"
                    self.connectButton.isUserInteractionEnabled = true
                    self.connectButton.isHidden = false
                    break
                }
            }
        }
    }

}

extension TutorProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tutor = self.tutor else {
            print("Error")
            return 0
        }
        return tutor.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CourseCell = coursesTableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseCell
        
        guard let tutor = self.tutor else {
            print("Error")
            return cell
        }
        
        let course : Course = tutor.courses[indexPath.row]
        cell.courseLabel.text = course.code + ": " + course.course_name
        return cell
    }
    
}
