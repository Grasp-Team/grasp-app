//
//  RegistrationController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-13.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class RegistrationController: UIViewController {
    
    @IBOutlet weak var registrationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    //continueRegistration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorEmailLabel.isHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(RegistrationController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "continueRegistration") {
            if let signUpInfo = sender as? [String: String] {
                let destinationVC: UserCompletionController = segue.destination as! UserCompletionController
                destinationVC.email_address = signUpInfo["email_address"]
                destinationVC.password = signUpInfo["password"]
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func continueRegistration(_ sender: UIButton) {
        let email_address = registrationTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if (password.isEmpty) {
            return
        }
        let signUpInfo : [String: String] = [
            "email_address" : email_address,
            "password" : password,
        ]
        APIManager.sharedInstance.isEmailAddressInUse(email_address: email_address) {
            in_use in
            if (in_use) {
                self.errorEmailLabel.isHidden = false
            } else {
                self.errorEmailLabel.isHidden = true
                self.performSegue(withIdentifier: "continueRegistration", sender: signUpInfo)
            }
        }
    }
}
