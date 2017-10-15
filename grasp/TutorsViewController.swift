//
//  TutorsViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class TutorsViewController: UIViewController {

    @IBOutlet weak var tutorsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorsTableView.delegate = self
        self.tutorsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension TutorsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TutorCell = tutorsTableView.dequeueReusableCell(withIdentifier: "tutorCell", for: indexPath) as! TutorCell
        
        if (indexPath.row % 2 == 0) {
            cell.nameLabel.text = "Joe Smith"
            cell.profileImageView.image = UIImage(named: "default_user_icon")
        } else {
            cell.nameLabel.text = "Sally Jane"
            cell.profileImageView.image = UIImage(named: "default_user_icon")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showTutor", sender: nil)
        
    }
    
    
}
