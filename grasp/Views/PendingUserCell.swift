//
//  PendingUserCell.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

protocol PendingUserCellDelegate {
    func relationshipModified()
}

class PendingUserCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var delegate : PendingUserCellDelegate?
    var relationshipId: Int = -1
    
    @IBAction func deleteRelationship(_ sender: UIButton) {
        if relationshipId < 0 {
            return
        }
        APIManager.sharedInstance.deleteRelationship(relationshipId: relationshipId) {
            _ in
            if let delegate = self.delegate {
                delegate.relationshipModified()
            }
        }
    }
    
    @IBAction func accept(_ sender: UIButton) {
        if relationshipId < 0 {
            return
        }
        APIManager.sharedInstance.relationshipAccepted(relationshipId: relationshipId) {
            _ in
            if let delegate = self.delegate {
                delegate.relationshipModified()
            }
        }
    }
    
}
