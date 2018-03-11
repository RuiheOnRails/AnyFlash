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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardData == nil ? 0 : flashCardData.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let keys = flashCardData.allKeys
        let label = keys[indexPath.row] as? String
        cell.textLabel?.text = label == "newUserPlaceHolderKey" ? keys[keys.count-1] as? String : label
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.category = flashCardData.allKeys[indexPath.row] as! String
        if self.category == "newUserPlaceHolderKey" {
            self.category = flashCardData.allKeys.last as! String
        }
        performSegue(withIdentifier: "categorySelected", sender: self)
    }
    
    var category = ""
    var uid = ""
    var ref: DatabaseReference! = Database.database().reference()
    var flashCardData: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ref.child("users").child(self.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.flashCardData = (snapshot.value as? NSDictionary)!
            self.table.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
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
            destination.category = self.category
        }
    }
}
