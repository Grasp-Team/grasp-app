//
//  TutorsViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-10-14.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit
import Alamofire

class TutorsViewController: UIViewController {

    @IBOutlet weak var tutorsTableView: UITableView!
    var tutors = [Tutor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tutorsTableView.delegate = self
        self.tutorsTableView.dataSource = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        APIManager.sharedInstance.retrieveTutors { tutors in
            self.tutors.removeAll()
            self.tutors = tutors
            self.tutorsTableView.reloadData()
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
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tutor = tutors[indexPath.row]
        self.performSegue(withIdentifier: "showTutor", sender: tutor)
    }
    
}
