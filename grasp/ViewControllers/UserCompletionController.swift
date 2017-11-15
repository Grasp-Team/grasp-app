//
//  UserCompletionController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-13.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class UserCompletionController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var programTextField: UITextField!
    @IBOutlet weak var yearSegmentedControl: UISegmentedControl!
    
    var email_address : String?
    var password : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UserProfileViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func finishRegistration() {
        guard let email_address = self.email_address, let password = self.password else {
            debugPrint("signup info not passed properly")
            return
        }
        let first_name = firstNameTextField.text ?? ""
        let last_name = lastNameTextField.text ?? ""
        let program = programTextField.text ?? ""
        let year = yearSegmentedControl.selectedSegmentIndex + 1
        
//        private String email;
//        private String password;
//        private String firstName;
//        private String lastName;
//        private int year;
//        private String program;
//        private String faculty;
        
        let user_info : [String: Any] = [
            "email" : email_address,
            "password" : password,
            "firstName" : first_name,
            "lastName" : last_name,
            "year" : year,
            "program" : program,
            "faculty" : "",
        ]
        
        if (first_name.isEmpty || last_name.isEmpty || program.isEmpty) {
            errorLabel.text = "Fill in Completely"
            errorLabel.isHidden = false
        } else{
            errorLabel.isHidden = true
            APIManager.sharedInstance.registerUser(user_info: user_info) {
                user_data in
                if let _ = user_data["id"] as? String {
                    APIManager.sharedInstance.getToken(username: email_address, password: password) {
                        token in
                        KeyChainManager.sharedInstance.storeValueFor("token", value: token)
                        User.sharedInstance.updateUser(user_data: user_data)
                        User.sharedInstance.login_email = email_address
                        self.appDelegate.openMainFeed()
                    }
                }
            }
        }
    }

}
