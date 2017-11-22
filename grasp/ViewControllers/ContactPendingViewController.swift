//
//  ContactPendingViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ContactPendingViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var pendingUsersTableView: UITableView!
    
    var relationships = [Relationship]()
    var usersPending = [Tutor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pendingUsersTableView.delegate = self
        self.pendingUsersTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        APIManager.sharedInstance.retrieveRelationshipsFor(status: Constants.RelationshipStatus.pending.rawValue) {
            relationships in
            self.relationships = relationships
            APIManager.sharedInstance.retrieveUsersFromRelationships(relationships: relationships) {
                success, users in
                if (success) {
                    self.usersPending = users
                }
                self.pendingUsersTableView.reloadData()
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Pending")
    }
}

extension ContactPendingViewController: UITableViewDelegate, UITableViewDataSource, PendingUserCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!User.sharedInstance.isTutor()) {
            return 1
        } else {
            return usersPending.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (!User.sharedInstance.isTutor()) {
            let cell = pendingUsersTableView.dequeueReusableCell(withIdentifier: "nonTutorCell", for: indexPath) as! UITableViewCell
            return cell
        } else {
            let cell : PendingUserCell = pendingUsersTableView.dequeueReusableCell(withIdentifier: "pendingUserCell", for: indexPath) as! PendingUserCell
            let user : Tutor = usersPending[indexPath.row]
            
            
            cell.nameLabel.text = user.firstName + " " + user.lastName
            cell.programLabel.text = user.email
            cell.relationshipId = relationships[indexPath.row].relationshipId
            cell.delegate = self
            
            return cell
        }
    }
    
    func relationshipModified() {
        self.loadData()
    }
    
}
