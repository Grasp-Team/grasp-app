//
//  TutorCourseSelectionViewController.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-15.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import UIKit

class TutorCourseSelectionViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var coursesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursesTableView.delegate = self
        coursesTableView.dataSource = self
        searchTextField.addTarget(self, action: #selector(searchFinished), for: .editingDidEndOnExit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func searchFinished(){
        searchTextField.resignFirstResponder()
        var query = searchTextField.text ?? ""
        query = query.uppercased()
        
        APIManager.sharedInstance.getCourseInfo(course_code: query) {
            success, course_data in
            if (success) {
                let course = Course(jsonDict: course_data)
                
                if (User.sharedInstance.alreadyTutoring(course: course)) {
                    let alert = UIAlertController(title: "Already Tutoring \(course.code)", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    User.sharedInstance.addCourse(course: course)
                    self.coursesTableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "\(query) does not exist", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        searchTextField.text = ""
    }
}

extension TutorCourseSelectionViewController: UITableViewDelegate, UITableViewDataSource, CourseTutorCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CourseTutorCell = coursesTableView.dequeueReusableCell(withIdentifier: "courseTutorCell", for: indexPath) as! CourseTutorCell
        
        let course : Course = User.sharedInstance.courses[indexPath.row]
        cell.courseLabel.text = course.code + ": " + course.course_name
        cell.courseCode = course.code
        cell.delegate = self
        return cell
    }
    
    func courseRemoved() {
        coursesTableView.reloadData()
    }
    
}
