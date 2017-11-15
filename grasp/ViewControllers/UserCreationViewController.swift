//
//  UserCreationViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class UserCreationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
