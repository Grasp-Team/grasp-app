//
//  ContactAcceptedViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ContactAcceptedViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var acceptedUsersTableView: UITableView!
    
    var relationships = [Relationship]()
    var usersAccepted = [Tutor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.acceptedUsersTableView.delegate = self
        self.acceptedUsersTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        APIManager.sharedInstance.retrieveRelationshipsFor(status: Constants.RelationshipStatus.accepted.rawValue) {
            relationships in
            self.relationships = relationships
            APIManager.sharedInstance.retrieveUsersFromRelationships(relationships: relationships) {
                success, users in
                if (success) {
                    self.usersAccepted = users
                }
                self.acceptedUsersTableView.reloadData()
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Accepted")
    }
}

extension ContactAcceptedViewController: UITableViewDelegate, UITableViewDataSource, AcceptedUserCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!User.sharedInstance.isTutor()) {
            return 1
        } else {
            return usersAccepted.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (!User.sharedInstance.isTutor()) {
            let cell = acceptedUsersTableView.dequeueReusableCell(withIdentifier: "nonTutorCell", for: indexPath) as! UITableViewCell
            return cell
        } else {
            let cell : AcceptedUserCell = acceptedUsersTableView.dequeueReusableCell(withIdentifier: "acceptedUserCell", for: indexPath) as! AcceptedUserCell
            let user : Tutor = usersAccepted[indexPath.row]
            
            
            cell.nameLabel.text = user.firstName + " " + user.lastName
            cell.emailLabel.text = user.email
            cell.relationshipId = relationships[indexPath.row].relationshipId
            cell.delegate = self
            
            if let url = URL(string: user.imageUrl) {
                cell.profileImageView.layer.cornerRadius = 30
                cell.profileImageView.layer.masksToBounds = true
                cell.profileImageView.af_setImage(withURL: url)
            }
            
            return cell
        }
    }
    
    func relationshipModified() {
        loadData()
    }
    
}
