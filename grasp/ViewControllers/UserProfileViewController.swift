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
    @IBOutlet weak var yearSegmentedControl : UISegmentedControl!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UserProfileViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func logout (_ sender: UIButton) {
        KeyChainManager.sharedInstance.deleteValueFor("token")
        appDelegate.openInitialScreen()
    }
    
}
