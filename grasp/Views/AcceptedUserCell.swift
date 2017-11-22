//
//  AcceptedUserCell.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-21.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

protocol AcceptedUserCellDelegate {
    func relationshipModified()
}

class AcceptedUserCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate : AcceptedUserCellDelegate?
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
    
}
