//
//  LoginViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    @IBOutlet weak var errorMessageLabel : UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessageLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func login() {
        
        //show loader
        
        let email_address = emailAddressTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        APIManager.sharedInstance.getToken(username: email_address, password: password) {
            token in
            if (!token.isEmpty) {
                self.errorMessageLabel.isHidden = true
                
                KeyChainManager.sharedInstance.storeValueFor("token", value: token)
                User.sharedInstance.login_email = email_address
                self.appDelegate.openMainFeed()
                
            } else {
                self.errorMessageLabel.isHidden = false
            }
        }
    }
    
}
