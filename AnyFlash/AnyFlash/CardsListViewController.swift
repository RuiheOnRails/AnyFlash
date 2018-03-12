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
    var catKey = ""
    var catName = ""
    var flashCardData: NSDictionary = [:]
    var ref: DatabaseReference! = Database.database().reference()
    var refHandle: DatabaseHandle!
    
    override func viewWillAppear(_ animated: Bool) {
        refHandle = self.ref.child("users").child(self.uid).child(self.catKey).observe(DataEventType.value, with: { (snapshot) in
            if(!(snapshot.value is NSNull)){
                let newData = snapshot.value as? NSDictionary
                if(newData?.object(forKey: "words") != nil){
                    self.flashCardData = newData?.object(forKey: "words") as! NSDictionary
                    self.table.reloadData()
                    self.quizButton.isEnabled = true
                }else{
                    self.quizButton.isEnabled = false
                }
            }else{
                self.quizButton.isEnabled = false
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.child("users").child(self.uid).child(self.catKey).removeObserver(withHandle: self.refHandle);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        let keys = flashCardData.allKeys
        let labelDict = flashCardData.object(forKey: keys[indexPath.row]) as! NSDictionary
        let label = labelDict.object(forKey: "front") as! String
        let labelDetail = labelDict.object(forKey: "back") as! String
        let learnedStatus = labelDict.object(forKey: "learned") as! Bool
        cell.backgroundColor = learnedStatus ? UIColor(red:220/255, green: 247/255, blue: 205/255, alpha: 1) : UIColor.white
        cell.textLabel?.text = label
        cell.detailTextLabel?.text = labelDetail
        tableView.tableFooterView = UIView()
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markLearned = self.contextualMarkLearnedAction(forRowAtIndexPath: indexPath)
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, markLearned])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markInP = self.contextualMarkAction(forRowAtIndexPath: indexPath)

        return UISwipeActionsConfiguration(actions: [markInP])
    }
    
    func contextualMarkAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Mark Learning") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
        self.ref.child("users").child(self.uid).child(self.catKey).child("words").child(self.flashCardData.allKeys[indexPath.row] as! String).child("learned").setValue(false)
            completionHandler(true)
            self.table.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
        }
        return action
    }
    
    func contextualMarkLearnedAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Mark Learned") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.ref.child("users").child(self.uid).child(self.catKey).child("words").child(self.flashCardData.allKeys[indexPath.row] as! String).child("learned").setValue(true)
            completionHandler(true)
            self.table.cellForRow(at: indexPath)?.backgroundColor = UIColor(red:220/255, green: 247/255, blue: 205/255, alpha: 1)
        }
        return action
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            NSLog("Deleting")
            self.ref.child("users").child(self.uid).child(self.catKey).child("words").child(self.flashCardData.allKeys[indexPath.row] as! String).removeValue()
            completionHandler(true)
        }
        return action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        table.dataSource = self
        table.delegate = self
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ref.child("users").child(self.uid).child(catKey).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if(!(snapshot.value is NSNull)) {
                let snapshotDict = snapshot.value as? NSDictionary
                self.catName = snapshotDict?.object(forKey: "catName") as! String
                self.courseNameLabel.text = self.catName
                if(snapshotDict?.object(forKey: "words") != nil){
                    self.flashCardData = snapshotDict?.object(forKey: "words") as! NSDictionary
                    if self.flashCardData.count > 1 {
                        self.quizButton.isEnabled = true
                    }
                    self.table.reloadData()
                }
            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func quizPressed(_ sender: Any) {
        var showQuiz: Bool = false
        let allCardValues = self.flashCardData.allValues
        allCardValues.forEach { (c) in
            let cD = c as! NSDictionary
            if(!(cD.object(forKey: "learned") as! Bool)){
                showQuiz = true
            }
        }
        
        if(showQuiz){
            performSegue(withIdentifier: "toQuizView", sender: self)
        }else{
            Util.showAlert(self, "No in progress vocabs")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "cardListToCourses") {
            let destination = segue.destination as! CoursesViewController
            destination.uid = self.uid
        } else if segue.identifier == "addFront" {
            let destination = segue.destination as! AddFrontViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
        } else if segue.identifier == "toQuizView" {

            let destination = segue.destination as! QuizFrontViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
            destination.flashCardData = self.flashCardData
        }
    }
}
