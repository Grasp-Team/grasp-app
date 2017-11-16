//
//  TutorSearchViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class TutorSearchViewController: UIViewController {

    @IBOutlet weak var tutorsResultsTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var tutors = [Tutor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorsResultsTableView.delegate = self
        tutorsResultsTableView.dataSource = self
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTutor") {
            let destVC = segue.destination as! TutorProfileViewController
            destVC.tutor = sender as? Tutor
        }
    }

}

extension TutorSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TutorResultCell = tutorsResultsTableView.dequeueReusableCell(withIdentifier: "tutorResultCell", for: indexPath) as! TutorResultCell
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

extension TutorSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        APIManager.sharedInstance.searchTutors(query: query) { tutors in
            self.tutors.removeAll()
            self.tutors = tutors
            self.tutorsResultsTableView.reloadData()
        }
    }
}
