//
//  UserProfileViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tutorSwitch: UISwitch!
    @IBOutlet weak var programTextField: UITextField!
    @IBOutlet weak var yearSegmentedControl: UISegmentedControl!
    @IBOutlet weak var selectCoursesButton: UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        tutorSwitch.addTarget(self, action: #selector(tutorSwitchChanged), for: UIControlEvents.valueChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UserProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tutorSwitch.isOn = User.sharedInstance.isTutor()
        selectCoursesButton.isEnabled = tutorSwitch.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initProfileInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initProfileInfo() {
        self.firstNameTextField.text = User.sharedInstance.first_name
        self.lastNameTextField.text = User.sharedInstance.last_name
        self.emailTextField.text = User.sharedInstance.email
        self.programTextField.text = User.sharedInstance.program
        self.yearSegmentedControl.selectedSegmentIndex = User.sharedInstance.year-1
    }
    
    func convertToTutor() {
        var courseCodes = [String]()
        for course in User.sharedInstance.courses {
            courseCodes.append(course.code)
        }
        
        let tutoringInfo: [String: Any] = [
            "userId": User.sharedInstance.id,
            "courseCodes": courseCodes
        ]
        
        APIManager.sharedInstance.convertToTutor(tutoringInfo: tutoringInfo) {
            user_data in
            User.sharedInstance.updateUser(user_data: user_data)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func logout() {
        KeyChainManager.sharedInstance.deleteValueFor("token")
        appDelegate.openInitialScreen()
    }
    
    @objc func tutorSwitchChanged() {
        selectCoursesButton.isEnabled = tutorSwitch.isOn
    }
    
    @IBAction func selectCourses(_ sender: UIButton) {
        if (!tutorSwitch.isOn) {
            return
        } else {
            performSegue(withIdentifier: "selectCourses", sender: nil)
        }
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let program = programTextField.text ?? ""
        let year = yearSegmentedControl.selectedSegmentIndex + 1
        
        let updated_info : [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "program": program,
            "year": year
        ]
        
        APIManager.sharedInstance.updateUserInfo(updated_info: updated_info) {
            user_data in
            User.sharedInstance.updateUser(user_data: user_data)
            if (self.tutorSwitch.isOn) {
                self.convertToTutor()
            }
        }
    }
    
}
