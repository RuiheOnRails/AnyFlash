//
//  CoursesViewController.swift
//  AnyFlash
//
//  Created by Isaac Chen on 3/10/18.
//  Copyright © 2018 Jerry Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class CoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    
    var refHandle: DatabaseHandle!
    var catKey = ""
    var catName = ""
    var uid = ""
    var ref: DatabaseReference! = Database.database().reference()
    var flashCardData: NSDictionary = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        refHandle = self.ref.child("users").child(self.uid).observe(DataEventType.value, with: { (snapshot) in
            if(!(snapshot.value is NSNull)){
                let newData = snapshot.value as? NSDictionary
                self.flashCardData = newData!
                self.table.reloadData()
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeObserver(withHandle: self.refHandle);
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let keys = flashCardData.allKeys
        
        let label = flashCardData.object(forKey: keys[indexPath.row] as! String) as! NSDictionary
        cell.textLabel?.text = label.object(forKey: "catName") as? String
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.catKey = flashCardData.allKeys[indexPath.row] as! String
        let name = flashCardData.object(forKey: self.catKey) as! NSDictionary
        print(name)
        self.catName = (name.object(forKey: "catName") as? String)!
        print(self.catName)
        performSegue(withIdentifier: "categorySelected", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            NSLog("Deleting")
            self.ref.child("users").child(self.uid).child(self.flashCardData.allKeys[indexPath.row] as! String).removeValue()
            completionHandler(true)
        }
        
        return action
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ref.child("users").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if(!(snapshot.value is NSNull)){
                self.flashCardData = (snapshot.value as? NSDictionary)!
                self.table.reloadData()
            }

        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "toSignIn", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {
            let destination = segue.destination as! AddCatViewController
            destination.uid = self.uid
        } else if segue.identifier == "categorySelected" {
            let destination = segue.destination as! CardsListViewController
            destination.uid = self.uid
            destination.catKey = self.catKey
        }
    }
}
