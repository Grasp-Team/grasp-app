//
//  TutorsViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TutorsViewController: UIViewController {

    @IBOutlet weak var tutorsTableView: UITableView!
    var tutors = [Tutor]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorsTableView.delegate = self
        self.tutorsTableView.dataSource = self
        self.refreshControl.tintColor = UIColor.clear
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tutorsTableView.addSubview(refreshControl)
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refresh(sender: AnyObject) {
        loadData()
        self.tutorsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func loadData() {
        APIManager.sharedInstance.getUserInfoFrom(email_address: User.sharedInstance.login_email) { user_data in
            User.sharedInstance.updateUser(user_data: user_data)
            APIManager.sharedInstance.retrieveTutors { tutors in
                self.tutors.removeAll()
                self.tutors = tutors
                self.tutorsTableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTutor") {
            let destVC = segue.destination as! TutorProfileViewController
            destVC.tutor = sender as? Tutor
        }
    }
}

extension TutorsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TutorCell = tutorsTableView.dequeueReusableCell(withIdentifier: "tutorCell", for: indexPath) as! TutorCell
        let tutor : Tutor = tutors[indexPath.row]
        
        cell.nameLabel.text = tutor.firstName + " " + tutor.lastName
        cell.programLabel.text = tutor.program + " (Year " + String(tutor.year) + ")"
        
        if let url = URL(string: tutor.imageUrl) {
            cell.profileImageView.layer.cornerRadius = 30
            cell.profileImageView.layer.masksToBounds = true
            cell.profileImageView.af_setImage(withURL: url)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tutor = tutors[indexPath.row]
        self.performSegue(withIdentifier: "showTutor", sender: tutor)
    }
    
}
