//
//  CardsListViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CardsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var quizButton: UIButton!
    
    var uid = ""
    var category = ""
    var flashCardData: NSDictionary!
    var ref: DatabaseReference! = Database.database().reference()
    var refHandle: DatabaseHandle!
    
    override func viewWillAppear(_ animated: Bool) {
        refHandle = self.ref.child("users").child(self.uid).child(self.category).observe(DataEventType.value, with: { (snapshot) in
            let newData = snapshot.value as? NSDictionary
            self.flashCardData = newData!
            self.table.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: self.refHandle);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardData == nil ? 0 : flashCardData.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        let keys = flashCardData.allKeys
        let label = keys[indexPath.row] as? String
        cell.textLabel?.text = label == "cardPlaceHolderKey" ? keys[keys.count-1] as? String : label
        let valuesData = flashCardData.object(forKey: cell.textLabel?.text ?? "this hsould not show up") as? NSDictionary
        cell.detailTextLabel?.text = valuesData?.object(forKey: "back") as? String
        tableView.tableFooterView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markInP = self.contextualMarkAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [markInP])
    }
    
    func contextualMarkAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Mark Learning") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
        self.ref.child("users").child(self.uid).child(self.category).child(self.flashCardData.allKeys[indexPath.row] as! String).child("learned").setValue(false)
            completionHandler(true)
        }
        return action
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            NSLog("Deleting")
            self.ref.child("users").child(self.uid).child(self.category).child(self.flashCardData.allKeys[indexPath.row] as! String).removeValue()
            completionHandler(true)
        }
        return action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        courseNameLabel.text = self.category
        
        table.dataSource = self
        table.delegate = self
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ref.child("users").child(self.uid).child(category).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.flashCardData = (snapshot.value as? NSDictionary)!
            if self.flashCardData.count > 1 {
                self.quizButton.isEnabled = true
            }
            self.table.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func quizPressed(_ sender: Any) {
        performSegue(withIdentifier: "toQuizView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cardListToCourses") {
            let destination = segue.destination as! CoursesViewController
            destination.uid = self.uid
        } else if segue.identifier == "addFront" {
            let destination = segue.destination as! AddFrontViewController
            destination.uid = self.uid
            destination.category = self.category
        } else if segue.identifier == "toQuizView" {
            let destination = segue.destination as! QuizFrontViewController
            destination.uid = self.uid
            destination.category = self.category
            destination.flashCardData = self.flashCardData
        }
    }
}
