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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flashCardData == nil ? 0 : flashCardData.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        
        let keys = flashCardData.allKeys
        let label = keys[indexPath.row] as? String
        cell.textLabel?.text = label == "cardPlaceHolderKey" ? keys[keys.count-1] as? String : label
        cell.detailTextLabel?.text = flashCardData.object(forKey: cell.textLabel?.text) as! String
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    
    var uid = ""
    var category = ""
    var flashCardData: NSDictionary!
    @IBOutlet weak var table: UITableView!
    

    @IBOutlet weak var courseNameLabel: UILabel!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(self.uid)
        print(self.category)
        
        courseNameLabel.text = self.category
        
        table.dataSource = self
        table.delegate = self
        
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        ref.child("users").child(self.uid).child(category).observeSingleEvent(of: .value, with: { (snapshot) in
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
        if (segue.identifier == "cardListToCourses") {
            let destination = segue.destination as! CoursesViewController
            destination.uid = self.uid
        }
    }
}
