//
//  LoginViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class InitialScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func button() {
        //KeyChainManager.sharedInstance.storeValueFor("token", value: "123")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openMainFeed()
    }
    
}
